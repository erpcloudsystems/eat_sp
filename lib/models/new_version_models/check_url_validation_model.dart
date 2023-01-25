class CheckUrlValidationModel {
  final String message;
  CheckUrlValidationModel({required this.message});

  factory CheckUrlValidationModel.fromJson(Map<String, dynamic> json) =>
      CheckUrlValidationModel(message: json['message']);
}
