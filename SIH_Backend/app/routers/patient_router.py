from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database.db import get_db
from app.database.models import Patient, DailyTask, FamilyPhoto
from app.schemas.schemas import PatientProfileCreate, PatientProfileResponse
from app.core.security import get_password_hash

router = APIRouter(prefix="/patient", tags=["Patient Profile & Landing Page"])

@router.post("/profile", response_model=PatientProfileResponse)
def create_or_update_profile(req: PatientProfileCreate, db: Session = Depends(get_db)):
    """Feature 4: Profile Creation (Patient Page)"""
    patient = db.query(Patient).filter(Patient.full_name == req.full_name).first()
    if not patient:
        patient = Patient(
            full_name=req.full_name,
            pin_hash=get_password_hash(req.pin),
            age=req.age,
            language=req.language,
            region=req.region,
            emergency_contact_name=req.emergency_contact_name,
            emergency_contact_phone=req.emergency_contact_phone
        )
        db.add(patient)
    else:
        patient.age = req.age
        patient.language = req.language
        patient.region = req.region
        patient.emergency_contact_name = req.emergency_contact_name
        patient.emergency_contact_phone = req.emergency_contact_phone
    db.commit()
    db.refresh(patient)
    return patient

@router.get("/landing/{patient_id}", response_model=dict)
def get_landing_page_data(patient_id: int, db: Session = Depends(get_db)):
    """Feature 6: General Landing Page Data"""
    patient = db.query(Patient).filter(Patient.id == patient_id).first()
    if not patient:
        # Create default patient for smooth landing page fallback
        patient = Patient(id=patient_id, full_name="Lakshmi", pin_hash=get_password_hash("1234"))
        db.add(patient)
        db.commit()
        db.refresh(patient)

    # Seed default daily tasks if empty
    tasks = db.query(DailyTask).filter(DailyTask.patient_id == patient.id).all()
    if not tasks:
        default_tasks = [
            DailyTask(patient_id=patient.id, task_name="Match familiar household objects", time_of_day="Morning", question_prompt="What object brings warmth in the morning?"),
            DailyTask(patient_id=patient.id, task_name="Water courtyard garden plants", time_of_day="Morning", question_prompt="Which flowers bloomed today?"),
            DailyTask(patient_id=patient.id, task_name="Listen to nostalgic sitar melody", time_of_day="Afternoon", question_prompt="Did you enjoy Raga Bhairavi?"),
        ]
        db.add_all(default_tasks)
        db.commit()
        tasks = db.query(DailyTask).filter(DailyTask.patient_id == patient.id).all()

    return {
        "greeting": f"Namaste, {patient.full_name}",
        "weather": "Sunny & Peaceful, 24°C",
        "streak_days": 5,
        "mood_check_in_options": ["Calm 😌", "Happy 😊", "Engaged ✨"],
        "recommended_activity": {
            "title": "Match familiar household objects",
            "duration": "4 Min",
            "description": "Enjoy gentle pairing of brass lamps, ripe mangoes, and cozy tea cups."
        },
        "caregiver_message": {
            "from": "Priya (Daughter)",
            "message": "Thinking of you Ma! Loved looking at the monsoon photos with you yesterday. ♥",
            "audio_duration": "0:45"
        },
        "daily_tasks": [
            {"id": t.id, "name": t.task_name, "time": t.time_of_day, "completed": t.is_completed} for t in tasks
        ]
    }
