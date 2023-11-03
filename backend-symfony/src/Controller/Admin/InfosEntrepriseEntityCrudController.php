<?php

namespace App\Controller\Admin;

use App\Entity\InfosEntrepriseEntity;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Field\IdField;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextEditorField;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;

class InfosEntrepriseEntityCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return InfosEntrepriseEntity::class;
    }

    public function configureActions(Actions $actions): Actions
    {
        $actions->disable(Action::NEW);
        $actions->disable(Action::DELETE);

        return $actions;
    }
}
