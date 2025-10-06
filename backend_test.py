#!/usr/bin/env python3
"""
Backend API Tests for TradePlay Application
Tests all backend endpoints with valid and invalid cases
"""

import asyncio
import httpx
import json
import uuid
from datetime import datetime
from typing import Dict, Any, Optional

# Backend URL from frontend environment
BACKEND_URL = "https://trade-play-app.preview.emergentagent.com/api"

class TradePlayAPITester:
    def __init__(self):
        self.client = httpx.AsyncClient(timeout=30.0)
        self.test_user_id = None
        self.test_lesson_id = None
        self.test_quiz_id = None
        self.results = {
            "authentication": [],
            "market_data": [],
            "trading": [],
            "learning": [],
            "challenges_leaderboard": [],
            "ai_assistant": [],
            "progress": []
        }
    
    async def log_test(self, category: str, test_name: str, success: bool, details: str, response_data: Any = None):
        """Log test results"""
        result = {
            "test": test_name,
            "success": success,
            "details": details,
            "timestamp": datetime.utcnow().isoformat()
        }
        if response_data:
            result["response_data"] = response_data
        
        self.results[category].append(result)
        status = "✅ PASS" if success else "❌ FAIL"
        print(f"{status} {test_name}: {details}")
    
    async def test_authentication(self):
        """Test authentication endpoints"""
        print("\n=== TESTING AUTHENTICATION ===")
        
        # Test 1: Create new user (POST /api/auth/login)
        try:
            user_data = {
                "email": f"trader_{uuid.uuid4().hex[:8]}@tradeplay.com",
                "name": "Jean Dupont",
                "avatar": "https://example.com/avatar.jpg"
            }
            
            response = await self.client.post(f"{BACKEND_URL}/auth/login", json=user_data)
            
            if response.status_code == 200:
                user = response.json()
                self.test_user_id = user.get("id")
                await self.log_test("authentication", "Create New User", True, 
                                  f"User created successfully with ID: {self.test_user_id}", user)
            else:
                await self.log_test("authentication", "Create New User", False, 
                                  f"Failed with status {response.status_code}: {response.text}")
        except Exception as e:
            await self.log_test("authentication", "Create New User", False, f"Exception: {str(e)}")
        
        # Test 2: Login existing user
        if self.test_user_id:
            try:
                response = await self.client.post(f"{BACKEND_URL}/auth/login", json=user_data)
                
                if response.status_code == 200:
                    user = response.json()
                    if user.get("id") == self.test_user_id:
                        await self.log_test("authentication", "Login Existing User", True, 
                                          "Existing user login successful")
                    else:
                        await self.log_test("authentication", "Login Existing User", False, 
                                          "User ID mismatch on existing user login")
                else:
                    await self.log_test("authentication", "Login Existing User", False, 
                                      f"Failed with status {response.status_code}")
            except Exception as e:
                await self.log_test("authentication", "Login Existing User", False, f"Exception: {str(e)}")
        
        # Test 3: Get user info (GET /api/users/{user_id})
        if self.test_user_id:
            try:
                response = await self.client.get(f"{BACKEND_URL}/users/{self.test_user_id}")
                
                if response.status_code == 200:
                    user = response.json()
                    await self.log_test("authentication", "Get User Info", True, 
                                      f"User info retrieved: {user.get('name')}", user)
                else:
                    await self.log_test("authentication", "Get User Info", False, 
                                      f"Failed with status {response.status_code}")
            except Exception as e:
                await self.log_test("authentication", "Get User Info", False, f"Exception: {str(e)}")
        
        # Test 4: Get non-existent user (invalid case)
        try:
            fake_user_id = str(uuid.uuid4())
            response = await self.client.get(f"{BACKEND_URL}/users/{fake_user_id}")
            
            if response.status_code == 404:
                await self.log_test("authentication", "Get Non-existent User", True, 
                                  "Correctly returned 404 for non-existent user")
            else:
                await self.log_test("authentication", "Get Non-existent User", False, 
                                  f"Expected 404, got {response.status_code}")
        except Exception as e:
            await self.log_test("authentication", "Get Non-existent User", False, f"Exception: {str(e)}")
    
    async def test_market_data(self):
        """Test market data endpoints"""
        print("\n=== TESTING MARKET DATA ===")
        
        # Test 1: Get crypto prices (GET /api/market/crypto)
        try:
            response = await self.client.get(f"{BACKEND_URL}/market/crypto")
            
            if response.status_code == 200:
                data = response.json()
                crypto_data = data.get("data", [])
                if crypto_data and len(crypto_data) > 0:
                    await self.log_test("market_data", "Get Crypto Prices", True, 
                                      f"Retrieved {len(crypto_data)} crypto prices", crypto_data[:2])
                else:
                    await self.log_test("market_data", "Get Crypto Prices", False, 
                                      "No crypto data returned")
            else:
                await self.log_test("market_data", "Get Crypto Prices", False, 
                                  f"Failed with status {response.status_code}")
        except Exception as e:
            await self.log_test("market_data", "Get Crypto Prices", False, f"Exception: {str(e)}")
        
        # Test 2: Get economic news (GET /api/market/news)
        try:
            response = await self.client.get(f"{BACKEND_URL}/market/news")
            
            if response.status_code == 200:
                data = response.json()
                news = data.get("news", [])
                if news and len(news) > 0:
                    await self.log_test("market_data", "Get Economic News", True, 
                                      f"Retrieved {len(news)} news articles", news[:2])
                else:
                    await self.log_test("market_data", "Get Economic News", False, 
                                      "No news data returned")
            else:
                await self.log_test("market_data", "Get Economic News", False, 
                                  f"Failed with status {response.status_code}")
        except Exception as e:
            await self.log_test("market_data", "Get Economic News", False, f"Exception: {str(e)}")
    
    async def test_trading(self):
        """Test trading endpoints"""
        print("\n=== TESTING TRADING ===")
        
        if not self.test_user_id:
            await self.log_test("trading", "Trading Tests", False, "No test user available")
            return
        
        # Test 1: Buy crypto (POST /api/trading/execute)
        try:
            trade_data = {
                "user_id": self.test_user_id,
                "symbol": "BTC",
                "asset_type": "crypto",
                "transaction_type": "buy",
                "quantity": 0.1,
                "price": 45000.0
            }
            
            response = await self.client.post(f"{BACKEND_URL}/trading/execute", json=trade_data)
            
            if response.status_code == 200:
                result = response.json()
                if result.get("success"):
                    await self.log_test("trading", "Buy Crypto", True, 
                                      "Crypto purchase executed successfully", result)
                else:
                    await self.log_test("trading", "Buy Crypto", False, 
                                      "Trade execution returned success=false")
            else:
                await self.log_test("trading", "Buy Crypto", False, 
                                  f"Failed with status {response.status_code}: {response.text}")
        except Exception as e:
            await self.log_test("trading", "Buy Crypto", False, f"Exception: {str(e)}")
        
        # Test 2: Get portfolio (GET /api/portfolio/{user_id})
        try:
            response = await self.client.get(f"{BACKEND_URL}/portfolio/{self.test_user_id}")
            
            if response.status_code == 200:
                data = response.json()
                positions = data.get("positions", [])
                await self.log_test("trading", "Get Portfolio", True, 
                                  f"Portfolio retrieved with {len(positions)} positions", positions)
            else:
                await self.log_test("trading", "Get Portfolio", False, 
                                  f"Failed with status {response.status_code}")
        except Exception as e:
            await self.log_test("trading", "Get Portfolio", False, f"Exception: {str(e)}")
        
        # Test 3: Sell crypto (POST /api/trading/execute)
        try:
            sell_data = {
                "user_id": self.test_user_id,
                "symbol": "BTC",
                "asset_type": "crypto",
                "transaction_type": "sell",
                "quantity": 0.05,
                "price": 46000.0
            }
            
            response = await self.client.post(f"{BACKEND_URL}/trading/execute", json=sell_data)
            
            if response.status_code == 200:
                result = response.json()
                if result.get("success"):
                    await self.log_test("trading", "Sell Crypto", True, 
                                      "Crypto sale executed successfully", result)
                else:
                    await self.log_test("trading", "Sell Crypto", False, 
                                      "Sell execution returned success=false")
            else:
                await self.log_test("trading", "Sell Crypto", False, 
                                  f"Failed with status {response.status_code}: {response.text}")
        except Exception as e:
            await self.log_test("trading", "Sell Crypto", False, f"Exception: {str(e)}")
        
        # Test 4: Get transaction history (GET /api/transactions/{user_id})
        try:
            response = await self.client.get(f"{BACKEND_URL}/transactions/{self.test_user_id}")
            
            if response.status_code == 200:
                data = response.json()
                transactions = data.get("transactions", [])
                await self.log_test("trading", "Get Transaction History", True, 
                                  f"Retrieved {len(transactions)} transactions", transactions)
            else:
                await self.log_test("trading", "Get Transaction History", False, 
                                  f"Failed with status {response.status_code}")
        except Exception as e:
            await self.log_test("trading", "Get Transaction History", False, f"Exception: {str(e)}")
        
        # Test 5: Invalid trade - insufficient balance
        try:
            invalid_trade = {
                "user_id": self.test_user_id,
                "symbol": "ETH",
                "asset_type": "crypto",
                "transaction_type": "buy",
                "quantity": 1000,  # Very large quantity
                "price": 50000.0
            }
            
            response = await self.client.post(f"{BACKEND_URL}/trading/execute", json=invalid_trade)
            
            if response.status_code == 400:
                await self.log_test("trading", "Invalid Trade - Insufficient Balance", True, 
                                  "Correctly rejected trade with insufficient balance")
            else:
                await self.log_test("trading", "Invalid Trade - Insufficient Balance", False, 
                                  f"Expected 400, got {response.status_code}")
        except Exception as e:
            await self.log_test("trading", "Invalid Trade - Insufficient Balance", False, f"Exception: {str(e)}")
    
    async def test_learning(self):
        """Test learning endpoints"""
        print("\n=== TESTING LEARNING ===")
        
        # Test 1: Get all lessons (GET /api/lessons)
        try:
            response = await self.client.get(f"{BACKEND_URL}/lessons")
            
            if response.status_code == 200:
                data = response.json()
                lessons = data.get("lessons", [])
                if lessons and len(lessons) > 0:
                    self.test_lesson_id = lessons[0].get("id")
                    await self.log_test("learning", "Get All Lessons", True, 
                                      f"Retrieved {len(lessons)} lessons", lessons[:2])
                else:
                    await self.log_test("learning", "Get All Lessons", False, 
                                      "No lessons returned")
            else:
                await self.log_test("learning", "Get All Lessons", False, 
                                  f"Failed with status {response.status_code}")
        except Exception as e:
            await self.log_test("learning", "Get All Lessons", False, f"Exception: {str(e)}")
        
        # Test 2: Get lesson details (GET /api/lessons/{lesson_id})
        if self.test_lesson_id:
            try:
                response = await self.client.get(f"{BACKEND_URL}/lessons/{self.test_lesson_id}")
                
                if response.status_code == 200:
                    lesson = response.json()
                    await self.log_test("learning", "Get Lesson Details", True, 
                                      f"Retrieved lesson: {lesson.get('title')}", lesson)
                else:
                    await self.log_test("learning", "Get Lesson Details", False, 
                                      f"Failed with status {response.status_code}")
            except Exception as e:
                await self.log_test("learning", "Get Lesson Details", False, f"Exception: {str(e)}")
        
        # Test 3: Complete lesson (POST /api/lessons/{lesson_id}/complete)
        if self.test_lesson_id and self.test_user_id:
            try:
                response = await self.client.post(
                    f"{BACKEND_URL}/lessons/{self.test_lesson_id}/complete",
                    params={"user_id": self.test_user_id}
                )
                
                if response.status_code == 200:
                    result = response.json()
                    if result.get("success"):
                        await self.log_test("learning", "Complete Lesson", True, 
                                          f"Lesson completed, XP earned: {result.get('xp_earned')}", result)
                    else:
                        await self.log_test("learning", "Complete Lesson", False, 
                                          "Lesson completion returned success=false")
                else:
                    await self.log_test("learning", "Complete Lesson", False, 
                                      f"Failed with status {response.status_code}: {response.text}")
            except Exception as e:
                await self.log_test("learning", "Complete Lesson", False, f"Exception: {str(e)}")
        
        # Test 4: Get lesson quizzes (GET /api/quizzes/{lesson_id})
        if self.test_lesson_id:
            try:
                response = await self.client.get(f"{BACKEND_URL}/quizzes/{self.test_lesson_id}")
                
                if response.status_code == 200:
                    data = response.json()
                    quizzes = data.get("quizzes", [])
                    if quizzes and len(quizzes) > 0:
                        self.test_quiz_id = quizzes[0].get("id")
                        await self.log_test("learning", "Get Lesson Quizzes", True, 
                                          f"Retrieved {len(quizzes)} quizzes", quizzes)
                    else:
                        await self.log_test("learning", "Get Lesson Quizzes", True, 
                                          "No quizzes found for this lesson")
                else:
                    await self.log_test("learning", "Get Lesson Quizzes", False, 
                                      f"Failed with status {response.status_code}")
            except Exception as e:
                await self.log_test("learning", "Get Lesson Quizzes", False, f"Exception: {str(e)}")
        
        # Test 5: Submit quiz answer (POST /api/quizzes/submit)
        if self.test_quiz_id and self.test_user_id:
            try:
                quiz_submission = {
                    "user_id": self.test_user_id,
                    "quiz_id": self.test_quiz_id,
                    "answer": 0  # First option
                }
                
                response = await self.client.post(f"{BACKEND_URL}/quizzes/submit", json=quiz_submission)
                
                if response.status_code == 200:
                    result = response.json()
                    await self.log_test("learning", "Submit Quiz Answer", True, 
                                      f"Quiz submitted, correct: {result.get('correct')}, XP: {result.get('xp_earned')}", result)
                else:
                    await self.log_test("learning", "Submit Quiz Answer", False, 
                                      f"Failed with status {response.status_code}")
            except Exception as e:
                await self.log_test("learning", "Submit Quiz Answer", False, f"Exception: {str(e)}")
    
    async def test_challenges_leaderboard(self):
        """Test challenges and leaderboard endpoints"""
        print("\n=== TESTING CHALLENGES & LEADERBOARD ===")
        
        # Test 1: Get daily challenges (GET /api/challenges/daily)
        try:
            response = await self.client.get(f"{BACKEND_URL}/challenges/daily")
            
            if response.status_code == 200:
                data = response.json()
                challenges = data.get("challenges", [])
                await self.log_test("challenges_leaderboard", "Get Daily Challenges", True, 
                                  f"Retrieved {len(challenges)} daily challenges", challenges)
            else:
                await self.log_test("challenges_leaderboard", "Get Daily Challenges", False, 
                                  f"Failed with status {response.status_code}")
        except Exception as e:
            await self.log_test("challenges_leaderboard", "Get Daily Challenges", False, f"Exception: {str(e)}")
        
        # Test 2: Get leaderboard (GET /api/leaderboard)
        try:
            response = await self.client.get(f"{BACKEND_URL}/leaderboard")
            
            if response.status_code == 200:
                data = response.json()
                leaderboard = data.get("leaderboard", [])
                await self.log_test("challenges_leaderboard", "Get Leaderboard", True, 
                                  f"Retrieved leaderboard with {len(leaderboard)} users", leaderboard[:3])
            else:
                await self.log_test("challenges_leaderboard", "Get Leaderboard", False, 
                                  f"Failed with status {response.status_code}")
        except Exception as e:
            await self.log_test("challenges_leaderboard", "Get Leaderboard", False, f"Exception: {str(e)}")
    
    async def test_ai_assistant(self):
        """Test AI assistant endpoint"""
        print("\n=== TESTING AI ASSISTANT ===")
        
        if not self.test_user_id:
            await self.log_test("ai_assistant", "AI Assistant Test", False, "No test user available")
            return
        
        # Test 1: Ask AI assistant (POST /api/ai/assistant)
        try:
            ai_request = {
                "user_id": self.test_user_id,
                "message": "Qu'est-ce que le Bitcoin et comment fonctionne-t-il ?",
                "context": "Débutant en trading"
            }
            
            response = await self.client.post(f"{BACKEND_URL}/ai/assistant", json=ai_request)
            
            if response.status_code == 200:
                result = response.json()
                ai_response = result.get("response", "")
                if ai_response and len(ai_response) > 10:
                    await self.log_test("ai_assistant", "AI Assistant Query", True, 
                                      f"AI responded with {len(ai_response)} characters", {"response_preview": ai_response[:100]})
                else:
                    await self.log_test("ai_assistant", "AI Assistant Query", False, 
                                      "AI response too short or empty")
            else:
                await self.log_test("ai_assistant", "AI Assistant Query", False, 
                                  f"Failed with status {response.status_code}")
        except Exception as e:
            await self.log_test("ai_assistant", "AI Assistant Query", False, f"Exception: {str(e)}")
    
    async def test_progress(self):
        """Test progress endpoint"""
        print("\n=== TESTING PROGRESS ===")
        
        if not self.test_user_id:
            await self.log_test("progress", "User Progress Test", False, "No test user available")
            return
        
        # Test 1: Get user progress (GET /api/progress/{user_id})
        try:
            response = await self.client.get(f"{BACKEND_URL}/progress/{self.test_user_id}")
            
            if response.status_code == 200:
                progress = response.json()
                await self.log_test("progress", "Get User Progress", True, 
                                  f"Progress retrieved for user", progress)
            else:
                await self.log_test("progress", "Get User Progress", False, 
                                  f"Failed with status {response.status_code}")
        except Exception as e:
            await self.log_test("progress", "Get User Progress", False, f"Exception: {str(e)}")
    
    async def run_all_tests(self):
        """Run all API tests"""
        print("🚀 Starting TradePlay Backend API Tests")
        print(f"Testing against: {BACKEND_URL}")
        
        try:
            await self.test_authentication()
            await self.test_market_data()
            await self.test_trading()
            await self.test_learning()
            await self.test_challenges_leaderboard()
            await self.test_ai_assistant()
            await self.test_progress()
            
            # Print summary
            print("\n" + "="*60)
            print("TEST SUMMARY")
            print("="*60)
            
            total_tests = 0
            passed_tests = 0
            
            for category, tests in self.results.items():
                category_passed = sum(1 for test in tests if test["success"])
                category_total = len(tests)
                total_tests += category_total
                passed_tests += category_passed
                
                print(f"{category.upper()}: {category_passed}/{category_total} passed")
                
                # Show failed tests
                failed_tests = [test for test in tests if not test["success"]]
                for failed_test in failed_tests:
                    print(f"  ❌ {failed_test['test']}: {failed_test['details']}")
            
            print(f"\nOVERALL: {passed_tests}/{total_tests} tests passed ({passed_tests/total_tests*100:.1f}%)")
            
            return self.results
            
        except Exception as e:
            print(f"Critical error during testing: {str(e)}")
            return None
        finally:
            await self.client.aclose()

async def main():
    """Main test runner"""
    tester = TradePlayAPITester()
    results = await tester.run_all_tests()
    
    # Save results to file
    if results:
        with open("/app/test_results_detailed.json", "w") as f:
            json.dump(results, f, indent=2, default=str)
        print(f"\nDetailed results saved to /app/test_results_detailed.json")

if __name__ == "__main__":
    asyncio.run(main())