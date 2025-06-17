import requests

def send_image(image_path, symbol, entry):
    url = "http://127.0.0.1:8000/analyze"
    with open(image_path, "rb") as image_file:
        files = {"file": image_file}
        data = {"symbol": symbol, "entry": str(entry)}
        response = requests.post(url, files=files, data=data)
    return response.json()

if __name__ == "__main__":
    image_path = "Test.jpg"  # Ton image, le contenu est ignoré si mode manuel
    symbol = "BTCUSD"
    entry = 106596.44

    result = send_image(image_path, symbol, entry)
    print("\n📊 Résultat de l'analyse SniperBot (mode manuel) :\n")
    print(f"Direction : {result['direction']}")
    print(f"Entrée (PE) : {result['entry']}")
    print(f"Stop Loss (SL) : {result['stop_loss']}")
    print(f"Take Profit (TP) : {result['take_profit']}")
    print(f"Niveau de confiance : {result['confidence']}")
    print(f"Commentaire : {result['comment']}")
