from fastapi import FastAPI, File, UploadFile
from keras.models import load_model
from PIL import Image
from scipy.stats import entropy
import numpy as np
import io
import time

# Initialiser l'application FastAPI
app = FastAPI(
    title="Breast Cancer Prediction API",
    description="Cette API prédit le type de cancer à partir d'images.",
    version="1.0.0"
)


# Route pour accêder a la page d'accueil
@app.get("/")
def read_root():
    return {"message": "API Breast Cancer Prediction"}

# Charger le modèle ML (assurez-vous d'ajuster le chemin si nécessaire
model = load_model('model_breast_cancer.keras')

# Fonction pour pré-traiter l'image avant de la passer au modèle
def preprocess_image(image):
    image = image.resize((1, 96))  # Ajustez la taille selon votre modèle
    image = np.array(image) / 255.0   # Normalisation
    image = np.expand_dims(image, axis=0)  # Ajouter une dimension batch
    return image

# Endpoint pour les prédictions

@app.post("/predict/", summary="Upload an image for breast cancer prediction", description="This endpoint allows you to upload a mammogram image and get a prediction about whether the breast tissue is benign, malignant, or normal.")
async def predict(file: UploadFile = File(...)):
    """
    Charge une image de 96x96 pixels et la passe au modèle pour prédire.
    
    - **file**: fichier image (jpeg ou png) à analyser
    """
    # Lire l'image envoyée
    try:
        image = Image.open(io.BytesIO(await file.read()))
    except Exception as e:
        return {"error": "Invalid image file"}
    
    # Pré-traiter l'image
    processed_image = preprocess_image(image)
    
    # Faire la prédiction avec le modèle
    prediction = model.predict(processed_image)
    
    # Liste des classes (ajuste les noms selon tes classes réelles)
    classes = ["Benign", "Malignant", "Normal"]
    
    # Trouver la classe avec la probabilité la plus élevée
    predicted_class_index = np.argmax(prediction[0])
    predicted_class = classes[predicted_class_index]
    
    # Calculer la marge de confiance
    sorted_probs = np.sort(prediction[0])[::-1]
    confidence_margin = sorted_probs[0] - sorted_probs[1]
    
    # Calculer le temps de traitement
    start_time = time.time()
    prediction = model.predict(processed_image)
    processing_time = time.time() - start_time

    # Calculer l'entropie
    uncertainty = entropy(prediction[0])  # calcul de l'entropie
    # Retourner la prédiction sous forme JSON
    return {
        "prediction": predicted_class,
        "confidence": float(prediction[0][predicted_class_index]),
        "confidence_margin": float(confidence_margin),
        "uncertainty": float(uncertainty),
        "processing_time": float(processing_time)
    }

# Commande pour démarrer le serveur FastAPI
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)