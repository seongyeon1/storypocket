import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_project/models/cuts.dart';

import 'package:my_project/models/story_book.dart';
import 'package:my_project/screens/contants/storybook/elder_storybook_cut_screen.dart';

class ElderStorybookInstructionScreen extends StatefulWidget {
  final StoryBook storyBook;
  const ElderStorybookInstructionScreen({super.key, required this.storyBook});

  @override
  State<ElderStorybookInstructionScreen> createState() =>
      _ElderStorybookInstructionScreenState();
}

class _ElderStorybookInstructionScreenState
    extends State<ElderStorybookInstructionScreen> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.storyBook.title),
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
      backgroundColor: const Color(0xFFFEF9F7),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            /*제목*/
            children: [
              Image.asset(
                "assets/image/storyimage/${widget.storyBook.sessionId}-1.png",
                width: 350,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.storyBook.title,
                    style: titleFontStyle(),
                  ),
                ],
              ),
              /* 글쓴이 */
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.storyBook.author} ${widget.storyBook.gender.contains("남자") ? "할아버지" : "할머니"}",
                    style: nameFontStyle(),
                  ),
                ],
              ),
              /* 글쓴이 */
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "조회수 : ${widget.storyBook.views} / 추천수 : ${widget.storyBook.recommendations}"),
                ],
              ),
            ],
          ),

          /* 동화 보러가기 */
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ElderStorybookCutScreen(
                            storyBook: widget.storyBook,
                          )));
            },
            style: ButtonStyle(
              fixedSize:
                  WidgetStateProperty.all(const Size(200, 50)), // 가로 200, 세로 50
            ),
            child: Text(
              '동화 보러가기!',
              style: buttonFontStyle(),
            ),
          )
        ],
      ),
    );
  }

  TextStyle titleFontStyle() {
    return const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  }

  TextStyle nameFontStyle() {
    return const TextStyle(fontSize: 17, fontWeight: FontWeight.w600);
  }

  TextStyle buttonFontStyle() {
    return const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  }
}
