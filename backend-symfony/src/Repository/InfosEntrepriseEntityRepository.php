<?php

namespace App\Repository;

use App\Entity\InfosEntrepriseEntity;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<InfosEntrepriseEntity>
 *
 * @method InfosEntrepriseEntity|null find($id, $lockMode = null, $lockVersion = null)
 * @method InfosEntrepriseEntity|null findOneBy(array $criteria, array $orderBy = null)
 * @method InfosEntrepriseEntity[]    findAll()
 * @method InfosEntrepriseEntity[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class InfosEntrepriseEntityRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, InfosEntrepriseEntity::class);
    }

    public function add(InfosEntrepriseEntity $entity, bool $flush = false): void
    {
        $this->getEntityManager()->persist($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    public function remove(InfosEntrepriseEntity $entity, bool $flush = false): void
    {
        $this->getEntityManager()->remove($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

//    /**
//     * @return InfosEntrepriseEntity[] Returns an array of InfosEntrepriseEntity objects
//     */
//    public function findByExampleField($value): array
//    {
//        return $this->createQueryBuilder('i')
//            ->andWhere('i.exampleField = :val')
//            ->setParameter('val', $value)
//            ->orderBy('i.id', 'ASC')
//            ->setMaxResults(10)
//            ->getQuery()
//            ->getResult()
//        ;
//    }

//    public function findOneBySomeField($value): ?InfosEntrepriseEntity
//    {
//        return $this->createQueryBuilder('i')
//            ->andWhere('i.exampleField = :val')
//            ->setParameter('val', $value)
//            ->getQuery()
//            ->getOneOrNullResult()
//        ;
//    }
}
