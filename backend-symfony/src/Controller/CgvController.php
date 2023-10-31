<?php

namespace App\Controller;

use App\Entity\CgvEntity;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class CgvController extends AbstractController
{
    private $entityManager;

    public function __construct(EntityManagerInterface $entityManager)
    {
        $this->entityManager = $entityManager;
    }

    public function showAction()
    {
    $cgvEntity = $this->entityManager->getRepository(CgvEntity::class)->findOneBy([]);

    return $this->render('cgv/index.html.twig', [
        'entity' => $cgvEntity,
    ]);
    }  

}
