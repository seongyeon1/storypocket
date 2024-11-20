import 'package:flutter/material.dart';
import 'package:my_project/models/story.dart';
import 'package:my_project/style/fontstyle.dart';

Widget buildStoryTile(
    Story story, int order, BuildContext context, Widget storyScreen) {
  return ListTile(
    leading: const CircleAvatar(
      backgroundImage: AssetImage("assets/image/grandma_grandpa.png"),
    ),
    title: Text(
      "${order + 1}  ${story.title}",
      style: StoryMenuFontsize(),
    ),
    trailing: Column(
      children: [Text('조회수: ${story.views}'), Text('작성자: ${story.author}')],
    ),
    onTap: () {
      //상세 이야기 화면
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => storyScreen,
        ),
      );
    },
  );
}
