import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/story.dart';
import '../../common/widgets/menu_tile.dart';
import 'elder_storybook_detail_screen.dart';

class ElderContantsScreen extends StatefulWidget {
  const ElderContantsScreen({super.key});

  @override
  State<ElderContantsScreen> createState() => _ElderContantsScreenState();
}

class _ElderContantsScreenState extends State<ElderContantsScreen> {
  // 동화 데이터 리스트 저장 변수
  List<Story> stories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStories();
  }

  // API에서 데이터 가져오기
  Future<void> fetchStories() async {
    try {
      final response = await http.get(Uri.parse("http://localhost:8000/api/stories")); // 백엔드 API URL
      if (response.statusCode == 200) {
        // UTF-8 디코딩 추가
        final List<dynamic> storyList = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          stories = storyList.map((data) => Story.fromJson(data)).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load stories");
      }
    } catch (e) {
      print("Error fetching stories: $e");
      setState(() {
        isLoading = false;
      });
    }
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
      // 로딩 상태
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                final order = index;

                // 타일 위젯
                Widget storyScreen = ElderStorybookDetailScreen(story: story);
                return buildStoryTile(story, order, context, storyScreen);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
    );
  }
}