#!/bin/sh

if [ ! -f _SUCCESS ];
then 
  # Write Env Variables
  touch .env
  echo "APP_URL=http://localhost" >> .env
  echo "DB_CONNECTION=${DB_CONNECTION:-pgsql}" >> .env
  echo "DB_HOST=${DB_HOST:-shopper_db}" >> .env
  echo "DB_DATABASE=${DB_DATABASE:-cmshopper}" >> .env
  echo "DB_USERNAME=${DB_USERNAME:-cmshopper}" >> .env
  echo "DB_PASSWORD=${DB_PASSWORD:-cmshopper}" >> .env

  expect install_shopper.exp
  sed -i '7d' app/Models/User.php
  sed -i '4i\\nuse Shopper\\Framework\\Models\\User\\User as Authenticatable; ' app/Models/User.php
  expect create_default_admin.exp
  php artisan shopper:publish
  touch _SUCCESS
  rm *.exp
fi

sleep 1

echo "***************||   Starting Laravel Shopper - Docker Edition    ||*************** "

exec "$@"