from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.database.db import engine, Base
from app.routers import (
    auth_router, patient_router, games_router, location_router, calling_router, voice_router
)

# Initialize database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="FastAPI Backend for SIH 2026 Senior Cognitive Care Platform supporting all 13 handwritten feature requirements."
)

# Enable CORS for Flutter web & mobile applications
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include API Routers under /api/v1
app.include_router(auth_router.router, prefix=settings.API_V1_STR)
app.include_router(patient_router.router, prefix=settings.API_V1_STR)
app.include_router(games_router.router, prefix=settings.API_V1_STR)
app.include_router(location_router.router, prefix=settings.API_V1_STR)
app.include_router(calling_router.router, prefix=settings.API_V1_STR)
app.include_router(voice_router.router, prefix=settings.API_V1_STR)

@app.get("/")
def root():
    return {
        "status": "Online",
        "app": settings.PROJECT_NAME,
        "version": settings.VERSION,
        "docs_url": "/docs",
        "features_supported": [
            "1) Language selection",
            "2) PIN setup login for patients",
            "3) Caretaker general login",
            "4) Profile creation (patient page)",
            "6) General landing page",
            "7) Family photo integration -> photo puzzle game",
            "8) Daily routine questions / Task generation",
            "9) Word search -> puzzle game generator",
            "10) General Quiz (Based on Region) -> Game",
            "11) Patient location monitoring",
            "12) Direct calling",
            "13) Voice Agent -> TTS using standard libraries"
        ]
    }
