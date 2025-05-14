# Mobile Fitness Platform Backend

Backend system for our comprehensive mobile fitness platform, built with FastAPI and PostgreSQL. It's designed to support the Flutter frontend.

## Features

*   **User Authentication & Management:** Secure registration, login (JWT-based), and role management (user, trainer, admin).
*   **User Profiles:** Manages user bios, fitness goals, and profile pictures.
*   **Community Feed:** Allows users to create, view, comment on, and like posts.
*   **Workout Creation & Tracking:** Enables users to design and log custom workouts and exercises.
*   **Health Metric Logging:** Tracks user health data like weight and body fat percentage over time.
*   **Food Logging:** Allows users to log calorie and macronutrient intake.
*   **AI-Powered Diet Recommendations:** (Schema and endpoint stubs for) generating personalized diet plans.

## Tech Stack

*   **Framework:** FastAPI
*   **Database:** PostgreSQL
*   **Language:** Python 3.9+
*   **Authentication:** JWT (JSON Web Tokens)
*   **ORM/Querying:** SQLAlchemy (Core used for async execution, can be extended to full ORM)
*   **Async Driver:** `asyncpg` for PostgreSQL

## Setup and Installation

1.  **Prerequisites:**
    *   Python 3.9 or higher
    *   Supabase database id
    *   `pip` and `virtualenv` (recommended)

2.  **Clone the Repository (if applicable):**
    ```bash
    git clone <your-repository-url>
    cd fitness_app_backend
    ```

3.  **Create and Activate Virtual Environment:**
    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows: venv\Scripts\activate
    ```

4.  **Install Dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

5.  **Database Setup:**
    *   Create a PostgreSQL database (e.g., `fitness_app`).
    *   Execute the schema script:
        ```bash
        psql -U your_postgres_user -d fitness_app -f sql/schema.sql
        ```
        (Replace `your_postgres_user` and `fitness_app` as needed)

6.  **Configure Environment Variables:**
    *   Copy the `.env.example` file (if provided) to `.env` or create a new `.env` file in the project root.
    *   Update the `.env` file with your database credentials and JWT secret key:
        ```env
        DATABASE_URL="postgresql+asyncpg://your_user:your_password@your_host:your_port/your_database"
        # Example: DATABASE_URL="postgresql+asyncpg://postgres:secret@localhost:5432/fitness_app"

        SECRET_KEY="your_very_strong_and_secret_jwt_key"
        ALGORITHM="HS256"
        ACCESS_TOKEN_EXPIRE_MINUTES=30
        REFRESH_TOKEN_EXPIRE_DAYS=7
        ```

7.  **Run the Application (Development):**
    ```bash
    uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
    ```

## API Documentation

Once the server is running, interactive API documentation (Swagger UI) is available at:
`http://localhost:8000/docs`

And ReDoc documentation at:
`http://localhost:8000/redoc`

The OpenAPI schema can be found at:
`http://localhost:8000/api/v1/openapi.json`

## Project Structure
fitness_app_backend/
├── app/ # Main application module
│ ├── api/ # API endpoints and dependencies
│ ├── core/ # Configuration, security utilities
│ ├── crud/ # Database Create, Read, Update, Delete operations
│ ├── db/ # Database session management
│ ├── models/ # Pydantic models for data validation and serialization
│ └── main.py # FastAPI application instance and router setup
├── sql/ # SQL schema and migration files
├── .env # Environment variables (ignored by git)
├── requirements.txt # Project dependencies


## Key API Endpoints (Current)

*   `POST /api/v1/auth/register`: Register a new user.
*   `POST /api/v1/auth/login`: Log in and receive JWT tokens.
*   `POST /api/v1/auth/refresh-token`: Refresh an access token.
*   `GET /api/v1/users/me`: Get current authenticated user's details.

Refer to the API documentation for a complete list of endpoints.