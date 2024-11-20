import 'package:flutter/material.dart';
import 'package:my_project/young/young_storybook_screen.dart';

class YoungHomeScreen extends StatefulWidget {
  const YoungHomeScreen({super.key});

  @override
  State<YoungHomeScreen> createState() => _YoungHomeScreenState();
}

class _YoungHomeScreenState extends State<YoungHomeScreen> {
  int _selectedIndex = 0; // 현재 인덱스
  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

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
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Page1(),
          const YoungStorybookScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: '동화 보기',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow),
              label: '이야기 보기',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '나의 발자취',
            ),
          ],
          currentIndex: 0, // 현재 페이지는 커뮤니티
          onTap: onItemTapped),
    );
  }

  Padding Page1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '무엇을 찾고싶으신가요?',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSectionTitle('인기 이야기들'),
                _buildStoryItem(
                    '30년만에 본 내 누이', '2024.2.27 11:25 AM', '좋아요 101 댓글 28'),
                _buildStoryItem(
                    '기브미 초꼬레또', '2024.10.01 9:28 AM', '좋아요 98 댓글 27'),
                _buildStoryItem(
                    '나의 어린시절', '2024.11.01 9:28 AM', '좋아요 98 댓글 27'),
                _buildSectionTitle('인기 동화들'),
                _buildStoryItem('두만강 건넜던 그 시절', '2024.10.11 10:41 AM', '좋아요 1'),
                _buildStoryItem(
                    '나성에 가면 편지를 띄우세요', '2024.10.10 1:41 PM', '좋아요 2'),
                _buildStoryItem('전쟁 전 나의 이야기', '2024.11.10 1:41 PM', '좋아요 2'),
                _buildSectionTitle('실시간 인기 태그'),
                _buildTagList(
                    ['#6.25', '#민주화', '#4.3사건', '#IMF', '#산업화', '#이산가족']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStoryItem(String title, String date, String likesComments) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage("assets/image/grandma_grandpa.png"),
      ),
      title: Text(title),
      subtitle: Text('$date | $likesComments'),
      onTap: () {
        // TODO: 이야기 상세 페이지로 이동하는 로직 구현
      },
    );
  }

  Widget _buildTagList(List<String> tags) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: tags.map((tag) => Chip(label: Text(tag))).toList(),
      ),
    );
  }
}
