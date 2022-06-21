#!/bin/sh

# Stop running docker
sudo docker stop $(docker ps -a -q)
sudo docker container prune -f

# Delete DB data
sudo rm -rf docker/mysql/data

# Pull git src code
sudo rm -rf src
sudo mkdir src
cd src
git clone https://github.com/jamiul/the-docker-with-laravel.git .
cd ..

sudo chown -R $USER:$GROUPS .*

# Starting up docker
cd docker
sudo docker-compose up -d --build nginx
cd ..

# PHP container
sudo docker exec php cp .env.example .env
sudo docker-compose run --rm composer update --ignore-platform-reqs
sudo docker-compose run --rm composer dump-autoload
sudo docker-compose run --rm artisan key:generate
sudo docker-compose run --rm artisan migrate:install
sudo docker-compose run --rm artisan migrate:fresh --seed
sudo chmod -R 777 src/storage

# NPM setup
sudo docker-compose run --rm npm install