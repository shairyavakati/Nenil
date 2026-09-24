import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_root_endpoint():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json()["status"] == "Online"

def test_feature1_language_selection():
    res = client.post("/api/v1/auth/language", json={"patient_id": 1, "language": "hi"})
    assert res.status_code == 200
    assert res.json()["language"] == "hi"

def test_feature2_pin_setup_and_login():
    res = client.post("/api/v1/auth/pin-setup", json={"patient_id": 1, "pin": "4321"})
    assert res.status_code == 200

    login_res = client.post("/api/v1/auth/pin-login", json={"patient_id": 1, "pin": "4321"})
    assert login_res.status_code == 200
    assert login_res.json()["role"] == "patient"

def test_feature3_caregiver_login():
    res = client.post("/api/v1/auth/caregiver-login", json={"email": "priya@example.com", "password": "password123"})
    assert res.status_code == 200
    assert res.json()["role"] == "caregiver"

def test_feature4_and_6_profile_and_landing():
    prof_res = client.post("/api/v1/patient/profile", json={
        "full_name": "Lakshmi Sharma",
        "pin": "1234",
        "age": 72,
        "language": "en",
        "region": "South"
    })
    assert prof_res.status_code == 200

    land_res = client.get("/api/v1/patient/landing/1")
    assert land_res.status_code == 200
    assert "daily_tasks" in land_res.json()

def test_feature7_photo_puzzle():
    res = client.get("/api/v1/games/photo-puzzle/1")
    assert res.status_code == 200
    assert len(res.json()) > 0

def test_feature8_daily_routine_questions():
    res = client.get("/api/v1/games/daily-routine/1")
    assert res.status_code == 200
    assert "daily_questions" in res.json()

def test_feature9_word_search():
    res = client.post("/api/v1/games/word-search", json={"category": "Household Items", "grid_size": 8})
    assert res.status_code == 200
    assert len(res.json()["grid"]) == 8

def test_feature10_regional_quiz():
    res = client.get("/api/v1/games/regional-quiz/South")
    assert res.status_code == 200
    assert len(res.json()) > 0

def test_feature11_location_monitoring():
    res = client.post("/api/v1/location/update", json={
        "patient_id": 1,
        "latitude": 12.9716,
        "longitude": 77.5946,
        "address_label": "Home Courtyard"
    })
    assert res.status_code == 200

    mon_res = client.get("/api/v1/location/monitor/1")
    assert mon_res.status_code == 200
    assert mon_res.json()["is_safe_zone"] is True

def test_feature12_direct_calling():
    res = client.post("/api/v1/calling/direct-call", json={
        "patient_id": 1,
        "recipient_name": "Priya (Daughter)",
        "phone_number": "+91 98765 43210"
    })
    assert res.status_code == 200
    assert res.json()["status"] == "Call Connected"

def test_feature13_voice_agent_tts():
    res = client.post("/api/v1/voice/agent", json={
        "patient_id": 1,
        "text_prompt": "Good morning",
        "language": "en"
    })
    assert res.status_code == 200
    assert "spoken_text" in res.json()
