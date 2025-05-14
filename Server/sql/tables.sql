--TODO: needs to be updated to match the new schema

-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Function to automatically update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Users Table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'trainer', 'admin')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TRIGGER set_timestamp_users
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

-- Profiles Table
CREATE TABLE profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    bio TEXT,
    profile_picture_url VARCHAR(1024),
    fitness_goals TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TRIGGER set_timestamp_profiles
BEFORE UPDATE ON profiles
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();
CREATE INDEX idx_profiles_user_id ON profiles(user_id);

-- Posts Table
CREATE TABLE posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT,
    media_url VARCHAR(1024), -- URL to media stored in cloud (e.g., S3)
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TRIGGER set_timestamp_posts
BEFORE UPDATE ON posts
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_created_at ON posts(created_at DESC); -- For feed ordering

-- Comments Table
CREATE TABLE comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW() -- If comments can be edited
);
CREATE TRIGGER set_timestamp_comments
BEFORE UPDATE ON comments
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();
CREATE INDEX idx_comments_post_id ON comments(post_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);

-- Likes Table
-- Using a composite primary key is more efficient for likes
CREATE TABLE likes (
    post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (post_id, user_id)
);
-- No updated_at needed, a like is either there or not.
CREATE INDEX idx_likes_post_id ON likes(post_id);
CREATE INDEX idx_likes_user_id ON likes(user_id);

-- Workouts Table
CREATE TABLE workouts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TRIGGER set_timestamp_workouts
BEFORE UPDATE ON workouts
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();
CREATE INDEX idx_workouts_user_id ON workouts(user_id);

-- Exercises Table
CREATE TABLE exercises (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workout_id UUID NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    sets INTEGER,
    reps INTEGER,
    weight FLOAT, -- Can be kg or lbs, unit consistency managed by app or user
    duration_seconds INTEGER, -- For time-based exercises
    notes TEXT,
    order_in_workout INTEGER, -- To maintain exercise order within a workout
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TRIGGER set_timestamp_exercises
BEFORE UPDATE ON exercises
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();
CREATE INDEX idx_exercises_workout_id ON exercises(workout_id);

-- HealthLogs Table
CREATE TABLE health_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    log_type VARCHAR(100) NOT NULL, -- e.g., 'weight_kg', 'body_fat_percentage', 'sleep_hours'
    value FLOAT NOT NULL,
    log_date TIMESTAMPTZ NOT NULL DEFAULT NOW(), -- The date the metric was recorded for
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TRIGGER set_timestamp_health_logs
BEFORE UPDATE ON health_logs
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();
CREATE INDEX idx_health_logs_user_id ON health_logs(user_id);
CREATE INDEX idx_health_logs_log_date ON health_logs(log_date DESC);
CREATE INDEX idx_health_logs_user_id_log_type ON health_logs(user_id, log_type);

-- FoodLogs Table
CREATE TABLE food_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    food_name VARCHAR(255) NOT NULL,
    external_food_id VARCHAR(255), -- Optional: ID from an external food database
    calories FLOAT,
    protein FLOAT, -- in grams
    carbs FLOAT,   -- in grams
    fat FLOAT,     -- in grams
    serving_size VARCHAR(100), -- e.g., "100g", "1 cup"
    meal_type VARCHAR(50), -- e.g., 'breakfast', 'lunch', 'dinner', 'snack'
    log_date TIMESTAMPTZ NOT NULL DEFAULT NOW(), -- The date the food was consumed
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE TRIGGER set_timestamp_food_logs
BEFORE UPDATE ON food_logs
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();
CREATE INDEX idx_food_logs_user_id ON food_logs(user_id);
CREATE INDEX idx_food_logs_log_date ON food_logs(log_date DESC);

-- DietRecommendations Table
CREATE TABLE diet_recommendations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    recommendation TEXT NOT NULL, -- Could be JSON for structured recommendations
    generated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW() -- 'generated_at' is specific to the AI process
    -- No updated_at, recommendations are generated, not typically updated
);
CREATE INDEX idx_diet_recommendations_user_id ON diet_recommendations(user_id);
CREATE INDEX idx_diet_recommendations_generated_at ON diet_recommendations(generated_at DESC);

-- Future tables (placeholder ideas)
-- CREATE TABLE music_playlists (...)
-- CREATE TABLE videos (...)

-- Optional: Table for refresh tokens if you implement more robust refresh token logic
CREATE TABLE refresh_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL UNIQUE, -- Store hash of the refresh token
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    revoked_at TIMESTAMPTZ NULL -- To mark if the token has been revoked
);
CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);

COMMIT;