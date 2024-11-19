import 'package:flutter/material.dart';
import '../storybook/elder_storybook_screen.dart';
import '../community/elder_community_screen.dart';
import '../talk/talk_screen.dart';

class ElderHomeScreen extends StatefulWidget {
  const ElderHomeScreen({super.key});

  @override
  State<ElderHomeScreen> createState() => _ElderHomeScreenState();
}

class _ElderHomeScreenState extends State<ElderHomeScreen> {
  void _showTalkScreen() {
    // TODO: 이야기 하기 화면으로 이동하는 로직 구현
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const TalkScreen()));
  }

  // 커뮤니티 화면으로 이동하는 함수
  void _showCommunityScreen() {
    // TODO: 커뮤니티 화면으로 이동하는 로직 구현
    // print('커뮤니티 화면으로 이동');
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => const ElderCommunityScreen()));
  }

  // 동화책 구경하기 화면으로 이동하는 함수
  void _showContantsScreen() {
    // TODO: 동화책 구경하기 화면으로 이동하는 로직 구현
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ElderContantsScreen()));
  }

  // 내 포인트 확인 화면으로 이동하는 함수
  void _showPointScreen() {
    // TODO: 내 포인트 확인 화면으로 이동하는 로직 구현
    print('내 포인트 확인 화면으로 이동');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /* 메뉴사진 */
          Image.asset("assets/image/grandma_grandpa.png"),
          const SizedBox(height: 20),
          /* 메뉴화면 */
          const Text("원하시는 서비스를 선택해주세요."),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
            shrinkWrap: true, // GridView 크기를 내용물에 맞게 조정
            crossAxisCount: 2, // 2개의 열을 가진 그리드
            // childAspectRatio: 2.5, // 가로 세로 비율 조정
            padding: const EdgeInsets.all(16.0), // 그리드 주변 여백 추가
            mainAxisSpacing: 20.0, // 세로 간격
            crossAxisSpacing: 16.0, // 가로 간격
            children: [
              _buildGridButton(_showTalkScreen, '이야기 하기', Icons.call),
              _buildGridButton(_showCommunityScreen, '커뮤니티', Icons.forum),
              _buildGridButton(
                  _showContantsScreen, '동화책 구경하기', Icons.menu_book),
              _buildGridButton(
                  _showPointScreen, '내 포인트 확인', Icons.monetization_on),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildGridButton(VoidCallback showScreen, String text, IconData icon) {
  return ElevatedButton(
    onPressed: showScreen,
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          bottom: 50,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Positioned(
          top: 50,
          child: Icon(
            icon,
            size: 30,
          ),
        ),
      ],
    ),
  );
}