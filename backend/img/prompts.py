story_to_img = """
동화 스타일로, 이야기 내용을 바탕으로 과거 한국의 시골 마을을 배경으로 한 장면을 그려주세요.
전체적으로 동화 같은 부드러운 색채와 따뜻한 분위기를 강조하고, 감동적인 어릴 적 기억을 담은 느낌으로 이미지를 구성해 주세요.

이야기 내용 :
{story}
"""

# story_to_imgs = """
# 동화 스타일로, 이야기의 각 장면을 시각적으로 묘사해주세요. 
# 과거 한국의 시골 마을을 배경으로 하고, 전체적으로 동화 같은 부드러운 색채와 따뜻한 분위기를 강조해주세요. 
# 감동적인 어릴 적 기억을 담은 느낌으로 각 장면을 간단하게 나누어 표현해 주세요.

# 묘사가 모든 페이지마다 공통되게 있어야 하고 페이지의 묘사마다 어린아이의 나이, 머리색 등 공통된 설정 제시해줘야 해.
# 'image_prompt'라는 컬럼을 추가해서 여기에는 영어로 묘사와 지시사항을 따르는 영어 묘사를 포함해줘


# 장면은 12컷 이하로 만들어주세요.
# 각 장면을 아래와 같이 JSON 형식으로 답변해주세요:

