<?php

namespace App\Services;

use App\Entity\UserEntity;
use Doctrine\DBAL\Connection;

class ApiAuthService
{
    private $connection;

    public function __construct(Connection $connection)
    {
        $this->connection = $connection;
    }

    public function authenticate($formUsername, $formPassword)
    {
        $query = "SELECT * FROM user_entity WHERE mail = ? AND password = ?";
        $result = $this->connection->executeQuery($query, [$formUsername, $formPassword]);

        if ($result->rowCount() > 0) {
             return true;
        } else {
             return false;
        }
    }

    public function getUserByUsername($username)
    {
        $query = "SELECT * FROM user_entity WHERE mail = ?";
        $result = $this->connection->executeQuery($query, [$username]);

        $userData = $result->fetchAssociative();

        if (!$userData) {
            return null;
        }

        // Créez un objet UserEntity à partir des données de la base de données
        $user = new UserEntity();
        $user->setMail($userData['mail']);
        $user->setPassword($userData['password']);

        return $user;
    }
}
