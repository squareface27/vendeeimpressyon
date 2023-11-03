<?php

namespace App\Controller;

use DateTime;
use Dompdf\Dompdf;
use Dompdf\Options;
use App\Entity\UserEntity;
use Psr\Log\LoggerInterface;
use App\Entity\ArticlesEntity;
use App\Services\ApiAuthService;
use Symfony\Component\Mime\Email;
use Symfony\Polyfill\Intl\Idn\Info;
use App\Repository\UserEntityRepository;
use Doctrine\ORM\EntityManagerInterface;
use App\Repository\FraisEntityRepository;
use Doctrine\Persistence\ManagerRegistry;
use App\Repository\ArticlesEntityRepository;
use App\Repository\SettingsEntityRepository;
use Symfony\Component\HttpClient\HttpClient;
use App\Repository\CodePromoEntityRepository;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Mailer\MailerInterface;
use App\Repository\CategoriesEntityRepository;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use App\Repository\ProductOptionEntityRepository;
use Symfony\Component\HttpFoundation\JsonResponse;
use App\Repository\InfosEntrepriseEntityRepository;
use App\Repository\EtablissementScolaireEntityRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class ApiController extends AbstractController
{

    private $entityManager;
    private $logger;
    private $pdfFilePath;

    public function __construct(ManagerRegistry $registry, LoggerInterface $logger)
    {
        $this->entityManager = $registry->getManager();
        $this->logger = $logger;
    }

    // Désérialisation du JSON flutter pour créer un utilisateur

    public function createUser(Request $request, UserPasswordHasherInterface $passwordHasher)
    {

        $pseudo = $request->request->get('pseudo');
        $username = $request->request->get('mail');
        $password = $request->request->get('password');
        $confirmPassword = $request->request->get('confirm_password');
        $selectedEtablissement = $request->request->get('etablissement');

        if ($password !== $confirmPassword) {
            return new JsonResponse(['message' => 'ERREUR'], 400);
        }
        if ($password == null) {
            return new JsonResponse(['message' => 'ERREUR'], 400);
        }

        // Vérification de l'adresse

        if (!preg_match('/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/', $username)) {
            return new JsonResponse(['message' => 'ERREUR'], 400);
        }

        $user = new UserEntity();
        $user->setPseudo($pseudo);
        $user->setMail($username);
        $user->setRole('ROLE_USER');
        $user->setetablissement($selectedEtablissement);

        $hashedPassword = $passwordHasher->hashPassword($user, $password);
        $user->setPassword($hashedPassword);

        $this->entityManager->persist($user);
        $this->entityManager->flush();

        return new JsonResponse(['message' => 'ERREUR'], 200);
    }

        // Désérialisation du JSON flutter pour la connexion des utilisateurs

    public function login(Request $request, ApiAuthService $authService, UserPasswordHasherInterface $passwordHasher)
    {
        $formUsername = $request->request->get('mail');
        $formPassword = $request->request->get('password');

        $user = $authService->getUserByUsername($formUsername);


        if (!$user || !$passwordHasher->isPasswordValid($user, $formPassword)) {
            return new JsonResponse(['message' => 'Connexion échouée, identifiant ou mot de passe incorrect'], 401);
        }
            return new JsonResponse(['message' => 'Connexion réussie avec succès'], 200);
    }

        // Sérialisation du nom des établissements scolaire de la BDD vers JSON pour flutter

    public function getEmail(EntityManagerInterface $entityManager, UserEntityRepository $UserEntityRepository)
    {
        $email = $UserEntityRepository->findAll();

        $data = [];
        foreach ($email as $email) {
            $mail = $email->getUsername();


            $data[] = [
            'mail' => $mail,
            ];
        }
        
        return new JsonResponse($data);
    }


    // Sérialisation des adresses-mail de la BDD vers JSON pour flutter (vérification si l'email est déjà associée à un compte)
    public function getEtablissement(EntityManagerInterface $entityManager, EtablissementScolaireEntityRepository $etablissementRepository)
    {
        $etablissements = $etablissementRepository->findAll();

        $data = [];
        foreach ($etablissements as $etablissement) {
            $nom = $etablissement->getNom();
            $ville = $etablissement->getVille();

            if ($ville === null) {
            $ville = "";
            }

            $data[] = [
            'nom' => $nom,
            'ville' => $ville,
            ];
        }
        
        return new JsonResponse($data);
    }


    // Sérialisation des catégories de la BDD vers JSON pour flutter
    public function getCategories(EntityManagerInterface $entityManager, CategoriesEntityRepository $categoriesEntityRepository)
    {
        $categories = $categoriesEntityRepository->findAll();

        $data = [];
        foreach ($categories as $categorie) {
            $name = $categorie->getName();
            $image = $categorie->getImage();

            $data[] = [
            'name' => $name,
            'image' => $image,
            ];
        }
        
        return new JsonResponse($data);
    }

    // Sérialisation des souscatégories de la BDD vers JSON pour flutter
    public function getSousCategories(EntityManagerInterface $entityManager, ArticlesEntityRepository $articlesEntityRepository)
    {
        $souscategories = $articlesEntityRepository->findAll();

        $data = [];
        foreach ($souscategories as $souscategorie) {
            $name = $souscategorie->getName();
            $description = $souscategorie->getDescription();
            $price = $souscategorie->getUnitprice();
            $image = $souscategorie->getImage();
            $categorieId = $souscategorie->getCategoryName();

            $data[] = [
            'name' => $name,
            'unitprice' => $price,
            'image' => $image,
            'categorieid' => $categorieId,
            ];
        }
        
        return new JsonResponse($data);
    }

    // Sérialisation du mode vacance de la BDD vers JSON pour flutter
    public function getSettings(EntityManagerInterface $entityManager, SettingsEntityRepository $settingsEntityRepository)
    {
        $settings = $settingsEntityRepository->findAll();

        $data = [];
        foreach ($settings as $settings) {
            $vacance = $settings->isVacance();

            $data[] = [
            'vacance' => $vacance,
            ];
        }
        
        return new JsonResponse($data);
    }

    // Sérialisation des souscatégories de la BDD vers JSON pour flutter
    public function getProductOption(EntityManagerInterface $entityManager, ProductOptionEntityRepository $ProductOptionEntityRepository)
    {
        $productOptions = $ProductOptionEntityRepository->findAll();

        $data = [];
        foreach ($productOptions as $productOption) {
            $name = $productOption->getNom();
            $price = $productOption->getPrix();
            $categorieOptionName = $productOption->getCategoryOptionName();
            $categorieId = $productOption->getCategoryName();


            $data[] = [
            'name' => $name,
            'prix' => $price,
            'categorieOptionName' => $categorieOptionName,
            'categorieid' => $categorieId,
            ];
        }
        
        return new JsonResponse($data);
    }

    // Sérialisation des codes promo de la BDD vers JSON pour flutter
    public function getCodePromo(EntityManagerInterface $entityManager, CodePromoEntityRepository $CodePromoEntityRepository)
    {
        $codepromos = $CodePromoEntityRepository->findAll();

        $data = [];
        foreach ($codepromos as $codepromo) {
            $code = $codepromo->getCode();
            $amount = $codepromo->getMontant();


            $data[] = [
            'code' => $code,
            'montant' => $amount,
            ];
        }
        
        return new JsonResponse($data);
    }

    public function uploadPdf(Request $request)
    {
        $response = new Response();

        if ($request->request->has('pdfName')) {
            $pdfName = $request->request->get('pdfName');
            $this->logger->info('Nom du fichier PDF importé avec succès !' . $pdfName);
            $response->setStatusCode(Response::HTTP_OK);
        } else {
            $this->logger->error('Erreur lors de l\'importation du nom du PDF !');
            $response->setStatusCode(Response::HTTP_INTERNAL_SERVER_ERROR);
        }
        if ($request->files->has('pdf')) {
            $uploadedFile = $request->files->get('pdf');
            $this->logger->info('Fichier PDF : ' . $uploadedFile);

            $this->pdfFilePath = $this->getParameter('pdf_directory') . '/' . $pdfName;
            $uploadedFile->move(
                $this->getParameter('pdf_directory'),
                $this->pdfFilePath
            );

            $this->logger->info('Fichier PDF téléchargé avec succès !');
            $response->setStatusCode(Response::HTTP_OK);
            $response->setContent('Fichier PDF téléchargé avec succès !');
        } else {
            $this->logger->error('Erreur lors du téléchargement du PDF !');
            $response->setStatusCode(Response::HTTP_INTERNAL_SERVER_ERROR);
            $response->setContent('Erreur lors du téléchargement du PDF !');
        }

        return $response;
    }


    // Sérialisation des frais de la BDD vers JSON pour flutter
    public function getFrais(EntityManagerInterface $entityManager, FraisEntityRepository $fraisEntityRepository)
    {
        $frais = $fraisEntityRepository->findAll();

        $data = [];
        foreach ($frais as $frai) {
            $id = $frai->getId();
            $nom = $frai->getNom();
            $amount = $frai->getMontant();


            $data[] = [
            'id' => $id,
            'nom' => $nom,
            'montant' => $amount,
            ];
        }
        
        return new JsonResponse($data);
    }

    

    // Création du PDF des factures

    public function generateInvoice(Request $request, MailerInterface $mailer, EntityManagerInterface $entityManager, InfosEntrepriseEntityRepository $Info)
{
    $date = new DateTime();
    $annee = $date->format('Y');
    $mois = $date->format('m');



    $rawData = $request->getContent();
    $data = json_decode($rawData, true);

    $id = $data['id'];
    $produit = $data['productName'];
    $price = $data['totalPrice'];
    $date = $data['date'];
    $quantite = $data['quantite'];
    $email = $data['email'];
    $reliureName = $data['reliureName'];
    $couleurCouvertureName = $data['couleurCouvertureName'];
    $premierpageName = $data['premierepageName'];
    $finitionName = $data['finitionName'];
    $couvertureName = $data['couvertureName'];
    $couverturePapierName = $data['couverturePapierName'];
    $nombrePage = $data['nombrePage'];
    $pdfName = $data['pdfName'];

    $userRepository = $entityManager->getRepository(UserEntity::class);

    $query = $userRepository->createQueryBuilder('u')
        ->select('u.pseudo')
        ->where('u.mail = :mail')
        ->setParameter('mail', $email)
        ->getQuery();

    $result = $query->getOneOrNullResult();
    $pseudo = $result['pseudo'];

    $numeroFacture = "FACTURE N° $annee-$mois-$id";
    $numeroCommande = "COMMANDE N° $annee-$mois-$id";
    $numeroFactureFile = "FACTURE N° $annee-$mois-$id.pdf";
    $numeroCommandeFile = "COMMANDE N° $annee-$mois-$id.pdf";

    $montantBrut = number_format($price / (1 + 0.20), 2);

    $prixUnitaire = number_format($montantBrut / $quantite, 2);

    $infoentreprise = $Info->findAll();

        $data = [];
        foreach ($infoentreprise as $infos) {
            $nom = $infos->getNom();
            $capital = $infos->getCapital();
            $mail = $infos->getMail();
            $tel = $infos->getTel();
            $web = $infos->getWeb();
            $rcs = $infos->getRcs();
            $ville = $infos->getVille();
            $tva = $infos->getTva();
            $ape = $infos->getApe();

    $options = new Options();
    $options->set('isHtml5ParserEnabled', true);
    $options->set('isPhpEnabled', true);

    $dompdf = new Dompdf($options);
    $dompdfForCommande = new Dompdf($options);

    $logoPath = 'http://localhost/vendeeimpressyon/backend-symfony/public/uploads/images/logo/logo.png';
    $logoData = base64_encode(file_get_contents($logoPath));


    $htmlFacture = '<html>
    <head>
        <style>
            table {
                width: 100%;
                border-collapse: collapse;
            }
            th, td {
                border: 1px solid #000;
                padding: 8px;
            }

            /* Style pour les en-têtes de tableau */
            th {
                background-color: #f2f2f2;
            }

            footer {
                position: absolute;
                bottom: 0;
                width: 100%;
            }

        </style>
    </head>
    <body>
        <div class="header">
        <img src="data:image/png;base64,' . $logoData . '" style="float:right" alt="Logo">
        <h5>EURL GRAPHINET - VENDEE IMPRESS\'YON</h5>
        <p style=font-size:15px;>62 bis rue Maréchal Ney
        <br>85000 LA ROCHE SUR YON</p>
        </div>
        <br>
        <div class="content">
            <h5>' . $numeroFacture . '</h5>
            <p>Date : ' . $date . '</p>

            <h4>Détails de la commande :</h4>
            <table>
                <tr>
                    <th>Produit</th>
                    <th>Prix unitaire HT</th>
                    <th>Quantité</th>
                    <th>Total</th>
                </tr>
                <tr>
                    <td>' . $produit . '</td>
                    <td>' . number_format($prixUnitaire, 2) . '€</td>
                    <td>' . $quantite . '</td>
                    <td>' . number_format($montantBrut * 1.2, 2) . ' €</td>
                </tr>
                <tr>
                    <td colspan="3">Sous-total HT</td>
                    <td>' . number_format($montantBrut, 2) . '€</td>
                </tr>
                <tr>
                    <td colspan="3">TVA (20%)</td>
                    <td>' . number_format($montantBrut * 0.2, 2) . ' €</td>
                </tr>
                <tr>
                    <td colspan="3"><strong>Total</strong></td>
                    <td><strong>' . number_format($montantBrut * 1.2, 2) . ' €</strong></td>
                </tr>
            </table>
        </div>
        <footer class="footer">
            <hr>
            <p style=font-size:15px;>
            ' . $nom . ' au capital de ' .$capital .' - ' .$rcs .' RCS ' .$ville .' - N°TVA: ' .$tva .' - APE : ' .$ape .'
            </p>
            <p style=font-size:13px;>Web : ' .$web .' - Email : ' .$mail .' - Tél : ' .$tel .'</p>
        </footer>
    </body>
</html>';

    $dompdf->loadHtml($htmlFacture);

    $dompdf->setPaper('A4', 'portrait');
    $dompdf->render();

    $output = $dompdf->output();
    file_put_contents($numeroFactureFile, $output);

    $htmlBonDeCommande = '<html>
    <head>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #000;
            padding: 8px;
        }

        /* Style pour les en-têtes de tableau */
        th {
            background-color: #f2f2f2;
        }

        footer {
            position: absolute;
            bottom: 0;
            width: 100%;
        }

    </style>
</head>
<body>
    <div class="header">
        <img src="data:image/png;base64,' . $logoData . '" style="float:right" alt="Logo">
        <h5>EURL GRAPHINET - VENDEE IMPRESS\'YON</h5>
        <p style="font-size:15px;">62 bis rue Maréchal Ney
            <br>85000 LA ROCHE SUR YON</p>
    </div>
    <br>
    <div class="content">
        <p>Date : ' . $date . '</p>
        <p>Client : ' . $pseudo . '</p>

        <h4> ' . $numeroCommande . '</h4>
        <hr>
        <br>
        <h3>Produit : ' . $produit . '</h3>
        
        <h4>Options :</h4>
        <ul>';

        $htmlBonDeCommande .= '<li>Nombre de pages : ' . $nombrePage .' </li>';
        $htmlBonDeCommande .= '<li>Nombre d\'exemplaires : ' . $quantite .' </li>';

if (!empty($reliureName)) {
    $htmlBonDeCommande .= '<li>Reliure : ' . $reliureName . '</li>';
}
if (!empty($couleurCouvertureName)) {
    $htmlBonDeCommande .= '<li>Couleur de la couverture : ' . $couleurCouvertureName . '</li>';
}
if (!empty($premierpageName)) {
    $htmlBonDeCommande .= '<li>Type de 1ère page : ' . $premierpageName . '</li>';
}
if (!empty($finitionName)) {
    $htmlBonDeCommande .= '<li>Type de finition : ' . $finitionName . '</li>';
}
if (!empty($couvertureName)) {
    $htmlBonDeCommande .= '<li>Type de couverture : ' . $couvertureName . '</li>';
}
if (!empty($couverturePapierName)) {
    $htmlBonDeCommande .= '<li>Type de papier de couverture : ' . $couverturePapierName . '</li>';
}

$htmlBonDeCommande .= '</ul>
    </div>
    <footer class="footer">
            <hr>
            <p style=font-size:15px;>
            ' . $nom . ' au capital de ' .$capital .' - ' .$rcs .' RCS ' .$ville .' - N°TVA: ' .$tva .' - APE : ' .$ape .'
            </p>
            <p style=font-size:13px;>Web : ' .$web .' - Email : ' .$mail .' - Tél : ' .$tel .'</p>
        </footer>
</body>
</html>';

        $dompdfForCommande->loadHtml($htmlBonDeCommande);
        $dompdfForCommande->render();
        $commandeOutput = $dompdfForCommande->output();
        file_put_contents($numeroCommandeFile, $commandeOutput);


    $emailClient = (new Email())
        ->from('vendee.impressyon@gmail.com')
        ->to($email)
        ->subject('Facture Vendée Impress\'Yon')
        ->text('Merci de trouver en pièce jointe la facture de votre achat.')
        ->attachFromPath($numeroFactureFile);

    $emailReceptionCommande = (new Email())
        ->from('vendee.impressyon@gmail.com')
        ->to('etudiant.impressyon@gmail.com')
        ->subject('Nouvelle Commande de ' . $pseudo)
        ->html('<a href="http://localhost/vendeeimpressyon/backend-symfony/public/pdf/'.$pdfName.'">Lien d\'accès au PDF</a>')
        ->attachFromPath($numeroCommandeFile)
        ->attachFromPath($numeroFactureFile);

    $mailer->send($emailClient);
    $mailer->send($emailReceptionCommande);


    return new JsonResponse(['message' => 'Facture générée et envoyée avec succès']);

        }
    }
}