
from flask import Flask, request, jsonify
import cv2
import numpy as np
import pytesseract
from PIL import Image
import io
import matplotlib.pyplot as plt

app = Flask(__name__)

def detect_market_structure(img_cv, top_price, bottom_price):
    height, width = img_cv.shape[:2]
    gray = cv2.cvtColor(img_cv, cv2.COLOR_BGR2GRAY)
    _, thresh = cv2.threshold(gray, 40, 255, cv2.THRESH_BINARY)

    contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    candles = []
    for cnt in contours:
        x, y, w, h = cv2.boundingRect(cnt)
        if 5 < w < 20 and 20 < h < height * 0.9:
            candles.append((x, y, w, h))

    candles = sorted(candles, key=lambda c: c[0])

    def y_to_price(y_pixel):
        return bottom_price + (top_price - bottom_price) * (1 - y_pixel / height)

    swings = []
    for i in range(1, len(candles) - 1):
        _, y_prev, _, h_prev = candles[i - 1]
        _, y_curr, _, h_curr = candles[i]
        _, y_next, _, h_next = candles[i + 1]

        high_prev = y_to_price(y_prev)
        high_curr = y_to_price(y_curr)
        high_next = y_to_price(y_next)

        low_prev = y_to_price(y_prev + h_prev)
        low_curr = y_to_price(y_curr + h_curr)
        low_next = y_to_price(y_next + h_next)

        if low_curr < low_prev and low_curr < low_next:
            swings.append({"type": "swing_low", "price": round(low_curr, 2), "index": i, "pos": candles[i]})
        elif high_curr > high_prev and high_curr > high_next:
            swings.append({"type": "swing_high", "price": round(high_curr, 2), "index": i, "pos": candles[i]})

    bos_list = []
    for i in range(1, len(swings)):
        prev = swings[i - 1]
        curr = swings[i]

        if prev["type"] == "swing_low" and curr["type"] == "swing_low":
            if curr["price"] < prev["price"]:
                bos_list.append({"type": "BOS_Down", "price": curr["price"], "index": curr["index"], "pos": curr["pos"]})
        elif prev["type"] == "swing_high" and curr["type"] == "swing_high":
            if curr["price"] > prev["price"]:
                bos_list.append({"type": "BOS_Up", "price": curr["price"], "index": curr["index"], "pos": curr["pos"]})

    return {
        "swings": swings,
        "bos": bos_list
    }

@app.route('/analyze', methods=['POST'])
def analyze_image():
    if 'image' not in request.files:
        return jsonify({'error': 'No image uploaded'}), 400

    file = request.files['image']
    img = Image.open(file.stream).convert("RGB")
    img_cv = cv2.cvtColor(np.array(img), cv2.COLOR_RGB2BGR)

    # Example: simulate top/bottom price for structure analysis
    top_price = 3450
    bottom_price = 3425
    structure = detect_market_structure(img_cv, top_price, bottom_price)

    return jsonify({
        "message": "Structure détectée avec succès",
        "structure": structure
    })

if __name__ == '__main__':
    app.run(debug=True)