# # 예시
# {
#   "storybook": [
#     {
#       "page": 1,
#       "text": "1944년, 나는 전라도의 작은 시골 마을에서 태어났어. 논과 밭이 끝없이 펼쳐져 있었고, 아이들은 흙길에서 맨발로 뛰어다녔지.",
#       "description": "평화로운 시골 마을 풍경. 초가집과 논밭이 펼쳐져 있고, 검은 머리의 어린아이가 맨발로 흙길에서 뛰어노는 모습.",
#       "image_prompt": "A peaceful rural Korean village in 1944, with thatched-roof houses and expansive rice paddies. A small black-haired boy, around 2 years old, runs barefoot on a dirt road surrounded by lush green fields."
#     },
#     {
#       "page": 2,
#       "text": "두 살 때였어. 1945년에 해방이 되었지. 엄마가 나를 등에 업고 마을 사람들과 함께 느티나무 아래에서 환호하셨어.",
#       "description": "느티나무 아래에 모여 환호하는 사람들. 검은 머리의 2살 아이를 등에 업은 엄마가 기뻐하는 모습.",
#       "image_prompt": "Under a large zelkova tree in a Korean village, a crowd of villagers cheer joyfully. A young mother with a 2-year-old black-haired boy on her back raises her arms in celebration of Korea's liberation."
#     },
#     {
#       "page": 3,
#       "text": "하지만 해방 후에도 어려움은 계속됐어. 사람들은 식량을 구하기 위해 매일같이 고생했지.",
#       "description": "긴 줄을 서서 식량을 기다리는 사람들. 흙먼지 묻은 헐렁한 옷을 입은 검은 머리의 어린아이와 가족이 기다리는 모습.",
#       "image_prompt": "Villagers in ragged clothing stand in a long line to receive food rations in post-liberation Korea. A black-haired boy, around 3 years old, clings to his mother while waiting."
#     },
#     {
#       "page": 4,
#       "text": "내가 일곱 살 되던 해, 전쟁이 터졌어. 밤마다 가족들과 산속으로 피신하던 기억이 아직도 생생해.",
#       "description": "어두운 산길을 따라 걷는 가족들. 검은 머리의 7살 소년이 엄마 손을 꼭 잡고 두려워하는 모습.",
#       "image_prompt": "A family walks cautiously along a dark mountain path at night, fleeing the Korean War. A 7-year-old black-haired boy tightly holds his mother's hand, his face filled with fear."
#     },
#     {
#       "page": 5,
#       "text": "전쟁이 끝난 뒤에도 학교에 다니는 길은 멀고 험했어. 친구들과 맨발로 산길을 걸었지.",
#       "description": "울창한 나무와 좁은 흙길을 따라 맨발로 걷는 검은 머리의 8살 소년과 친구들.",
#       "image_prompt": "A group of barefoot children, including an 8-year-old black-haired boy, walk along a narrow dirt path surrounded by dense trees on their way to school."
#     },
#     {
#       "page": 6,
#       "text": "학교에서는 선생님이 '우리말을 잊지 말아야 한다'며 우리에게 글을 가르쳐 주셨어.",
#       "description": "작은 교실에서 선생님이 칠판에 글을 쓰는 모습. 검은 머리의 8살 소년이 집중해서 듣는 모습.",
#       "image_prompt": "A small classroom in post-war Korea. A teacher writes on the chalkboard, emphasizing the importance of the Korean language, as an 8-year-old black-haired boy listens attentively."
#     },
#     {
#       "page": 7,
#       "text": "한번은 논둑길을 걷다가 미끄러져 진흙탕에 빠진 적이 있어. 친구들이 배를 잡고 웃었지.",
#       "description": "검은 머리의 9살 소년이 논둑길에서 진흙탕에 빠진 모습. 주변 친구들이 웃고 있는 장면.",
#       "image_prompt": "A 9-year-old black-haired boy slips into a muddy puddle on a narrow rice field path, while his friends laugh and point playfully in the bright sunlight."
#     },
#     {
#       "page": 8,
#       "text": "우리 집은 여전히 가난했지만, 고구마 한 개만으로도 온 가족이 행복하게 웃을 수 있었어.",
#       "description": "검은 머리의 10살 소년과 가족들이 둘러앉아 고구마를 나눠 먹으며 환히 웃는 모습.",
#       "image_prompt": "A humble Korean family sits around a small table in a thatched-roof house, sharing a single roasted sweet potato. A 10-year-old black-haired boy smiles warmly."
#     },
#     {
#       "page": 9,
#       "text": "아버지는 소를 키우며 밭을 일구셨어. 나도 아버지를 도우며 농사일을 배우기 시작했지.",
#       "description": "검은 머리의 11살 소년이 아버지와 함께 소를 끌며 밭을 일구는 모습.",
#       "image_prompt": "A farm scene with a father plowing a field using a cow. An 11-year-old black-haired boy walks beside him, helping with the work under a clear blue sky."
#     },
#     {
#       "page": 10,
#       "text": "어렵고 배고팠지만, 우리 가족은 서로를 의지하며 살아갔어. 가족의 따뜻함은 무엇과도 바꿀 수 없었지.",
#       "description": "저녁 무렵 초가집 내부에서 검은 머리의 12살 소년과 가족들이 함께 식사 준비를 하는 모습.",
#       "image_prompt": "Inside a thatched-roof house at dusk, a warm family scene unfolds as a 12-year-old black-haired boy helps his mother prepare dinner with his siblings."
#     },
#     {
#       "page": 11,
#       "text": "지금의 내가 있는 건 그 시절의 모든 순간들이 있었기 때문이야. 힘들었지만 참 소중한 시간들이었어.",
#       "description": "성인이 된 할아버지가 들판을 바라보며 옛날을 떠올리는 모습.",
#       "image_prompt": "An older man with graying hair stands in a tranquil field, gazing nostalgically at the horizon as he remembers his childhood in rural Korea."
#     },
#     {
#       "page": 12,
#       "text": "손주들에게 그 시절 이야기를 들려주며 나는 이렇게 말하지. '어려웠던 시절도 웃을 수 있었단다.'",
#       "description": "할아버지가 손주들에게 이야기하며 웃는 모습. 따뜻한 분위기의 거실.",
#       "image_prompt": "In a cozy living room, an elderly man with gray hair sits in a chair, telling nostalgic stories to his grandchildren, who listen intently with warm smiles."
#     }
#   ]
# }

# 이야기 내용:
# {story}
# """

