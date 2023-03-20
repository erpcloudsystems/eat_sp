import 'package:equatable/equatable.dart';

class GeneralLedgerReportEntity extends Equatable {
  final String? name;
  final String? postingDate;
  final String? account;
  final String? partyType;
  final String? party;
  final String? costCenter;
  final double? debit;
  final double? credit;
  final String? against;
  final String? againstVoucherType;
  final String? againstVoucher;
  final String? voucherType;
  final String? voucherNo;
  final String? project;
  final String? remarks;
  final String? accountCurrency;
  final String? company;
  final String? balance;

  const GeneralLedgerReportEntity({
    required this.name,
    required this.postingDate,
    required this.account,
    required this.partyType,
    required this.party,
    required this.costCenter,
    required this.debit,
    required this.credit,
    required this.against,
    required this.againstVoucherType,
    required this.againstVoucher,
    required this.voucherType,
    required this.voucherNo,
    required this.project,
    required this.remarks,
    required this.accountCurrency,
    required this.company,
    required this.balance,
  });

  @override
  List<Object?> get props => [
        name,
        postingDate,
        account,
        partyType,
        party,
        costCenter,
        debit,
        credit,
        against,
        againstVoucherType,
        againstVoucher,
        voucherType,
        voucherNo,
        project,
        remarks,
        accountCurrency,
        company,
        balance,
      ];
}
