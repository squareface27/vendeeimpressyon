<?php

namespace App\Controller\Admin;

use App\Entity\UserEntity;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\ArrayField;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;

class UserEntityCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return UserEntity::class;
    }

    
    public function configureFields(string $pageName): iterable
    {
        return [
            TextField::new('username'),
            TextField::new('etablissement'),
            TextField::new('role'),
        ];
    }
    
}
