part of 'req_new_trip_bloc.dart';

@immutable
abstract class ReqNewTripEvent {}

class CallReqNewTrip extends ReqNewTripEvent {
  final String passengerId;
  final String origin;
  final String destination;

  CallReqNewTrip({
    required this.passengerId,
    required this.origin,
    required this.destination,
  });
}
