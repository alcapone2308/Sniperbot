from fastapi import FastAPI, File, UploadFile, Form
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from PIL import Image
import pytesseract
import io
import numpy as np
import cv2
import re

app = FastAPI()

# Autoriser requêtes Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Modèle de réponse JSON
class TradeSignal(BaseModel):
    direction: str
    entry: float
    stop_loss: float
    take_profit: float
    confidence: str
    comment: str

# 🔍 OCR pour détecter les prix dans l'image
def extract_prices_from_image(image_bytes) -> list[float]:
    try:
        image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
        image_cv = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)

        gray = cv2.cvtColor(image_cv, cv2.COLOR_BGR2GRAY)
        text = pytesseract.image_to_string(gray)

        raw_numbers = re.findall(r'\d+\.\d+', text)
        prices = [float(p) for p in raw_numbers]
        return sorted(set([p for p in prices if p > 10]), reverse=True)
    except Exception as e:
        print(f"Erreur OCR : {e}")
        return []

# 🕯️ Détection des bougies pour BOS/FVG
def detect_candles(image_bytes) -> list[tuple[int, int, int, int]]:
    image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    image_cv = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)
    gray = cv2.cvtColor(image_cv, cv2.COLOR_BGR2GRAY)

    _, thresh = cv2.threshold(gray, 180, 255, cv2.THRESH_BINARY_INV)
    contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    candles = [cv2.boundingRect(c) for c in contours if 5 < cv2.boundingRect(c)[2] < 20]
    return candles

# 🚀 Route principale
@app.post("/analyze")
async def analyze_chart(
    file: UploadFile = File(...),
    symbol: str = Form(default=""),
    entry: float = Form(default=0.0)
) -> TradeSignal:
    contents = await file.read()

    # ✅ Mode manuel activé
    if symbol and entry > 0:
        if symbol.upper() in ["EURUSD", "GBPUSD", "AUDUSD"]:
            sl = round(entry - 0.0010, 5)
            tp = round(entry + 0.0020, 5)
        elif symbol.upper() in ["BTCUSD", "XAUUSD", "NAS100"]:
            sl = round(entry - 100, 2)
            tp = round(entry + 200, 2)
        else:
            sl = round(entry - 10, 2)
            tp = round(entry + 20, 2)

        return TradeSignal(
            direction="Buy",
            entry=entry,
            stop_loss=sl,
            take_profit=tp,
            confidence="Manuel",
            comment=f"Mode manuel activé pour {symbol.upper()}"
        )

    # 🔎 Mode IA (OCR + détection structure)
    prices = extract_prices_from_image(contents)
    candles = detect_candles(contents)

    if prices:
        entry = prices[0]
        sl = round(entry - entry * 0.003, 2)
        tp = round(entry + entry * 0.006, 2)

        return TradeSignal(
            direction="Buy",
            entry=entry,
            stop_loss=sl,
            take_profit=tp,
            confidence="IA",
            comment=f"OCR détecté ({len(prices)} prix), bougies détectées : {len(candles)}"
        )

    # ❌ Fallback (aucun prix détecté)
    return TradeSignal(
        direction="Buy",
        entry=3432.83,
        stop_loss=3422.83,
        take_profit=3452.83,
        confidence="Faible",
        comment="OCR échoué – prix par défaut utilisé"
    )
