<?php

namespace App\Tests\Controller;

use Symfony\Component\HttpFoundation\Response;
use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class ApiControllerFactorizedTest extends WebTestCase
{
    private $apiUrls = [];

    public function setUp(): void
    {
        parent::setUp();

        // URLs à tester
        $this->apiUrls = [
            'login' => getenv('API_URL_LOGIN'),
            'register' => getenv('API_URL_REGISTER'),
            'reset_password' => getenv('API_URL_RESET_PASSWORD'),
            'get_etablissement' => getenv('API_URL_GET_ETABLISSEMENT'),
            'get_categories' => getenv('API_URL_GET_CATEGORIES'),
        ];
    }

    // Tester la disponibilité d'une page avec GET
    private function testApiPageGet($urlKey) {
        $client = static::createClient();
        $client->request('GET', $this->apiUrls[$urlKey]);
        $this->assertResponseStatusCodeSame(Response::HTTP_OK);
    }

    // Tester la disponibilité d'une page avec GET
    private function testApiPagePost($urlKey) {
        $client = static::createClient();
        $client->request('POST', $this->apiUrls[$urlKey]);
        $this->assertResponseStatusCodeSame(Response::HTTP_OK);
    }

    // Méthode page login
    public function testLoginApiPage() {
        $this->testApiPagePost('login');
    }

    // Méthode page register
    public function testRegisterApiPage() {
        $this->testApiPagePost('register');
    }

    // Méthode page reset password
    public function testResetPasswordApiPage() {
        $this->testApiPageGet('reset_password');
    }

    // Méthode page get établissement
    public function testGetEtablissementApiPage() {
        $this->testApiPageGet('get_etablissement');
    }

    // Méthode page get categories
    public function testGetCategoriesApiPage() {
        $this->testApiPageGet('get_categories');
    }
}
