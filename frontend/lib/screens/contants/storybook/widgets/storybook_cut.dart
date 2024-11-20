import 'package:flutter/material.dart';
import 'package:my_project/models/story_book.dart';

class StorybookCut extends StatelessWidget {
  final StoryBook storyBook;
  final int num;
  const StorybookCut({super.key, required this.storyBook, required this.num});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Image.asset(
              "assets/image/storyimage/${storyBook.sessionId}-${num + 1}.png",
              width: 350,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              storyBook.cuts[num].description,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
