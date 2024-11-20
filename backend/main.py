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
        return {"response": response.replace('손자','').replace(':','').strip()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {str(e)}")


# 대화 기록 조회
@app.get("/history/{session_id}")
async def get_chat_history(session_id: str):
    if session_id not in store:
        raise HTTPException(status_code=404, detail="Session ID not found")
    
    chat_history = await store[session_id].aget_messages()
    history = [
        {
            "role": "user" if isinstance(msg, HumanMessage) else "ai",
            "content": msg.content
        }
        for msg in chat_history
    ]
    return {"session_id": session_id, "history": history}

class GenerateStoryRequest(BaseModel):
    session_id: str
    user_id: str

@app.post("/generate-story/")
async def generate_story(request: GenerateStoryRequest):
    session_id = request.session_id
    user_id = request.user_id
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

    # 이야기 생성
    try:
        final_story = story_chain.invoke({"story": story_text})
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Story generation failed: {str(e)}")

    # MongoDB에 저장
    story_data = {
        "_id": session_id,
        "user_id": user_id,
        "title": final_story['title'],
        "story_text": final_story['text'],
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

    return {"session_id": session_id, "title": final_story['title'],
        "story_text": final_story['text']}

@app.post("/tts/")
async def generate_story_tts(session_id: str):
    # 사용자 정보 가져오기
    data = stories_collection.find_one({"_id": session_id})
    if not data:
        raise HTTPException(status_code=404, detail="Data not found")

    from openai import OpenAI
    client = OpenAI()

    response = client.audio.speech.create(
        model="tts-1",
        voice="onyx",
        input=data['story_text'],
    )
    file_path = f"./static/{session_id}/{data['title']}.mp3"

    response.stream_to_file(file_path)

    return {"session_id": session_id, "file_path": file_path}

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

## storycut만드는 함수 추가
@app.post("/generate-storycuts/")
async def generate_storycuts(session_id: str, user_id: str):
    """
    Generate storycuts for a story and save them to MongoDB.
    """
    # Fetch the story from MongoDB
    story = stories_collection.find_one({"_id": session_id, "user_id": user_id})
    if not story:
        raise HTTPException(status_code=404, detail="Story not found or unauthorized access")

    # Generate storycuts using the provided `make_storycuts` function
    try:
        storycuts_data = make_storycuts(story["story_text"])
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Storycuts generation failed: {str(e)}")

    # Update the MongoDB document with the generated storycuts
    try:
        stories_collection.update_one(
            {"_id": session_id},
            {"$set": {"cuts": storycuts_data["storybook"]}}
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to save storycuts: {str(e)}")

    return {"session_id": session_id, "cuts": storycuts_data["storybook"]}


# @app.post("/generate-images/{session_id}")
# async def generate_images_for_storycuts(session_id: str, user_id: str):
#     """
#     Generate images for storycuts and save paths to MongoDB.
#     """
#     # Fetch the story with cuts from MongoDB
#     story = stories_collection.find_one({"_id": session_id, "user_id": user_id})
#     if not story or "cuts" not in story:
#         raise HTTPException(status_code=404, detail="Story or storycuts not found")

#     # Prepare directory for storing images
#     session_path = f"./static/{session_id}"
#     os.makedirs(session_path, exist_ok=True)

#     # Validate and process cuts
#     updated_cuts = []
#     for cut in story["cuts"]:
#         if not isinstance(cut, dict) or "image_prompt" not in cut or "page" not in cut:
#             raise HTTPException(status_code=400, detail=f"Invalid cut format: {cut}")

#         prompt = cut["image_prompt"]
#         try:
#             print(prompt)
#             img = generate_images(story=prompt)  # Generate image using the prompt
#             if not isinstance(img, Image.Image):
#                 raise ValueError("generate_images must return a PIL.Image object")

#             # Save image to the file system
#             img_filename = f"{cut['page']}.png"
#             img_filepath = os.path.join(session_path, img_filename)
#             img.save(img_filepath)

#             # Update cut data with image path
#             cut["image_path"] = img_filepath
#             updated_cuts.append(cut)

#         except Exception as e:
#             raise HTTPException(status_code=500, detail=f"Failed to process cut: {cut}. Error: {str(e)}")

#     # Update the MongoDB document with image paths
#     stories_collection.update_one(
#         {"_id": session_id},
#         {"$set": {"cuts": updated_cuts}}
#     )

#     return {"session_id": session_id, "cuts": updated_cuts}

from fastapi import HTTPException
from PIL import Image
import os

@app.post("/generate-images/{session_id}")
async def generate_images_for_storycuts(session_id: str, user_id: str, method: str = "stable_diffusion"):
    """
    Generate images for storycuts and save paths to MongoDB.
    """
    # Fetch the story with cuts from MongoDB
    story = stories_collection.find_one({"_id": session_id, "user_id": user_id})
    if not story or "cuts" not in story:
        raise HTTPException(status_code=404, detail="Story or storycuts not found")

    # Prepare directory for storing images
    session_path = f"./static/{session_id}"
    os.makedirs(session_path, exist_ok=True)

    # Validate and process cuts
    updated_cuts = []
    for cut in story["cuts"]:
        if not isinstance(cut, dict) or "image_prompt" not in cut or "page" not in cut:
            raise HTTPException(status_code=400, detail=f"Invalid cut format: {cut}")

        prompt = cut["image_prompt"]
        try:
            # Generate image using the selected method
            print(f"Generating image for prompt: {prompt}")
            generated_images = generate_images(story=prompt, method=method)  # Pass method as argument

            if not isinstance(generated_images, list) or not generated_images:
                raise ValueError("generate_images must return a list of image objects")

            # Process the first generated image (if multiple are generated)
            img_data = generated_images[0]  # Assuming only one image is returned
            if "image" in img_data and isinstance(img_data["image"], Image.Image):
                img = img_data["image"]
                img_filename = f"{cut['page']}.png"
                img_filepath = os.path.join(session_path, img_filename)
                img.save(img_filepath)
                cut["image_path"] = img_filepath
            elif "image_url" in img_data and isinstance(img_data["image_url"], str):
                cut["image_path"] = img_data["image_url"]
            else:
                raise ValueError("Invalid image data structure returned from generate_images")

            updated_cuts.append(cut)

        except Exception as e:
            print(f"Error generating image for prompt '{prompt}': {e}")
            cut["image_path"] = None  # Optional: Mark as failed
            updated_cuts.append(cut)  # Ensure all cuts are added, even failed ones

    # Update the MongoDB document with image paths
    try:
        stories_collection.update_one(
            {"_id": session_id},
            {"$set": {"cuts": updated_cuts}}
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to update database: {e}")

    return {"session_id": session_id, "cuts": updated_cuts}