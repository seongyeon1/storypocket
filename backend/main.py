#main.py
from pydantic import BaseModel
from langchain.schema import HumanMessage, AIMessage 
from dotenv import load_dotenv

from fastapi.responses import StreamingResponse
from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware

from typing import List, Optional
from io import BytesIO
from zipfile import ZipFile

# 추가적인 모듈 가져오기
from chat import *
from story import *
from img import *

import os

# 이미지 저장 경로
IMAGE_STORAGE_PATH = "../static/"

## MONGODB에서 가능하도록 변경
from pymongo import MongoClient
from fastapi import FastAPI, HTTPException
from typing import List

from datetime import datetime

# MongoDB 연결 설정
connection_string = "mongodb+srv://seongyeon:seongyeon01@storypocket.u47cz.mongodb.net/?retryWrites=true&w=majority&appName=StoryPocket"
client = MongoClient(connection_string)

# 데이터베이스 및 컬렉션
db = client["StoryPocket"]
stories_collection = db["stories"]  # Stories 컬렉션

# 환경 변수 로드
load_dotenv()

app = FastAPI()

# CORS 설정 추가
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 모든 출처 허용
    allow_credentials=True,
    allow_methods=["*"],  # 모든 HTTP 메서드 허용
    allow_headers=["*"],  # 모든 헤더 허용
)

# 요청 모델 정의
class ChatRequest(BaseModel):
    sex: str
    message: str
    session_id: str

class StoryCutResponse(BaseModel):
    page: int
    text: str
    description: str
    image_prompt: str


class StoryResponse(BaseModel):
    session_id: str
    user_id: str
    title: str
    author: str
    story_text: Optional[str]
    recommendations: int
    views: int
    daily_topic: bool
    created_at: datetime
    cuts: List[StoryCutResponse]

# import pyttsx3
import io
import base64

# API 엔드포인트 정의
# 대화 생성
@app.post("/chat/")
async def chat(request: ChatRequest):
    try:
        response = multi_turn_chat(request.sex, request.message, request.session_id)
        return {"response": response}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")

# @app.post("/chat/")
# async def chat(request: ChatRequest):
#     try:
#         # Generate chatbot response
#         response_text = multi_turn_chat(request.sex, request.message, request.session_id)
        
#         # Initialize pyttsx3 TTS engine
#         engine = pyttsx3.init()
        
#         # Set properties (optional)
#         engine.setProperty('rate', 150)    # Speed percent (can go over 100)
#         engine.setProperty('volume', 0.9)  # Volume 0-1
        
#         # Generate speech
#         audio_buffer = io.BytesIO()
#         engine.save_to_file(response_text, audio_buffer)
#         engine.runAndWait()
        
#         # Get audio data
#         audio_buffer.seek(0)
#         audio_data = audio_buffer.read()
        
#         # Encode audio data to base64
#         audio_base64 = base64.b64encode(audio_data).decode('utf-8')
        
#         return {
#             "response": response_text,
#             "audio": audio_base64
#         }
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")


# # 대화 기록 조회
# @app.get("/history/{session_id}")
# async def get_chat_history(session_id: str):
#     if session_id not in store:
#         raise HTTPException(status_code=404, detail="Session ID not found")
    
#     chat_history = await store[session_id].aget_messages()
#     history = [
#         {
#             "role": "user" if isinstance(msg, HumanMessage) else "ai",
#             "content": msg.content
#         }
#         for msg in chat_history
#     ]
#     return {"session_id": session_id, "history": history}


@app.post("/generate-story/")
async def generate_story(session_id: str, user_id: str):
    # 기존 세션 확인 (스토어 내 세션 기반 처리)
    if session_id not in store:
        raise HTTPException(status_code=404, detail="Session ID not found")

    # 대화 기록 가져오기
    chat_history = await store[session_id].aget_messages()
    story_text = "\n".join([msg.content for msg in chat_history if isinstance(msg, (HumanMessage, AIMessage))])

    # 사용자 정보 가져오기
    user_data = db["users"].find_one({"_id": user_id})
    if not user_data:
        raise HTTPException(status_code=404, detail="User not found")

    # 이야기 제목 동적 생성
    title_suffix = "할아버지의 옛날 이야기" if user_data["gender"] == "male" else "할머니의 옛날 이야기"
    title = f"{user_data['name']} {title_suffix}"

    # 이야기 생성
    try:
        final_story = story_chain.invoke({"story": story_text})
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Story generation failed: {str(e)}")

    # MongoDB에 저장
    story_data = {
        "_id": session_id,
        "user_id": user_id,
        "title": title,
        "story_text": final_story,
        "recommendations": 0,
        "views": 0,
        "daily_topic": True,  # 구분: 오늘의 이야기로 설정
        "created_at": datetime.utcnow(),  # 생성일자
        "cuts": []  # 이후 이미지 생성 시 추가
    }
    try:
        stories_collection.insert_one(story_data)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database insertion failed: {str(e)}")

    return {"session_id": session_id, "story_text": final_story}

