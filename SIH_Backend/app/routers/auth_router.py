from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database.db import get_db
from app.database.models import Patient, Caregiver
from app.schemas.schemas import (
    LanguageSelectRequest, PinSetupRequest, PinLoginRequest, CaregiverLoginRequest, TokenResponse
)
from app.core.security import get_password_hash, verify_password, create_access_token

router = APIRouter(prefix="/auth", tags=["Authentication & Preferences"])

@router.post("/language", response_model=dict)
def update_language(req: LanguageSelectRequest, db: Session = Depends(get_db)):
    """Feature 1: Language Selection"""
    patient = db.query(Patient).filter(Patient.id == req.patient_id).first()
    if not patient:
        # Create default patient if not exists
        patient = Patient(id=req.patient_id, full_name="Lakshmi", pin_hash=get_password_hash("1234"), language=req.language)
        db.add(patient)
    else:
        patient.language = req.language
    db.commit()
    return {"message": f"Language updated to {req.language} successfully", "language": req.language}

@router.post("/pin-setup", response_model=dict)
def setup_patient_pin(req: PinSetupRequest, db: Session = Depends(get_db)):
    """Feature 2: PIN setup for patients"""
    patient = db.query(Patient).filter(Patient.id == req.patient_id).first()
    if not patient:
        patient = Patient(id=req.patient_id, full_name="Lakshmi", pin_hash=get_password_hash(req.pin))
        db.add(patient)
    else:
        patient.pin_hash = get_password_hash(req.pin)
    db.commit()
    return {"message": "Patient PIN set successfully", "patient_id": req.patient_id}

@router.post("/pin-login", response_model=TokenResponse)
def patient_pin_login(req: PinLoginRequest, db: Session = Depends(get_db)):
    """Feature 2: PIN Login for patients"""
    patient = db.query(Patient).filter(Patient.id == req.patient_id).first()
    if not patient or not verify_password(req.pin, patient.pin_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid Patient PIN or ID"
        )
    token = create_access_token(subject=f"patient:{patient.id}")
    return TokenResponse(access_token=token, user_id=patient.id, role="patient")

@router.post("/caregiver-login", response_model=TokenResponse)
def caregiver_login(req: CaregiverLoginRequest, db: Session = Depends(get_db)):
    """Feature 3: Caretaker General Login"""
    caregiver = db.query(Caregiver).filter(Caregiver.email == req.email).first()
    if not caregiver:
        # Auto seed default caregiver for hackathon demo
        if req.email == "priya@example.com" and req.password == "password123":
            # Check default patient
            default_patient = db.query(Patient).first()
            if not default_patient:
                default_patient = Patient(full_name="Lakshmi", pin_hash=get_password_hash("1234"))
                db.add(default_patient)
                db.commit()
                db.refresh(default_patient)
            caregiver = Caregiver(
                email=req.email,
                password_hash=get_password_hash(req.password),
                full_name="Priya Sharma",
                relation="Daughter",
                patient_id=default_patient.id
            )
            db.add(caregiver)
            db.commit()
            db.refresh(caregiver)
        else:
            raise HTTPException(status_code=401, detail="Invalid Caregiver Credentials")
    elif not verify_password(req.password, caregiver.password_hash):
        raise HTTPException(status_code=401, detail="Invalid Caregiver Credentials")

    token = create_access_token(subject=f"caregiver:{caregiver.id}")
    return TokenResponse(access_token=token, user_id=caregiver.id, role="caregiver")
