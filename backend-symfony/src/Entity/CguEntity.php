<?php

namespace App\Entity;

use App\Repository\CguEntityRepository;
use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity(repositoryClass=CguEntityRepository::class)
 */
class CguEntity
{
    /**
     * @ORM\Id
     * @ORM\GeneratedValue
     * @ORM\Column(type="integer")
     */
    private $id;

    /**
     * @ORM\Column(type="text")
     */
    private $cgu;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getCgu(): ?string
    {
        return $this->cgu;
    }

    public function setCgu(string $cgu): self
    {
        $this->cgu = $cgu;

        return $this;
    }
}
