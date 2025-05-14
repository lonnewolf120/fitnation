#!/bin/bash

# Base project directory
BASE_DIR="Server"

# Create directories
mkdir -p $BASE_DIR/app/api/endpoints
mkdir -p $BASE_DIR/app/core
mkdir -p $BASE_DIR/app/crud
mkdir -p $BASE_DIR/app/db
mkdir -p $BASE_DIR/app/models
mkdir -p $BASE_DIR/alembic
mkdir -p $BASE_DIR/sql

# Create Python files
touch $BASE_DIR/app/__init__.py

touch $BASE_DIR/app/api/__init__.py
touch $BASE_DIR/app/api/deps.py
touch $BASE_DIR/app/api/endpoints/__init__.py
touch $BASE_DIR/app/api/endpoints/auth.py
touch $BASE_DIR/app/api/endpoints/users.py
touch $BASE_DIR/app/api/endpoints/profiles.py
touch $BASE_DIR/app/api/endpoints/posts.py
touch $BASE_DIR/app/api/endpoints/comments.py
touch $BASE_DIR/app/api/endpoints/likes.py
touch $BASE_DIR/app/api/endpoints/workouts.py
touch $BASE_DIR/app/api/endpoints/exercises.py
touch $BASE_DIR/app/api/endpoints/health_logs.py
touch $BASE_DIR/app/api/endpoints/food_logs.py
touch $BASE_DIR/app/api/endpoints/diet_recommendations.py

touch $BASE_DIR/app/core/__init__.py
touch $BASE_DIR/app/core/config.py
touch $BASE_DIR/app/core/security.py

touch $BASE_DIR/app/crud/__init__.py
touch $BASE_DIR/app/crud/base.py
touch $BASE_DIR/app/crud/crud_user.py
# Add other CRUD files as needed manually or extend this script

touch $BASE_DIR/app/db/__init__.py
touch $BASE_DIR/app/db/session.py

touch $BASE_DIR/app/models/__init__.py
touch $BASE_DIR/app/models/user.py
touch $BASE_DIR/app/models/post.py
# Add other model files as needed manually or extend this script

touch $BASE_DIR/app/main.py

# Create root-level files
touch $BASE_DIR/.env
touch $BASE_DIR/requirements.txt
touch $BASE_DIR/README.md
touch $BASE_DIR/sql/schema.sql

echo "Project structure created at ./$BASE_DIR"
