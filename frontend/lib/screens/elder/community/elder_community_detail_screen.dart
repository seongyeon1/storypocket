import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_project/models/story.dart';

class ElderCommunityDetailScreen extends StatefulWidget {
  final Story story;
  const ElderCommunityDetailScreen({super.key, required this.story});

  @override
  State<ElderCommunityDetailScreen> createState() =>
      _ElderCommunityDetailScreenState();
}

class _ElderCommunityDetailScreenState
    extends State<ElderCommunityDetailScreen> {
  late FlutterTts flutterTts;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();

    // TTS 초기화
    initializeTTS();
  }

  void initializeTTS() {
    flutterTts.setLanguage("ko-KR"); // 한국어 설정
    flutterTts.setSpeechRate(0.5); // 읽는 속도 조절
    flutterTts.setPitch(1.0); // 목소리 톤 조절

    // 이벤트 리스너 (읽기 완료 시)
    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    // 에러 처리 리스너
    flutterTts.setErrorHandler((msg) {
      print("TTS 에러: $msg");
      setState(() {
        isPlaying = false;
      });
    });
  }

  // TTS 읽기
  Future<void> startReading(String text) async {
    setState(() {
      isPlaying = true;
    });
    await flutterTts.speak(text);
  }

  // TTS 멈추기
  Future<void> stopReading() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    flutterTts.stop(); // 화면이 닫힐 때 TTS 중지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "제목 : ${widget.story.title}",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                widget.story.storyText,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (isPlaying) {
                      stopReading();
                    } else {
                      startReading(widget.story.storyText);
                    }
                  },
                  icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                  label: Text(isPlaying ? "멈추기" : "읽기"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}