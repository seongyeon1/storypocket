// 스토리 객체 정의
import 'package:my_project/models/cuts.dart';

class StoryBook {
  String title;
  String author;
  String userId;
  String sessionId;
  String gender;
  int views;
  int recommendations;
  List<Cut> cuts;

  StoryBook({
    required this.title,
    required this.author,
    required this.userId,
    required this.sessionId,
    required this.gender,
    required this.views,
    required this.recommendations,
    required this.cuts,
  });

  factory StoryBook.fromJson(Map<String, dynamic> json) {
    return StoryBook(
      title: json['title'],
      author: json['author'],
      userId: json['user_id'],
      sessionId: json['session_id'],
      gender: json['gender'],
      views: json['views'],
      recommendations: json['recommendations'],
      cuts: (json['cuts'] as List)
          .map((cutJson) => Cut.fromJson(cutJson))
          .toList(),
    );
  }
}
