<?php
require __DIR__ . '/vendor/autoload.php';

use Database\MySQLWrapper;

// connect
$mysqli = new MySQLWrapper();

// 1️⃣ Insert data
$studentsData = [
    ['Alice', 20, 'Computer Science'],
    ['Bob', 22, 'Mathematics'],
    ['Charlie', 21, 'Physics'],
    ['David', 23, 'Chemistry'],
    ['Eve', 20, 'Biology'],
    ['Frank', 22, 'History'],
    ['Grace', 21, 'English Literature'],
    ['Hannah', 23, 'Art History'],
    ['Isaac', 20, 'Economics'],
    ['Jack', 24, 'Philosophy']
];

// clean table before insert (optional safety for reruns)
$mysqli->query("TRUNCATE TABLE students");

foreach ($studentsData as $student) {
    $insertQuery = "INSERT INTO students (name, age, major) VALUES ('$student[0]', $student[1], '$student[2]')";
    $mysqli->query($insertQuery);
}
echo "✅ Inserted 10 students.\n\n";

// 2️⃣ Read data (fetch_assoc)
echo "--- Reading with fetch_assoc() ---\n";
$result = $mysqli->query("SELECT * FROM students");
while ($row = $result->fetch_assoc()) {
    echo "ID: {$row['id']}, Name: {$row['name']}, Age: {$row['age']}, Major: {$row['major']}\n";
}
echo "\n";

// 2️⃣ Read data (fetch_all)
echo "--- Reading with fetch_all(MYSQLI_ASSOC) ---\n";
$result = $mysqli->query("SELECT * FROM students");
$allRows = $result->fetch_all(MYSQLI_ASSOC);
foreach ($allRows as $row) {
    echo $row['name'] . " is studying " . $row['major'] . "\n";
}
echo "\n";

// 3️⃣ Update majors
$updates = [
    ['Alice', 'Physics'],
    ['Bob', 'Art History'],
    ['Charlie', 'Philosophy'],
    ['David', 'Economics']
];

foreach ($updates as $update) {
    $updateQuery = "UPDATE students SET major='$update[1]' WHERE name='$update[0]'";
    $mysqli->query($updateQuery);
}
echo "✅ Updated majors for Alice, Bob, Charlie, and David.\n\n";

// confirm updates
$result = $mysqli->query("SELECT * FROM students");
while ($row = $result->fetch_assoc()) {
    echo "After Update → ID: {$row['id']}, {$row['name']} ({$row['major']})\n";
}
echo "\n";

// 4️⃣ Delete Alice, Bob, Charlie
$studentsToDelete = ['Alice', 'Bob', 'Charlie'];
foreach ($studentsToDelete as $studentName) {
    $deleteQuery = "DELETE FROM students WHERE name='$studentName'";
    $mysqli->query($deleteQuery);
}
echo "✅ Deleted Alice, Bob, and Charlie.\n\n";

// final state
$result = $mysqli->query("SELECT * FROM students");
while ($row = $result->fetch_assoc()) {
    echo "Remaining → ID: {$row['id']}, {$row['name']} ({$row['major']})\n";
}

