#!/bin/sh

# Stop running docker
sudo docker rm -v $(docker ps -aq -f status=exited)
sudo docker stop $(docker ps -a -q)
sudo docker container prune -f

# Delete DB data
sudo rm -rf docker/mysql/data

# Pull git src code
sudo rm -rf src
mkdir src
cd src
git clone https://github.com/jamiul/forum-tdd.git .
cd ..
sudo chown -R $USER:$GROUPS .*

# Starting up docker
cd docker
sudo docker-compose up -d --build nginx

# PHP container
sudo docker-compose run --rm php cp .env.example .env
sudo docker-compose run --rm composer update --ignore-platform-reqs
sudo docker-compose run --rm composer dump-autoload
sudo docker-compose run --rm artisan key:generate
sudo docker-compose run --rm artisan migrate:install
sudo docker-compose run --rm artisan migrate:fresh --seed


# NPM setup
sudo docker-compose run --rm npm install
cd ..
sudo chmod -R 777 src/storage