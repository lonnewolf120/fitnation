from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from pydantic import UUID4

from app.api import deps
from app.models.user import User, UserUpdate
from app.crud import crud_user

router = APIRouter()

@router.get("/{user_id}", response_model=User)
async def read_user_by_id(
    user_id: UUID4,
    db: AsyncSession = Depends(deps.get_db_session),
    # current_user: User = Depends(deps.get_current_active_user) # Optional: if only logged-in users can view
):
    """
    Retrieve user details.
    """
    user = await crud_user.get_user_by_id(db, user_id=user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return User(**user)

@router.put("/{user_id}", response_model=User)
async def update_user_details(
    user_id: UUID4,
    user_in: UserUpdate,
    db: AsyncSession = Depends(deps.get_db_session),
    current_user: User = Depends(deps.get_current_active_user),
):
    """
    Update user details.
    Users can update their own details. Admins might update others.
    """
    if current_user.id != user_id and current_user.role != "admin":
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not enough permissions")

    user = await crud_user.get_user_by_id(db, user_id=user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    updated_user_dict = await crud_user.update_user(db=db, user_id=user_id, user_in=user_in)
    if not updated_user_dict:
        raise HTTPException(status_code=500, detail="Could not update user.") # Or 404 if update target not found
    return User(**updated_user_dict)

# GET /users/me - for current user to get their own details
@router.get("/me/", response_model=User)
async def read_users_me(current_user: User = Depends(deps.get_current_active_user)):
    """
    Get current user.
    """
    return current_user