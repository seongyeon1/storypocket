from .prompts import *
# from common import *
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder, PromptTemplate
from langchain_core.output_parsers import JsonOutputParser

from pydantic import BaseModel, Field
from dotenv import load_dotenv

load_dotenv()
from langchain_openai import ChatOpenAI

gpt_4o_mini = ChatOpenAI(
    temperature=0, 
    model_name="gpt-4o-mini",
    streaming=True,
)

llm = gpt_4o_mini

# Define your desired data structure.
class Story(BaseModel):
    text: str = Field(description="story")
    title: str = Field(description="title of the story")
    
parser = JsonOutputParser(pydantic_object=Story)

story_prompt = PromptTemplate(
    template = story_template+'\n{format_instructions}',
    input_variables = ["story"],
    partial_variables = {"format_instructions": parser.get_format_instructions()},
)

story_chain = story_prompt | llm | parser
