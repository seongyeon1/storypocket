import 'package:flutter/material.dart';

import 'package:my_project/models/story_book.dart';
import 'package:my_project/screens/contants/storybook/elder_storybook_cut_screen.dart';
import 'package:my_project/screens/contants/storybook/elder_storybook_mp3_screen.dart';

class ElderStorybookInstructionScreen extends StatefulWidget {
  final StoryBook storyBook;
  const ElderStorybookInstructionScreen({super.key, required this.storyBook});

  @override
  State<ElderStorybookInstructionScreen> createState() =>
      _ElderStorybookInstructionScreenState();
}

class _ElderStorybookInstructionScreenState
    extends State<ElderStorybookInstructionScreen> {
  // void toAudioBook() {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => ElderStorybookMp3Screen(
  //                 storyBook: widget.storyBook,
  //               )));
  // }

  // void toStoryBook() {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => ElderStorybookCutScreen(
  //                 storyBook: widget.storyBook,
  //               )));
  // }

  Future<void> toStoryBook() async {
    // showDialog로 알림창 띄우기
    bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Wrap(
            children: [
              Text(
                '동화를 읽으시려면 ',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '포인트 10',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Text(
                '이 소모됩니다. 읽으시겠습니까?',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // 아니오 버튼
              child: const Text(
                '아니오',
                style: TextStyle(fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // 예 버튼
              child: const Text(
                '예',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        );
      },
    );

    // result가 true이면 다음 페이지로 이동
    if (result == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ElderStorybookCutScreen(
                    storyBook: widget.storyBook,
                  )));
    }
  }

  Future<void> toAudioBook() async {
    // showDialog로 알림창 띄우기
    bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Wrap(
            children: [
              Text(
                '오디오 북을 들으시려면 ',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '포인트 10',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Text(
                '이 소모됩니다. 읽으시겠습니까?',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // 아니오 버튼
              child: const Text(
                '아니오',
                style: TextStyle(fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // 예 버튼
              child: const Text(
                '예',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        );
      },
    );

    // result가 true이면 다음 페이지로 이동
    if (result == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ElderStorybookMp3Screen(
                    storyBook: widget.storyBook,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.storyBook.title),
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
                width: 370,
              ),
              const SizedBox(height: 10),
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
              const SizedBox(
                height: 20,
              ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              readButton(context, '동화 읽기', toStoryBook),
              //오디오북 듣기
              readButton(context, '오디오 북', toAudioBook)
            ],
          )
        ],
      ),
    );
  }

  ElevatedButton readButton(
      BuildContext context, String text, VoidCallback navi) {
    return ElevatedButton(
      onPressed: navi,
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all(
          const Size(180, 50),
        ), // 가로 200, 세로 50
      ),
      child: Text(
        text,
        style: buttonFontStyle(),
      ),
    );
  }

  TextStyle titleFontStyle() {
    return const TextStyle(fontSize: 28, fontWeight: FontWeight.w600);
  }

  TextStyle nameFontStyle() {
    return const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  }

  TextStyle buttonFontStyle() {
    return const TextStyle(fontSize: 23, fontWeight: FontWeight.w600);
  }
}
