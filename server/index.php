<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

require 'vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

$stripe = new \Stripe\StripeClient($_ENV['STRIPE_SECRET_KEY']);

if ($_SERVER['REQUEST_METHOD'] === 'POST' && $_SERVER['REQUEST_URI'] === '/create-checkout-session') {
    $json = file_get_contents('php://input');
    $data = json_decode($json);
    
    try {
        $session = $stripe->checkout->sessions->create([
            'payment_method_types' => ['card'],
            'line_items' => [[
                'price_data' => [
                    'currency' => 'eur',
                    'product_data' => [
                        'name' => $data->product->name,
                        'description' => $data->product->description,
                        'images' => [$data->product->image],
                    ],
                    'unit_amount' => round($data->product->price * 100),
                ],
                'quantity' => 1,
            ]],
            'mode' => 'payment',
            'success_url' => $_ENV['FRONTEND_URL'] . '/success',
            'cancel_url' => $_ENV['FRONTEND_URL'] . '/cancel',
        ]);
        
        echo json_encode(['id' => $session->id]);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
    }
} else {
    http_response_code(404);
    echo json_encode(['error' => 'Not found']);
}
