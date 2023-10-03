<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use App\Services\ApiAuthService;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class ApiAuthController extends AbstractController
{
    public function login(Request $request, ApiAuthService $authService, UserPasswordHasherInterface $passwordHasher)
    {
        $formUsername = $request->request->get('username');
        $formPassword = $request->request->get('password');

        // Récupérez l'utilisateur depuis votre service AuthService
        $user = $authService->getUserByUsername($formUsername);


        // Si l'utilisateur n'existe pas ou si le mot de passe ne correspond pas
        if (!$user || !$passwordHasher->isPasswordValid($user, $formPassword)) {
            return new JsonResponse(['message' => 'Connexion échouée, identifiant ou mot de passe incorrect'], 401);
        }
            return new JsonResponse(['message' => 'Connexion réussie avec succès'], 200);
    }
}

