import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const/responsive.dart';

class OnlineCardWidget extends StatefulWidget {
  final String title;
  final String price;
  final Color startColor;
  final Color endColor;
  final String duration;
  final bool isPopular;
  final String desc;
  final bool isSelected;
  final VoidCallback onSelect;

  const OnlineCardWidget({
    Key? key,
    this.title = "پرداخت آنلاین",
    this.price = "پرداخت امن با درگاه بانکی",
    this.startColor = const Color(0xFF6A11CB),
    this.endColor = const Color(0xFF2575FC),
    this.duration = "ماهانه",
    this.isPopular = false,
    this.desc = "موجودی ناکافی",
    this.isSelected = false,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<OnlineCardWidget> createState() => _OnlineCardWidgetState();
}

class _OnlineCardWidgetState extends State<OnlineCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelect,
      child: Container(
        width: double.infinity,
        height: 120.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: widget.isSelected
                ? [widget.startColor.withOpacity(0.9), widget.endColor.withOpacity(0.9)]
                : [widget.startColor, widget.endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.startColor.withOpacity(widget.isSelected ? 0.5 : 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
          border: widget.isSelected
              ? Border.all(
            color: Colors.white,
            width: 2.0,
          )
              : null,
        ),
        child: Stack(
          children: [
            // Background pattern
            Align(
              alignment: Alignment.bottomLeft,
              child: Opacity(
                opacity: 0.1,
                child: Icon(
                  Icons.payment,
                  size: 80.sp,
                  color: Colors.white,
                ),
              ),
            ),

            // Selection indicator
            if (widget.isSelected)
              Positioned(
                top: 2.sp,
                right: 12.sp,
                child: Container(
                  padding: EdgeInsets.all(4.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: widget.startColor,
                    size: 16.sp,
                  ),
                ),
              ),

            // Popular badge
            if (widget.isPopular)
              Positioned(
                top: 12.sp,
                left: 12.sp,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade500,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "پیشنهادی",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'peyda',
                    ),
                  ),
                ),
              ),

            // Content
            Padding(
              padding: EdgeInsets.all(16.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'peyda',
                          ),
                        ),
                        SizedBox(height: 6.sp),
                        Text(
                          widget.price,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14.sp,
                            fontFamily: 'peyda',
                          ),
                        ),
                        if (widget.desc.isNotEmpty) SizedBox(height: 6.sp),
                        if (widget.desc.isNotEmpty)
                          Text(
                            widget.desc,
                            style: TextStyle(
                              color: Colors.red.shade600,
                              fontSize: 14.sp,
                              fontFamily: 'peyda',
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.sp),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(widget.isSelected ? 0.3 : 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "انتخاب",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'peyda',
                          ),
                        ),
                        SizedBox(width: 4.sp),
                        Icon(
                          Icons.arrow_back,
                          size: 16.sp,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}