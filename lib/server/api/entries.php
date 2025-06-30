<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: POST, GET, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

require_once __DIR__ . '/../config/database.php';

$action = $_GET['action'] ?? '';

try {
    $pdo = createPDOConnection();
    
    switch ($action) {
        case 'create':
            $data = json_decode(file_get_contents('php://input'), true);
            $stmt = $pdo->prepare("
                INSERT INTO entries 
                (user_id, date, location, latitude, longitude, fish_type, weight, length, bait, tackle, weather, notes, is_public, rating, companion_ids)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ");
            $companionIds = json_encode($data['companionIds']);
            $stmt->execute([
                $data['userId'],
                $data['date'],
                $data['location'],
                $data['latitude'],
                $data['longitude'],
                $data['fishType'],
                $data['weight'],
                $data['length'] ?? null,
                $data['bait'],
                $data['tackle'],
                $data['weather'],
                $data['notes'],
                $data['isPublic'] ? 1 : 0,
                $data['rating'],
                $companionIds
            ]);
            $id = $pdo->lastInsertId();
            
            // Обработка загрузки фото
            if (!empty($_FILES['photo'])) {
                $targetDir = "../uploads/entries/";
                $fileName = "entry_{$id}_" . basename($_FILES["photo"]["name"]);
                $targetFile = $targetDir . $fileName;
                
                if (move_uploaded_file($_FILES["photo"]["tmp_name"], $targetFile)) {
                    $pdo->prepare("UPDATE entries SET photo_url = ? WHERE id = ?")
                        ->execute([$targetFile, $id]);
                }
            }
            
            echo json_encode(['id' => $id]);
            break;
            
        case 'get_top_fish':
            $fishType = $_GET['fish_type'];
            $stmt = $pdo->prepare("
                SELECT u.id, u.name, u.avatar_url, MAX(e.weight) as max_weight, COUNT(e.id) as total_catches
                FROM entries e
                JOIN users u ON e.user_id = u.id
                WHERE e.fish_type = ?
                GROUP BY u.id
                ORDER BY max_weight DESC
                LIMIT 10
            ");
            $stmt->execute([$fishType]);
            $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($results);
            break;
            
        // Другие действия...
            
        default:
            http_response_code(400);
            echo json_encode(['error' => 'Invalid action']);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}