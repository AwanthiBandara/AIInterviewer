class Question {
  String id;
  String question;
  String category;

  Question({
    required this.id,
    required this.question,
    required this.category,
  });

  // Factory constructor to create a Question from JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      question: json['question'] as String,
      category: json['category'] as String,
    );
  }

  // Method to convert a Question instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'category': category,
    };
  }
}
