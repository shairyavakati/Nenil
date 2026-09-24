import random
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.database.db import get_db
from app.database.models import Patient, FamilyPhoto, DailyTask, QuizQuestion
from app.schemas.schemas import (
    FamilyPhotoCreate, PhotoPuzzleResponse, WordSearchRequest, WordSearchResponse,
    RegionalQuizResponse, DailyTaskCreate
)

router = APIRouter(prefix="/games", tags=["Cognitive Games & Task Engine"])

# -------------------------------------------------------------
# Feature 7: Family Photo Integration -> Puzzle Game
# -------------------------------------------------------------
@router.post("/photo-puzzle/upload", response_model=dict)
def upload_family_photo(req: FamilyPhotoCreate, db: Session = Depends(get_db)):
    """Feature 7: Upload family photo for puzzle game"""
    photo = FamilyPhoto(
        patient_id=req.patient_id,
        title=req.title,
        image_url=req.image_url,
        description=req.description,
        audio_note_prompt=req.audio_note_prompt
    )
    db.add(photo)
    db.commit()
    db.refresh(photo)
    return {"message": "Family photo uploaded for puzzle game", "photo_id": photo.id}

@router.get("/photo-puzzle/{patient_id}", response_model=List[PhotoPuzzleResponse])
def get_photo_puzzles(patient_id: int, db: Session = Depends(get_db)):
    """Feature 7: Get photo puzzle cards for patient"""
    photos = db.query(FamilyPhoto).filter(FamilyPhoto.patient_id == patient_id).all()
    if not photos:
        # Seed default family keepsake photos for demo
        default_photos = [
            FamilyPhoto(
                patient_id=patient_id,
                title="Monsoon Tea at Courtyard",
                image_url="https://lh3.googleusercontent.com/aida-public/AB6AXuCCIfEO_0JXjcS1pGOFlvZznkR40--FdKTvAsn7bWrVWpX36-xyZ2iIfWGCX5T9-b9GNvlPKoUDVg5ldZ9DCeEDo1wQM85nml9ucnH6cWkss1A8MUUcZtRmWFzY16e49KPLE16lQ8IRySRlUbWQToMrNpxX8m9tkvGQIjND6xF_8brpHxWqVMX6P7ymA1o9sPGJ3J18Kndr1RmJkWBglv7b4hwwAI1Nmqz-XM-L5NJXLz8i8Jx8LXRs",
                description="Pairing tea cups and garden rain memories.",
                audio_note_prompt="Remember how we used to watch the rain sitting on the swing?"
            ),
            FamilyPhoto(
                patient_id=patient_id,
                title="Diwali Festivities with Family",
                image_url="https://lh3.googleusercontent.com/aida-public/AB6AXuCPmU9lAc8HXQTAMvSL4GOM1ka1TIs12X3kfzBF1xZlTICn8djsRKylWnvprCpQ7WYp1jTw5Sfi3YiYk59BYZRLwuV-jtOx1tzeLSmu8taqDtEA60Y-ziBI-FbRZf7iovQati-VbF9JnOBqZeWEbnKRLJRN9HzPW97CvC51a70fKtvETF-VI3f8W8jqdc2yObrrVNlTl9zDcYdGWXDlzl25DGAxuxNVDpezJa0eVUQHslyMzWAiWRiG",
                description="Pairing brass diya lamps and festive sweets.",
                audio_note_prompt="Grandma made the best gulab jamuns!"
            ),
        ]
        db.add_all(default_photos)
        db.commit()
        photos = db.query(FamilyPhoto).filter(FamilyPhoto.patient_id == patient_id).all()

    return [
        PhotoPuzzleResponse(
            puzzle_id=p.id,
            title=p.title,
            image_url=p.image_url,
            description=p.description,
            grid_size=3,
            audio_note_prompt=p.audio_note_prompt
        ) for p in photos
    ]

# -------------------------------------------------------------
# Feature 8: Daily Routine Questions / Task Generation
# -------------------------------------------------------------
@router.post("/daily-routine/task", response_model=dict)
def add_daily_routine_task(req: DailyTaskCreate, db: Session = Depends(get_db)):
    """Feature 8: Generate / Add daily routine task"""
    task = DailyTask(
        patient_id=req.patient_id,
        task_name=req.task_name,
        time_of_day=req.time_of_day,
        question_prompt=req.question_prompt
    )
    db.add(task)
    db.commit()
    db.refresh(task)
    return {"message": "Daily routine task generated", "task_id": task.id}

