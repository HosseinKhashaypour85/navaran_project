import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:navaran_project/const/theme/colors.dart';
import 'package:navaran_project/features/auth_features/screen/auth_screen.dart';
import 'package:navaran_project/features/public_features/functions/pre_values/pre_values.dart';
import 'package:navaran_project/features/public_features/functions/secure_storage/secure_storage.dart';
import 'package:navaran_project/features/public_features/screen/bottom_nav_bar_screen.dart';

import 'intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String screenId = 'splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  navigate()  {
    Future.delayed(Duration(seconds: 3), () async {
      final token = await SecureStorage().getUserToken();
      if (token != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          BottomNavBarScreen.screenId,
          (route) => false,
        );
      } else {
        Navigator.pushReplacementNamed(context, IntroScreen.screenId);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(), // Empty space at the top
              Center(
                // Logo centered in the middle
                child: Image.asset(PreValues().logoUrl, fit: BoxFit.contain),
              ),
              Column(
                // Spinner and padding at the bottom
                children: [
                  const SpinKitWanderingCubes(color: Colors.white, size: 40.0),
                  const SizedBox(height: 60), // Space from the bottom
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
