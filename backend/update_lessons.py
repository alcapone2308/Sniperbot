import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
import os
import uuid
from lessons_ict import ICT_LESSONS

async def update_lessons():
    # Connect to MongoDB
    mongo_url = os.environ.get('MONGO_URL', 'mongodb://localhost:27017')
    client = AsyncIOMotorClient(mongo_url)
    db = client['trading_app']
    
    # Delete existing lessons
    await db.lessons.delete_many({})
    await db.quizzes.delete_many({})
    print("✅ Anciennes leçons supprimées")
    
    # Insert new lessons
    for lesson in ICT_LESSONS:
        lesson['id'] = str(uuid.uuid4())
        await db.lessons.insert_one(lesson)
        print(f"✅ Leçon ajoutée: {lesson['title']}")
    
    # Add quizzes
    lessons = await db.lessons.find().to_list(100)
    
    quizzes = [
        {
            "id": str(uuid.uuid4()),
            "lesson_id": lessons[0]["id"],
            "question": "Quel est le principe de base du trading ?",
            "options": [
                "Acheter bas, vendre haut",
                "Acheter haut, vendre bas",
                "Trader sans stop loss",
                "Risquer tout son capital"
            ],
            "correct_answer": 0,
            "explanation": "Le principe fondamental du trading est d'acheter à bas prix et de vendre à prix élevé pour réaliser un profit.",
            "xp_reward": 25
        },
        {
            "id": str(uuid.uuid4()),
            "lesson_id": lessons[1]["id"],
            "question": "Que représente le corps d'une chandelle japonaise ?",
            "options": [
                "Le volume échangé",
                "La zone entre ouverture et clôture",
                "Le plus haut prix",
                "Le plus bas prix"
            ],
            "correct_answer": 1,
            "explanation": "Le corps de la chandelle représente la zone entre le prix d'ouverture et le prix de clôture.",
            "xp_reward": 25
        },
        {
            "id": str(uuid.uuid4()),
            "lesson_id": lessons[2]["id"],
            "question": "Que signifie 'BOS' en trading ICT ?",
            "options": [
                "Buy On Support",
                "Break of Structure",
                "Best Order Setup",
                "Bullish Order Signal"
            ],
            "correct_answer": 1,
            "explanation": "BOS signifie Break of Structure, c'est quand le prix casse un niveau important de la structure de marché.",
            "xp_reward": 30
        },
        {
            "id": str(uuid.uuid4()),
            "lesson_id": lessons[3]["id"],
            "question": "Qu'est-ce que le Smart Money ?",
            "options": [
                "De l'argent virtuel",
                "Les traders retail",
                "Les grandes institutions (banques, hedge funds)",
                "Les applications de trading"
            ],
            "correct_answer": 2,
            "explanation": "Le Smart Money représente les grandes institutions financières comme les banques et hedge funds qui ont le pouvoir de déplacer le marché.",
            "xp_reward": 30
        },
        {
            "id": str(uuid.uuid4()),
            "lesson_id": lessons[4]["id"],
            "question": "Qu'est-ce qu'un Order Block ?",
            "options": [
                "Un blocage d'ordre par le broker",
                "La dernière bougie avant un mouvement impulsif",
                "Un ordre en attente",
                "Une zone de consolidation"
            ],
            "correct_answer": 1,
            "explanation": "Un Order Block est la dernière bougie avant un mouvement impulsif fort, représentant où les institutions ont placé leurs ordres.",
            "xp_reward": 35
        },
        {
            "id": str(uuid.uuid4()),
            "lesson_id": lessons[5]["id"],
            "question": "Un FVG (Fair Value Gap) se forme avec combien de bougies ?",
            "options": [
                "2 bougies",
                "3 bougies",
                "4 bougies",
                "5 bougies"
            ],
            "correct_answer": 1,
            "explanation": "Un FVG se forme avec 3 bougies : un gap entre la mèche de la 1ère et la mèche de la 3ème bougie.",
            "xp_reward": 35
        },
        {
            "id": str(uuid.uuid4()),
            "lesson_id": lessons[6]["id"],
            "question": "Quelle est la Kill Zone la plus volatile ?",
            "options": [
                "Asian Kill Zone",
                "London Kill Zone",
                "New York Kill Zone",
                "Sydney Kill Zone"
            ],
            "correct_answer": 1,
            "explanation": "La London Kill Zone (8h-11h Paris) est généralement la période la plus volatile avec l'ouverture des marchés européens.",
            "xp_reward": 35
        },
        {
            "id": str(uuid.uuid4()),
            "lesson_id": lessons[7]["id"],
            "question": "Quel pourcentage maximum de votre capital devriez-vous risquer par trade ?",
            "options": [
                "5-10%",
                "10-20%",
                "1-2%",
                "20-50%"
            ],
            "correct_answer": 2,
            "explanation": "La règle d'or du risk management est de ne jamais risquer plus de 1-2% de votre capital par trade pour protéger votre compte.",
            "xp_reward": 30
        },
        {
            "id": str(uuid.uuid4()),
            "lesson_id": lessons[8]["id"],
            "question": "Quelle est la fenêtre de temps du London Silver Bullet (heure de Paris) ?",
            "options": [
                "06h00-07h00",
                "09h00-10h00",
                "14h00-15h00",
                "18h00-19h00"
            ],
            "correct_answer": 1,
            "explanation": "Le London Silver Bullet se situe entre 9h et 10h (heure de Paris), une fenêtre haute probabilité pour des setups de qualité.",
            "xp_reward": 40
        }
    ]
    
    await db.quizzes.insert_many(quizzes)
    print(f"✅ {len(quizzes)} quiz ajoutés")
    
    client.close()
    print("\n✅ Mise à jour terminée avec succès !")

if __name__ == "__main__":
    asyncio.run(update_lessons())
