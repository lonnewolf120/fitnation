from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import text
from uuid import UUID
from typing import Optional, Dict, Any

from app.core.security import get_password_hash
from app.models.user import UserCreate, UserUpdate

async def get_user_by_email(db: AsyncSession, email: str) -> Optional[Dict[str, Any]]:
    query = text("SELECT id, username, email, password_hash, role, created_at, updated_at FROM users WHERE email = :email")
    result = await db.execute(query, {"email": email})
    user = result.fetchone()
    return dict(user._mapping) if user else None


async def get_user_by_username(db: AsyncSession, username: str) -> Optional[Dict[str, Any]]:
    query = text("SELECT id, username, email, password_hash, role, created_at, updated_at FROM users WHERE username = :username")
    result = await db.execute(query, {"username": username})
    user = result.fetchone()
    return dict(user._mapping) if user else None

async def get_user_by_id(db: AsyncSession, user_id: UUID) -> Optional[Dict[str, Any]]:
    query = text("SELECT id, username, email, password_hash, role, created_at, updated_at FROM users WHERE id = :user_id")
    result = await db.execute(query, {"user_id": user_id})
    user = result.fetchone()
    return dict(user._mapping) if user else None

async def create_user(db: AsyncSession, user_in: UserCreate) -> Dict[str, Any]:
    hashed_password = get_password_hash(user_in.password)
    query = text("""
        INSERT INTO users (username, email, password_hash, role)
        VALUES (:username, :email, :password_hash, :role)
        RETURNING id, username, email, role, created_at, updated_at
    """)
    result = await db.execute(
        query,
        {
            "username": user_in.username,
            "email": user_in.email,
            "password_hash": hashed_password,
            "role": user_in.role or 'user'
        }
    )
    created_user = result.fetchone()
    await db.commit()
    
    # Create a profile for the new user
    profile_query = text("""
        INSERT INTO profiles (user_id, bio, fitness_goals)
        VALUES (:user_id, '', '') 
        RETURNING id 
    """) # Basic empty profile
    await db.execute(profile_query, {"user_id": created_user.id})
    await db.commit()

    return dict(created_user._mapping) if created_user else None

async def update_user(db: AsyncSession, user_id: UUID, user_in: UserUpdate) -> Optional[Dict[str, Any]]:
    # Construct SET clause dynamically
    set_clauses = []
    params = {"user_id": user_id}
    if user_in.username is not None:
        set_clauses.append("username = :username")
        params["username"] = user_in.username
    if user_in.email is not None:
        set_clauses.append("email = :email")
        params["email"] = user_in.email
    if user_in.role is not None: # Be careful with role updates
        set_clauses.append("role = :role")
        params["role"] = user_in.role
    
    if not set_clauses:
        # If nothing to update, fetch and return current user data or raise error
        return await get_user_by_id(db, user_id)

    set_clause_str = ", ".join(set_clauses)
    # updated_at will be handled by the trigger
    
    query_str = f"""
        UPDATE users
        SET {set_clause_str}
        WHERE id = :user_id
        RETURNING id, username, email, role, created_at, updated_at
    """
    query = text(query_str)
    
    result = await db.execute(query, params)
    updated_user = result.fetchone()
    await db.commit()
    return dict(updated_user._mapping) if updated_user else None

# Add delete_user if needed