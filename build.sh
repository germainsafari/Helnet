#!/usr/bin/env bash
# exit on error
set -o errexit

# Print environment variables (excluding sensitive data)
echo "Current working directory: $(pwd)"
echo "Python version: $(python --version)"
echo "Database URL: $DATABASE_URL"

# Install dependencies
pip install -r requirements.txt

# Remove any existing migrations
rm -rf base/migrations/*
touch base/migrations/__init__.py

# Make fresh migrations
echo "Making migrations..."
python manage.py makemigrations base

# Show migrations
echo "Available migrations:"
python manage.py showmigrations

# Apply migrations
echo "Applying migrations..."
python manage.py migrate

# Show migrations again to confirm
echo "Migrations after applying:"
python manage.py showmigrations

# Create superuser if it doesn't exist
echo "Creating superuser..."
python manage.py shell << END
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(is_superuser=True).exists():
    User.objects.create_superuser('admin@example.com', 'adminpassword')
END

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --no-input

# List the contents of the migrations directory
echo "Contents of migrations directory:"
ls -la base/migrations/ 