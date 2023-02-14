import 'package:equatable/equatable.dart';

class DriverModel extends Equatable {
  final String name, fullName, employee, status;

  DriverModel({
    required this.name,
    required this.fullName,
    required this.employee,
    required this.status,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        name: json['name'],
        fullName: json['full_name'],
        employee: json['employee'],
        status: json['status'],
      );
      
  @override
  List<Object?> get props => [
        name,
        fullName,
        employee,
        status,
      ];
}
