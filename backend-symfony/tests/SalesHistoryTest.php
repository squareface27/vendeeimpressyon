<?php

namespace App\Tests;

use App\Entity\SaleshistoryEntity;
use PHPUnit\Framework\TestCase;

class SalesHistoryTest extends TestCase
{
    public function testGetDateDeVenteString() {
        $vente = new SaleshistoryEntity();
        $now = new \DateTime('now');
        $vente->setDate($now);
        $this->assertEquals($now, $vente->getDate()); 
    }
}
