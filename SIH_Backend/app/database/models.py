import datetime
from sqlalchemy import Column, Integer, String, Float, Boolean, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
from app.database.db import Base

class Patient(Base):
    __tablename__ = "patients"

    id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String(100), nullable=False, default="Lakshmi")
    pin_hash = Column(String(255), nullable=False)
    language = Column(String(20), default="en") # en, hi, ta, te, kn, mr, bn
    age = Column(Integer, default=72)
    region = Column(String(50), default="South") # South, North, West, East
    emergency_contact_name = Column(String(100), default="Priya (Daughter)")
    emergency_contact_phone = Column(String(20), default="+91 98765 43210")
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

    # Relationships
    caregivers = relationship("Caregiver", back_populates="patient")
    family_photos = relationship("FamilyPhoto", back_populates="patient")
    daily_tasks = relationship("DailyTask", back_populates="patient")
    location_logs = relationship("LocationLog", back_populates="patient")
    call_logs = relationship("CallLog", back_populates="patient")

class Caregiver(Base):
    __tablename__ = "caregivers"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(150), unique=True, index=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    full_name = Column(String(100), nullable=False)
    relation = Column(String(50), default="Daughter")
    patient_id = Column(Integer, ForeignKey("patients.id"), nullable=True)

    patient = relationship("Patient", back_populates="caregivers")

class FamilyPhoto(Base):
    __tablename__ = "family_photos"

    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(Integer, ForeignKey("patients.id"), nullable=False)
    title = Column(String(150), nullable=False)
    image_url = Column(Text, nullable=False)
    description = Column(Text, nullable=True)
    audio_note_prompt = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

    patient = relationship("Patient", back_populates="family_photos")

class DailyTask(Base):
    __tablename__ = "daily_tasks"

    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(Integer, ForeignKey("patients.id"), nullable=False)
    task_name = Column(String(200), nullable=False)
    time_of_day = Column(String(50), default="Morning") # Morning, Afternoon, Evening
    is_completed = Column(Boolean, default=False)
    question_prompt = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

    patient = relationship("Patient", back_populates="daily_tasks")

class LocationLog(Base):
    __tablename__ = "location_logs"

    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(Integer, ForeignKey("patients.id"), nullable=False)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    address_label = Column(String(200), default="Home - Courtyard")
    is_safe_zone = Column(Boolean, default=True)
    timestamp = Column(DateTime, default=datetime.datetime.utcnow)

    patient = relationship("Patient", back_populates="location_logs")

class CallLog(Base):
    __tablename__ = "call_logs"

    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(Integer, ForeignKey("patients.id"), nullable=False)
    recipient_name = Column(String(100), nullable=False)
    phone_number = Column(String(20), nullable=False)
    status = Column(String(50), default="Completed") # Initiated, Connected, Missed
    timestamp = Column(DateTime, default=datetime.datetime.utcnow)

    patient = relationship("Patient", back_populates="call_logs")

class QuizQuestion(Base):
    __tablename__ = "quiz_questions"

    id = Column(Integer, primary_key=True, index=True)
    region = Column(String(50), default="South") # South, North, West, East
    question_text = Column(Text, nullable=False)
    option_a = Column(String(100), nullable=False)
    option_b = Column(String(100), nullable=False)
    option_c = Column(String(100), nullable=False)
    option_d = Column(String(100), nullable=False)
    correct_option = Column(String(1), nullable=False) # A, B, C, or D
