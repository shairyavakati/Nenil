from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.database.db import get_db
from app.database.models import LocationLog, Patient
from app.schemas.schemas import LocationUpdateRequest, LocationLogResponse

router = APIRouter(prefix="/location", tags=["Patient Location Monitoring"])

@router.post("/update", response_model=LocationLogResponse)
def update_patient_location(req: LocationUpdateRequest, db: Session = Depends(get_db)):
    """Feature 11: Patient Location Monitoring - GPS update"""
    patient = db.query(Patient).filter(Patient.id == req.patient_id).first()
    if not patient:
        raise HTTPException(status_code=404, detail="Patient not found")

    # Simple safe zone radius check demo (around home courtyard)
    home_lat, home_lng = 12.9716, 77.5946 # Bangalore default coordinates
    distance_sq = (req.latitude - home_lat)**2 + (req.longitude - home_lng)**2
    is_safe = distance_sq < 0.01  # Within safe perimeter

    log = LocationLog(
        patient_id=req.patient_id,
        latitude=req.latitude,
        longitude=req.longitude,
        address_label=req.address_label or "Home - Courtyard",
        is_safe_zone=is_safe
    )
    db.add(log)
    db.commit()
    db.refresh(log)
    return log

@router.get("/monitor/{patient_id}", response_model=dict)
def monitor_patient_location(patient_id: int, db: Session = Depends(get_db)):
    """Feature 11: Patient Location Monitoring - Caregiver live status & history"""
    logs = db.query(LocationLog).filter(LocationLog.patient_id == patient_id).order_by(LocationLog.timestamp.desc()).limit(10).all()
    if not logs:
        # Seed default home log
        default_log = LocationLog(
            patient_id=patient_id,
            latitude=12.9716,
            longitude=77.5946,
            address_label="Home - Courtyard Garden",
            is_safe_zone=True
        )
        db.add(default_log)
        db.commit()
        logs = [default_log]

    latest = logs[0]
    return {
        "patient_id": patient_id,
        "status": "Safe & In Perimeter" if latest.is_safe_zone else "Alert: Outside Safe Zone",
        "current_label": latest.address_label,
        "latitude": latest.latitude,
        "longitude": latest.longitude,
        "is_safe_zone": latest.is_safe_zone,
        "last_updated": latest.timestamp.isoformat(),
        "recent_history": [
            {
                "id": l.id,
                "label": l.address_label,
                "lat": l.latitude,
                "lng": l.longitude,
                "is_safe": l.is_safe_zone,
                "timestamp": l.timestamp.isoformat()
            } for l in logs
        ]
    }
