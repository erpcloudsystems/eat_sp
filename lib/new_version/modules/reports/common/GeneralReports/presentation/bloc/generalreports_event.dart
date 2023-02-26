part of 'generalreports_bloc.dart';

abstract class GeneralReportsEvent extends Equatable {
  const GeneralReportsEvent();

  @override
  List<Object> get props => [];
}

class GetAllReportsEvent extends GeneralReportsEvent {
  final String moduleName;
  GetAllReportsEvent({required this.moduleName});
}
