import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/faq_entity.dart';
import '../../../../core/utils/request_state.dart';
import '../../domain/usecases/get_faqs_use_case.dart';

part 'faq_event.dart';
part 'faq_state.dart';

class FaqBloc extends Bloc<FaqEvent, FaqState> {
  final GetFaqsUseCase _getFaqsUseCase;

  FaqBloc(this._getFaqsUseCase) : super(const FaqState()) {
    on<GetFagsEvent>(_getFaqs);
  }

  FutureOr<void> _getFaqs(GetFagsEvent event, Emitter<FaqState> emit) async {
    if (state.getFagsState != RequestState.loading) {
      emit(state.copyWith(getFagsState: RequestState.loading));
    }
    final response = await _getFaqsUseCase(event.tag);

    response.fold(
      (failure) => emit(state.copyWith(
        getFagsState: RequestState.error,
        getFagsFailMessage: failure.errorMessage,
      )),
      (faqs) => emit(state.copyWith(
        getFagsState: RequestState.success,
        getFagsData: faqs,
      )),
    );
  }
}
