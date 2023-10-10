<?php

namespace App\Controller;

use App\Entity\UserEntity;
use App\Repository\CategoriesEntityRepository;
use App\Services\ApiAuthService;
use App\Repository\UserEntityRepository;
use Doctrine\ORM\EntityManagerInterface;
use Doctrine\Persistence\ManagerRegistry;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\JsonResponse;
use App\Repository\EtablissementScolaireEntityRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class ApiController extends AbstractController
{

    private $entityManager;

    public function __construct(ManagerRegistry $registry)
    {
        $this->entityManager = $registry->getManager();
    }

    // Désérialisation du JSON flutter pour créer un utilisateur

    public function createUser(Request $request, UserPasswordHasherInterface $passwordHasher)
    {

        $username = $request->request->get('mail');
        $password = $request->request->get('password');
        $confirmPassword = $request->request->get('confirm_password');

        if ($password !== $confirmPassword) {
            return new JsonResponse(['message' => 'ERREUR'], 400);
        }
        if ($password == null) {
            return new JsonResponse(['message' => 'ERREUR'], 400);
        }

        // Vérification de l'adresse

        if (!preg_match('/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/', $username)) {
            return new JsonResponse(['message' => 'ERREUR'], 400);
        }

        $user = new UserEntity();
        $user->setMail($username);
        $user->setRole('ROLE_USER');
        $user->setetablissement('autre');

        $hashedPassword = $passwordHasher->hashPassword($user, $password);
        $user->setPassword($hashedPassword);

        $this->entityManager->persist($user);
        $this->entityManager->flush();

        return new JsonResponse(['message' => 'ERREUR'], 200);
    }

        // Désérialisation du JSON flutter pour la connexion des utilisateurs

    public function login(Request $request, ApiAuthService $authService, UserPasswordHasherInterface $passwordHasher)
    {
        $formUsername = $request->request->get('mail');
        $formPassword = $request->request->get('password');

        $user = $authService->getUserByUsername($formUsername);


        if (!$user || !$passwordHasher->isPasswordValid($user, $formPassword)) {
            return new JsonResponse(['message' => 'Connexion échouée, identifiant ou mot de passe incorrect'], 401);
        }
            return new JsonResponse(['message' => 'Connexion réussie avec succès'], 200);
    }

        // Sérialisation du nom des établissements scolaire de la BDD vers JSON pour flutter

    public function getEmail(EntityManagerInterface $entityManager, UserEntityRepository $UserEntityRepository)
    {
        $email = $UserEntityRepository->findAll();

        $data = [];
        foreach ($email as $email) {
            $mail = $email->getUsername();


            $data[] = [
            'mail' => $mail,
            ];
        }
        
        return new JsonResponse($data);
    }


    // Sérialisation des adresses-mail de la BDD vers JSON pour flutter (vérification si l'email est déjà associée à un compte)
    public function getEtablissement(EntityManagerInterface $entityManager, EtablissementScolaireEntityRepository $etablissementRepository)
    {
        $etablissements = $etablissementRepository->findAll();

        $data = [];
        foreach ($etablissements as $etablissement) {
            $nom = $etablissement->getNom();
            $ville = $etablissement->getVille();

            if ($ville === null) {
            $ville = "";
            }

            $data[] = [
            'nom' => $nom,
            'ville' => $ville,
            ];
        }
        
        return new JsonResponse($data);
    }


    // Sérialisation des catégories de la BDD vers JSON pour flutter
    public function getCategories(EntityManagerInterface $entityManager, CategoriesEntityRepository $categoriesEntityRepositoryRepository)
    {
        $categories = $categoriesEntityRepositoryRepository->findAll();

        $data = [];
        foreach ($categories as $categorie) {
            $name = $categorie->getName();
            $image = $categorie->getImage();

            $data[] = [
            'name' => $name,
            'image' => $image,
            ];
        }
        
        return new JsonResponse($data);
    }
}
