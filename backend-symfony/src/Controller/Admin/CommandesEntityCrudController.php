<?php

namespace App\Controller\Admin;

use App\Entity\CommandesEntity;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;

class CommandesEntityCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return CommandesEntity::class;
    }

    /*
    public function configureFields(string $pageName): iterable
    {
        return [
            IdField::new('id'),
            TextField::new('title'),
            TextEditorField::new('description'),
        ];
    }
    */
}
