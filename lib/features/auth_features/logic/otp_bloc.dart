import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:navaran_project/features/auth_features/services/otp_repository.dart';

part 'otp_event.dart';

part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final OtpRepository repository;

  OtpBloc(this.repository) : super(OtpInitial()) {
    on<SendOtpEvent>((event, emit) async {
      emit(OtpLoadingState());
      try {
        final res = await repository.sendOtp(event.mobile);
        emit(OtpSentSuccess('کد یکبار مصرف با موفقیت ارسال شد !'));
      } on DioException catch (e) {
        emit(OtpFailure(e.toString()));
      }
    });
    on<VerifyOtpEvent>((event, emit) async {
      emit(OtpLoadingState());
      try {
        final res = await repository.verifyOtp(event.mobile, event.code);
        emit(OtpVerifiedSuccess('کد یکبار مصرف با موفقیت ارسال شد !'));
      } on DioException catch (e) {
        emit(OtpFailure(e.toString()));
      }
    });
  }
}
