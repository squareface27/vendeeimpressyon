<?php

namespace App\Repository;

use App\Entity\EtablissementScolaireEntity;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<EtablissementScolaireEntity>
 *
 * @method EtablissementScolaireEntity|null find($id, $lockMode = null, $lockVersion = null)
 * @method EtablissementScolaireEntity|null findOneBy(array $criteria, array $orderBy = null)
 * @method EtablissementScolaireEntity[]    findAll()
 * @method EtablissementScolaireEntity[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class EtablissementScolaireEntityRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, EtablissementScolaireEntity::class);
    }

    public function add(EtablissementScolaireEntity $entity, bool $flush = false): void
    {
        $this->getEntityManager()->persist($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    public function remove(EtablissementScolaireEntity $entity, bool $flush = false): void
    {
        $this->getEntityManager()->remove($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

//    /**
//     * @return EtablissementScolaireEntity[] Returns an array of EtablissementScolaireEntity objects
//     */
//    public function findByExampleField($value): array
//    {
//        return $this->createQueryBuilder('e')
//            ->andWhere('e.exampleField = :val')
//            ->setParameter('val', $value)
//            ->orderBy('e.id', 'ASC')
//            ->setMaxResults(10)
//            ->getQuery()
//            ->getResult()
//        ;
//    }

//    public function findOneBySomeField($value): ?EtablissementScolaireEntity
//    {
//        return $this->createQueryBuilder('e')
//            ->andWhere('e.exampleField = :val')
//            ->setParameter('val', $value)
//            ->getQuery()
//            ->getOneOrNullResult()
//        ;
//    }
}
