import sys
import os

# Add SIH_Backend directory to system path
backend_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "SIH_Backend")
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)

# Import FastAPI app from backend
from main import app
