from fastapi import FastAPI, APIRouter, HTTPException, Depends
from dotenv import load_dotenv
from starlette.middleware.cors import CORSMiddleware
from motor.motor_asyncio import AsyncIOMotorClient
import os
import logging
from pathlib import Path
from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
import uuid
from datetime import datetime, timedelta
import httpx
from emergentintegrations.llm.chat import LlmChat, UserMessage

ROOT_DIR = Path(__file__).parent
load_dotenv(ROOT_DIR / '.env')

# MongoDB connection
mongo_url = os.environ['MONGO_URL']
client = AsyncIOMotorClient(mongo_url)
db = client[os.environ['DB_NAME']]

# Create the main app
app = FastAPI()
api_router = APIRouter(prefix="/api")

# Models
class User(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    email: str
    name: str
    avatar: Optional[str] = None
    level: int = 1
    xp: int = 0
    virtual_balance: float = 10000.0  # Starting balance
    total_profit: float = 0.0
    created_at: datetime = Field(default_factory=datetime.utcnow)

class UserCreate(BaseModel):
    email: str
    name: str
    avatar: Optional[str] = None

class Position(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    user_id: str
    symbol: str
    asset_type: str  # 'crypto', 'stock', 'forex'
    quantity: float
    buy_price: float
    current_price: float = 0.0
    total_value: float = 0.0
    profit_loss: float = 0.0
    profit_loss_percent: float = 0.0
    created_at: datetime = Field(default_factory=datetime.utcnow)

class Transaction(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    user_id: str
    symbol: str
    asset_type: str
    transaction_type: str  # 'buy' or 'sell'
    quantity: float
    price: float
    total: float
    timestamp: datetime = Field(default_factory=datetime.utcnow)

class TradeRequest(BaseModel):
    user_id: str
    symbol: str
    asset_type: str
    transaction_type: str
    quantity: float
    price: float

class Lesson(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    title: str
    description: str
    content: str
    difficulty: str  # 'beginner', 'intermediate', 'advanced'
    category: str  # 'crypto', 'stocks', 'forex', 'general'
    order: int
    xp_reward: int = 50

class Quiz(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    lesson_id: str
    question: str
    options: List[str]
    correct_answer: int
    explanation: str
    xp_reward: int = 25

class QuizSubmit(BaseModel):
    user_id: str
    quiz_id: str
    answer: int

class Challenge(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    title: str
    description: str
    challenge_type: str  # 'daily_trade', 'profit_target', 'lesson_complete'
    target_value: float
    xp_reward: int = 100
    date: str

class UserProgress(BaseModel):
    user_id: str
    completed_lessons: List[str] = []
    completed_quizzes: List[str] = []
    completed_challenges: List[str] = []

class AIAssistantRequest(BaseModel):
    user_id: str
    message: str
    context: Optional[str] = None

# Initialize sample data
async def initialize_data():
    # Check if lessons exist
    lessons_count = await db.lessons.count_documents({})
    if lessons_count == 0:
        sample_lessons = [
            {
                "id": str(uuid.uuid4()),
                "title": "Introduction au Trading",
                "description": "Découvrez les fondamentaux du trading et l'importance de la psychologie",
                "content": """Le trading est l'art d'acheter et de vendre des actifs financiers dans le but de réaliser un profit.

📊 Les Types d'Actifs
• Actions : Parts de propriété d'une entreprise
• Cryptomonnaies : Monnaies numériques décentralisées (Bitcoin, Ethereum)
• Forex : Marché des devises (EUR/USD, GBP/USD)
• Matières premières : Or, pétrole, argent

💡 Principes Fondamentaux
1. Achetez bas, vendez haut : Le principe de base de tout trading
2. Gestion du risque : Ne risquez jamais plus de 1-2% de votre capital
3. Patience et discipline : Les émotions sont l'ennemi du trader
4. Formation continue : Les marchés évoluent constamment

🎯 Votre Objectif : Devenir un trader consistant et rentable sur le long terme !""",
                "difficulty": "beginner",
                "category": "general",
                "order": 1,
                "xp_reward": 50
            },
            {
                "id": str(uuid.uuid4()),
                "title": "Les Chandelles Japonaises",
                "description": "Apprenez à lire les bougies, l'outil principal de tout trader",
                "content": """Les chandelles japonaises sont la représentation graphique des mouvements de prix.

🕯️ Anatomie d'une Bougie
• Corps : Zone entre ouverture et clôture
• Mèche haute : Plus haut prix atteint
• Mèche basse : Plus bas prix atteint
• Bougie verte : Hausse (clôture > ouverture)
• Bougie rouge : Baisse (clôture < ouverture)

📈 Patterns Importants
1. Doji : Ouverture = Clôture (indécision)
2. Marteau : Longue mèche basse (retournement haussier)
3. Étoile filante : Longue mèche haute (retournement baissier)
4. Englobante haussière/baissière

💡 Conseil Pro : Ne tradez jamais sur une seule bougie ! Attendez la confirmation.""",
                "difficulty": "beginner",
                "category": "general",
                "order": 2,
                "xp_reward": 75
            },
            {
                "id": str(uuid.uuid4()),
                "title": "Structure de Marché ICT",
                "description": "Comprenez comment identifier les tendances et les points clés",
                "content": """La structure de marché est le fondement de l'analyse ICT/SMC.

📊 Les 3 Structures de Base

1. Tendance Haussière : Higher Highs (HH) + Higher Lows (HL)
2. Tendance Baissière : Lower Highs (LH) + Lower Lows (LL)
3. Range : Consolidation entre support et résistance

🔑 Break of Structure (BOS)
• BOS haussier : Casse un sommet précédent (signal d'achat)
• BOS baissier : Casse un creux précédent (signal de vente)

🎯 Change of Character (CHoCH)
Signal de changement de tendance quand le prix ne suit plus la structure actuelle.

💡 Règle d'Or : Tradez AVEC la tendance, jamais contre !""",
                "difficulty": "intermediate",
                "category": "general",
                "order": 3,
                "xp_reward": 100
            },
            {
                "id": str(uuid.uuid4()),
                "title": "Liquidité et Smart Money",
                "description": "Découvrez comment les institutions manipulent le marché",
                "content": """Le Smart Money représente les grandes institutions : banques, hedge funds, market makers.

💰 Qu'est-ce que la Liquidité ?
La liquidité = les ordres d'achat/vente en attente dans le marché.

📍 Zones de Liquidité
• Au-dessus des sommets : Stop Loss des vendeurs
• En-dessous des creux : Stop Loss des acheteurs
• Niveaux psychologiques : 100.00, 1.2000, etc.

🎭 Manipulation du Marché
Phase 1 : Accumulation (institutions accumulent)
Phase 2 : Manipulation (liquidity grab, faux mouvement)
Phase 3 : Distribution (vraie direction)

🎯 Comment Trader : Attendez le liquidity grab, puis entrez quand le prix revient dans la zone d'intérêt.

💡 Citation ICT : Le marché cherche toujours la liquidité avant son vrai mouvement.""",
                "difficulty": "advanced",
                "category": "general",
                "order": 4,
                "xp_reward": 150
            },
            {
                "id": str(uuid.uuid4()),
                "title": "Order Blocks (OB)",
                "description": "Les zones où les institutions placent leurs ordres massifs",
                "content": """Les Order Blocks sont des zones de décision institutionnelle.

📦 Qu'est-ce qu'un Order Block ?
C'est la dernière bougie avant un mouvement impulsif fort.

🟢 Bullish Order Block
• Dernière bougie rouge avant une forte hausse
• Zone de demande institutionnelle
• Le prix rebondit au retest

🔴 Bearish Order Block
• Dernière bougie verte avant une forte baisse
• Zone d'offre institutionnelle
• Le prix chute au retest

✅ OB de Qualité
1. Mouvement impulsif après l'OB
2. Non retesté (plus puissant)
3. Timeframe élevé (H4/D1)
4. Confluence avec FVG

🎯 Comment Trader un OB
1. Identifiez la structure
2. Marquez les OB
3. Attendez le retest
4. Cherchez une confirmation
5. Entrez avec Stop Loss approprié

💎 Meilleurs OB : Ceux créés après un liquidity grab !""",
                "difficulty": "advanced",
                "category": "general",
                "order": 5,
                "xp_reward": 150
            },
            {
                "id": str(uuid.uuid4()),
                "title": "Fair Value Gaps (FVG)",
                "description": "Les déséquilibres du marché exploités par les pros",
                "content": """Les Fair Value Gaps sont des zones de déséquilibre créées par des mouvements rapides.

⚡ Qu'est-ce qu'un FVG ?
Un FVG se forme quand le prix bouge si vite qu'il laisse un vide sur le graphique.

🟢 Bullish FVG : Gap entre mèche basse bougie 1 et mèche haute bougie 3
🔴 Bearish FVG : Gap entre mèche haute bougie 1 et mèche basse bougie 3

📋 Types de FVG
1. FVG Standard : Prix remplit 50%+ du gap
2. FVG Partiel : Prix touche le gap
3. FVG Inversé : Change de polarité

🎯 Stratégie de Trading
1. Identifiez un FVG dans la tendance
2. Attendez le retest
3. Cherchez un rejet
4. Entrez avec SL approprié
5. Target : Prochain FVG opposé

💎 FVG + Order Block = Setup Premium !

💡 Règle ICT : 70% des FVG sont comblés avant que le prix continue.""",
                "difficulty": "advanced",
                "category": "general",
                "order": 6,
                "xp_reward": 150
            },
            {
                "id": str(uuid.uuid4()),
                "title": "Kill Zones et Sessions",
                "description": "Tradez aux meilleurs moments quand le Smart Money est actif",
                "content": """Les Kill Zones sont les périodes où le Smart Money est le plus actif.

🌍 Les 3 Sessions Principales
1. Asiatique (00h-09h GMT) : Faible volatilité
2. Européenne (07h-16h GMT) : Haute volatilité
3. Américaine (13h-22h GMT) : Très haute volatilité

⚡ Les Kill Zones ICT

London Kill Zone : 08h00-11h00 (Paris)
• Période la plus volatile
• Institutions européennes actives

New York Kill Zone : 13h00-16h00 (Paris)
• Overlap Londres + New York
• Maximum de liquidité

🎯 Power of 3 (Cycle de chaque Kill Zone)
1. Accumulation : Consolidation, volume faible
2. Manipulation : Liquidity grab, faux breakout
3. Distribution : Vrai mouvement, trend

💡 Comment Utiliser
• Tradez QUE pendant les Kill Zones
• Attendez la manipulation
• London donne la direction du jour
• NY peut inverser la tendance

⏰ Évitez : 30 min avant/après les news, week-ends, hors Kill Zones""",
                "difficulty": "advanced",
                "category": "general",
                "order": 7,
                "xp_reward": 200
            },
            {
                "id": str(uuid.uuid4()),
                "title": "Gestion du Risque ICT",
                "description": "Protégez votre capital comme un professionnel",
                "content": """La gestion du risque différencie les gagnants des perdants.

💰 Règle d'Or : Ne risquez JAMAIS plus de 1-2% par trade !

Exemple 10,000€ :
• Risque 1% = 100€ max par trade
• 10 pertes = -10% seulement
• Avec 50% de perte, il faut +100% pour revenir !

📊 Calcul de Position Size
Position = (Capital × Risque%) / Distance SL en pips

🎯 Ratio Risk/Reward (RR)
• Minimum : 1:2 (risque 100€, visez 200€)
• Pro : 1:3 ou plus
• ICT : souvent 1:5 à 1:10

💎 Types de Stop Loss
1. Technique : Sous OB haussier / Au-dessus OB baissier
2. ATR : Basé sur volatilité
3. Temporel : Si setup ne fonctionne pas en X heures

🎓 Prise de Profit ICT
• 50% à 1:2 RR
• 25% à 1:3 RR
• 25% laissés runner (SL break-even)

Targets : Prochain OB/FVG opposé, zone de liquidité

⚠️ Erreurs Mortelles
1. Over-leveraging (levier >1:30)
2. Revenge trading après perte
3. Déplacer le SL pour éviter stop
4. Pas de SL = suicide financier
5. Over-trading (qualité > quantité)

🧠 Psychologie : Une perte fait partie du jeu. Une grosse perte vous sort du jeu.""",
                "difficulty": "intermediate",
                "category": "general",
                "order": 8,
                "xp_reward": 150
            },
            {
                "id": str(uuid.uuid4()),
                "title": "Silver Bullet Setup",
                "description": "La stratégie signature d'ICT pour trader comme un pro",
                "content": """La Silver Bullet est une des stratégies les plus puissantes d'ICT.

🎯 Fenêtres de Temps Silver Bullet
• London : 09h00-10h00 (Paris)
• New York : 16h00-17h00 (Paris)

⚡ Le Setup (3 Phases)

PHASE 1 : Analyse Préalable
1. Identifiez la tendance H4/D1
2. Marquez OB, FVG, zones de liquidité
3. Déterminez le biais (haussier/baissier)

PHASE 2 : Pendant la Kill Zone
1. Observation (15 premières minutes)
2. Liquidity Grab (faux mouvement = MANIPULATION)
3. Reversal rapide (moment magique !)

PHASE 3 : Exécution
Pour trade HAUSSIER :
• Prix grab liquidité sous un low
• Retour rapide créant bullish FVG
• Entrée au retest FVG/OB
• SL sous le low du grab
• Target : Prochain high ou FVG opposé

Pour trade BAISSIER :
• Prix grab liquidité au-dessus high
• Retour rapide créant bearish FVG
• Entrée au retest FVG/OB
• SL au-dessus du high du grab
• Target : Prochain low ou FVG opposé

✅ Confirmations Additionnelles
• FVG dans un OB
• CHoCH créé
• Volume augmente
• Bougie de reversal impulsive
• Direction = tendance H4/D1

❌ Ne PAS Trader Si
• News importantes (NFP, CPI, FOMC)
• Aucun FVG formé
• Mouvement lent
• Range (pas de tendance)
• Vendredi après-midi

💰 Gestion du Trade
1. Scalp : 1:2 ou 1:3, sortie rapide
2. Swing : Runner jusqu'au prochain OB/FVG majeur (1:5 à 1:10)
3. Hybride : 50% à 1:2, 50% runner avec trailing

💎 Statistiques Silver Bullet
• Win rate : 60-70% (si bien exécuté)
• RR moyen : 1:3 à 1:5
• Fréquence : 2-4 setups/semaine par paire

🎯 Prochaines Étapes : Backtestez 50+ trades avant d'utiliser en réel !""",
                "difficulty": "advanced",
                "category": "general",
                "order": 9,
                "xp_reward": 250
            }
        ]
        await db.lessons.insert_many(sample_lessons)
        
        # Create quizzes for lessons
        sample_quizzes = [
            {
                "id": str(uuid.uuid4()),
                "lesson_id": sample_lessons[0]["id"],
                "question": "Qu'est-ce que le trading ?",
                "options": [
                    "L'achat et la vente d'actifs financiers",
                    "Un jeu vidéo",
                    "Une application mobile",
                    "Un réseau social"
                ],
                "correct_answer": 0,
                "explanation": "Le trading est l'achat et la vente d'actifs financiers pour réaliser des profits.",
                "xp_reward": 25
            },
            {
                "id": str(uuid.uuid4()),
                "lesson_id": sample_lessons[1]["id"],
                "question": "Quelle a été la première cryptomonnaie créée ?",
                "options": [
                    "Ethereum",
                    "Bitcoin",
                    "Ripple",
                    "Litecoin"
                ],
                "correct_answer": 1,
                "explanation": "Bitcoin a été créé en 2009 et est la première cryptomonnaie au monde.",
                "xp_reward": 25
            }
        ]
        await db.quizzes.insert_many(sample_quizzes)
    
    # Create daily challenge
    today = datetime.utcnow().strftime("%Y-%m-%d")
    challenge_exists = await db.challenges.find_one({"date": today})
    if not challenge_exists:
        daily_challenge = {
            "id": str(uuid.uuid4()),
            "title": "Défi Quotidien : Première Transaction",
            "description": "Effectuez votre première transaction du jour",
            "challenge_type": "daily_trade",
            "target_value": 1.0,
            "xp_reward": 100,
            "date": today
        }
        await db.challenges.insert_one(daily_challenge)

@app.on_event("startup")
async def startup_event():
    await initialize_data()

# Routes
@api_router.post("/auth/login", response_model=User)
async def login(user_data: UserCreate):
    """Login or create user"""
    existing_user = await db.users.find_one({"email": user_data.email})
    
    if existing_user:
        return User(**existing_user)
    
    # Create new user
    new_user = User(**user_data.dict())
    await db.users.insert_one(new_user.dict())
    
    # Initialize user progress
    progress = UserProgress(user_id=new_user.id)
    await db.user_progress.insert_one(progress.dict())
    
    return new_user

@api_router.get("/users/{user_id}", response_model=User)
async def get_user(user_id: str):
    user = await db.users.find_one({"id": user_id})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return User(**user)

@api_router.get("/market/crypto")
async def get_crypto_prices():
    """Get cryptocurrency prices from CoinGecko"""
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get(
                "https://api.coingecko.com/api/v3/simple/price",
                params={
                    "ids": "bitcoin,ethereum,cardano,solana,polkadot,dogecoin,ripple,litecoin",
                    "vs_currencies": "usd",
                    "include_24hr_change": "true"
                },
                timeout=10.0
            )
            data = response.json()
            
            # Format the data
            formatted_data = []
            symbol_mapping = {
                "bitcoin": "BTC",
                "ethereum": "ETH",
                "cardano": "ADA",
                "solana": "SOL",
                "polkadot": "DOT",
                "dogecoin": "DOGE",
                "ripple": "XRP",
                "litecoin": "LTC"
            }
            
            for coin_id, coin_data in data.items():
                formatted_data.append({
                    "symbol": symbol_mapping.get(coin_id, coin_id.upper()),
                    "name": coin_id.capitalize(),
                    "price": coin_data.get("usd", 0),
                    "change_24h": coin_data.get("usd_24h_change", 0),
                    "type": "crypto"
                })
            
            return {"data": formatted_data}
    except Exception as e:
        logging.error(f"Error fetching crypto prices: {str(e)}")
        return {"data": []}

@api_router.get("/market/news")
async def get_economic_news():
    """Get economic news"""
    # Using sample news for now (NewsAPI would require API key)
    sample_news = [
        {
            "id": "1",
            "title": "Bitcoin atteint un nouveau sommet historique",
            "source": "Crypto Daily",
            "timestamp": datetime.utcnow().isoformat()
        },
        {
            "id": "2",
            "title": "Les marchés européens en hausse après annonce de la BCE",
            "source": "Financial Times",
            "timestamp": datetime.utcnow().isoformat()
        },
        {
            "id": "3",
            "title": "Ethereum lance une mise à jour majeure",
            "source": "Blockchain News",
            "timestamp": datetime.utcnow().isoformat()
        },
        {
            "id": "4",
            "title": "Les actions tech en forte progression cette semaine",
            "source": "Market Watch",
            "timestamp": datetime.utcnow().isoformat()
        },
        {
            "id": "5",
            "title": "Le dollar américain se stabilise face à l'euro",
            "source": "Forex Live",
            "timestamp": datetime.utcnow().isoformat()
        }
    ]
    return {"news": sample_news}

@api_router.post("/trading/execute")
async def execute_trade(trade: TradeRequest):
    """Execute a buy or sell trade"""
    user = await db.users.find_one({"id": trade.user_id})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    total_cost = trade.quantity * trade.price
    
    if trade.transaction_type == "buy":
        # Check if user has enough balance
        if user["virtual_balance"] < total_cost:
            raise HTTPException(status_code=400, detail="Insufficient balance")
        
        # Update user balance
        new_balance = user["virtual_balance"] - total_cost
        await db.users.update_one(
            {"id": trade.user_id},
            {"$set": {"virtual_balance": new_balance}}
        )
        
        # Check if position already exists
        existing_position = await db.positions.find_one({
            "user_id": trade.user_id,
            "symbol": trade.symbol
        })
        
        if existing_position:
            # Update existing position
            new_quantity = existing_position["quantity"] + trade.quantity
            avg_price = ((existing_position["quantity"] * existing_position["buy_price"]) + total_cost) / new_quantity
            await db.positions.update_one(
                {"id": existing_position["id"]},
                {"$set": {
                    "quantity": new_quantity,
                    "buy_price": avg_price
                }}
            )
        else:
            # Create new position
            position = Position(
                user_id=trade.user_id,
                symbol=trade.symbol,
                asset_type=trade.asset_type,
                quantity=trade.quantity,
                buy_price=trade.price
            )
            await db.positions.insert_one(position.dict())
    
    elif trade.transaction_type == "sell":
        # Find position
        position = await db.positions.find_one({
            "user_id": trade.user_id,
            "symbol": trade.symbol
        })
        
        if not position or position["quantity"] < trade.quantity:
            raise HTTPException(status_code=400, detail="Insufficient position")
        
        # Calculate profit
        profit = (trade.price - position["buy_price"]) * trade.quantity
        
        # Update user balance and profit
        new_balance = user["virtual_balance"] + total_cost
        new_total_profit = user.get("total_profit", 0) + profit
        await db.users.update_one(
            {"id": trade.user_id},
            {"$set": {
                "virtual_balance": new_balance,
                "total_profit": new_total_profit
            }}
        )
        
        # Update or remove position
        new_quantity = position["quantity"] - trade.quantity
        if new_quantity <= 0:
            await db.positions.delete_one({"id": position["id"]})
        else:
            await db.positions.update_one(
                {"id": position["id"]},
                {"$set": {"quantity": new_quantity}}
            )
    
    # Create transaction record
    transaction = Transaction(
        user_id=trade.user_id,
        symbol=trade.symbol,
        asset_type=trade.asset_type,
        transaction_type=trade.transaction_type,
        quantity=trade.quantity,
        price=trade.price,
        total=total_cost
    )
    await db.transactions.insert_one(transaction.dict())
    
    # Award XP for trading
    await db.users.update_one(
        {"id": trade.user_id},
        {"$inc": {"xp": 10}}
    )
    
    return {"success": True, "message": "Trade executed successfully"}

@api_router.get("/portfolio/{user_id}")
async def get_portfolio(user_id: str):
    """Get user's portfolio"""
    positions = await db.positions.find({"user_id": user_id}).to_list(100)
    # Remove MongoDB _id field
    for position in positions:
        if "_id" in position:
            del position["_id"]
    return {"positions": positions}

@api_router.get("/transactions/{user_id}")
async def get_transactions(user_id: str):
    """Get user's transaction history"""
    transactions = await db.transactions.find({"user_id": user_id}).sort("timestamp", -1).to_list(100)
    # Remove MongoDB _id field
    for transaction in transactions:
        if "_id" in transaction:
            del transaction["_id"]
    return {"transactions": transactions}

@api_router.get("/lessons")
async def get_lessons():
    """Get all lessons"""
    lessons = await db.lessons.find().sort("order", 1).to_list(100)
    # Remove MongoDB _id field
    for lesson in lessons:
        if "_id" in lesson:
            del lesson["_id"]
    return {"lessons": lessons}

@api_router.get("/lessons/{lesson_id}")
async def get_lesson(lesson_id: str):
    """Get lesson details"""
    lesson = await db.lessons.find_one({"id": lesson_id})
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")
    # Remove MongoDB _id field
    if "_id" in lesson:
        del lesson["_id"]
    return lesson

@api_router.post("/lessons/{lesson_id}/complete")
async def complete_lesson(lesson_id: str, user_id: str):
    """Mark lesson as completed"""
    lesson = await db.lessons.find_one({"id": lesson_id})
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")
    
    # Update user progress
    progress = await db.user_progress.find_one({"user_id": user_id})
    if not progress:
        progress = UserProgress(user_id=user_id)
        await db.user_progress.insert_one(progress.dict())
    
    if lesson_id not in progress.get("completed_lessons", []):
        await db.user_progress.update_one(
            {"user_id": user_id},
            {"$push": {"completed_lessons": lesson_id}}
        )
        
        # Award XP
        await db.users.update_one(
            {"id": user_id},
            {"$inc": {"xp": lesson["xp_reward"]}}
        )
    
    return {"success": True, "xp_earned": lesson["xp_reward"]}

@api_router.get("/quizzes/{lesson_id}")
async def get_lesson_quizzes(lesson_id: str):
    """Get quizzes for a lesson"""
    quizzes = await db.quizzes.find({"lesson_id": lesson_id}).to_list(100)
    # Remove MongoDB _id field
    for quiz in quizzes:
        if "_id" in quiz:
            del quiz["_id"]
    return {"quizzes": quizzes}

@api_router.post("/quizzes/submit")
async def submit_quiz(submission: QuizSubmit):
    """Submit quiz answer"""
    quiz = await db.quizzes.find_one({"id": submission.quiz_id})
    if not quiz:
        raise HTTPException(status_code=404, detail="Quiz not found")
    
    is_correct = submission.answer == quiz["correct_answer"]
    
    if is_correct:
        # Check if already completed
        progress = await db.user_progress.find_one({"user_id": submission.user_id})
        if progress and submission.quiz_id not in progress.get("completed_quizzes", []):
            await db.user_progress.update_one(
                {"user_id": submission.user_id},
                {"$push": {"completed_quizzes": submission.quiz_id}}
            )
            
            # Award XP
            await db.users.update_one(
                {"id": submission.user_id},
                {"$inc": {"xp": quiz["xp_reward"]}}
            )
    
    return {
        "correct": is_correct,
        "explanation": quiz["explanation"],
        "xp_earned": quiz["xp_reward"] if is_correct else 0
    }

@api_router.get("/challenges/daily")
async def get_daily_challenges():
    """Get today's challenges"""
    today = datetime.utcnow().strftime("%Y-%m-%d")
    challenges = await db.challenges.find({"date": today}).to_list(100)
    # Remove MongoDB _id field
    for challenge in challenges:
        if "_id" in challenge:
            del challenge["_id"]
    return {"challenges": challenges}

@api_router.get("/leaderboard")
async def get_leaderboard():
    """Get top users by total profit"""
    users = await db.users.find().sort("total_profit", -1).limit(50).to_list(50)
    leaderboard = []
    for idx, user in enumerate(users):
        leaderboard.append({
            "rank": idx + 1,
            "name": user["name"],
            "avatar": user.get("avatar"),
            "level": user["level"],
            "total_profit": user.get("total_profit", 0),
            "xp": user["xp"]
        })
    return {"leaderboard": leaderboard}

@api_router.post("/ai/assistant")
async def ai_assistant(request: AIAssistantRequest):
    """AI Trading Assistant"""
    try:
        emergent_key = os.getenv("EMERGENT_LLM_KEY")
        
        system_message = """Tu es un assistant de trading expert et pédagogue. 
        Ton rôle est d'aider les débutants à comprendre le trading de manière simple et ludique.
        Explique les concepts avec des exemples concrets et reste toujours encourageant.
        Réponds en français de manière claire et concise."""
        
        chat = LlmChat(
            api_key=emergent_key,
            session_id=f"user_{request.user_id}",
            system_message=system_message
        ).with_model("openai", "gpt-4o-mini")
        
        context_prefix = f"Contexte: {request.context}\n\n" if request.context else ""
        user_message = UserMessage(text=context_prefix + request.message)
        
        response = await chat.send_message(user_message)
        
        return {"response": response}
    except Exception as e:
        logging.error(f"AI Assistant error: {str(e)}")
        return {"response": "Désolé, je rencontre un problème technique. Réessayez plus tard."}

@api_router.get("/progress/{user_id}")
async def get_user_progress(user_id: str):
    """Get user progress"""
    progress = await db.user_progress.find_one({"user_id": user_id})
    if not progress:
        progress = UserProgress(user_id=user_id)
        await db.user_progress.insert_one(progress.dict())
        progress = progress.dict()
    else:
        # Remove MongoDB _id field
        if "_id" in progress:
            del progress["_id"]
    return progress

# Include router
app.include_router(api_router)

app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

@app.on_event("shutdown")
async def shutdown_db_client():
    client.close()
