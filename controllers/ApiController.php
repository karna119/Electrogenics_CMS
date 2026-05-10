<?php

namespace app\controllers;

use Yii;
use yii\rest\Controller;
use yii\filters\Cors;
use yii\filters\auth\HttpBearerAuth;
use app\models\User;
use app\components\Jwt;

class ApiController extends Controller
{
    public function behaviors()
    {
        $behaviors = parent::behaviors();

        // Build allowed origins dynamically
        $allowedOrigins = ['http://localhost:5173', 'http://localhost:3000'];
        $frontendUrl = getenv('FRONTEND_URL');
        if ($frontendUrl) {
            $allowedOrigins[] = $frontendUrl;
        }

        // add CORS filter
        $behaviors['corsFilter'] = [
            'class' => Cors::className(),
            'cors' => [
                'Origin' => $allowedOrigins,
                'Access-Control-Request-Method' => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD', 'OPTIONS'],
                'Access-Control-Request-Headers' => ['*'],
                'Access-Control-Allow-Credentials' => true,
                'Access-Control-Max-Age' => 3600,
                'Access-Control-Expose-Headers' => ['X-Pagination-Current-Page'],
            ],
        ];

        // Add Bearer Auth
        $behaviors['authenticator'] = [
            'class' => HttpBearerAuth::className(),
            'except' => ['login', 'index', 'options'],
        ];

        return $behaviors;
    }

    public function actionIndex()
    {
        return [
            'status' => 'success',
            'message' => 'Electrogenics API is running!',
            'version' => '1.0'
        ];
    }

    public function actionLogin()
    {
        $request = Yii::$app->request;
        $username = $request->post('username');
        $password = $request->post('password');

        if (!$username || !$password) {
            Yii::$app->response->statusCode = 400;
            return ['status' => 'error', 'message' => 'Username and password are required.'];
        }

        $user = User::findByUsername($username);

        if ($user && $user->validatePassword($password)) {
            // Check if user is blocked
            if ($user->is_block == 1) {
                Yii::$app->response->statusCode = 403;
                return ['status' => 'error', 'message' => 'Your account is blocked.'];
            }

            // Generate JWT
            $payload = [
                'id' => $user->user_id,
                'username' => $user->user_login_id,
                'type' => $user->user_type,
                'exp' => time() + (86400 * 7), // Valid for 7 days
            ];
            
            $token = Jwt::encode($payload);

            return [
                'status' => 'success',
                'token' => $token,
                'user' => [
                    'id' => $user->user_id,
                    'username' => $user->user_login_id,
                    'type' => $user->user_type,
                ]
            ];
        } else {
            Yii::$app->response->statusCode = 401;
            return ['status' => 'error', 'message' => 'Invalid username or password.'];
        }
    }
}
