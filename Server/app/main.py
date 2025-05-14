from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import settings
from app.api.endpoints import auth, users #, profiles, posts, comments, etc.
from app.api import deps # For global dependencies if any

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.PROJECT_VERSION,
    openapi_url=f"/api/v1/openapi.json"
)

# CORS (Cross-Origin Resource Sharing)
# Adjust origins as needed for your Flutter app's development/production URLs
origins = [
    "http://localhost",
    "http://localhost:8080", # Common Flutter web dev port
    # Add your Flutter app's deployed URLs
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Database Pool Management (Optional, but good for graceful shutdown) ---
# from app.db.session import get_db_pool, _db_pool # Use the raw asyncpg pool
# @app.on_event("startup")
# async def startup_event():
#     await get_db_pool() # Initialize pool

# @app.on_event("shutdown")
# async def shutdown_event():
#     if _db_pool:
#         await _db_pool.close()
# --- End Database Pool Management ---


# API Routers
api_prefix = "/api/v1" # Version your API

app.include_router(auth.router, prefix=f"{api_prefix}/auth", tags=["Authentication"])
app.include_router(users.router, prefix=f"{api_prefix}/users", tags=["Users"])
# app.include_router(profiles.router, prefix=f"{api_prefix}/profiles", tags=["Profiles"], dependencies=[Depends(deps.get_current_active_user)])
# app.include_router(posts.router, prefix=f"{api_prefix}/posts", tags=["Posts"], dependencies=[Depends(deps.get_current_active_user)])
# ... include other routers ...

@app.get(f"{api_prefix}/health", tags=["Health"])
async def health_check():
    return {"status": "healthy"}

# Placeholder for other routers (you'd create these files similarly to users.py and auth.py)
# from app.api.endpoints import profiles, posts, comments, likes, workouts, exercises, health_logs, food_logs, diet_recommendations

# Example for posts router stub
# app.include_router(posts.router, prefix=f"{api_prefix}/posts", tags=["Posts"], dependencies=[Depends(deps.get_current_active_user)])
# app.include_router(comments.router, prefix=f"{api_prefix}/posts", tags=["Comments"], dependencies=[Depends(deps.get_current_active_user)]) # Nested under posts usually
# app.include_router(likes.router, prefix=f"{api_prefix}/posts", tags=["Likes"], dependencies=[Depends(deps.get_current_active_user)]) # Nested under posts
# app.include_router(workouts.router, prefix=f"{api_prefix}/workouts", tags=["Workouts"], dependencies=[Depends(deps.get_current_active_user)])
# app.include_router(exercises.router, prefix=f"{api_prefix}/workouts", tags=["Exercises"], dependencies=[Depends(deps.get_current_active_user)]) # Nested under workouts
# app.include_router(health_logs.router, prefix=f"{api_prefix}/health-logs", tags=["Health Logs"], dependencies=[Depends(deps.get_current_active_user)])
# app.include_router(food_logs.router, prefix=f"{api_prefix}/food-logs", tags=["Food Logs"], dependencies=[Depends(deps.get_current_active_user)])
# app.include_router(diet_recommendations.router, prefix=f"{api_prefix}/diet-recommendations", tags=["Diet Recommendations"], dependencies=[Depends(deps.get_current_active_user)])


if __name__ == "__main__":
    import uvicorn
    # For development, uvicorn app.main:app --reload
    # This direct run is mainly for simple testing; use uvicorn CLI for production.
    uvicorn.run(app, host="0.0.0.0", port=8000)