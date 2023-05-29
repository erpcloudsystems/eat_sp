import 'package:equatable/equatable.dart';

class GeneralLedgerFilters extends Equatable {
  final String? account;
  final String? partyType;
  final String? party;
  final String? toDate;
  final String? fromDate;
  final int? startKey;

  const GeneralLedgerFilters({
    this.account,
    this.partyType,
    this.party,
    this.toDate,
    this.fromDate,
    this.startKey = 0,
  });

  @override
  List<Object?> get props => [
        account,
        partyType,
        party,
        toDate,
        fromDate,
        startKey,
      ];
}
