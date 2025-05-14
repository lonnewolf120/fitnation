from pydantic import BaseModel, EmailStr, UUID4
from typing import Optional
from datetime import datetime

class UserBase(BaseModel):
    username: str
    email: EmailStr
    role: Optional[str] = 'user'

class UserCreate(UserBase):
    password: str

class UserUpdate(BaseModel):
    username: Optional[str] = None
    email: Optional[EmailStr] = None
    # Password updates should be handled via a separate endpoint e.g. /users/me/change-password
    role: Optional[str] = None # Typically only admin can change roles

class UserInDBBase(UserBase):
    id: UUID4
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True # For SQLAlchemy model conversion

class User(UserInDBBase):
    pass # What's returned to the client (NO password_hash)

class UserInDB(UserInDBBase):
    password_hash: str # Stored in DB

class Token(BaseModel):
    access_token: str
    refresh_token: Optional[str] = None # Optional for now
    token_type: str = "bearer"

class TokenData(BaseModel):
    username: Optional[str] = None
    user_id: Optional[UUID4] = None
    role: Optional[str] = None