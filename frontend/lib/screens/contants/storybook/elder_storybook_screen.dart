import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:my_project/models/story_book.dart';
import 'package:my_project/screens/common/widgets/story_meau_tile.dart';

import 'package:my_project/screens/contants/storybook/elder_storybook_instruction_screen.dart';
import 'package:my_project/screens/contants/storybook/widgets/story_book_tile.dart';

class ElderStoybookScreen extends StatefulWidget {
  const ElderStoybookScreen({super.key});

  @override
  State<ElderStoybookScreen> createState() => _ElderStoybookScreenState();
}

class _ElderStoybookScreenState extends State<ElderStoybookScreen> {
  //동화 데이터 리스트 저장 변수
  List<StoryBook> storyBook = [];
  List<StoryBook> originalStoryBooks = [];

  //버튼 텍스트 스타일
  final _headerMeauStyle =
      const TextStyle(fontSize: 27, fontWeight: FontWeight.w600);

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 5),
          //메뉴//
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MeauBottonTile(
                headerMeauStyle: _headerMeauStyle,
                title: "최신순",
                onPressed: () {
                  //최신순 정렬
                  setState(() {
                    // 원본 데이터로 다시 정렬
                    storyBook = List.from(originalStoryBooks);
                  });
                },
              ),
              MeauBottonTile(
                headerMeauStyle: _headerMeauStyle,
                title: "추천순",
                onPressed: () {
                  //조회수 정렬
                  setState(() {
                    storyBook.sort((a, b) =>
                        b.recommendations.compareTo(a.recommendations));
                  });
                },
              ),
              MeauBottonTile(
                headerMeauStyle: _headerMeauStyle,
                title: "조회순",
                onPressed: () {
                  setState(() {
                    storyBook.sort((a, b) => b.views.compareTo(a.views));
                  });
                },
              ),
            ],
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
                return storyBookTile(story, order, context, storyScreen);
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
