import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navaran_project/features/auth_features/logic/otp_bloc.dart';
import 'package:navaran_project/features/auth_features/services/otp_repository.dart';
import 'package:navaran_project/features/home_features/screen/home_screen.dart';
import 'package:navaran_project/features/intro_features/logic/intro_cubit.dart';
import 'package:navaran_project/features/intro_features/screen/intro_screen.dart';
import 'package:navaran_project/features/intro_features/screen/splash_screen.dart';
import 'package:navaran_project/features/public_features/logic/bottom_nav/bottom_nav_cubit.dart';

import 'features/auth_features/screen/auth_screen.dart';
import 'features/auth_features/screen/code_validation_screen.dart';
import 'features/map_features/screen/map_screen.dart';
import 'features/public_features/screen/bottom_nav_bar_screen.dart';
import 'features/public_features/widget/loading_states_widget.dart';
import 'features/public_features/widget/null_location_widget.dart';

void main() {
  runApp(const MyApp());
  HttpOverrides.global = MyHttpOverrides();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder:
          (context, child) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => IntroCubit()),
              BlocProvider(create: (context) => OtpBloc(OtpRepository())),
              BlocProvider(create: (context) => BottomNavCubit()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('fa')],
              routes: {
                SplashScreen.screenId: (context) => SplashScreen(),
                BottomNavBarScreen.screenId: (context) => BottomNavBarScreen(),
                AuthScreen.screenId: (context) => AuthScreen(),
                IntroScreen.screenId: (context) => IntroScreen(),
                MapScreen.screenId: (context) => MapScreen(),
                HomeScreen.screenId: (context) => HomeScreen(),
                CodeValidationScreen.screenId:
                    (context) => CodeValidationScreen(),
                NullLocationWidget.screenId: (context) => NullLocationWidget(),
                LoadingStatesWidget.screenId:
                    (context) => LoadingStatesWidget(stuffObjectName: '',),
              },
              initialRoute: MapScreen.screenId,
            ),
          ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
