<?php

namespace App\Controller\Admin;

use App\Entity\CategoriesEntity;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ImageField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextEditorField;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use Vich\UploaderBundle\Form\Type\VichImageType;

class CategoriesEntityCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return CategoriesEntity::class;
    }

    
    public function configureFields(string $pageName): iterable
    {

        return [
            TextField::new('name')->setLabel('Nom de la catégorie'),
            ImageField::new('image')
                ->setLabel('Image de la catégorie')
                ->setUploadDir('public/uploads/images')
                ->setRequired(true)
                ->setUploadedFileNamePattern('[randomhash].[extension]')
                ->setHelp('Téléversez une image au format PNG')
        ];
    }
    
}
