<?php

namespace App\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Symfony\Component\HttpFoundation\Response;

class ApiControllerTest extends WebTestCase
{
    private $apiUrlLogin;
    private $apiUrlRegister;
    private $apiUrlResetPassword;
    private $apiUrlGetEtablissement;
    private $apiUrlGetCategories;

    public function setUp(): void
    {
        parent::setUp();
        $this->apiUrlLogin = getenv('API_URL_LOGIN');
        $this->apiUrlRegister = getenv('API_URL_REGISTER');
        $this->apiUrlResetPassword = getenv('API_URL_RESET_PASSWORD');
        $this->apiUrlGetEtablissement = getenv('API_URL_GET_ETABLISSEMENT');
        $this->apiUrlGetCategories = getenv('API_URL_GET_CATEGORIES');
    }

    // Méthode pour tester la disponibilité de la page login de l'API
    public function testLoginApiPage() {
        $client = static::createClient();
        $client->request('POST', $this->apiUrlLogin);
        $this->assertResponseStatusCodeSame(Response::HTTP_OK);
    }

    // Méthode pour tester la disponibilité de la page register de l'API
    public function testRegisterApiPage() {
        $client = static::createClient();
        $client->request('POST', $this->apiUrlRegister);
        $this->assertResponseStatusCodeSame(Response::HTTP_OK);
    }

    // Méthode pour tester la disponibilité de la page de réinitialisation de mot de passe de l'API
    public function testResetPasswordApiPage() {
        $client = static::createClient();
        $client->request('GET', $this->apiUrlResetPassword);
        $this->assertResponseStatusCodeSame(Response::HTTP_OK);
    }

    // Méthode pour tester la disponibilité de la page de réinitialisation de mot de passe de l'API
    public function testGetEtablissementApiPage() {
        $client = static::createClient();
        $client->request('GET', $this->apiUrlGetEtablissement);
        $this->assertResponseStatusCodeSame(Response::HTTP_OK);
    }

    // Méthode pour tester la disponibilité de la page get categories l'API
    public function testGetCategoriesApiPage() {
        $client = static::createClient();
        $client->request('GET', $this->apiUrlGetCategories);
        $this->assertResponseStatusCodeSame(Response::HTTP_OK);
    }
}
