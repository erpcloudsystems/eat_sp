part of 'faq_bloc.dart';

class FaqState extends Equatable {
  final RequestState getFagsState;
  final String getFagsFailMessage;
  final List<Faq> getFagsData;

  const FaqState({
    this.getFagsState = RequestState.loading,
    this.getFagsFailMessage = '',
    this.getFagsData = const [],
  });
  FaqState copyWith({
    RequestState? getFagsState,
    String? getFagsFailMessage,
    List<Faq>? getFagsData,
  }) =>
      FaqState(
        getFagsData: getFagsData ?? this.getFagsData,
        getFagsState: getFagsState ?? this.getFagsState,
        getFagsFailMessage: getFagsFailMessage ?? this.getFagsFailMessage,
      );

  @override
  List<Object> get props => [
        getFagsData,
        getFagsState,
        getFagsFailMessage,
      ];
}
