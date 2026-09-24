import os
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    PROJECT_NAME: str = "Nenil Cognitive Care Backend"
    VERSION: str = "1.0.0"
    API_V1_STR: str = "/api/v1"
    SECRET_KEY: str = os.getenv("SECRET_KEY", "nenil_sih_2026_super_secret_key_9416124989909981684")
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 7 days

    # SQLite / DB URL
    DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite:///./sih_nenil.db")

    class Config:
        case_sensitive = True

settings = Settings()
