<?php

namespace App\Controller\Admin;

use App\Entity\CategoriesProductOptionEntity;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;

class CategoriesProductOptionEntityCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return CategoriesProductOptionEntity::class;
    }

    
    public function configureFields(string $pageName): iterable
    {
        return [
            TextField::new('nom'),
        ];
    }
    
}
