<?php

namespace App\Controller\Admin;

use App\Entity\ArticlesEntity;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Field\IdField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Field\NumberField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextEditorField;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;

class ArticlesEntityCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return ArticlesEntity::class;
    }

    public function configureFields(string $pageName): iterable
    {
        return [
            TextField::new('name')->setLabel('Article'),
            NumberField::new('unitprice')->setLabel('Prix unitaire (€)'),
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
