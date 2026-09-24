# Nenil (SIH2026)

*A compassionate companion application designed to bridge the gap between memory-care patients (like those with Alzheimer's or Dementia) and their caregivers.*

---

## Our Story
Caregiving is an act of deep dedication, but it can also be overwhelming. Patients with memory loss often struggle with daily routines, emotional regulation, and feelings of isolation. **Nenil** (Project SIH2026) was built with empathy at its core—designed to empower both the patient and the caregiver. 

By combining simple, accessible patient interfaces with a comprehensive caregiver dashboard, we aim to bring peace of mind to families while preserving the dignity and independence of patients.

---

## Features

### For the Caregiver (Caregiver Hub)
- **Real-Time Monitoring:** Keep track of the patient's daily activities, such as morning routines and engagement levels.
- **Activity & Mood Tracking:** Receive updates when the patient completes cognitive exercises (like Memory Match games) along with their mood for the day.
- **Voice Notes:** Send encouraging, personalized morning voice notes that play automatically for the patient, providing a familiar and comforting voice.
- **Emergency Support Network:** One-tap access to a support network, including primary doctors and family members.

### For the Patient
- **Simplified Interface:** A highly accessible and distraction-free UI tailored for elderly users and those with cognitive impairments.
- **Cognitive Exercises:** Interactive and gentle games, like Memory Match, designed to stimulate cognitive function.
- **Audio Prompts:** Text-to-Speech (TTS) integration to gently guide the patient through the app without confusion.
- **Direct Calling:** A straightforward PIN and calling screen to instantly reach out to loved ones when feeling lost or distressed.

---

## Tech Stack

We carefully chose technologies that allow us to build a robust, cross-platform, and highly responsive application.

**Frontend:**
- **Flutter:** For a seamless, accessible cross-platform mobile experience (iOS & Android).
- **Google Fonts & Cupertino Icons:** For clean, highly legible typography and intuitive iconography.
- **Flutter TTS:** For voice prompts and reading messages aloud.

**Backend:**
- **FastAPI (Python):** A lightning-fast and modern web framework for building our RESTful APIs.
- **SQLAlchemy:** For reliable and structured database management.
- **Bcrypt & JOSE:** For secure authentication and data protection.
- **gTTS:** Google Text-to-Speech integration on the server side.

---

## Project Structure

```text
SIH2026/
├── SIH_Backend/       # FastAPI Python Backend
│   ├── main.py        # Entry point for the backend server
│   ├── requirements.txt # Python dependencies
│   └── ...            # Routes, Models, and Schemas
│
├── SIH_Frontned/      # Flutter Mobile Application
│   ├── lib/
│   │   ├── features/  # Feature-first architecture (Auth, Caregiver, Profile, etc.)
│   │   ├── core/      # Core configs, themes, and network layers
│   │   └── main.dart  # Entry point for the Flutter app
│   └── pubspec.yaml   # Flutter dependencies
│
└── main.py            # Root runner for local backend testing
```

---

## Getting Started

### Prerequisites
- **Flutter SDK** (v3.13.4 or higher)
- **Python** (v3.9 or higher)
- **Android Studio / VS Code** (with Flutter extensions)

### 1. Setting up the Backend
1. Navigate to the backend directory:
   ```bash
   cd SIH_Backend
   ```
2. Install the required Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Run the FastAPI server:
   ```bash
   uvicorn main:app --reload
   ```
   *The backend will typically run on `http://127.0.0.1:8000`.*

### 2. Setting up the Frontend
1. Navigate to the frontend directory:
   ```bash
   cd SIH_Frontned
   ```
2. Fetch the Flutter packages:
   ```bash
   flutter pub get
   ```
3. Run the application on your connected device or emulator:
   ```bash
   flutter run
   ```

---

## Built for SIH 2026
This project was conceptualized and developed with technical rigor for the **Smart India Hackathon 2026**.