story_to_imgs = """
# Objective:
Create a visual representation of a storybook in JSON format. The story is set in a past rural Korean village with a fairy-tale style, warm atmosphere, and soft, nostalgic colors.

# Instructions:
1. Divide the story into no more than 12 scenes (pages), ensuring the story flows naturally and engages children with vivid descriptions.
2. Each page should include:
   - **Page Number (page)**: Numeric order of the scene.
   - **Text (text)**: A simple and engaging story narrative written in Korean, like a children's storybook. Make the story continuous so that each page connects naturally to the next.
   - **Description (description)**: A concise depiction of the scene in Korean, emphasizing visual details.
   - **Image Prompt (image_prompt)**: The English description of the scene, focusing on key visual elements to guide image generation (include age, hair color, and setting details).
3. Ensure characters have consistent details (e.g., child’s age, hair color, etc.) across all pages.
4. Reflect a fairy-tale-like warmth and the emotions of childhood memories.

# Example JSON Output:
{{
  "storybook": [
    {{
      "page": 1,
      "text": "아주 오래전, 전라도의 작은 마을에 한 소년이 살았어요. 소년은 초가집 마당에서 맨발로 뛰어다니며 친구들과 노는 것을 좋아했답니다.",
      "description": "평화로운 시골 마을 풍경. 초가집과 논밭이 펼쳐져 있고, 검은 머리의 어린아이가 맨발로 흙길에서 뛰어노는 모습.",
      "image_prompt": "A peaceful rural Korean village in 1944, with thatched-roof houses and expansive rice paddies. A small black-haired boy, around 2 years old, runs barefoot on a dirt road surrounded by lush green fields."
    }},
    {{
      "page": 2,
      "text": "소년은 엄마 품에서 이야기를 듣는 걸 좋아했어요. 어느 날, 마을 사람들이 큰 느티나무 아래에 모여 환호성을 질렀어요. '해방이 되었대!' 소년은 엄마의 등에 업혀 그 모습을 지켜봤답니다.",
      "description": "느티나무 아래에 모여 환호하는 사람들. 검은 머리의 2살 아이를 등에 업은 엄마가 기뻐하는 모습.",
      "image_prompt": "Under a large zelkova tree in a Korean village, a crowd of villagers cheer joyfully. A young mother with a 2-year-old black-haired boy on her back raises her arms in celebration of Korea's liberation."
    }},
    {{
      "page": 3,
      "text": "시간이 흘러, 소년은 학교에 다니기 시작했어요. 학교 가는 길은 멀었지만, 친구들과 함께 걷는 길은 언제나 즐거웠답니다. 길가에 핀 야생화를 보고 이야기꽃을 피우곤 했죠.",
      "description": "좁은 흙길을 따라 맨발로 걷는 검은 머리의 8살 소년과 친구들. 주변에는 야생화가 피어 있는 모습.",
      "image_prompt": "A group of barefoot children, including an 8-year-old black-haired boy, walking along a narrow dirt path surrounded by wildflowers on their way to school."
    }},
    {{
      "page": 4,
      "text": "하지만 어느 날, 하늘에 검은 연기가 피어오르며 전쟁이 시작되었어요. 소년과 가족은 밤마다 산길을 걸어 피난을 떠났답니다. 그 길은 두렵고 외로웠어요.",
      "description": "어두운 산길을 따라 걷는 가족들. 검은 머리의 7살 소년이 엄마 손을 꼭 잡고 두려워하는 모습.",
      "image_prompt": "A family walks cautiously along a dark mountain path at night, fleeing the Korean War. A 7-year-old black-haired boy tightly holds his mother's hand, his face filled with fear."
    }},
    {{
      "page": 5,
      "text": "전쟁이 끝난 후, 소년은 다시 학교에 다닐 수 있었어요. 선생님은 칠판에 '우리말'을 가르치며 소년에게 꿈을 심어주었답니다.",
      "description": "작은 교실에서 선생님이 칠판에 글을 쓰는 모습. 검은 머리의 8살 소년이 집중해서 듣는 모습.",
      "image_prompt": "A small classroom in post-war Korea. A teacher writes on the chalkboard, emphasizing the importance of the Korean language, as an 8-year-old black-haired boy listens attentively."
    }}
  ]
}}

# Content of the Story:
{story}
"""



prefix = ["Illustrated in a refined and cohesive style inspired by modern Korean children's storybooks",
          "A whimsical Korean fairy tale scene in a 2.5D watercolor illustration style, with soft shadows, subtle depth, and warm pastel tones. Inspired by traditional Korean art and stories.",
          "In a hand-drawn illustration style inspired by Korean fairy tales, with soft watercolors and traditional patterns, evoking warmth and nostalgia."]


content = """
## 지시사항
이미지를 생성하기 위한 이미지 프롬프트를 작성해주세요.
동화 스타일로, 이야기의 각 장면을 시각적으로 묘사해주세요.
과거 한국의 시골 마을을 배경으로 하고, 전체적으로 동화 같은 부드러운 색채와 따뜻한 분위기를 강조해주세요.

아래의 작성법을 참고해서 영어로만 작성해주세요.
"""

