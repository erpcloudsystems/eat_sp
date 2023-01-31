import '../../../models/list_models/list_model.dart';
import 'package:uuid/uuid.dart';

class EmailTableModel extends ListModel<EmailModel> {
  EmailTableModel(List<EmailModel>? list) : super(list);

  factory EmailTableModel.fromJson(Map<String, dynamic> json) {
    var _list = <EmailModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new EmailModel.fromJson(v));
      });
    }
    return EmailTableModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson).toList();
    return data;
  }
}

class EmailModel {
  String id;
  String emailId;
  int isPrimary;



  EmailModel(
      {
        required this.id,
        required this.emailId,
        required this.isPrimary,

      });

  factory EmailModel.fromJson(Map<String, dynamic> json) {
    return EmailModel(
      id: json['id'] ?? Uuid().v1().toString(),
      emailId: json['email_id'] ?? '',
      isPrimary: json['is_primary'] ?? 0,

    );
  }

  Map<String, dynamic> get toJson {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email_id'] = this.emailId;
    data['is_primary'] = this.isPrimary;

    return data;
  }

  @override
  bool operator ==(Object other) =>
      other is EmailModel && this.emailId == other.emailId;

  @override
  int get hashCode => emailId.hashCode;

}


