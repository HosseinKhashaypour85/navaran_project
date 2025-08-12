import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navaran_project/const/theme/colors.dart';

class TextFormFieldMobileWidget extends StatelessWidget {
  final String labelText;
  final TextInputAction textInputAction;
  final FloatingLabelBehavior floatingLabelBehavior;
  final TextEditingController controller;
  final Widget? icon;
  final Widget? suffixIcon;

  const TextFormFieldMobileWidget({
    super.key,
    required this.controller,
    required this.labelText,
    required this.textInputAction,
    required this.floatingLabelBehavior,
    this.icon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      cursorColor: boxColors,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: floatingLabelBehavior,
        labelStyle: const TextStyle(
          fontFamily: 'peyda',
          color: primary2Color,
          fontSize: 16,
        ),
        suffixText: "| +98",
        suffixStyle: const TextStyle(color: Colors.black54, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // ✅ این خط مشکل تداخل لیبل با بوردر رو حل می‌کنه
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        counter: const SizedBox.shrink(),
        icon: icon,
        suffixIcon: suffixIcon,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'لطفا شماره را وارد کنید';
        }
        if (value.length < 10) {
          return 'شماره وارد شده معتبر نیست';
        }
        return null;
      },
    );
  }
}
