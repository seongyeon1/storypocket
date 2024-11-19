import 'package:flutter/material.dart';
import '../../../models/story.dart';
import '../../elder/storybook/elder_storybook_detail_screen.dart';

Widget buildStoryTile(
    Story story, int order, BuildContext context, Widget storyScreen) {
  return ListTile(
    leading: const CircleAvatar(
      backgroundImage: AssetImage("assets/image/grandma_grandpa.png"),
    ),
    title: Text("${order + 1}  ${story.title}"),
    trailing: Column(
      children: [
        Text('조회수: ${story.views}'),
        Text('작성자: ${story.author}')
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
