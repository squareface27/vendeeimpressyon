<?php

namespace App\Entity;

use App\Repository\ArticlesEntityRepository;
use App\Entity\CategoriesEntity;
use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity(repositoryClass=ArticlesEntityRepository::class)
 */
class ArticlesEntity
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
    private $name;

    /**
     * @ORM\Column(type="float")
     */
    private $unitprice;

    /**
    * @ORM\ManyToOne(targetEntity=CategoriesEntity::class, inversedBy="articles")
    * @ORM\JoinColumn(name="category_id", referencedColumnName="id", nullable=false)
    */
    private $category;


    public function getId(): ?int
    {
        return $this->id;
    }

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(string $name): self
    {
        $this->name = $name;

        return $this;
    }

    public function getUnitprice(): ?float
    {
        return $this->unitprice;
    }

    public function setUnitprice(float $unitprice): self
    {
        $this->unitprice = $unitprice;

        return $this;
    }

}
