class DriverModel {
  final int id;
  final String name;
  final String phone;
  final String carModel;
  final String licensePlate; // شماره پلاک
  final String cityCode;
  final String alphaBet;

  DriverModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.carModel,
    required this.licensePlate,
    required this.cityCode,
    required this.alphaBet,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      carModel: json['cardModel'],
      licensePlate: json['licensePlate'],
      cityCode: json['cityCode'],
      alphaBet: json['alphaBet'],
    );
  }
}