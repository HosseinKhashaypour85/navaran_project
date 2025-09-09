import 'dart:math';

import '../model/driver_model.dart';

class DriversIdListFunc {
  final List<DriverModel> _drivers = [
    DriverModel(
      id: 101,
      name: "علی محمدی",
      phone: "09123456789",
      carModel: 'پرااید سفید',
      cityCode: '10',
      licensePlate: '344',
      alphaBet: 'غ',
    ),
    DriverModel(
      id: 102,
      name: "رضا حسینی",
      phone: "09124567890",
      carModel: 'کوییک سفید',
      cityCode: '33',
      licensePlate: '855',
      alphaBet: 'ب',
    ),
    DriverModel(
      id: 103,
      name: "سارا احمدی",
      phone: "09125678901",
      carModel: 'ساینا مشکی',
      cityCode: '80',
      licensePlate: '556',
      alphaBet: 'ز',
    ),
    DriverModel(
      id: 104,
      name: "حسین رضایی",
      phone: "09126789012",
      carModel: 'ال90 سفید',
      cityCode: '90',
      licensePlate: '999',
      alphaBet: 'ی',
    ),
  ];

  Future<List<DriverModel>> getAllDrviers() async {
    return _drivers;
  }

  Future<DriverModel?> selectRandomDriver() async {
    if (_drivers.isEmpty) {
      return null;
    }
    Random random = Random();
    int randomIndex = random.nextInt(_drivers.length);
    return _drivers[randomIndex];
  }
}
