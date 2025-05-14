from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm # For form data login
from sqlalchemy.ext.asyncio import AsyncSession
from datetime import timedelta

from app.api import deps
from app.crud import crud_user
from app.models.user import UserCreate, User as PydanticUser, Token
from app.core.security import create_access_token, create_refresh_token, verify_password
from app.core.config import settings

router = APIRouter()

@router.post("/register", response_model=PydanticUser, status_code=status.HTTP_201_CREATED)
async def register_new_user(
    user_in: UserCreate,
    db: AsyncSession = Depends(deps.get_db_session)
):
    """
    Create new user.
    """
    db_user_by_email = await crud_user.get_user_by_email(db, email=user_in.email)
    if db_user_by_email:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User with this email already exists.",
        )
    db_user_by_username = await crud_user.get_user_by_username(db, username=user_in.username)
    if db_user_by_username:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User with this username already exists.",
        )
    
    created_user_dict = await crud_user.create_user(db=db, user_in=user_in)
    if not created_user_dict:
         raise HTTPException(status_code=500, detail="Could not create user.")
    return PydanticUser(**created_user_dict)


@router.post("/login", response_model=Token)
async def login_for_access_token(
    db: AsyncSession = Depends(deps.get_db_session),
    form_data: OAuth2PasswordRequestForm = Depends() # username and password from form
):
    """
    OAuth2 compatible token login, get an access token for future requests.
    """
    user_dict = await crud_user.get_user_by_username(db, username=form_data.username)
    if not user_dict or not verify_password(form_data.password, user_dict["password_hash"]):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        subject=user_dict["username"], 
        user_id=user_dict["id"],
        role=user_dict["role"],
        expires_delta=access_token_expires
    )
    
    refresh_token_expires = timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)
    refresh_token = create_refresh_token(
        subject=user_dict["username"],
        user_id=user_dict["id"],
        role=user_dict["role"],
        expires_delta=refresh_token_expires
    )
    # Here you might want to store the refresh_token (hashed) in the DB (e.g., in 'refresh_tokens' table)
    # For simplicity now, just returning it.

    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer",
    }

@router.post("/refresh-token", response_model=Token)
async def refresh_access_token(
    # In a real app, you'd validate the refresh token against a DB store
    # and ensure it's not revoked.
    # For this example, we'll assume the refresh token is passed in a header or body.
    # Let's assume it's passed in the body for simplicity.
    refresh_token_body: str, # Simplified: In reality, use a Pydantic model for the request body
    db: AsyncSession = Depends(deps.get_db_session)
):
    """
    Refresh an access token using a refresh token.
    A more robust implementation would:
    1. Expect refresh token in Authorization header (e.g., Bearer <refresh_token>) or secure cookie.
    2. Decode the refresh token.
    3. Check if the refresh token is present (hashed) in the database and not revoked.
    4. If valid, issue a new access token (and optionally a new refresh token - token rotation).
    5. Invalidate the old refresh token if rotating.
    """
    from app.core.security import decode_token # Import locally to avoid circular dependency if deps imports this
    
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate refresh token",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    token_data = decode_token(refresh_token_body) # Use the raw refresh token string
    
    if not token_data or token_data.user_id is None or getattr(token_data, 'type', None) != 'refresh':
        raise credentials_exception

    user_dict = await crud_user.get_user_by_id(db, user_id=token_data.user_id)
    if not user_dict:
        raise credentials_exception

    # Check if refresh token is in DB and valid (if you implement DB storage for refresh tokens)
    # For example:
    # stored_refresh_token = await crud_refresh_token.get_by_user_id_and_verify(db, user_id=token_data.user_id, token_to_check=refresh_token_body)
    # if not stored_refresh_token:
    #     raise credentials_exception

    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    new_access_token = create_access_token(
        subject=user_dict["username"],
        user_id=user_dict["id"],
        role=user_dict["role"],
        expires_delta=access_token_expires
    )
    
    # Optionally, issue a new refresh token (token rotation)
    # new_refresh_token = create_refresh_token(...)
    # await crud_refresh_token.revoke(db, old_refresh_token)
    # await crud_refresh_token.store(db, new_refresh_token_hashed, user_id, expiry)

    return {
        "access_token": new_access_token,
        "refresh_token": refresh_token_body, # or new_refresh_token if rotating
        "token_type": "bearer",
    }

@router.post("/logout") # Placeholder
async def logout(
    # Invalidate refresh token if stored server-side
    # Client should discard tokens
    current_user: PydanticUser = Depends(deps.get_current_active_user)
):
    """
    Logout user. (Client-side token discard is primary. Server-side for refresh token invalidation).
    If you store refresh tokens in the DB, mark the used one as revoked.
    """
    # Example: await crud_refresh_token.revoke_for_user(db, user_id=current_user.id)
    return {"message": "Successfully logged out. Please discard your tokens."}