import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

class TalkScreen extends StatefulWidget {
  const TalkScreen({super.key});

  @override
  State<TalkScreen> createState() => _TalkScreenState();
}

class _TalkScreenState extends State<TalkScreen> {
  final TextStyle speechBalloonText =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

  final FlutterTts _tts = FlutterTts();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _showSuggestions = true; // 추천 질문 초기 표시 여부
  String _recognizedText = ''; // 실시간 사용자 말풍선 텍스트
  String _responseText = '안녕하세요! 오늘은 어떤 이야기를 할까요?'; // 초기 AI 응답 텍스트
  String _sessionId = 'session_id1'; // 세션 ID
  String _userId = 'user_id1'; // 사용자 ID
  String sex = '할아버지'; // 성별 정보 (예: 할아버지, 할머니)
  Timer? _stopListeningTimer;
  final int _noInputTimeout = 5;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeTTS();
    _generateSessionId();
  }

  // TTS 초기화 및 언어 설정
  void _initializeTTS() async {
    await _tts.setLanguage("ko-KR");
    _tts.setCompletionHandler(() => setState(() => _isSpeaking = false));
  }

  // 세션 ID 생성 (사용자 고유 세션)
  void _generateSessionId() {
    final random = Random();
    _sessionId =
        List.generate(10, (index) => random.nextInt(10).toString()).join();
  }

  Future<void> _listenAndRespond() async {
    if (_isSpeaking) {
      await _tts.stop();
      setState(() => _isSpeaking = false);
      return;
    }

    if (!_isListening) {
      setState(() => _showSuggestions = false); // 음성 인식 시작 시 추천 질문 숨기기
      bool available = await _speech.initialize(
        onStatus: (status) => print("STT Status: $status"),
        onError: (error) => print("STT Error: $error"),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _recognizedText = result.recognizedWords; // 실시간 텍스트 업데이트
            });
          },
          localeId: "ko_KR",
        );
        _resetStopListeningTimer();
      } else {
        print("Speech recognition not available");
      }
    } else {
      _stopListening();
    }
  }

  Future<void> _sendMessage(String message) async {
    final url = Uri.parse('http://127.0.0.1:8000/chat/'); // 서버 URL
    final headers = {
      "accept": "application/json",
      "Content-Type": "application/json",
    };

    final body = json.encode({
      "sex": sex,
      "message": message,
      "session_id": _sessionId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _responseText = responseBody['response'];
          _tts.speak(_responseText); // AI 응답을 한글로 읽어줌
          _isSpeaking = true;
        });
      } else {
        setState(() {
          _responseText = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _responseText = "서버 연결에 실패했습니다.";
      });
    }
  }

  Future<void> _generateStory() async {
    final url = Uri.parse('http://127.0.0.1:8000/generate-story/'); // 이야기 생성 API
    final headers = {
      "accept": "application/json",
      "Content-Type": "application/json",
    };

    final body = json.encode({
      "session_id": _sessionId,
      "user_id": _userId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("이야기 생성 완료!"),
            content: Text("제목: ${responseBody['title']}\n\n${responseBody['story_text']}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("확인"),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          _responseText = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _responseText = "이야기 생성 중 오류가 발생했습니다.";
      });
    }
  }

  // 추천 질문 리스트 생성
  List<String> _getRandomSuggestions() {
    List<String> suggestions = [
      '오늘 식사는 어떠셨어요?',
      '요즘 가장 행복한 순간은 언제였나요?',
      '어제는 뭐하셨나요?',
      '오늘 기분은 어떠세요?',
      '추억의 음식이 있나요?',
      '어렸을 때 자주 놀던 놀이는 무엇인가요?',
      '어릴 적 가족과의 추억은?',
      '가장 좋아하는 노래는 뭐였나요?',
      '옛날에 자주 가셨던 곳은?',
    ];
    suggestions.shuffle();
    return suggestions.take(3).toList();
  }

  // 추천 질문 버튼 생성
  Widget _buildSuggestedQuestions() {
    List<String> randomSuggestions = _getRandomSuggestions();

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: randomSuggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _recognizedText = randomSuggestions[index];
                  _showSuggestions = false; // 추천 질문 클릭 시 추천 질문 숨기기
                });
                _sendMessage(randomSuggestions[index]); // 추천 질문 즉시 전송
              },
              child: Text(
                randomSuggestions[index],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _resetStopListeningTimer() {
    _stopListeningTimer?.cancel();
    _stopListeningTimer = Timer(Duration(seconds: _noInputTimeout), () {
      _stopListening();
    });
  }

  void _stopListening() async {
    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
      if (_recognizedText.isNotEmpty) {
        _sendMessage(_recognizedText);
      }
    }
  }

  void _stopSpeaking() async {
    if (_isSpeaking) {
      await _tts.stop();
      setState(() => _isSpeaking = false);
    }
  }

  void _popTalkScreen() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _stopListeningTimer?.cancel();
    _speech.stop();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI 손녀"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "마이크 버튼을 클릭하고 대화를 시작해 보세요!",
            style: TextStyle(fontSize: 17),
          ),

          // AI 응답 말풍선
          Stack(
            children: [
              Image.asset(
                'assets/image/speech_balloon.png',
                height: 250,
              ),
              Positioned(
                top: 50,
                left: 15,
                child: SizedBox(
                  width: 240,
                  child: Text(
                    _responseText, // AI 응답 텍스트
                    textAlign: TextAlign.left,
                    style: speechBalloonText,
                  ),
                ),
              )
            ],
          ),

          // 소녀 이미지
          Image.asset(
            'assets/image/girl.png',
            height: 300,
          ),

          // 사용자 말풍선 (하단)
          if (_recognizedText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "사용자: $_recognizedText", // 사용자 실시간 텍스트
                style: speechBalloonText,
              ),
            ),

          // 마이크 버튼
          _buildMicrophoneButton(),

          // 추천 질문 초기 표시
          if (_showSuggestions) _buildSuggestedQuestions(),

          // 이야기 생성 버튼
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromWidth(199),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: _generateStory,
            child: const Text(
              "이야기 생성",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildMicrophoneButton() {
    return Container(
      decoration: const ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      child: IconButton(
        onPressed: _listenAndRespond,
        icon: Icon(
          _isListening ? Icons.mic : Icons.mic_none,
          size: 60,
          color: _isListening ? Colors.red : Colors.blueAccent,
        ),
      ),
    );
  }
}