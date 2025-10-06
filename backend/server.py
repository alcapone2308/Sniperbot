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
                "description": "Apprenez les bases du trading et les concepts fondamentaux",
                "content": "Le trading est l'achat et la vente d'actifs financiers dans le but de réaliser un profit. Les actifs peuvent inclure des actions, des cryptomonnaies, des devises (forex) et plus encore.",
                "difficulty": "beginner",
                "category": "general",
                "order": 1,
                "xp_reward": 50
            },
            {
                "id": str(uuid.uuid4()),
                "title": "Comprendre les Cryptomonnaies",
                "description": "Découvrez le monde des cryptomonnaies et de la blockchain",
                "content": "Les cryptomonnaies sont des monnaies numériques décentralisées basées sur la technologie blockchain. Bitcoin a été la première cryptomonnaie créée en 2009.",
                "difficulty": "beginner",
                "category": "crypto",
                "order": 2,
                "xp_reward": 50
            },
            {
                "id": str(uuid.uuid4()),
                "title": "Analyse Technique de Base",
                "description": "Apprenez à lire les graphiques et identifier les tendances",
                "content": "L'analyse technique utilise les données historiques des prix pour prédire les mouvements futurs. Les concepts clés incluent les supports, résistances, et tendances.",
                "difficulty": "intermediate",
                "category": "general",
                "order": 3,
                "xp_reward": 75
            },
            {
                "id": str(uuid.uuid4()),
                "title": "Gestion des Risques",
                "description": "Protégez votre capital avec des stratégies de gestion des risques",
                "content": "La gestion des risques est cruciale en trading. Ne risquez jamais plus de 1-2% de votre capital sur une seule transaction. Utilisez des stop-loss pour limiter les pertes.",
                "difficulty": "intermediate",
                "category": "general",
                "order": 4,
                "xp_reward": 75
            },
            {
                "id": str(uuid.uuid4()),
                "title": "Le Marché Forex",
                "description": "Découvrez le trading de devises sur le marché forex",
                "content": "Le Forex (Foreign Exchange) est le marché des devises. C'est le plus grand marché financier au monde avec plus de 6 trillions de dollars échangés quotidiennement.",
                "difficulty": "beginner",
                "category": "forex",
                "order": 5,
                "xp_reward": 50
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
