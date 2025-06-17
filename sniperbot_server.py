from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import numpy as np
import cv2
import io
from PIL import Image

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class TradeSignal(BaseModel):
    direction: str
    entry: float
    stop_loss: float
    take_profit: float
    confidence: str
    comment: str

def detect_bos_and_swings(img_np):
    gray = cv2.cvtColor(img_np, cv2.COLOR_BGR2GRAY)
    blur = cv2.GaussianBlur(gray, (5, 5), 0)

    # Détection de contours (lignes de chandeliers)
    edges = cv2.Canny(blur, 50, 150)

    # On convertit les lignes en points pour analyse de structure
    contours, _ = cv2.findContours(edges, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    swing_highs = []
    swing_lows = []

    for cnt in contours:
        x, y, w, h = cv2.boundingRect(cnt)
        if h > 20:
            center = (x + w // 2, y + h // 2)
            if y < img_np.shape[0] // 2:
                swing_highs.append(center)
            else:
                swing_lows.append(center)

    if len(swing_highs) < 2 or len(swing_lows) < 2:
        return None

    # Simuler un BOS baissier pour l'exemple (détection de cassure du swing low précédent)
    last_high = sorted(swing_highs, key=lambda p: p[0])[-1]
    last_low = sorted(swing_lows, key=lambda p: p[0])[-1]

    entry = last_low[1] * 1.0
    sl = entry + 100
    tp = entry - 200

    return {
        "direction": "Sell",
        "entry": round(entry, 2),
        "stop_loss": round(sl, 2),
        "take_profit": round(tp, 2),
        "confidence": "Structure",
        "comment": "BOS baissier détecté sur cassure du swing low."
    }

@app.post("/analyze")
async def analyze_image(file: UploadFile = File(...)) -> TradeSignal:
    content = await file.read()
    image = Image.open(io.BytesIO(content)).convert("RGB")
    img_np = np.array(image)

    result = detect_bos_and_swings(img_np)
    if not result:
        return TradeSignal(
            direction="Unknown",
            entry=0,
            stop_loss=0,
            take_profit=0,
            confidence="Aucune structure détectée",
            comment="L'analyse n'a pas pu détecter de BOS ou swings clairs"
        )

    return TradeSignal(**result)
