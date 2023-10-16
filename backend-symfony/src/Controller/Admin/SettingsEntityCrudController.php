<?php

namespace App\Controller\Admin;

use App\Entity\SettingsEntity;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;

class SettingsEntityCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return SettingsEntity::class;
    }

    public function configureFields(string $pageName): iterable
    {
        return [
            BooleanField::new('vacance')->setLabel('Mode Vacance'),
        ];
    }
    
    public function configureActions(Actions $actions): Actions
    {
        $actions->disable(Action::NEW);
        $actions->disable(Action::DELETE);

        return $actions;
    }
}
