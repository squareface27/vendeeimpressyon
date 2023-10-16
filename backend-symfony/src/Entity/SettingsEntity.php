<?php

namespace App\Entity;

use App\Repository\SettingsEntityRepository;
use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity(repositoryClass=SettingsEntityRepository::class)
 */
class SettingsEntity
{
    /**
     * @ORM\Id
     * @ORM\GeneratedValue
     * @ORM\Column(type="integer")
     */
    private $id;

    /**
     * @ORM\Column(type="boolean")
     */
    private $vacance;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function isVacance(): ?bool
    {
        return $this->vacance;
    }

    public function setVacance(bool $vacance): self
    {
        $this->vacance = $vacance;

        return $this;
    }
}
