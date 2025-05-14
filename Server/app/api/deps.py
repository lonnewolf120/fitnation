#Dependencies

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession
from jose import JWTError
from pydantic import UUID4

from app.db.session import get_db_session
from app.core.security import decode_token, TokenPayload
from app.models.user import User
from app.crud import crud_user # Assuming you have a crud_user.py

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login") # Path to your login endpoint

async def get_current_user(
    db: AsyncSession = Depends(get_db_session), token: str = Depends(oauth2_scheme)
) -> User: # Returns a Pydantic User model
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    token_data = decode_token(token)
    if token_data is None or token_data.user_id is None:
        raise credentials_exception
    
    user_dict = await crud_user.get_user_by_id(db, user_id=UUID4(token_data.user_id))
    if user_dict is None:
        raise credentials_exception
    
    # Convert dict to Pydantic model User (excluding password_hash)
    return User(**user_dict)

async def get_current_active_user(current_user: User = Depends(get_current_user)) -> User:
    # Add logic here if users can be deactivated
    # if current_user.disabled:
    #     raise HTTPException(status_code=400, detail="Inactive user")
    return current_user

async def get_current_admin_user(current_user: User = Depends(get_current_active_user)) -> User:
    if current_user.role != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="The user doesn't have enough privileges"
        )
    return current_user

# You can create similar dependencies for 'trainer' role if needed