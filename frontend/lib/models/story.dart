class Story {
  final String sessionId;
  final String userId;
  final String title;
  final String author;
  final String storyText;
  final int recommendations;
  final int views;
  final bool dailyTopic;
  final DateTime createdAt;
  final List<StoryCut> cuts;

  Story({
    required this.sessionId,
    required this.userId,
    required this.title,
    required this.author,
    required this.storyText,
    required this.recommendations,
    required this.views,
    required this.dailyTopic,
    required this.createdAt,
    required this.cuts,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    final sessionId = json['session_id'] as String;

    return Story(
      sessionId: sessionId,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      storyText: json['story_text'] as String,
      recommendations: json['recommendations'] as int,
      views: json['views'] as int,
      dailyTopic: json['daily_topic'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      cuts: (json['cuts'] as List<dynamic>)
          .map((cut) => StoryCut.fromJson(cut, sessionId))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'user_id': userId,
      'title': title,
      'author': author,
      'story_text': storyText,
      'recommendations': recommendations,
      'views': views,
      'daily_topic': dailyTopic,
      'created_at': createdAt.toIso8601String(),
      'cuts': cuts.map((cut) => cut.toJson()).toList(),
    };
  }
}

class StoryCut {
  final int page;
  final String text;
  final String description;
  final String imagePath;

  StoryCut({
    required this.page,
    required this.text,
    required this.description,
    required this.imagePath,
  });

  factory StoryCut.fromJson(Map<String, dynamic> json, String sessionId) {
    return StoryCut(
      page: json['page'] as int,
      text: json['text'] as String,
      description: json['description'] as String,
      imagePath: 'static/$sessionId/${json['page']}.png', // 동적 이미지 경로 생성
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'text': text,
      'description': description,
      'image_prompt': imagePath,
    };
  }
}