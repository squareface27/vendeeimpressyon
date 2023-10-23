<?php

namespace App\Controller\Admin;

use App\Entity\FraisEntity;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;

class FraisEntityCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return FraisEntity::class;
    }

    public function configureActions(Actions $actions): Actions
    {
        $actions->disable(Action::NEW);
        $actions->disable(Action::DELETE);

        return $actions;
    }
}
