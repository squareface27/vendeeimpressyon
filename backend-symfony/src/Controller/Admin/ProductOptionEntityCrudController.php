<?php

namespace App\Controller\Admin;

use App\Entity\ProductOptionEntity;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Field\NumberField;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;

class ProductOptionEntityCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return ProductOptionEntity::class;
    }

    public function configureFields(string $pageName): iterable
    {
        return [
            AssociationField::new('categoryoption', 'Catégorie de l\'option')
                ->formatValue(function ($value, $entity) {
                    return $entity->getCategoryOptionName();
                })
                ->setSortable(true)
                ->setFormTypeOptions([
                    'choice_label' => 'nom',
                ]),
            TextField::new('nom')->setLabel('Nom de l\'option'),
            NumberField::new('prix')->setLabel('Prix (€)'),
            AssociationField::new('category', 'Catégorie')
                ->formatValue(function ($value, $entity) {
                    return $entity->getCategoryName();
                })
                ->setSortable(true)
                ->setFormTypeOptions([
                    'choice_label' => 'name',
                ]),
        ];
    }
}
