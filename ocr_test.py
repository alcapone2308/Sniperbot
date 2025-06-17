import cv2
import pytesseract

image = cv2.imread("ton_image.png")
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
data = pytesseract.image_to_string(gray)
print("Texte détecté par OCR :")
print(data)
