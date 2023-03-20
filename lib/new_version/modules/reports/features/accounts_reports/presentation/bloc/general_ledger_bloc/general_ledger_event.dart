part of 'general_ledger_bloc.dart';

abstract class GeneralLedgerEvent extends Equatable{
  const GeneralLedgerEvent();

  @override
  List<Object> get props => [];
}

class GetGeneralLedgerEvent extends GeneralLedgerEvent {
  final GeneralLedgerFilters generalLedgerFilters;

  const GetGeneralLedgerEvent({
    required this.generalLedgerFilters,
  });

  @override
  List<Object> get props => [
    generalLedgerFilters,
  ];
}

class ResetGeneralLedgerEvent extends GeneralLedgerEvent {
  const ResetGeneralLedgerEvent();
}

class ChangePartyTypeEvent extends GeneralLedgerEvent {
  final bool isPartyType;
  const ChangePartyTypeEvent(this.isPartyType);
}