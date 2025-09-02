import 'package:flutter/material.dart';

class DiscountCodeField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onSubmitted;

  const DiscountCodeField({
    Key? key,
    required this.controller,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.blue.shade300,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintText: 'کد تخفیف را وارد کنید',
          hintStyle: TextStyle(
            color: Colors.blue.shade400,
            fontWeight: FontWeight.w500,
            fontFamily: 'peyda',
          ),
          prefixIcon: Icon(
            Icons.discount_outlined,
            color: Colors.blue.shade400,
            size: 24,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.blue.shade400,
            ),
            onPressed: () {
              if (onSubmitted != null && controller.text.isNotEmpty) {
                onSubmitted!(controller.text);
              }
            },
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
        style: TextStyle(
          color: Colors.blue.shade800,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        textCapitalization: TextCapitalization.characters,
      ),
    );
  }
}