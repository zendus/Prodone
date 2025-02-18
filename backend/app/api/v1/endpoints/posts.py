from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session
from typing import List
from app.core.deps import get_current_user, get_db
from app.schemas.post import PostCreate, PostResponse
from app.services.s3 import upload_file

post_router = APIRouter()

@post_router.post("/", response_model=PostResponse)
async def create_post(
    post: PostCreate,
    files: List[UploadFile] = File(None),
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Handle media uploads
    media_urls = []
    if files:
        for file in files:
            url = await upload_file(file)
            media_urls.append(url)
    
    # Post creation logic here
    # return created_post
    return "Create Post"