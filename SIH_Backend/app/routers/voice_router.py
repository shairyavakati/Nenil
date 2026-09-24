import os
from fastapi import APIRouter, Depends, HTTPException, Response
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session
from gtts import gTTS
from app.schemas.schemas import VoiceAgentRequest, VoiceAgentResponse

router = APIRouter(prefix="/voice", tags=["Voice Agent & Text-To-Speech (TTS)"])

STATIC_AUDIO_DIR = os.path.join(os.path.dirname(__file__), "..", "..", "static", "audio")
os.makedirs(STATIC_AUDIO_DIR, exist_ok=True)

@router.post("/agent", response_model=VoiceAgentResponse)
def voice_agent_interact(req: VoiceAgentRequest):
    """Feature 13: Voice Agent - Generates empathetic senior voice response using standard libraries (gTTS)"""
    prompt = req.text_prompt.strip()

    # Friendly cognitive response generator
    if "good morning" in prompt.lower():
        reply = "Good Morning! Today is a calm, peaceful day. Take a deep, gentle breath."
    elif "activity" in prompt.lower() or "game" in prompt.lower():
        reply = "Let's play Memory Match! We will pair familiar brass lamps, sweet mangoes, and warm tea cups."
    elif "priya" in prompt.lower() or "daughter" in prompt.lower():
        reply = "Priya sent a message today: Thinking of you Ma, loved looking at monsoon photos yesterday."
    else:
        reply = f"I am right here with you. {prompt}. Everything is peaceful and calm."

    # Generate audio file using standard gTTS library
    audio_filename = f"tts_response_{req.patient_id}.mp3"
    audio_path = os.path.join(STATIC_AUDIO_DIR, audio_filename)
    try:
        tts = gTTS(text=reply, lang=req.language if req.language in ['en', 'hi', 'ta', 'te'] else 'en', slow=True)
        tts.save(audio_path)
        audio_url = f"/api/v1/voice/audio/{audio_filename}"
    except Exception as e:
        audio_url = None

    return VoiceAgentResponse(
        prompt=prompt,
        spoken_text=reply,
        audio_url=audio_url
    )

@router.get("/audio/{filename}")
def get_tts_audio_file(filename: str):
    """Feature 13: Stream TTS MP3 audio file"""
    file_path = os.path.join(STATIC_AUDIO_DIR, filename)
    if not os.path.exists(file_path):
        raise HTTPException(status_code=404, detail="Audio file not found")
    return FileResponse(file_path, media_type="audio/mpeg")
