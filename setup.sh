#!/bin/bash
set -e

# Go to workspace root
cd /workspaces

# Create Laravel project if not exists
if [ ! -d "kpi-starter-app" ]; then
  composer create-project laravel/laravel kpi-starter-app
fi

cd kpi-starter-app

# Install UI scaffolding and auth
composer require laravel/ui
php artisan ui bootstrap --auth
npm install && npm run build

# Create DB file if not exists
if [ ! -f database/database.sqlite ]; then
  touch database/database.sqlite
fi

# Update .env for sqlite
sed -i 's/DB_CONNECTION=mysql/DB_CONNECTION=sqlite/' .env
sed -i '/DB_HOST=/d' .env
sed -i '/DB_PORT=/d' .env
sed -i '/DB_DATABASE=.*/c\DB_DATABASE=\/workspaces\/kpi-starter-app\/database\/database.sqlite' .env
sed -i '/DB_USERNAME=/d' .env
sed -i '/DB_PASSWORD=/d' .env

# Run migrations
php artisan migrate:fresh --seed || true

echo "✅ Laravel KPI Starter app is ready."

