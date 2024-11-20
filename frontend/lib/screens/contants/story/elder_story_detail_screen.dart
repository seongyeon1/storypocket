import 'package:flutter/material.dart';
import 'package:my_project/models/story.dart';

class ElderStoryDetailScreen extends StatefulWidget {
  final Story story;
  const ElderStoryDetailScreen({super.key, required this.story});

  State<ElderStoryDetailScreen> createState() => _ElderStoryDetailScreenState();
}
  @override
  class _ElderStoryDetailScreenState extends State<ElderStoryDetailScreen> {
    final TextEditingController _commentController = TextEditingController();
    final List<String> _comments = []; // 댓글 목록을 저장할 리스트


  @override
  State<ElderStoryDetailScreen> createState() => _ElderStoryDetailScreenState();
}

class _ElderStoryDetailScreenState extends State<ElderStoryDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = []; // 댓글 목록을 저장할 리스트

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("작성자 : ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.story.author),
                        Text(
                            widget.story.gender.contains("남자") ? "할아버지" : "할머니")
                      ],
                    ),
                    Row(
                      children: [
                        const Text("조회수 : ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.story.views.toString())
                      ],
                    ),
                    const SizedBox(height: 20),
                    //이야기 작성란
                    Text(widget.story.storyText),
                    //추천
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 50,
                            onPressed: () {},
                            icon: const Icon(Icons.thumb_up),
                          ),
                          Text("추천수 : ${widget.story.recommendations}"),
                        ],
                      ),
                    ),

                    // 댓글 목록
                    const SizedBox(height: 20),
                    const Text(
                      "댓글",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    ListView.builder(
                      shrinkWrap: true, // ListView를 Column 안에서 사용하기 위해
                      physics: const NeverScrollableScrollPhysics(), // 스크롤 방지
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_comments[index]),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 댓글 입력 영역
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: '댓글을 입력하세요',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _comments.add(_commentController.text);
                      _commentController.clear();
                    });
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
