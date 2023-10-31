<?php

namespace App\Controller\Admin;

use App\Entity\CgvEntity;
use FOS\CKEditorBundle\Form\Type\CKEditorType;

use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextEditorField;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;

class CgvEntityCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return CgvEntity::class;
    }

    public function configureFields(string $pageName): iterable
    {
        return [
            TextEditorField::new('cgv', 'Contenu')
        ];
    }

    public function configureActions(Actions $actions): Actions
    {
        $actions->disable(Action::NEW);
        $actions->disable(Action::DELETE);

        return $actions;
    }
}
