// 스토리 객체 정의
class StoryBook {
  String title;
  String author;
  String storyText;
  String userId;
  String gender;
  int views;
  int recommendations;

  StoryBook({
    required this.title,
    required this.author,
    required this.storyText,
    required this.userId,
    required this.gender,
    required this.views,
    required this.recommendations,
  });

  factory StoryBook.fromJson(Map<String, dynamic> json) {
    return StoryBook(
      title: json['title'],
      author: json['author'],
      storyText: json['story_text'],
      userId: json['user_id'],
      gender: json['gender'],
      views: json['views'],
      recommendations: json['recommendations'],
    );
  }
}
