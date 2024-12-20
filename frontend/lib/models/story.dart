// 스토리 객체 정의
class Story {
  String title;
  String author;
  String storyText;
  String userId;
  String gender;
  int views;
  int recommendations;

  Story({
    required this.title,
    required this.author,
    required this.storyText,
    required this.userId,
    required this.gender,
    required this.views,
    required this.recommendations,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
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
