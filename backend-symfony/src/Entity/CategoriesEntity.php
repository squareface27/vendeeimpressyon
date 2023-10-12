<?php

namespace App\Entity;

use App\Repository\CategoriesEntityRepository;
use App\Entity\ArticlesEntity;
use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity(repositoryClass=CategoriesEntityRepository::class)
 */
class CategoriesEntity
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
     * @ORM\Column(type="string", length=255)
     */
    private $image;

    /**
     * @ORM\OneToMany(targetEntity=ArticlesEntity::class, mappedBy="category")
     */
     private $articles;


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

    public function getImage(): ?string
    {
        return $this->image;
    }

    public function setImage(string $image): self
    {
        $this->image = $image;

        return $this;
    }

    public function getArticles(): ?string
    {
        return $this->articles;
    }

    public function setArticles(string $articles): self
    {
        $this->image = $articles;

        return $this;
    }
}