@router.get("/daily-routine/{patient_id}", response_model=dict)
def get_daily_routine_questions(patient_id: int, db: Session = Depends(get_db)):
    """Feature 8: Get daily routine questions & generated tasks"""
    tasks = db.query(DailyTask).filter(DailyTask.patient_id == patient_id).all()
    questions = [
        {"question": "Have you taken your morning warm tea?", "suggested_task": "Morning Tea & Quiet Breath"},
        {"question": "Would you like to listen to sitar music this afternoon?", "suggested_task": "Listen to Raga Melody"},
        {"question": "Did you check the garden flowers today?", "suggested_task": "Courtyard Walk"}
    ]
    return {
        "patient_id": patient_id,
        "daily_questions": questions,
        "generated_tasks": [
            {"id": t.id, "name": t.task_name, "time": t.time_of_day, "completed": t.is_completed} for t in tasks
        ]
    }

# -------------------------------------------------------------
# Feature 9: Word Search Puzzle Game
# -------------------------------------------------------------
@router.post("/word-search", response_model=WordSearchResponse)
def generate_word_search(req: WordSearchRequest):
    """Feature 9: Word Search Game Grid Generator"""
    words = ["LAMP", "MANGO", "CHAI", "SAGE", "TEA", "FLOW"]
    grid_size = max(8, req.grid_size)
    grid = [["" for _ in range(grid_size)] for _ in range(grid_size)]

    # Simple placement logic for standard word search grid
    for word in words:
        row = random.randint(0, grid_size - 1)
        col = random.randint(0, grid_size - len(word))
        for i, char in enumerate(word):
            grid[row][col + i] = char

    # Fill empty cells with random letters
    alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    for r in range(grid_size):
        for c in range(grid_size):
            if grid[r][c] == "":
                grid[r][c] = random.choice(alphabet)

    return WordSearchResponse(grid=grid, words_to_find=words)

# -------------------------------------------------------------
# Feature 10: General Quiz (Based on Region) Game
# -------------------------------------------------------------
@router.get("/regional-quiz/{region}", response_model=List[RegionalQuizResponse])
def get_regional_quiz(region: str, db: Session = Depends(get_db)):
    """Feature 10: General Quiz based on Region (South, North, West, East)"""
    quizzes = db.query(QuizQuestion).filter(QuizQuestion.region.ilike(region)).all()
    if not quizzes:
        # Seed region-based quiz questions
        seeded = [
            QuizQuestion(
                region="South",
                question_text="Which traditional brass oil lamp is lit during morning prayers in South India?",
                option_a="Diya / Kuthuvilakku", option_b="Lantern", option_c="Candle", option_d="Torch",
                correct_option="A"
            ),
            QuizQuestion(
                region="South",
                question_text="Which sweet tropical fruit is famous in Ratnagiri and Alphonso varieties?",
                option_a="Apple", option_b="Mango", option_c="Banana", option_d="Guava",
                correct_option="B"
            ),
            QuizQuestion(
                region="North",
                question_text="Which festival of lights is celebrated with clay lamps and sweets?",
                option_a="Holi", option_b="Diwali", option_c="Baisakhi", option_d="Pongal",
                correct_option="B"
            ),
            QuizQuestion(
                region="West",
                question_text="Which famous festival honors Lord Ganesha with clay idols and modaks?",
                option_a="Ganesh Chaturthi", option_b="Navratri", option_c="Onam", option_d="Bihu",
                correct_option="A"
            ),
        ]
        db.add_all(seeded)
        db.commit()
        quizzes = db.query(QuizQuestion).filter(QuizQuestion.region.ilike(region)).all()

    return [
        RegionalQuizResponse(
            question_id=q.id,
            region=q.region,
            question=q.question_text,
            options=[q.option_a, q.option_b, q.option_c, q.option_d],
            correct_option=q.correct_option
        ) for q in quizzes
    ]
