<?php

namespace App\Controller;

use App\Entity\CguEntity;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class CguController extends AbstractController
{
    private $entityManager;

    public function __construct(EntityManagerInterface $entityManager)
    {
        $this->entityManager = $entityManager;
    }

    public function showAction()
    {
    $cguEntity = $this->entityManager->getRepository(CguEntity::class)->findOneBy([]);

    return $this->render('cgu/index.html.twig', [
        'entity' => $cguEntity,
    ]);
    }  

}
