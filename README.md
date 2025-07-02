## Server App Replica server-app-replica
This is just a replica of the old fashioned server app that was used to run the old website. It is not meant to be used in production, but rather as a reference for how the old app was structured.

- Virtual Host sites uses Ports to be able to used by Traefik.
- Mariadb is not setup properly in my setup as I won't be needing it for my simple/sample testing purposes.

## Installation and Configuration
1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/server-app-replica.git
    cd server-app-replica
    ```

2. Setup all Sample files to your local need
    docker-compose.yml.SAMPLE
    Dockerfile.SAMPLE
    vhost-site1.conf.SAMPLE
    vhost-site2.conf.SAMPLE
    sites-cron.SAMPLE
    apache_log_watcher.py.SAMPLE

    ```bash
    cp apache_log_watcher.py.SAMPLE apache_log_watcher.py
    cp docker-compose.yml.SAMPLE docker-compose.yml
    cp Dockerfile.SAMPLE Dockerfile
    cp sites-cron.SAMPLE sites-cron
    cp vhost-site1.conf.SAMPLE vhost-site1.conf
    cp vhost-site2.conf.SAMPLE vhost-site2.conf
    ```

4. Install using docker-compose:

    ```bash
    docker-compose up --build -d
    ```

 



## Useful commands

For building app server
`docker-compose up --build -d`
