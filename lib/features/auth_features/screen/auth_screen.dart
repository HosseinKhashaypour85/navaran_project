import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:navaran_project/const/shape/border_radius.dart';
import 'package:navaran_project/const/theme/colors.dart';
import 'package:navaran_project/features/auth_features/widget/textformfield.dart';
import 'package:navaran_project/features/public_features/functions/pref/save_phone_number.dart';
import 'package:navaran_project/features/public_features/widget/snack_bar_widget.dart';
import '../logic/otp_bloc.dart';
import 'code_validation_screen.dart';

class AuthScreen extends StatefulWidget {
  static const String screenId = 'auth';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _controller = TextEditingController();

  bool isValidPhone(String input) {
    final regex = RegExp(r'^9\d{9}$'); // 10 digits starting with 9 (without 0)
    return regex.hasMatch(input);
  }

  @override
  void initState() {
    super.initState();
    // Add a listener to update the UI when text changes
    _controller.addListener(() {
      setState(() {}); // This will rebuild widgets that depend on the controller's text
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpBloc, OtpState>(
      listener: (context, state) async {
        if (state is OtpSentSuccess) {
          await SavePhoneNumber().savePhoneNumber(phoneNum: _controller.text);
          Navigator.pushNamed(context, CodeValidationScreen.screenId);
        } else if (state is OtpFailure) {
          getSnackBarWidget(context, state.error, Colors.red);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: primary2Color),
        floatingActionButton: BlocBuilder<OtpBloc, OtpState>(
          builder: (context, state) {
            final isValidPhoneNumber = isValidPhone(_controller.text);
            final isLoadingState = state is OtpLoadingState;

            return ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, child) {
                return FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: getBorderRadiusFunc(100),
                  ),
                  backgroundColor: isValidPhone(value.text)
                      ? primary2Color
                      : Colors.grey,
                  onPressed: isValidPhone(value.text) && !isLoadingState
                      ? () {
                    final fullNumber = '0${_controller.text.trim()}';
                    context.read<OtpBloc>().add(SendOtpEvent(mobile: fullNumber));
                  }
                      : null,
                  child: isLoadingState
                      ? SizedBox(
                    width: 24,
                    height: 24,
                    child: SpinKitThreeBounce(
                      color: Colors.white,
                      size: 10,
                    ),
                  )
                      : const Icon(Icons.arrow_forward, color: Colors.white),
                );
              },
            );
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20.sp),
              Text(
                'برای استفاده از سرویس های ناوران شماره موبایل خود را وارد کنید',
                style: TextStyle(fontFamily: 'kalameh', fontSize: 14.sp),
              ),
              Padding(
                padding: EdgeInsets.all(20.sp),
                child: TextFormFieldMobileWidget(
                  controller: _controller,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  textInputAction: TextInputAction.done,
                  labelText: 'شماره موبایل',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}