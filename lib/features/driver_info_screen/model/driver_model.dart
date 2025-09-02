class DriverModel {
  final int id;
  final String name;
  final String phone;

  DriverModel({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}