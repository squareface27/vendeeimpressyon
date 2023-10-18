<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\Collection;
use App\Repository\CategoriesProductOptionEntityRepository;

/**
 * @ORM\Entity(repositoryClass=CategoriesProductOptionEntityRepository::class)
 */
class CategoriesProductOptionEntity
{
    /**
     * @ORM\Id
     * @ORM\GeneratedValue
     * @ORM\Column(type="integer")
     */
    private $id;

    /**
     * @ORM\Column(type="string", length=255)
     */
    private $nom;

    /**
     * @ORM\OneToMany(targetEntity=ProductOptionEntity::class, mappedBy="categoryoption")
     */
    private $categorieproductoption;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getNom(): ?string
    {
        return $this->nom;
    }

    public function setNom(string $nom): self
    {
        $this->nom = $nom;

        return $this;
    }

    public function categorieproductoption(): ?Collection
    {
        return $this->categorieproductoption;
    }
}
