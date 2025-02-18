# app/api/v1/endpoints/projects.py
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session
from typing import List, Optional
from app.core.deps import get_current_user, get_db
from app.schemas.project import ProjectCreate, ProjectUpdate, ProjectResponse
from app.services.s3 import upload_file
from app.models.user import UserType

project_router = APIRouter()

@project_router.post("/", response_model=ProjectResponse)
async def create_project(
    project: ProjectCreate,
    current_user = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    if current_user.user_type not in [UserType.GOVERNMENT, UserType.CONTRACTOR]:
        raise HTTPException(status_code=403, detail="Not authorized to create projects")
    
    # Project creation logic here
    # return created_project
    return "Create Project"

@project_router.get("/", response_model=List[ProjectResponse])
async def list_projects(
    area_code: str,
    status: Optional[str] = None,
    db: Session = Depends(get_db)
):
    # Project listing logic here
    # return projects
    return "List of Projects"