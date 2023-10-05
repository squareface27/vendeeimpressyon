<?php

namespace App\Controller\Admin;

use App\Entity\CategorieEntity;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;

class CategorieEntityCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return CategorieEntity::class;
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
