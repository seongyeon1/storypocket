import 'package:flutter/material.dart';
import 'package:my_project/models/story_book.dart';
import 'package:my_project/style/fontstyle.dart';

Widget storyBookTile(
    StoryBook story, int order, BuildContext context, Widget storyScreen) {
  return ListTile(
    leading: const CircleAvatar(
      backgroundImage: AssetImage("assets/image/grandma_grandpa.png"),
    ),
    title: Text("${order + 1}  ${story.title}", style: StoryMenuFontsize()),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('조회수: ${story.views}'),
        Text('작성자: ${story.author}'),
      ],
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
