import 'package:equatable/equatable.dart';

class Faq extends Equatable {
  final String question, answer, tag;

  const Faq({required this.question, required this.answer, required this.tag});

  @override
  List<String> get props => [question, answer, tag];
}
