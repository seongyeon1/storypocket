import 'package:flutter/material.dart';
import 'package:my_project/models/story_book.dart';
import 'package:my_project/screens/contants/storybook/widgets/storybook_cut.dart';

class ElderStorybookCutScreen extends StatefulWidget {
  final StoryBook storyBook;
  const ElderStorybookCutScreen({super.key, required this.storyBook});

  @override
  State<ElderStorybookCutScreen> createState() =>
      _ElderStorybookCutScreenState();
}

class _ElderStorybookCutScreenState extends State<ElderStorybookCutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.storyBook.title),
      ),
      body: PageView.builder(
        itemCount: widget.storyBook.cuts.length,
        itemBuilder: (context, cutIndex) {
          return StorybookCut(
            storyBook: widget.storyBook,
            num: cutIndex,
          );
        },
      ),
    );
  }
}
