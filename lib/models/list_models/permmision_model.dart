class PermissionModel {
  final String docType;
  final bool permission;

  PermissionModel({required this.docType, required this.permission});

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      PermissionModel(
        docType: json['document_name'] ?? '',
        permission: json['has_permission'] ?? true,
      );
}
