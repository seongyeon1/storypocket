import 'package:flutter/material.dart';
import 'package:my_project/point.dart';
import 'package:my_project/style/fontstyle.dart';

class ElderPointScreen extends StatefulWidget {
  const ElderPointScreen({super.key});

  @override
  State<ElderPointScreen> createState() => _ElderPointScreenState();
}

class _ElderPointScreenState extends State<ElderPointScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 포인트'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.monetization_on, size: 60),
                  const SizedBox(height: 8.0),
                  const Text(
                    '홍길동 님의 누적 포인트',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    leftPoint.toString(),
                    style: const TextStyle(
                        fontSize: 40.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.monetization_on,
                    size: 30,
                  ),
                  title: Text(
                    '포인트 적립 내역',
                    style: menuFontsize(),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.bolt, size: 30),
                  title: Text(
                    '포인트 충전소',
                    style: menuFontsize(),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart, size: 30),
                  title: Text(
                    '스토어',
                    style: menuFontsize(),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.settings, size: 30),
                  title: Text(
                    '포인트 설정',
                    style: menuFontsize(),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
