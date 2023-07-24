import '../../domain/entities/faq_entity.dart';

class FaqModel extends Faq {
  const FaqModel(
      {required super.question, required super.answer, required super.tag});

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        question: json['question'] ?? 'none',
        answer: json['answer'] ?? 'none',
        tag: json['tag'] ?? 'none',
      );
}
