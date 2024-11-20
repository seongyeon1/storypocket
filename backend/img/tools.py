import os
from stability_sdk import client
import stability_sdk.interfaces.gooseai.generation.generation_pb2 as generation
from PIL import Image
import io

from langchain_core.output_parsers import StrOutputParser

from dotenv import load_dotenv

load_dotenv()

# API 클라이언트 초기화
stability_api = client.StabilityInference(
    key=os.getenv('STABILITY_KEY'),
    verbose=True,
)

from .preprocessing import story_to_imgs_chain #, description_to_prompt_chain
            
# # 이미지 생성 함수 정의 (여러 묘사 지원)
# def generate_images_sd(story, width=512, height=512, steps=50):
#     # story로부터 여러 개의 묘사(description)를 생성
#     descriptions = story_to_imgs_chain.invoke({"story": story})

#     # 묘사(description)마다 프롬프트를 생성하고 이미지 생성
#     images = []
#     for description in descriptions.split('\n\n'):  # 묘사를 여러 줄로 구분하는 경우
#         # prefix
#         prompt = description_to_prompt_chain.invoke({'description': description})
        
#         # Stability API를 사용해 이미지 생성
#         answers = stability_api.generate(
#             prompt=prompt,
#             seed=992446758,
#             steps=steps,
#             cfg_scale=8.0,
#             width=width,
#             height=height,
#             samples=1,
#             sampler=generation.SAMPLER_K_DPMPP_2M
#         )

#         # 생성된 이미지를 리스트에 추가
#         for resp in answers:
#             for artifact in resp.artifacts:
#                 if artifact.type == generation.ARTIFACT_IMAGE:
#                     img = Image.open(io.BytesIO(artifact.binary))
#                     images.append(img)
    
#     return images

prefix = ["Illustrated in a refined and cohesive style inspired by modern Korean children's storybooks",
          "A whimsical Korean fairy tale scene in a 2.5D watercolor illustration style, with soft shadows, subtle depth, and warm pastel tones. Inspired by traditional Korean art and stories.",
          "In a hand-drawn illustration style inspired by Korean fairy tales, with soft watercolors and traditional patterns, evoking warmth and nostalgia."]

from openai import OpenAI
import json

def make_storycuts(story):
    storybook_data = story_to_imgs_chain.invoke({"story": story})
    storybook_data = storybook_data.strip('```json').strip('```')
    # Convert the cleaned string into a JSON object
    try:
        storybook_data = json.loads(storybook_data)
        print("Successfully converted to JSON")
    except json.JSONDecodeError as e:
        print(f"JSONDecodeError: {e}")
    
    return storybook_data

# Stable Diffusion 이미지 생성 함수
def generate_images_stable_diffusion(story, width=512, height=512, steps=50):
    storybook_data = story_to_imgs_chain.invoke({"story": story})

    images = []
    for data in storybook_data['storybook']:  # 묘사를 여러 줄로 구분
        prompt = prefix[1]+ data['image_prompt']
        answers = stability_api.generate(
            prompt=prompt,
            seed=82,
            steps=steps,
            cfg_scale=8.0,
            width=width,
            height=height,
            samples=1,
            sampler=generation.SAMPLER_K_DPMPP_2M
        )

        for resp in answers:
            for artifact in resp.artifacts:
                if artifact.type == generation.ARTIFACT_IMAGE:
                    img = Image.open(io.BytesIO(artifact.binary))
                    images.append({"prompt": prompt, "image": img})
    
    return images



# DALL·E 이미지 생성 함수
def generate_images_dalle(story, size="1024x1024", quality="standard"):
    storybook_data = make_storycuts(story, story_to_imgs_chain)

    images = []
    for data in storybook_data['storybook']:  # 묘사를 여러 줄로 구분
        prompt = prefix[1]+ data['image_prompt']
        try:
            response = OpenAI().images.generate(
                model="dall-e-3",
                prompt=prompt,
                size=size,
                quality=quality,
                n=1
            )
            images.append({"prompt": prompt, "image_url": response.data[0].url})
        except Exception as e:
            print(f"이미지 생성 중 오류: {e}")
            images.append({"prompt": prompt, "image_url": None})
    
    return images

# 통합 이미지 생성 함수
def generate_images(story, method="stable_diffusion", **kwargs):
    """
    method:
        "stable_diffusion" - Use Stable Diffusion for image generation
        "dalle" - Use DALL·E for image generation
    """

    if method == "stable_diffusion":
        images = generate_images_stable_diffusion(story, **kwargs)
        return [
            {"prompt": img["prompt"], "image": img["image"]} for img in images
        ]
    elif method == "dalle":
        images = generate_images_dalle(story, **kwargs)
        return [
            {"prompt": img["prompt"], "image_url": img["image_url"]} for img in images
        ]
    else:
        raise ValueError("Invalid method. Choose 'stable_diffusion' or 'dalle'.")