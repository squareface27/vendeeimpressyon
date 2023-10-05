<?php

namespace App\Controller\Admin;

use App\Entity\EtablissementScolaireEntity;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;

class EtablissementScolaireEntityCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return EtablissementScolaireEntity::class;
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
