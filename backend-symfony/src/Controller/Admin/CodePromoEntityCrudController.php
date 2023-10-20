<?php

namespace App\Controller\Admin;

use App\Entity\CodePromoEntity;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\NumberField;

class CodePromoEntityCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return CodePromoEntity::class;
    }

    public function configureFields(string $pageName): iterable
    {
        return [
            TextField::new('code'),
            NumberField::new('montant')->setLabel('montant (%)'),
        ];
    }
    
}
