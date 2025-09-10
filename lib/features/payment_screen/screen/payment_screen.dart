import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navaran_project/const/shape/border_radius.dart';
import 'package:navaran_project/features/map_features/pref/save_money_cost_pref.dart';
import 'package:navaran_project/features/payment_screen/screen/paymentwebview_screen.dart';
import 'package:navaran_project/features/payment_screen/widget/bank_card_widget.dart';
import 'package:navaran_project/features/public_features/functions/price_format/price_format_function.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  static const String screenId = 'payment';

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedMethod = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Color(0xFFF8F9FA),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.sp),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: getBorderRadiusFunc(10),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Payment card section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: getBorderRadiusFunc(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'مبلغ قابل پرداخت',
                      style: TextStyle(
                        fontFamily: 'peyda',
                        fontSize: 16.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 12.sp),
                    FutureBuilder<double>(
                      future: SaveMoneyCostPref().getTripCost(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: 40.sp,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'خطا در بارگذاری',
                            style: TextStyle(
                              fontFamily: 'peyda',
                              fontSize: 14.sp,
                              color: Colors.red.shade400,
                            ),
                          );
                        } else {
                          final tripCost = snapshot.data ?? 0;
                          return Text(
                            getPriceFormat(tripCost.toString()),
                            style: TextStyle(
                              fontFamily: 'peyda',
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                              letterSpacing: -0.5,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 8.sp),
                    // Text(
                    //   'تومان',
                    //   style: TextStyle(
                    //     fontFamily: 'peyda',
                    //     fontSize: 14.sp,
                    //     color: Colors.grey.shade500,
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 24.sp),

              // Payment methods title
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'روش های پرداخت',
                  style: TextStyle(
                    fontFamily: 'peyda',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              SizedBox(height: 16.sp),

              // Online payment card
              OnlineCardWidget(
                title: "پرداخت آنلاین",
                price: "پرداخت امن با درگاه بانکی",
                startColor: const Color(0xFF6A11CB),
                endColor: const Color(0xFF2575FC),
                isPopular: true,
                desc: "",
                isSelected: selectedMethod == 0,
                onSelect: () {
                  setState(() {
                    selectedMethod = 0;
                  });
                },
              ),
              SizedBox(height: 16.sp),

              // Bank cards section
              OnlineCardWidget(
                title: "پرداخت از کیف پول",
                price: "پرداخت امن با ناوران پی",
                startColor: const Color(0xFF6A11CB),
                endColor: const Color(0xFF2575FC),
                isPopular: false,
                isSelected: selectedMethod == 1,
                onSelect: () {
                  setState(() {
                    selectedMethod = 1;
                  });
                },
              ),
              SizedBox(height: 24.sp),

              // Payment button
              SizedBox(
                width: double.infinity,
                height: 50.sp,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, PaymentSWebViewScreen.screenId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2575FC),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: getBorderRadiusFunc(12),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    textStyle: TextStyle(
                      fontFamily: 'peyda',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text('پرداخت'),
                ),
              ),
              SizedBox(height: 16.sp),

              // Security assurance
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.security,
                    size: 16.sp,
                    color: Colors.grey.shade500,
                  ),
                  SizedBox(width: 6.sp),
                  Text(
                    'پرداخت امن با SSL',
                    style: TextStyle(
                      fontFamily: 'peyda',
                      fontSize: 12.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
