import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_project/models/story.dart';
import 'package:my_project/screens/common/widgets/story_meau_tile.dart';
import 'package:my_project/screens/contants/story/widgets/story_tile.dart';
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
      const TextStyle(fontSize: 27, fontWeight: FontWeight.w600);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 데이터 가져오기
    loadStories();
  }

  Future<void> loadStories() async {
    String jsonString =
        await rootBundle.loadString('assets/data/dummy_data.json');
    List<dynamic> jsonData = jsonDecode(jsonString);

    List<Story> datalist =
        jsonData.map((data) => Story.fromJson(data)).toList();

    setState(() {
      stories = datalist;
      originalStories = datalist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("이야기"),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MeauBottonTile(
                headerMeauStyle: _header_meau_style,
                title: "최신순",
                onPressed: () {
                  //최신순 정렬
                  setState(() {
                    // 원본 데이터로 다시 정렬
                    stories = List.from(originalStories);
                  });
                },
              ),
              MeauBottonTile(
                headerMeauStyle: _header_meau_style,
                title: "추천순",
                onPressed: () {
                  //인기순 정렬
                  setState(() {
                    stories.sort((a, b) =>
                        b.recommendations.compareTo(a.recommendations));
                  });
                },
              ),
              MeauBottonTile(
                headerMeauStyle: _header_meau_style,
                title: "조회순",
                onPressed: () {
                  setState(() {
                    stories.sort((a, b) => b.views.compareTo(a.views));
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 10),
          //게시글//

          Expanded(
            child: ListView.separated(
              itemCount: stories.length,
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
