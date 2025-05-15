from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import settings
from app.api.endpoints import auth, users #, profiles, posts, comments, etc.
from app.api import deps

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.PROJECT_VERSION,
    openapi_url=f"/api/v1/openapi.json"
)

origins = [
    "http://localhost",
    "http://localhost:8080",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Database Pool Management---
# from app.db.session import get_db_pool, _db_pool # Use the raw asyncpg pool
# @app.on_event("startup")
# async def startup_event():
#     await get_db_pool() 
# @app.on_event("shutdown")
# async def shutdown_event():
#     if _db_pool:
#         await _db_pool.close()
# --- End Database Pool Management ---


api_prefix = "/api/v1"

app.include_router(auth.router, prefix=f"{api_prefix}/auth", tags=["Authentication"])
app.include_router(users.router, prefix=f"{api_prefix}/users", tags=["Users"])

@app.get(f"{api_prefix}/health", tags=["Health"])
async def health_check():
    return {"status": "healthy"}


if __name__ == "__main__":
    import uvicorn
    # For development, uvicorn app.main:app --reload
    # This direct run is mainly for simple testing; use uvicorn CLI for production.
    uvicorn.run(app, host="0.0.0.0", port=8000)