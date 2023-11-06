<?php

namespace App\Controller;

use App\Entity\MentionsLegalesEntity;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class MentionsLegalesController extends AbstractController
{
    private $entityManager;

    public function __construct(EntityManagerInterface $entityManager)
    {
        $this->entityManager = $entityManager;
    }

    public function showAction()
    {
    $MentionslegalesEntity = $this->entityManager->getRepository(MentionsLegalesEntity::class)->findOneBy([]);

    return $this->render('mentionslegales/index.html.twig', [
        'entity' => $MentionslegalesEntity,
    ]);
    }  
}
