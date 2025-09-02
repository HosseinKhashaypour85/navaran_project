class NewTripModel {
  NewTripModel({
      this.trips,});

  NewTripModel.fromJson(dynamic json) {
    if (json['trips'] != null) {
      trips = [];
      json['trips'].forEach((v) {
        trips?.add(Trips.fromJson(v));
      });
    }
  }
  List<Trips>? trips;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (trips != null) {
      map['trips'] = trips?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Trips {
  Trips({
      this.id, 
      this.passengerId, 
      this.driverId, 
      this.origin, 
      this.destination, 
      this.status, 
      this.requestedAt, 
      this.completedAt,});

  Trips.fromJson(dynamic json) {
    id = json['id'];
    passengerId = json['passenger_id'];
    driverId = json['driver_id'];
    origin = json['origin'];
    destination = json['destination'];
    status = json['status'];
    requestedAt = json['requested_at'];
    completedAt = json['completed_at'];
  }
  int? id;
  int? passengerId;
  int? driverId;
  String? origin;
  String? destination;
  String? status;
  String? requestedAt;
  dynamic completedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['passenger_id'] = passengerId;
    map['driver_id'] = driverId;
    map['origin'] = origin;
    map['destination'] = destination;
    map['status'] = status;
    map['requested_at'] = requestedAt;
    map['completed_at'] = completedAt;
    return map;
  }

}