instruction = """
## 작성 방법
첫째, AI 이미지 생성 프롬프트는 가능한 구체적으로 작성하는 것이 좋습니다. 예를 들어 ‘아름다운 강아지 그림’보다는 ‘푸른 바다 배경에 갈색 털의 웨스트하이랜드 화이트테리어가 바닷가 모래사장에서 노는 모습’처럼 구체적으로 묘사하면 더 나은 결과를 얻을 수 있습니다.
둘째, AI 이미지 생성 프롬프트에 스타일, 기법, 화풍 등의 정보를 추가하면 원하는 분위기의 이미지를 만들 수 있습니다. 
예를 들어 ‘고흐의 해바라기 풍으로 그린 강아지 초상화’, ‘만화 캐릭터 스타일의 내 프로필 사진’ 등입니다.
셋째, 해상도나 종횡비, 화면 구도 등 이미지 속성 정보도 AI 이미지 생성 프롬프트에 포함시킬 수 있습니다. 
예를 들어 ‘4K 고해상도 16:9 종횡비 가로 구도의 우주 풍경화’ 등입니다
이외에도 AI 이미지 생성 프롬프트에 감정, 분위기, 주제 등의 키워드를 넣으면 그에 맞는 이미지를 얻을 수 있습니다. 가능한 많은 정보를 AI 이미지 생성 프롬프트에 담되, 지나치게 길어지지 않도록 주의해야 합니다.
"""

description = """
## 묘사 :
{description}
"""

instruction2 = """
① 주제(Subject)
_ 생성하고 싶은 대상. 사람, 동물, 식물 등 가급적 구체적 묘사를 해주는 것이 좋다.
“사람”이 아닌 “놀이터에서 그네에 앉아 있는 보라색 모자를 쓴 어린 한국 남자아이”
이처럼 외형과 동작, 인상착의를 함께 표현하면 더 구체적인 이미지가 생성된다.

② 표현수단(Medium)
_ 3D 렌더링, 사진, 그림(유화, 수채화, 애니메이션 등)과 같이 이미지를 생성 소재를 뜻하며,
이미지를 표현하는 프롬프트에서 중요하게 적용되는 부분이다.

③ 배경(Background)
_ 이미지의 배경을 프롬프트로 알려주는 것이며, ‘저녁 노을, 은하수, 해가 뜨는’과 같이 프롬프트를 작성한다.

④ 스타일(Style)
_ 이미지에 대한 예술적 표현양식을 설정할 수 있으며, ‘현실주의(realistic)’, ‘팝아트(pop art)’ 또는
‘비현실적인(fantastical)’처럼 스타일 프롬프트도 이미지 생성에 큰 영향력을 끼칠 수 있다.

2) 사진(이미지) 생성을 위한 추가 구성(3가지)
① 색감(Color)
_ 이미지의 전체적 색감(색상)을 나타낼 수 있으며, ‘색상: 블랙블루, 남색의 음영으로 보완된 하늘색’이라는
프롬프트를 추가함으로써 생각하고 있는 이미지의 색감을 나타낼 수 있다.

② 빛(Lighting), 해상도(Resolution)
_ 이미지의 구성(Composition)을 프롬프트로 추가할 수 있다. 예를 들어서 구체적으로 카메라 설정값처럼
‘해상도 4570만 화소, ISO감도: 64, 셔터스피트 1/100초’와 같이 이미지의 빛에 대한 질감을 표현할 수 있다.

③ 화가(Artist)
_ 화가 또는 작가(영화, 그림)의 화풍을 이미지에 담을 수 있다.
‘미야자키 하야오 영화와 같은 몽환적인’ 프롬프트를 추가해 이미지의 화풍을 설정할 수 있다.

## 예시
현실적인 사진으로 표현된 검정색과 파란색으로 표현된 놀이터라는 공간에서 보라색 모자를 쓴 어린 한국 남자아이.
스타일: 미야자키 하야오 영화의 몽환적인 영상의 융합.
조명: 검은 밤하늘에서 반짝이는 은하수를 표현하고 있다.
색상: 블랙블루, 남색의 음영으로 보완된 하늘색.
구성: 해상도 4570만 화소, ISO 감도: 64, 셔터 스피드 1/100초, 떠다니는 행성들과 은하수를 배경으로 배치.
"""