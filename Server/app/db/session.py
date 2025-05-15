from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
from app.core.config import settings
# We don't need asyncpg directly here if using SQLAlchemy for all DB interactions.
# SQLAlchemy's async engine will use asyncpg under the hood if specified in DATABASE_URL.

# SQLAlchemy async engine for connection pooling
async_engine = create_async_engine(
    settings.DATABASE_URL,
    echo=False,  # Set to True for debugging SQL queries
    pool_pre_ping=True,
    # Supabase (and other cloud DBs) might have aggressive connection timeouts.
    # These settings help manage connection pooling more robustly.
    pool_recycle=1800, # Recycle connections every 30 minutes
    pool_size=10,      # Default is 5, adjust based on expected load
    max_overflow=20    # Default is 10
)

# AsyncSession maker
AsyncSessionLocal = sessionmaker(
    bind=async_engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autoflush=False,
    autocommit=False
)

async def get_db_session() -> AsyncSession:
    """
    Dependency to get an SQLAlchemy AsyncSession.
    """
    async with AsyncSessionLocal() as session:
        try:
            yield session
            await session.commit() # Commit if no exceptions occurred within the endpoint
        except Exception:
            await session.rollback() # Rollback on error
            raise
        finally:
            await session.close() # Ensure session is closed
    
# Raw asyncpg pool is not strictly necessary if all interaction is via SQLAlchemy session
# but can be kept if you have specific use cases for it.
# For simplicity with Supabase as a straightforward PG provider, relying on SQLAlchemy's
# engine and session management is usually sufficient.
# _db_pool = None
# async def get_db_pool(): ...
# async def get_db_connection(): ...