<?php

namespace App\Controller\Admin;

use App\Entity\User;
use App\Entity\CguEntity;
use App\Entity\UserEntity;
use App\Entity\FraisEntity;
use App\Entity\ArticlesEntity;
use App\Entity\SettingsEntity;
use App\Entity\CodePromoEntity;
use App\Entity\CommandesEntity;
use App\Entity\CategoriesEntity;
use App\Entity\SaleshistoryEntity;
use App\Entity\ProductOptionEntity;
use App\Entity\EtablissementScolaireEntity;
use App\Entity\CategoriesProductOptionEntity;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use EasyCorp\Bundle\EasyAdminBundle\Config\MenuItem;
use EasyCorp\Bundle\EasyAdminBundle\Config\Dashboard;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractDashboardController;

class AdminDashboardController extends AbstractDashboardController
{
    public function index(): Response
    {
        return parent::index();
    }

    public function configureDashboard(): Dashboard
    {
        return Dashboard::new()
            ->setTitle('<img src="../templates/assets/images/logo.png"> Vendée Impress\'Yon');
    }

    public function configureMenuItems(): iterable
    {
        yield MenuItem::section('Établissements scolaires');
        yield MenuItem::linkToCrud('Liste des établissements', 'fa fa-list', EtablissementScolaireEntity::class);
        yield MenuItem::section('Boutique');
        yield MenuItem::linkToCrud('Listes des catégories', 'fa fa-tags', CategoriesEntity::class);
        yield MenuItem::linkToCrud('Listes des articles', 'fa fa-shopping-bag', ArticlesEntity::class);
        yield MenuItem::linkToCrud('Listes catégories d\'options', 'fa fa-list', CategoriesProductOptionEntity::class);
        yield MenuItem::linkToCrud('Listes des options', 'fa fa-filter', ProductOptionEntity::class);
        yield MenuItem::linkToCrud('Listes des codes promos', 'fa fa-ticket', CodePromoEntity::class);
        yield MenuItem::linkToCrud('Listes des clients', 'fa fa-users', UserEntity::class);
        yield MenuItem::section('Paramètres de la boutique');
        yield MenuItem::linkToCrud('Paramètres', 'fa fa-cog', SettingsEntity::class);
        yield MenuItem::linkToCrud('Modifier les CGU', 'fa fa-file-text', CguEntity::class);
        yield MenuItem::linkToCrud('Liste des frais', 'fa fa-money', FraisEntity::class);
        yield MenuItem::linkToCrud('Liste des administrateurs', 'fa fa-user', User::class);
    }
}
