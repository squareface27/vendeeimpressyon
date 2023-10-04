<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;

class AccueilController extends AbstractController
{
    public function index(): Response
    {
        return $this->render('pages/accueil.html.twig', [
            'controller_name' => 'AccueilController',
        ]);
    }
}
