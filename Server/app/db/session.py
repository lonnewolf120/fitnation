from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
from app.core.config import settings
import asyncpg

# SQLAlchemy async engine for connection pooling
async_engine = create_async_engine(settings.DATABASE_URL, echo=False, pool_pre_ping=True)

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
        yield session

# For raw asyncpg connection if needed (SQLAlchemy is generally preferred for structure)
# This might be useful for very specific queries or if you avoid ORM features entirely.
# For this basic setup, we will rely on SQLAlchemy AsyncSession for executing text SQL.
_db_pool = None

async def get_db_pool():
    global _db_pool
    if _db_pool is None:
        _db_pool = await asyncpg.create_pool(dsn=settings.DATABASE_URL.replace("postgresql+asyncpg", "postgresql"))
    return _db_pool

async def get_db_connection():
    pool = await get_db_pool()
    async with pool.acquire() as connection:
        yield connection