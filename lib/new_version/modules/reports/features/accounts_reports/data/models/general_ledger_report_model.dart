import '../../domain/entities/general_ledger_report_entity.dart';

class GeneralLedgerModel extends GeneralLedgerReportEntity {
  const GeneralLedgerModel({
    required super.name,
    required super.postingDate,
    required super.account,
    required super.partyType,
    required super.party,
    required super.costCenter,
    required super.debit,
    required super.credit,
    required super.against,
    required super.againstVoucherType,
    required super.againstVoucher,
    required super.voucherType,
    required super.voucherNo,
    required super.project,
    required super.remarks,
    required super.accountCurrency,
    required super.company,
    required super.balance,
  });

  factory GeneralLedgerModel.fromJson(Map<String, dynamic> json) =>
      GeneralLedgerModel(
        name: json['name'] ?? 'none',
        postingDate: json['posting_date'] ?? 'none',
        account: json['account'] ?? 'none',
        partyType: json['party_type'] ?? 'none',
        party: json['party'] ?? 'none',
        costCenter: json['cost_center'] ?? 'none',
        debit: json['debit'] ?? 'none',
        credit: json['credit'] ?? 'none',
        against: json['against'] ?? 'none',
        againstVoucherType: json['against_voucher_type'] ?? 'none',
        againstVoucher: json['against_voucher'] ?? 'none',
        voucherType: json['voucher_type'] ?? 'none',
        voucherNo: json['voucher_no'] ?? 'none',
        project: json['project'] ?? 'none',
        remarks: json['remarks'] ?? 'none',
        accountCurrency: json['account_currency'] ?? 'none',
        company: json['company'] ?? 'none',
        balance: json['balance'].toString(),
      );

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
