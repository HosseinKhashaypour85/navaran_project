part of 'otp_bloc.dart';

@immutable
abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoadingState extends OtpState{}

class OtpSentSuccess extends OtpState{
  final String successMsg;
  OtpSentSuccess(this.successMsg);
}

class OtpVerifiedSuccess extends OtpState{
  final String msg;
  OtpVerifiedSuccess(this.msg);
}

class OtpFailure extends OtpState {
  final String error;
  OtpFailure(this.error);
}