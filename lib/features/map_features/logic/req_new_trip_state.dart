part of 'req_new_trip_bloc.dart';

@immutable
abstract class ReqNewTripState {}

class ReqNewTripInitial extends ReqNewTripState {}

class ReqNewTripLoadingState extends ReqNewTripState {}

class ReqNewTripCompletedState extends ReqNewTripState {
  final NewTripModel newTripModel;
  ReqNewTripCompletedState({required this.newTripModel});
}

class ReqNewTripErrorState extends ReqNewTripState {
  final ErrorMessageClass error;
  ReqNewTripErrorState({required this.error});
}
