#preprocessing.py
from .prompts import *
from common import *
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser

llm = gpt_4o_mini
# llm = gemini_1_5_flash

story_to_img_prompt = PromptTemplate(
    template=story_to_img,
    input_variables=["story"]
)
story_to_imgs_prompt = PromptTemplate(
    template=story_to_imgs,
    input_variables=["story"]
)

description_to_prompt = '\n\n'.join([content, instruction, description])

description_to_prompt = PromptTemplate(
    template=description_to_prompt,
    input_variables=["description"]
)

story_to_img_chain = story_to_img_prompt | llm | StrOutputParser()
story_to_imgs_chain = story_to_imgs_prompt | llm | StrOutputParser()
description_to_prompt_chain = description_to_prompt | llm | StrOutputParser()