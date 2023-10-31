<?php

namespace App\Entity;

use App\Repository\CgvEntityRepository;
use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity(repositoryClass=CgvEntityRepository::class)
 */
class CgvEntity
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
    private $cgv;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getCgv(): ?string
    {
        return $this->cgv;
    }

    public function setCgv(string $cgv): self
    {
        $this->cgv = $cgv;

        return $this;
    }
}
