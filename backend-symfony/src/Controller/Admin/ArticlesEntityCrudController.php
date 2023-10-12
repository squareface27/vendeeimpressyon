<?php

namespace App\Controller\Admin;

use App\Entity\ArticlesEntity;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;

class ArticlesEntityCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return ArticlesEntity::class;
    }

}
