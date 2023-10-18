<?php

namespace App\Entity;

use App\Repository\ProductOptionEntityRepository;
use App\Entity\CategoriesEntity;
use App\Entity\CategoriesProductOptionEntity;
use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity(repositoryClass=ProductOptionEntityRepository::class)
 */
class ProductOptionEntity
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
     * @ORM\Column(type="float")
     */
    private $prix;

    /**
     * @ORM\ManyToOne(targetEntity=CategoriesEntity::class, inversedBy="articles")
     * @ORM\JoinColumn(name="category_id", referencedColumnName="id", nullable=false)
     */
    public $category;

    /**
     * @ORM\ManyToOne(targetEntity=CategoriesProductOptionEntity::class, inversedBy="categorieproductoption")
     * @ORM\JoinColumn(name="categoryoption", referencedColumnName="id", nullable=false)
     */
    public $categoryoption;

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

    public function getPrix(): ?float
    {
        return $this->prix;
    }

    public function setPrix(float $prix): self
    {
        $this->prix = $prix;

        return $this;
    }

    public function getCategoryOptionName(): ?string
    {
        return $this->categoryoption->getNom();
    }

    public function getCategoryName(): ?string
    {
    return $this->category->getName();
    }


    public function getCategoryoption(): ?CategoriesProductOptionEntity
    {
        return $this->categoryoption;
    }

    public function setCategoryoption(CategoriesProductOptionEntity $categoryoption): self
    {
        $this->categoryoption = $categoryoption;

        return $this;
    }
}
