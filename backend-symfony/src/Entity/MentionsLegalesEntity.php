<?php

namespace App\Entity;

use App\Repository\MentionsLegalesEntityRepository;
use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity(repositoryClass=MentionsLegalesEntityRepository::class)
 */
class MentionsLegalesEntity
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
    private $mentions;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getMentions(): ?string
    {
        return $this->mentions;
    }

    public function setMentions(string $mentions): self
    {
        $this->mentions = $mentions;

        return $this;
    }
}
