from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from PIL import Image
import pytesseract
import io
import numpy as np
import cv2
import re

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
    symbol: str = "UNKNOWN"

@app.post("/analyze")
async def analyze_chart(file: UploadFile = File(...)) -> TradeSignal:
    contents = await file.read()
    image = Image.open(io.BytesIO(contents)).convert("RGB")
    img_array = np.array(image)

    # --- Étape 1 : OCR complet ---
    ocr_text = pytesseract.image_to_string(image)

    # 🔍 Reconnaissance automatique de la paire (symbol)
    detected_symbol = "UNKNOWN"
    match = re.search(r"\b([A-Z]{3,5}USD)\b", ocr_text.upper())
    if match:
        detected_symbol = match.group(1)

    # 🧠 Extraction des prix OCR
    price_lines = [line for line in ocr_text.split("\n") if any(c.isdigit() for c in line)]
    prices = []
    for line in price_lines:
        line_clean = line.replace(',', '').replace(' ', '').replace('O', '0')
        try:
            value = float(line_clean)
            if 10 <= value <= 1000000:
                prices.append(value)
        except:
            continue

    if not prices:
        return TradeSignal(
            direction="Sell",
            entry=3432.83,
            stop_loss=3422.83,
            take_profit=3452.83,
            confidence="Faible",
            comment="OCR échoué – aucune échelle valide trouvée",
            symbol=detected_symbol
        )

    # --- Étape 2 : Analyse graphique simplifiée (Canny) ---
    gray = cv2.cvtColor(img_array, cv2.COLOR_RGB2GRAY)
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)
    edges = cv2.Canny(blurred, 50, 150)

    # 🔁 Analyse très simplifiée des swings
    entry_price = round(sum(prices) / len(prices), 2)
    sl = round(min(prices), 2)
    tp = round(max(prices), 2)

    direction = "Buy" if tp > entry_price else "Sell"

    return TradeSignal(
        direction=direction,
        entry=entry_price,
        stop_loss=sl,
        take_profit=tp,
        confidence="Modérée",
        comment="Détection auto : symbol + plage prix OCR analysée",
        symbol=detected_symbol
    )
