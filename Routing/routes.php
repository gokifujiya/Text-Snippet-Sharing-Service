<?php
use Helpers\DatabaseHelper;
use Helpers\ValidationHelper;
use Helpers\SnippetHelper;
use Response\HTTPRenderer;
use Response\Render\HTMLRenderer;
use Response\Render\JSONRenderer;

return [
    'random/part'=>function(): HTTPRenderer{
        $part = DatabaseHelper::getRandomComputerPart();
        return new HTMLRenderer('component/computer-part-card', ['part'=>$part]);
    },
    'parts'=>function(): HTTPRenderer{
        $id = ValidationHelper::integer($_GET['id']??null);
        $part = DatabaseHelper::getComputerPartById($id);
        return new HTMLRenderer('component/computer-part-card', ['part'=>$part]);
    },

    // ---- Snippets UI ----
    'paste' => function(): HTTPRenderer {
        return new HTMLRenderer('paste/new');
    },

    'paste/create' => function(): HTTPRenderer {
        if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST') {
            return new HTMLRenderer('paste/new', ['error' => 'Invalid method']);
        }
        $content  = $_POST['content']  ?? '';
        $language = $_POST['language'] ?? '';
        $expiry   = $_POST['expiry']   ?? 'keep';

        try {
            $slug = \Helpers\SnippetHelper::create(
                $content,
                $language ?: null,
                $expiry ?: null,
                $_SERVER['REMOTE_ADDR'] ?? null,
                $_SERVER['HTTP_USER_AGENT'] ?? null
            );
            header('Location: /s/' . $slug, true, 302);
            exit;
        } catch (\Throwable $e) {
            return new HTMLRenderer('paste/new', ['error' => $e->getMessage()]);
        }
    },

    // View snippet: /s/{slug}
    's' => function(): HTTPRenderer {
        $path = trim(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH), '/');
        $parts = explode('/', $path, 3);
        $slug = $parts[1] ?? '';
        if ($slug === '') {
            http_response_code(404);
            return new HTMLRenderer('paste/new', ['error' => 'Missing slug']);
        }
        $snippet = \Helpers\SnippetHelper::getBySlug($slug);
        return new HTMLRenderer('snippet/show', ['snippet' => $snippet]);
    },

    // Raw: /raw/{slug}
    'raw' => function(): HTTPRenderer {
        $path = trim(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH), '/');
        $parts = explode('/', $path, 3);
        $slug = $parts[1] ?? '';

        $snippet = ($slug !== '') ? \Helpers\SnippetHelper::getBySlug($slug) : null;

        return new class($snippet) implements \Response\HTTPRenderer {
            private ?array $s;
            public function __construct($s){ $this->s = $s; }
            public function getFields(): array { return ['Content-Type' => 'text/plain; charset=UTF-8']; }
            public function getContent(): string {
                return $this->s ? (string)$this->s['content'] : "Expired Snippet";
            }
        };
    },

    // API: POST /api/snippets
    'api/snippets' => function(): HTTPRenderer {
        if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST') {
            return new JSONRenderer(['error' => 'Invalid method']);
        }
        $payload = file_get_contents('php://input');
        $json = json_decode($payload, true) ?? [];

        try {
            $slug = \Helpers\SnippetHelper::create(
                (string)($json['content'] ?? ''),
                isset($json['language']) ? (string)$json['language'] : null,
                isset($json['expiry']) ? (string)$json['expiry'] : null,
                $_SERVER['REMOTE_ADDR'] ?? null,
                $_SERVER['HTTP_USER_AGENT'] ?? null
            );
            return new JSONRenderer(['slug' => $slug, 'url' => '/s/'.$slug, 'raw' => '/raw/'.$slug]);
        } catch (\Throwable $e) {
            http_response_code(400);
            return new JSONRenderer(['error' => $e->getMessage()]);
        }
    },

    // API: GET /api/snippets/get?slug=...
    'api/snippets/get' => function(): HTTPRenderer {
        $slug = $_GET['slug'] ?? '';
        try {
            $snippet = \Helpers\SnippetHelper::getBySlug(\Helpers\ValidationHelper::string($slug, 1, 32));
            if (!$snippet) {
                http_response_code(404);
                return new JSONRenderer(['error' => 'Expired Snippet']);
            }
            return new JSONRenderer(['snippet' => $snippet]);
        } catch (\Throwable $e) {
            http_response_code(400);
            return new JSONRenderer(['error' => $e->getMessage()]);
        }
    },
];

