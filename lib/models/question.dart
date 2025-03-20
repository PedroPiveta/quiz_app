class Question {
  int? id;
  String question;
  List<String> options;
  int answer;

  Question({
    this.id,
    required this.question,
    required this.options,
    required this.answer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options.join(','),
      'answer': answer,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      question: map['question'],
      options: map['options'].split(','),
      answer: map['answer'],
    );
  }
}
