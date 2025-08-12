part of 'otp_bloc.dart';

@immutable
abstract class OtpEvent {}

class SendOtpEvent extends OtpEvent {
  final String mobile;

  SendOtpEvent({required this.mobile});
}

class VerifyOtpEvent extends OtpEvent {
  final String mobile;
  final String code;
  VerifyOtpEvent(this.mobile, this.code);
}
