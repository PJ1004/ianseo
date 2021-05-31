# pj1004/ianseo - docker-compose build
Docker Build for World Archery IANSEO System

Info:
 - Author - PJ1004
 - Version - 1.0
 - Last Modified - 21-May-2021


Context:
 - Database - MariaDB:10.5
 - Apache Webserver - PHP 7.2
 - IANSEO - 20210414

How To:
Once the repository is cloned, run the following command from inside the ianseo directory:
    docker-compose up

When the containers have started, open your web browser and navigate to:
    http://127.0.0.1/ianseo


First Run:
When connecting to the database on the IANSEO first-run screen, just enter either "db" or "172.20.0.20" in the write server Host field.  The root password is not required as a blank 'ianseo' database is created at first-time startup along with the 'ianseo' user.

Refer to the .env file if you wish to change the password or database settings before first run.
If you want to retain your customisations in the .env file for future versions, add ".env" to your ".gitignore" file