# @app.get("/api/stories", response_model=List[StoryResponse])
# async def get_all_stories():
#     try:
#         # MongoDB에서 모든 이야기를 가져옴
#         stories_cursor = stories_collection.find()
#         stories = []

#         for story in stories_cursor:
#             # MongoDB ObjectId를 문자열로 변환
#             story_data = {
#                 "session_id": str(story["_id"]),
#                 "user_id": story["user_id"],
#                 "title": story["title"],
#                 "story_text": story["story_text"],
#                 "recommendations": story["recommendations"],
#                 "views": story["views"],
#                 "daily_topic": story["daily_topic"],
#                 "created_at": story["created_at"],
#                 "cuts": [
#                     {
#                         "page": cut["page"],
#                         "text": cut["text"],
#                         "description": cut["description"],
#                         "image_prompt": cut["image_prompt"]
#                     }
#                     for cut in story["cuts"]
#                 ]
#             }
#             stories.append(story_data)

#         return stories
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Failed to fetch stories: {str(e)}")

@app.get("/api/stories", response_model=List[StoryResponse])
async def get_all_stories():
    try:
        # MongoDB에서 모든 이야기를 가져옴
        stories_cursor = stories_collection.find()
        stories = []

        for story in stories_cursor:
            # 사용자 데이터 가져오기
            user = db["users"].find_one({"_id": story["user_id"]})
            author_name = user["name"] if user else "Unknown Author"  # 사용자 이름

            # MongoDB ObjectId를 문자열로 변환하고 데이터 매핑
            story_data = {
                "session_id": str(story["_id"]),
                "user_id": story["user_id"],
                "title": story["title"],
                "author": author_name,  # Author 필드 추가
                "story_text": story["story_text"],
                "recommendations": story["recommendations"],
                "views": story["views"],
                "daily_topic": story["daily_topic"],
                "created_at": story["created_at"],
                "cuts": [
                    {
                        "page": cut["page"],
                        "text": cut["text"],
                        "description": cut["description"],
                        "image_prompt": cut["image_prompt"],
                    }
                    for cut in story["cuts"]
                ],
            }
            stories.append(story_data)

        return stories
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch stories: {str(e)}")


import os
from bson.objectid import ObjectId
from io import BytesIO
from PIL import Image

# 이미지 저장 경로
IMAGE_STORAGE_PATH = "../static/"

@app.post("/generate-images/{session_id}")
async def generate_images(session_id: str, user_id: str):
    # MongoDB에서 이야기 가져오기
    story = stories_collection.find_one({"_id": session_id, "user_id": user_id})
    if not story:
        raise HTTPException(status_code=404, detail="Story not found or unauthorized access")

    # 이미지 프롬프트 생성 및 이미지 생성
    try:
        descriptions = story_to_img_chain.invoke({"story": story["story_text"]}).split('\n\n')
        session_path = os.path.join(IMAGE_STORAGE_PATH, session_id)
        os.makedirs(session_path, exist_ok=True)  # 이미지 저장 경로 생성

        cuts = []  # 페이지별 데이터 저장
        for idx, description in enumerate(descriptions):
            prompt = description_to_prompt_chain.invoke({'description': description})
            img = generate_image(story=prompt)  # PIL 이미지 객체

            # 이미지 저장
            img_filename = f"{idx+1}.png"
            img_filepath = os.path.join(session_path, img_filename)
            img.save(img_filepath)

            # StoryCut 데이터 생성
            cuts.append({
                "page": idx + 1,  # 페이지 정보 (1, 2, 3...)
                "text": f"Page {idx + 1} content generated based on the story",
                "description": description, #한글 장면묘사
                "image_prompt": prompt, # 이미지 프롬프트
            })

        # MongoDB에 업데이트 (cuts 필드에 이미지 데이터 추가)
        stories_collection.update_one(
            {"_id": session_id},
            {"$set": {"cuts": cuts}}
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Image generation failed: {str(e)}")

    return {"session_id": session_id, "cuts": cuts}