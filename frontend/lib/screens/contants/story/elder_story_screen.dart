import 'package:flutter/material.dart';
import 'package:my_project/data/community_dummy_data.dart';
import 'package:my_project/models/story.dart';
import 'package:my_project/screens/common/widgets/story_tile.dart';
import 'package:my_project/screens/contants/story/elder_story_detail_screen.dart';

class ElderStoryScreen extends StatefulWidget {
  const ElderStoryScreen({super.key});

  @override
  State<ElderStoryScreen> createState() => _ElderStoryScreenState();
}

class _ElderStoryScreenState extends State<ElderStoryScreen> {
  List<Story> stories = [];
  List<Story> originalStories = [];

  //버튼 텍스트 스타일
  final _header_meau_style =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

  @override
  void initState() {
    // TODO: implement initState

    // 데이터 가져오기
    super.initState();
    stories = storyData
        .map((data) => Story(
              title: data['title'] as String,
              author: data['author'] as String,
              story: data['story'] as String,
              numberOfView: data['numberOfView'] as int,
            ))
        .toList();
    originalStories = List.from(stories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("동화책"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.monetization_on_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle_rounded),
          )
        ],
      ),
      //동화 리스트
      body: Column(
        children: [
          const SizedBox(height: 5),
          //메뉴//
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // 가로 스크롤 설정
            child: Row(
              children: [
                const SizedBox(width: 10),
                MenuButton(
                  header_meau_style: _header_meau_style,
                  title: "# 최신순 동화",
                  onPressed: () {
                    //최신순 정렬
                    setState(() {
                      // 원본 데이터로 다시 정렬
                      stories = List.from(originalStories);
                    });
                  },
                ),
                const SizedBox(width: 20),
                MenuButton(
                  header_meau_style: _header_meau_style,
                  title: "# 인기순 동화",
                  onPressed: () {
                    //조회수 정렬
                    setState(() {
                      stories.sort(
                          (a, b) => b.numberOfView.compareTo(a.numberOfView));
                    });
                  },
                ),
                const SizedBox(width: 20),
                MenuButton(
                  header_meau_style: _header_meau_style,
                  title: "# 급상승 동화",
                  onPressed: () {
                    stories.sort(
                        (a, b) => b.numberOfView.compareTo(a.numberOfView));
                  },
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          const SizedBox(height: 10),
          //게시글//
          Expanded(
            child: ListView.separated(
              itemCount: storyData.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                final order = index;
                //타일 위젯
                Widget storyScreen = ElderStoryDetailScreen(story: story);
                return buildStoryTile(story, order, context, storyScreen);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.onPressed,
    required TextStyle header_meau_style,
    required this.title,
  }) : _header_meau_style = header_meau_style;

  final TextStyle _header_meau_style;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: _header_meau_style,
      ),
    );
  }
}
