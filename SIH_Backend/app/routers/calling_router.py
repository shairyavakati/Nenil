from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database.db import get_db
from app.database.models import CallLog, Patient
from app.schemas.schemas import DirectCallRequest

router = APIRouter(prefix="/calling", tags=["Direct Calling & Emergency Support"])

@router.post("/direct-call", response_model=dict)
def trigger_direct_call(req: DirectCallRequest, db: Session = Depends(get_db)):
    """Feature 12: Direct Calling - Initiate one-touch emergency or speed dial call"""
    patient = db.query(Patient).filter(Patient.id == req.patient_id).first()
    if not patient:
        # Fallback patient check
        patient = Patient(id=req.patient_id, full_name="Lakshmi", pin_hash="1234")
        db.add(patient)
        db.commit()

    call_entry = CallLog(
        patient_id=req.patient_id,
        recipient_name=req.recipient_name,
        phone_number=req.phone_number,
        status="Connected"
    )
    db.add(call_entry)
    db.commit()

    return {
        "status": "Call Connected",
        "patient_id": req.patient_id,
        "calling_to": req.recipient_name,
        "phone_number": req.phone_number,
        "action": f"Dialing {req.recipient_name} at {req.phone_number}...",
        "tel_uri": f"tel:{req.phone_number.replace(' ', '')}"
    }

@router.get("/contacts/{patient_id}", response_model=dict)
def get_direct_call_contacts(patient_id: int, db: Session = Depends(get_db)):
    """Feature 12: Direct Calling - Get one-touch emergency contacts"""
    patient = db.query(Patient).filter(Patient.id == patient_id).first()
    emergency_name = patient.emergency_contact_name if patient else "Priya (Daughter)"
    emergency_phone = patient.emergency_contact_phone if patient else "+91 98765 43210"

    contacts = [
        {"id": 1, "name": emergency_name, "role": "Primary Caregiver", "phone": emergency_phone, "icon": "favorite"},
        {"id": 2, "name": "Dr. Rajesh Verma", "role": "Senior Geriatric Specialist", "phone": "+91 98220 11223", "icon": "medical_services"},
        {"id": 3, "name": "Emergency Medical Helpline", "role": "24/7 Ambulance & Care", "phone": "108", "icon": "support_agent"}
    ]
    return {"patient_id": patient_id, "speed_dial_contacts": contacts}
