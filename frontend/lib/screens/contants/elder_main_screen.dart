import 'package:flutter/material.dart';
import 'package:my_project/screens/contants/profile/elder_profile_sceen.dart';
import 'elder_home_screen.dart';

class ElderMainScreen extends StatefulWidget {
  const ElderMainScreen({super.key});

  @override
  State<ElderMainScreen> createState() => _ElderMainScreenState();
}

class _ElderMainScreenState extends State<ElderMainScreen> {
  int _selectedIndex = 0; // 현재 인덱스

  /* 메뉴 탭 화면 이동 함수*/
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      /* 화면 */
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          ElderHomeScreen(), // 홈 화면
          ElderProfileSceen(),
        ],
      ),

      /* 네비게이션 메뉴 */
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 20.0, // 선택된 항목 글씨 크기
        unselectedFontSize: 20.0, // 선택되지 않은 항목 글씨 크기
        type: BottomNavigationBarType.fixed, //메뉴 4개 이상
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 30,
            ),
            label: '나의 발자취',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
