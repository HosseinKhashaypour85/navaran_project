import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:navaran_project/features/map_features/model/new_trip_model.dart';
import 'package:navaran_project/features/map_features/services/new_trip_api_repository.dart';
import 'package:navaran_project/features/public_features/functions/error/error_exception.dart';
import 'package:navaran_project/features/public_features/functions/error/error_message_class.dart';

part 'req_new_trip_event.dart';

part 'req_new_trip_state.dart';

class ReqNewTripBloc extends Bloc<ReqNewTripEvent, ReqNewTripState> {
  final NewTripApiRepository repository;

  ReqNewTripBloc(this.repository) : super(ReqNewTripInitial()) {
    on<CallReqNewTrip>((event, emit) async {
      emit(ReqNewTripLoadingState());
      try {
        NewTripModel newTripModel = await repository.callNewTripApiRepository(
          passengerId: event.passengerId,
          origin: event.origin,
          destination: event.destination,
        );
        emit(ReqNewTripCompletedState(newTripModel: newTripModel));
      } on DioException catch (e) {
        emit(
          ReqNewTripErrorState(
            error: ErrorMessageClass(errorMsg: ErrorExceptions().fromError(e)),
          ),
        );
      }
    });
  }
}
