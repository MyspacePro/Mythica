class HelpFaqModel {
  final String question;
  final String answer;

  HelpFaqModel({
    required this.question,
    required this.answer,
  });

  factory HelpFaqModel.fromMap(Map<String, dynamic> map) {
    return HelpFaqModel(
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}