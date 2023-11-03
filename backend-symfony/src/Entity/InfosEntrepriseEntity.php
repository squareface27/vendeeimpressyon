<?php

namespace App\Entity;

use App\Repository\InfosEntrepriseEntityRepository;
use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity(repositoryClass=InfosEntrepriseEntityRepository::class)
 */
class InfosEntrepriseEntity
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
     * @ORM\Column(type="string", length=255)
     */
    private $mail;

    /**
     * @ORM\Column(type="string", length=255)
     */
    private $tel;

    /**
     * @ORM\Column(type="string", length=255)
     */
    private $tva;

    /**
     * @ORM\Column(type="string", length=255)
     */
    private $web;

    /**
     * @ORM\Column(type="string", length=255)
     */
    private $capital;

    /**
     * @ORM\Column(type="string", length=255)
     */
    private $ape;

    /**
     * @ORM\Column(type="string", length=255)
     */
    private $rcs;

    /**
     * @ORM\Column(type="string", length=255)
     */
    private $ville;

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

    public function getMail(): ?string
    {
        return $this->mail;
    }

    public function setMail(string $mail): self
    {
        $this->mail = $mail;

        return $this;
    }

    public function getTel(): ?string
    {
        return $this->tel;
    }

    public function setTel(string $tel): self
    {
        $this->tel = $tel;

        return $this;
    }

    public function getTva(): ?string
    {
        return $this->tva;
    }

    public function setTva(string $tva): self
    {
        $this->tva = $tva;

        return $this;
    }

    public function getWeb(): ?string
    {
        return $this->web;
    }

    public function setWeb(string $web): self
    {
        $this->web = $web;

        return $this;
    }

    public function getCapital(): ?string
    {
        return $this->capital;
    }

    public function setCapital(string $capital): self
    {
        $this->capital = $capital;

        return $this;
    }

    public function getApe(): ?string
    {
        return $this->ape;
    }

    public function setApe(string $ape): self
    {
        $this->ape = $ape;

        return $this;
    }

    public function getRcs(): ?string
    {
        return $this->rcs;
    }

    public function setRcs(string $rcs): self
    {
        $this->rcs = $rcs;

        return $this;
    }

    public function getVille(): ?string
    {
        return $this->ville;
    }

    public function setVille(string $ville): self
    {
        $this->ville = $ville;

        return $this;
    }
}
