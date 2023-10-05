<?php

namespace App\Controller\Admin;

use App\Entity\UserEntity;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;

class UserEntityCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return UserEntity::class;
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
