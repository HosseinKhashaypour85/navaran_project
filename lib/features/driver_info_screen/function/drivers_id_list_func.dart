import '../model/driver_model.dart';

class DriversIdListFunc {
  final List<DriverModel> _drivers = [
    DriverModel(id: 101, name: "Ali", phone: "09120000001"),
    DriverModel(id: 102, name: "Reza", phone: "09120000002"),
    DriverModel(id: 103, name: "Sara", phone: "09120000003"),
    DriverModel(id: 104, name: "Hossein", phone: "09120000004"),
  ];
  Future<List<DriverModel>>getAllDrviers()async{
    return _drivers;
  }
}