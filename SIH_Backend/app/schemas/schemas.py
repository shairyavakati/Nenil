from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime

# Auth & Language Schemas
class LanguageSelectRequest(BaseModel):
    patient_id: int
    language: str = Field(..., example="en") # en, hi, ta, te, kn, mr, bn

class PinSetupRequest(BaseModel):
    patient_id: int
    pin: str = Field(..., min_length=4, max_length=6, example="1234")

class PinLoginRequest(BaseModel):
    patient_id: int
    pin: str = Field(..., min_length=4, max_length=6, example="1234")

class CaregiverLoginRequest(BaseModel):
    email: str = Field(..., example="priya@example.com")
    password: str = Field(..., example="password123")

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_id: int
    role: str

# Profile Schemas
class PatientProfileCreate(BaseModel):
    full_name: str
    pin: str
    age: int = 72
    language: str = "en"
    region: str = "South"
    emergency_contact_name: str = "Priya (Daughter)"
    emergency_contact_phone: str = "+91 98765 43210"

class PatientProfileResponse(BaseModel):
    id: int
    full_name: str
    language: str
    age: int
    region: str
    emergency_contact_name: str
    emergency_contact_phone: str

    class Config:
        from_attributes = True

# Games & Task Schemas
class FamilyPhotoCreate(BaseModel):
    patient_id: int
    title: str
    image_url: str
    description: Optional[str] = None
    audio_note_prompt: Optional[str] = None

class PhotoPuzzleResponse(BaseModel):
    puzzle_id: int
    title: str
    image_url: str
    description: Optional[str]
    grid_size: int = 3
    audio_note_prompt: Optional[str]

class WordSearchRequest(BaseModel):
    category: str = "Household Items"
    grid_size: int = 8

class WordSearchResponse(BaseModel):
    grid: List[List[str]]
    words_to_find: List[str]

class RegionalQuizResponse(BaseModel):
    question_id: int
    region: str
    question: str
    options: List[str]
    correct_option: str

class DailyTaskCreate(BaseModel):
    patient_id: int
    task_name: str
    time_of_day: str = "Morning"
    question_prompt: Optional[str] = None

# Location Schemas
class LocationUpdateRequest(BaseModel):
    patient_id: int
    latitude: float
    longitude: float
    address_label: Optional[str] = "Current Location"

class LocationLogResponse(BaseModel):
    id: int
    patient_id: int
    latitude: float
    longitude: float
    address_label: str
    is_safe_zone: bool
    timestamp: datetime

    class Config:
        from_attributes = True

# Calling & Voice Schemas
class DirectCallRequest(BaseModel):
    patient_id: int
    recipient_name: str = "Priya (Daughter)"
    phone_number: str = "+91 98765 43210"

class VoiceAgentRequest(BaseModel):
    patient_id: int
    text_prompt: str
    language: str = "en"

class VoiceAgentResponse(BaseModel):
    prompt: str
    spoken_text: str
    audio_url: Optional[str] = None
