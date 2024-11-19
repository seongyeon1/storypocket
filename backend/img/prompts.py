story_to_img = """
동화 스타일로, 이야기 내용을 바탕으로 과거 한국의 시골 마을을 배경으로 한 장면을 그려주세요.
전체적으로 동화 같은 부드러운 색채와 따뜻한 분위기를 강조하고, 감동적인 어릴 적 기억을 담은 느낌으로 이미지를 구성해 주세요.

이야기 내용 :
{story}
"""

story_to_imgs = """
동화 스타일로, 이야기의 각 장면을 시각적으로 묘사해주세요. 
과거 한국의 시골 마을을 배경으로 하고, 전체적으로 동화 같은 부드러운 색채와 따뜻한 분위기를 강조해주세요. 
감동적인 어릴 적 기억을 담은 느낌으로 각 장면을 간단하게 나누어 표현해 주세요.
장면은 여섯 컷 이하로 만들어주세요.

각 장면을 아래와 같이 분리하여 설명해주세요:

#첫 번째 장면 묘사 내용
\n\n
#두 번째 장면 묘사 내용
\n\n
#세 번째 장면 묘사 내용
\n\n
#네 번째 장면 묘사 내용
...

이야기 내용:
{story}
"""

prefix = "Illustrated in a refined and cohesive style inspired by modern Korean children's storybooks"

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