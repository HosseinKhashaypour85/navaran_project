import 'package:flutter/material.dart';

void navigateWithFadeAndRemoveAll(BuildContext context, Widget targetPage) {
  Future.delayed(Duration.zero, () {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => targetPage,
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
          (route) => false,
    );
  });
}
