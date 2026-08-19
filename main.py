# WARM START PATTERN
from fastapi import FastAPI, UploadFile, File
from faster_whisper import WhisperModel
import io

app = FastAPI()

# This runs once at startup. The model is now "Warm" in VRAM.
model = WhisperModel("large-v3-turbo"
, device="cuda"
, compute_type="float16")

@app.post("/transcribe")
async def transcribe(file: UploadFile = File(...)):
    # Read file into memory and transcribe
    audio_data = io.BytesIO(await file.read())
    segments, _ = model.transcribe(audio_data)
    
    # Join all segments into a single string
    full_text = " ".join([segment.text for segment in segments])
    return {"text": full_text.strip()}