<?php

namespace App\Entity;

use App\Entity\ArticlesEntity;
use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\Collection;
use App\Repository\CategoriesEntityRepository;

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
        return 'http://IP/vendeeimpressyon/backend-symfony/public/uploads/images/categories/' . $this->image;
    }

    public function setImage(string $image): self
    {
        $this->image = $image;

        return $this;
    }

    public function getArticles(): ?Collection
    {
        return $this->articles;
    }

    public function setArticles(Collection $articles): self
    {
        $this->image = $articles;

        return $this;
    }
}
