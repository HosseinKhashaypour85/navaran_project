import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:navaran_project/const/shape/border_radius.dart';
import 'package:navaran_project/const/theme/colors.dart';
import 'package:navaran_project/features/auth_features/widget/textformfield.dart';
import 'package:navaran_project/features/public_features/functions/pref/save_phone_number.dart';
import 'code_validation_screen.dart';

class AuthScreen extends StatefulWidget {
  static const String screenId = 'auth';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  bool isValidPhone(String input) {
    final regex = RegExp(r'^9\d{9}$'); // 10 digits starting with 9 (without 0)
    return regex.hasMatch(input);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    setState(() {
      _isLoading = true;
    });

    await SavePhoneNumber().savePhoneNumber(phoneNum: _controller.text);

    // شبیه‌سازی تأخیر مثل درخواست شبکه
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    Navigator.pushNamed(context, CodeValidationScreen.screenId);
  }

  @override
  Widget build(BuildContext context) {
    final isValidPhoneNumber = isValidPhone(_controller.text);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: primary2Color),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: getBorderRadiusFunc(100),
        ),
        backgroundColor: isValidPhoneNumber ? primary2Color : Colors.grey,
        onPressed: isValidPhoneNumber && !_isLoading ? _onSubmit : null,
        child: _isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: SpinKitThreeBounce(
            color: Colors.white,
            size: 10,
          ),
        )
            : const Icon(Icons.arrow_forward, color: Colors.white),
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
    );
  }
}
