<?php

namespace App\Repository;

use App\Entity\MentionsLegalesEntity;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<MentionsLegalesEntity>
 *
 * @method MentionsLegalesEntity|null find($id, $lockMode = null, $lockVersion = null)
 * @method MentionsLegalesEntity|null findOneBy(array $criteria, array $orderBy = null)
 * @method MentionsLegalesEntity[]    findAll()
 * @method MentionsLegalesEntity[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class MentionsLegalesEntityRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, MentionsLegalesEntity::class);
    }

    public function add(MentionsLegalesEntity $entity, bool $flush = false): void
    {
        $this->getEntityManager()->persist($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    public function remove(MentionsLegalesEntity $entity, bool $flush = false): void
    {
        $this->getEntityManager()->remove($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

//    /**
//     * @return MentionsLegalesEntity[] Returns an array of MentionsLegalesEntity objects
//     */
//    public function findByExampleField($value): array
//    {
//        return $this->createQueryBuilder('m')
//            ->andWhere('m.exampleField = :val')
//            ->setParameter('val', $value)
//            ->orderBy('m.id', 'ASC')
//            ->setMaxResults(10)
//            ->getQuery()
//            ->getResult()
//        ;
//    }

//    public function findOneBySomeField($value): ?MentionsLegalesEntity
//    {
//        return $this->createQueryBuilder('m')
//            ->andWhere('m.exampleField = :val')
//            ->setParameter('val', $value)
//            ->getQuery()
//            ->getOneOrNullResult()
//        ;
//    }
}
