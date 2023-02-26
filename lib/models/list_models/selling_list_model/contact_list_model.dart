import '../list_model.dart';

class ContactListModel extends ListModel<ContactItemModel> {
  ContactListModel(List<ContactItemModel>? list) : super(list);

  factory ContactListModel.fromJson(Map<String, dynamic> json) {
    var _list = <ContactItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new ContactItemModel.fromJson(v));
      });
    }
    return ContactListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class ContactItemModel {
  final String id;
  final String firstName;
  final String user;
  final String mobileNo;
  final String phone;
  final String emailId;
  final String linkDoctype;
  final String linkName;
  final String status;

  ContactItemModel({
    required this.id,
    required this.firstName,
    required this.user,
    required this.mobileNo,
    required this.phone,
    required this.emailId,
    required this.linkDoctype,
    required this.linkName,
    required this.status,
  });

  factory ContactItemModel.fromJson(Map<String, dynamic> json) {
    return ContactItemModel(
      id: json['name'] ?? 'none',
      firstName: json['first_name'] ?? 'none',
      user: json['user'] ?? 'none',
      mobileNo: json['mobile_no'] ?? 'none',
      phone: json['phone'] ?? 'none',
      emailId: json['email_id'] ?? 'none',
      linkDoctype: json['link_doctype'] ?? 'none',
      linkName: json['link_name'] ?? 'none',
      status: 'Random',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['first_name'] = this.firstName;
    data['user'] = this.user;
    data['mobile_no'] = this.mobileNo;
    data['phone'] = this.phone;
    data['email_id'] = this.emailId;
    data['link_doctype'] = this.linkDoctype;
    data['link_name'] = this.linkName;
    return data;
  }
}
