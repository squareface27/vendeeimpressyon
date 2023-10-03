<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use App\Entity\UserEntity;
use Doctrine\Persistence\ManagerRegistry;

class AddUserController extends AbstractController
{

    private $entityManager;

    public function __construct(ManagerRegistry $registry)
    {
        $this->entityManager = $registry->getManager();
    }

    public function createUser(Request $request, UserPasswordHasherInterface $passwordHasher)
    {

        $username = $request->request->get('username');
        $password = $request->request->get('password');
        $confirmPassword = $request->request->get('confirm_password');

        // Vérifiez si le mot de passe et la confirmation du mot de passe sont identiques
        if ($password !== $confirmPassword) {
            return new JsonResponse(['message' => 'Les mots de passe ne correspondent pas'], 400);
        }

        // Créez un nouvel utilisateur et définissez le rôle par défaut
        $user = new UserEntity();
        $user->setUsername($username);
        $user->setRole('');

        // Hachez le mot de passe et stockez-le
        $hashedPassword = $passwordHasher->hashPassword($user, $password);
        $user->setPassword($hashedPassword);

        $this->entityManager->persist($user);
        $this->entityManager->flush();

        return new JsonResponse(['message' => 'Utilisateur créé avec succès']);
    }
}
