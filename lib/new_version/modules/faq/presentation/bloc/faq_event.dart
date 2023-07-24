part of 'faq_bloc.dart';

abstract class FaqEvent extends Equatable {
  const FaqEvent();

  @override
  List<Object?> get props => [];
}

class GetFagsEvent extends FaqEvent {
  final String? tag;

  const GetFagsEvent({this.tag});
  @override
  List<Object?> get props => [tag];
}
