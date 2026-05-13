<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, DELETE, PUT, PATCH");
header("Access-Control-Allow-Headers: Content-Type");

include "db.php";
$method = $_SERVER['REQUEST_METHOD'];

if ($method == "GET") {
    $result = $conn->query("SELECT * FROM tasks");
    $tasks = [];
    while ($row = $result->fetch_assoc()) {
        $tasks[] = $row;
    }
    echo json_encode([
        "success" => true,
        "data" => $tasks
    ]);
}

if ($method == "POST") {
    $data = json_decode(file_get_contents("php://input"));
    $title = $data->title;
    $conn->query("INSERT INTO tasks (title, done) VALUES ('$title', 0)");
    echo json_encode([
        "success" => true,
        "data" => [
            "id" => $conn->insert_id,
            "title" => $title,
            "done" => 0
        ]
    ]);
}

if ($method == "PUT") {
    $data = json_decode(file_get_contents("php://input"));
    $id = $data->id;
    $title = $data->title;
    $conn->query("UPDATE tasks SET title='$title' WHERE id=$id");
    echo json_encode([
        "success" => true,
        "data" => [
            "id" => $id,
            "title" => $title
        ]
    ]);
}

if ($method == "PATCH") {
    $data = json_decode(file_get_contents("php://input"));
    $id = $data->id;
    $done = $data->done;
    $conn->query("UPDATE tasks SET done=$done WHERE id=$id");
    echo json_encode([
        "success" => true,
        "data" => [
            "id" => $id,
            "done" => $done
        ]
    ]);
}

if ($method == "DELETE") {
    $data = json_decode(file_get_contents("php://input"));
    $id = $data->id;
    $conn->query("DELETE FROM tasks WHERE id=$id");
    echo json_encode([
        "success" => true
    ]);
}
?>