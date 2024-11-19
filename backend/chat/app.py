from fastapi import FastAPI, WebSocket, WebSocketDisconnect , Request
from fastapi.responses import FileResponse

import openai
import time
import os


system_template = """
당신은 할머니 혹은 할아버지의 이야기를 들어주는 손자입니다.
아이의 말투로 공감하며 이야기를 들어주세요.
할머니 혹은 할아버지의 대화를 통해 동화를 만들 예정입니다.
동화를 만들기 위해 필요한 정보들을 많이 물어봐주세요.

충분한 정보가 모였다면 자연스럽게 대화를 마무리 할 수 있게 대화합니다.
성별에 따라 호칭을 맞춰서 불러주세요.
간결하게 한 번에 한 가지의 질문만 물어봐야 합니다.

알아서 영어로 알아듣고, 한국어로 번역해서 한국어로 대답해야 합니다.
"""

from dotenv import load_dotenv

# API KEY 정보로드
load_dotenv()

app = FastAPI()


client = openai.OpenAI()

# record the time before the request is sent
start_time = time.time()


def call_open_api(message):
    completion = client.chat.completions.create(
        model='gpt-4o-mini',
        
        messages=[
            {"role": "system", "content": system_template},
            #add 10 last messages history here

            {'role': 'user', 'content': message}
        ],
        temperature=0,
        stream=True  # again, we set stream=True
    )

    return completion
    # create variables to collect the stream of chunks
    
    
    

class ConnectionManager:
    def __init__(self):
        self.active_connections = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def send_text(self, text: str, websocket: WebSocket):
        await websocket.send_text(text)

manager = ConnectionManager()

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            try:
                # Receive text data (speech recognition result) from the client
                data = await websocket.receive_text()
                
                # Process the data
                print(f"Received text: {data}")  # Example: print it to the console
                res = call_open_api(data)
                # Optionally, send a response back to the client
                collected_chunks = []
                collected_messages = []
                # iterate through the stream of events
                for chunk in res:
                    chunk_time = time.time() - start_time  # calculate the time delay of the chunk
                    collected_chunks.append(chunk)  # save the event response
                    chunk_message = chunk.choices[0].delta.content  # extract the message
                    collected_messages.append(chunk_message)  # save the message
                    
                    
                    if chunk_message is not None and chunk_message.find('.') != -1:
                        print("Found full stop")
                        message = [m for m in collected_messages if m is not None]
                        full_reply_content = ''.join([m for m in message])

                        await manager.send_text(full_reply_content, websocket)
                        collected_messages = []
                    

                    print(f"Message received {chunk_time:.2f} seconds after request: {chunk_message}")  # print the delay and text

                 # print the time delay and text received
                # print(f"Full response received {chunk_time:.2f} seconds after request")
                # # clean None in collected_messages
                # collected_messages = [m for m in collected_messages if m is not None]
                # full_reply_content = ''.join([m for m in collected_messages])
                #check if collected_messages is not empty
                if len(collected_messages) > 0:
                    message = [m for m in collected_messages if m is not None]
                    full_reply_content = ''.join([m for m in message])

                    await manager.send_text(full_reply_content, websocket)
                    collected_messages = []
                
            except WebSocketDisconnect:
                manager.disconnect(websocket)
                break
            except Exception as e:
                # Handle other exceptions
                print(f"Error: {str(e)}")
                break
    finally:
        manager.disconnect(websocket)

# api to acces htmlpage call voice.html
@app.get("/")
async def get():
    return FileResponse("voice_frontend.html")