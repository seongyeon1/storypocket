import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:my_project/models/story_book.dart';

import 'package:my_project/screens/contants/storybook/elder_storybook_instruction_screen.dart';
import 'package:my_project/young/widgets/young_story_book_tile.dart';

class YoungStorybookScreen extends StatefulWidget {
  const YoungStorybookScreen({super.key});

  @override
  State<YoungStorybookScreen> createState() => _ElderStoybookScreenState();
}

class _ElderStoybookScreenState extends State<YoungStorybookScreen> {
  //동화 데이터 리스트 저장 변수
  List<StoryBook> storyBook = [];
  List<StoryBook> originalStoryBooks = [];

  //버튼 텍스트 스타일
  final _headerMeauStyle =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 데이터 가져오기
    loadStoryBooks();
  }

  Future<void> loadStoryBooks() async {
    String jsonString =
        await rootBundle.loadString('assets/data/dummy_data.json');
    List<dynamic> jsonData = jsonDecode(jsonString);

    List<StoryBook> datalist =
        jsonData.map((data) => StoryBook.fromJson(data)).toList();

    setState(() {
      storyBook = datalist;
      originalStoryBooks = datalist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  headerMeauStyle: _headerMeauStyle,
                  title: "# 최신순 동화",
                  onPressed: () {
                    //최신순 정렬
                    setState(() {
                      // 원본 데이터로 다시 정렬
                      storyBook = List.from(originalStoryBooks);
                    });
                  },
                ),
                const SizedBox(width: 20),
                MenuButton(
                  headerMeauStyle: _headerMeauStyle,
                  title: "# 추천순 동화",
                  onPressed: () {
                    //조회수 정렬
                    setState(() {
                      storyBook.sort((a, b) =>
                          b.recommendations.compareTo(a.recommendations));
                    });
                  },
                ),
                const SizedBox(width: 20),
                MenuButton(
                  headerMeauStyle: _headerMeauStyle,
                  title: "# 조회순 동화",
                  onPressed: () {
                    setState(() {
                      storyBook.sort((a, b) => b.views.compareTo(a.views));
                    });
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
              itemCount: storyBook.length,
              itemBuilder: (context, index) {
                final story = storyBook[index];
                final order = index;
                //타일 위젯
                Widget storyScreen =
                    ElderStorybookInstructionScreen(storyBook: story);
                return youngStoryBookTile(story, order, context, storyScreen);
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
    required TextStyle headerMeauStyle,
    required this.title,
  }) : _headerMeauStyle = headerMeauStyle;

  final TextStyle _headerMeauStyle;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(180, 40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: _headerMeauStyle,
      ),
    );
  }
}
