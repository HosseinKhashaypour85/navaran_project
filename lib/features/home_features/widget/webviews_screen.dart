import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../public_features/logic/bottom_nav/bottom_nav_cubit.dart';
import '../../public_features/screen/bottom_nav_bar_screen.dart';
import '../../public_features/widget/snack_bar_widget.dart';

class CustomWebViews extends StatefulWidget {
  const CustomWebViews({super.key});

  static const String screenId = '/customwebview';

  @override
  State<CustomWebViews> createState() => _CustomWebViewsState();
}

class _CustomWebViewsState extends State<CustomWebViews> {
  late final WebViewController _controller;
  bool canScope = false;
  int pressCount = 0;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url == 'app://prokala/succeed') {
              getSnackBarWidget(context, 'پرداخت شما با موفقیت انجام شد ✅', Colors.green);
              BlocProvider.of<BottomNavCubit>(context).changeIndex(0);
              Navigator.pushNamedAndRemoveUntil(
                context,
                BottomNavBarScreen.screenId,
                    (route) => false,
              );
              return NavigationDecision.prevent;
            } else if (request.url == 'app://prokala/failed') {
              getSnackBarWidget(context, 'پرداخت شما با شکست مواجه شد ❌ دوباره تلاش کنید', Colors.red);
              BlocProvider.of<BottomNavCubit>(context).changeIndex(0);
              Navigator.pushNamedAndRemoveUntil(
                context,
                BottomNavBarScreen.screenId,
                    (route) => false,
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://codeplusdev.ir'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PopScope(
          canPop: canScope,
          onPopInvoked: (value) async {
            final canGoBack = await _controller.canGoBack();
            if (canGoBack) {
              _controller.goBack();
              canScope = false;
            } else {
              pressCount++;
              if (pressCount == 2) {
                BlocProvider.of<BottomNavCubit>(context).changeIndex(0);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  BottomNavBarScreen.screenId,
                      (route) => false,
                );
                canScope = false;
              } else {
                Future.delayed(const Duration(milliseconds: 1500))
                    .whenComplete(() => pressCount--);
                getSnackBarWidget(
                  context,
                  'برای بازگشت به صفحه اصلی یکبار دیگر کلیک کنید',
                  Colors.black,
                );
                canScope = false;
              }
            }
          },
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
