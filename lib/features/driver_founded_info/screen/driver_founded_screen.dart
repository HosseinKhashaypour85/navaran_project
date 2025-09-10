import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:navaran_project/features/home_features/screen/home_screen.dart';
import 'package:navaran_project/features/map_features/pref/save_money_cost_pref.dart';
import 'package:navaran_project/features/payment_screen/screen/payment_screen.dart';
import 'package:navaran_project/features/public_features/functions/navigator_animation/navigator_function.dart';
import 'package:navaran_project/features/public_features/functions/price_format/price_format_function.dart';
import 'package:navaran_project/features/public_features/screen/bottom_nav_bar_screen.dart';
import 'package:navaran_project/features/public_features/widget/snack_bar_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/driver_model.dart';
import '../widget/plate_widget.dart';

class DriverFoundedScreen extends StatefulWidget {
  const DriverFoundedScreen({super.key});

  static const String screenId = 'driver_founded';

  @override
  State<DriverFoundedScreen> createState() => _DriverFoundedScreenState();
}

class _DriverFoundedScreenState extends State<DriverFoundedScreen>
    with SingleTickerProviderStateMixin {
  LatLng? currentPosition;
  LatLng? driverPosition;
  LatLng? destinationPosition;
  final MapController mapController = MapController();

  late AnimationController _controller;
  Timer? _tripTimer;

  bool driverArrived = false;
  bool onTrip = false;

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      driverPosition =
          LatLng(position.latitude + 0.01, position.longitude + 0.01);
    });
    _startDriverAnimation();
  }

  void _startDriverAnimation() {
    if (currentPosition == null || driverPosition == null) return;

    final startDriverPos = driverPosition!;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )
      ..addListener(() {
        final lat = lerpDouble(
            startDriverPos.latitude, currentPosition!.latitude, _controller.value)!;
        final lng = lerpDouble(
            startDriverPos.longitude, currentPosition!.longitude, _controller.value)!;
        setState(() {
          driverPosition = LatLng(lat, lng);
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            driverArrived = true;
          });

          // بعد از ۵ ثانیه سفر به مقصد شروع بشه
          Future.delayed(const Duration(seconds: 5), () {
            if (!mounted) return;
            _startTripToDestination();
          });
        }
      });

    _controller.forward();
  }

  void _startTripToDestination() {
    if (currentPosition == null || driverPosition == null) return;

    final random = Random();
    destinationPosition = LatLng(
      currentPosition!.latitude + (random.nextDouble() - 0.5) * 0.02,
      currentPosition!.longitude + (random.nextDouble() - 0.5) * 0.02,
    );

    final startDriverPos = driverPosition!;

    setState(() {
      onTrip = true;
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )
      ..addListener(() {
        final lat = lerpDouble(
            startDriverPos.latitude, destinationPosition!.latitude,
            _controller.value)!;
        final lng = lerpDouble(
            startDriverPos.longitude, destinationPosition!.longitude,
            _controller.value)!;
        setState(() {
          driverPosition = LatLng(lat, lng);
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (mounted) {
            getSnackBarWidget(context, 'سفر به پایان رسید!', Colors.green);
            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.screenId, (route) => false);
          }
        }
      });

    _controller.forward();
  }

  Future<void>_tripEnded()async{
    Future.delayed(Duration(minutes: 2), () {
      getSnackBarWidget(context, 'سفر به پایان رسید', Colors.green);
      navigateWithFadeAndRemoveAll(context, BottomNavBarScreen());
    },);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _tripEnded();
  }

  @override
  void dispose() {
    _controller.dispose();
    _tripTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final driverInfoArg = arguments?['driverInfo'] as DriverModel?;
    final driverName = driverInfoArg?.name ?? "نام راننده";
    final driverCar = driverInfoArg?.carModel ?? 'ماشین یافت نشد';
    final driverPlate = driverInfoArg?.licensePlate ?? 'پلاک ناموجود';
    final driverPlateCode = driverInfoArg?.cityCode ?? '0';
    final driverAlphaBet = driverInfoArg?.alphaBet ?? 'A';
    final driverPhone = driverInfoArg?.phone ?? "شماره راننده";

    if (currentPosition == null || driverPosition == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: currentPosition!,
              initialZoom: 15.sp,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(markers: [
                Marker(
                  point: currentPosition!,
                  child: const Icon(Icons.location_on,
                      color: Colors.red, size: 50),
                ),
              ]),
              MarkerLayer(markers: [
                Marker(
                  point: driverPosition!,
                  child: const Icon(Icons.local_taxi,
                      color: Colors.green, size: 40),
                ),
              ]),
              if (destinationPosition != null)
                MarkerLayer(markers: [
                  Marker(
                    point: destinationPosition!,
                    child: const Icon(Icons.flag,
                        color: Colors.orange, size: 40),
                  ),
                ]),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [
                      driverPosition!,
                      onTrip && destinationPosition != null
                          ? destinationPosition!
                          : currentPosition!,
                    ],
                    strokeWidth: 4.0,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 40.sp,
            left: 16.sp,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.sp),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8.sp,
                    offset: Offset(0, 2.sp),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: 24.sp),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding:
              EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.sp),
                  topRight: Radius.circular(24.sp),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20.sp,
                    offset: Offset(0, -5.sp),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40.sp,
                      height: 4.sp,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.sp),
                  Center(
                    child: Text(
                      driverArrived
                          ? (onTrip ? "در حال سفر به مقصد... 🛣️" : "راننده رسید 🚖")
                          : "راننده پیدا شد!",
                      style: TextStyle(
                        fontFamily: 'peyda',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: driverArrived
                            ? (onTrip ? Colors.blue[700] : Colors.orange[700])
                            : Colors.green[700],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.sp),
                  _buildDriverInfoCard(driverName, driverCar, driverPhone),
                  SizedBox(height: 16.sp),
                  LicensePlateWidget(
                    alphaBet: driverAlphaBet,
                    cityCode: driverPlateCode,
                    licensePlate: driverPlate,
                  ),
                  SizedBox(height: 16.sp),
                  _buildCostInfo(),
                  SizedBox(height: 20.sp),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final Uri url = Uri(scheme: 'tel', path: driverPhone);
                            if (await canLaunchUrl(url)) {
                              launchUrl(url);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 56.sp),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.sp),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Icon(Icons.phone, size: 20.sp)),
                              SizedBox(width: 8.sp),
                              Text(
                                "تماس با راننده",
                                style: TextStyle(
                                  fontFamily: 'peyda',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 5.sp),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(PaymentScreen.screenId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 56.sp),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.sp),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.payment, size: 20.sp),
                              SizedBox(width: 8.sp),
                              Text(
                                "پرداخت",
                                style: TextStyle(
                                  fontFamily: 'peyda',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfoCard(String name, String car, String phone) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.person_outline, name),
          SizedBox(height: 12.sp),
          _buildInfoRow(Icons.directions_car_outlined, car),
          SizedBox(height: 12.sp),
          _buildInfoRow(Icons.phone_iphone_outlined, phone),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20.sp),
        SizedBox(width: 12.sp),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'peyda',
              fontSize: 15.sp,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCostInfo() {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Row(
        children: [
          Icon(Icons.attach_money_rounded,
              color: Colors.blue[700], size: 24.sp),
          SizedBox(width: 12.sp),
          Expanded(
            child: FutureBuilder<double>(
              future: SaveMoneyCostPref().getTripCost(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("در حال محاسبه...",
                      style: TextStyle(fontFamily: 'peyda', fontSize: 16.sp));
                } else if (snapshot.hasError) {
                  return Text("خطا در بارگذاری هزینه",
                      style: TextStyle(
                          fontFamily: 'peyda',
                          fontSize: 16.sp,
                          color: Colors.red));
                } else if (snapshot.hasData) {
                  return Text(
                    "${getPriceFormat(snapshot.data!.toStringAsFixed(0))}",
                    style: TextStyle(
                      fontFamily: 'peyda',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  );
                } else {
                  return Text("هزینه در دسترس نیست",
                      style: TextStyle(fontFamily: 'peyda', fontSize: 16.sp));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
