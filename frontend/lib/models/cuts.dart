class Cut {
  int page;
  String text;
  String description;
  String imagePrompt;

  Cut({
    required this.page,
    required this.text,
    required this.description,
    required this.imagePrompt,
  });

  // JSON 객체를 Cut 객체로 변환하는 팩토리 생성자
  factory Cut.fromJson(Map<String, dynamic> json) {
    return Cut(
      page: json['page'],
      text: json['text'],
      description: json['description'],
      imagePrompt: json['image_prompt'],
    );
  }
}
