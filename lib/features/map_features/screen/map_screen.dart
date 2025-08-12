import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:navaran_project/const/shape/media_query.dart';
import 'package:navaran_project/features/public_features/widget/loading_states_widget.dart';
import 'package:navaran_project/features/public_features/widget/null_location_widget.dart';

import '../../../const/shape/border_radius.dart';
import '../widget/location_input_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);
  static const String screenId = 'map';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? currentPosition;
  LatLng? destinationPosition;
  bool isLoading = true;
  String origin = '';
  String destination = '';

  final Dio dio = Dio(
    BaseOptions(
      headers: {"User-Agent": "FlutterApp"}, // ضروری برای Nominatim
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    ),
  );

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      // بررسی فعال بودن سرویس GPS
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        setState(() => isLoading = false);
        return;
      }

      // بررسی و درخواست مجوز
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        setState(() => isLoading = false);
        return;
      }

      // دریافت موقعیت با timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 20),
      );

      final originAddress = await getAddressFormat(position.latitude, position.longitude);
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
        origin = originAddress;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Location error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<String> getAddressFormat(double lat, double lng) async {
    try {
      final url =
          "https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&zoom=18&addressdetails=1";

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        return response.data["display_name"] ?? "آدرس پیدا نشد";
      } else {
        return "آدرس پیدا نشد";
      }
    } catch (e) {
      debugPrint("Reverse geocoding error: $e");
      return "آدرس پیدا نشد";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingStatesWidget(stuffObjectName: 'نقشه',);
    }

    if (currentPosition == null) {
      return NullLocationWidget();
    }

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: currentPosition!,
              initialZoom: 15,
              onTap: (tapPosition, point) async {
                setState(() {
                  destinationPosition = point;
                  destination = "در حال دریافت آدرس...";
                });
                final originAddress = await getAddressFormat(
                  currentPosition!.latitude,
                  currentPosition!.longitude,
                );
                final address = await getAddressFormat(
                  point.latitude,
                  point.longitude,
                );
               if(!mounted) return;
               setState(() {
                 origin = originAddress;
                 destination = address;
               });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              PolylineLayer(
                polylines: [
                  if (currentPosition != null && destinationPosition != null)
                    Polyline(
                      points: [currentPosition!, destinationPosition!],
                      strokeWidth: 4,
                      color: Colors.blueAccent,
                    ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: currentPosition!,
                    width: 60,
                    height: 60,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                  if (destinationPosition != null)
                    Marker(
                      point: destinationPosition!,
                      width: 60,
                      height: 60,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            destinationPosition = null;
                            destination = '';
                          });
                        },
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                    ),
                ],
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: currentPosition!,
                    color: Colors.blue.withOpacity(0.3),
                    borderStrokeWidth: 2,
                    borderColor: Colors.blue,
                    radius: 50,
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: Container(
                    width: getAllWidth(context),
                    height: getHeight(context, 0.2.sp),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 5.sp),
                        buildLocationInput(
                          icon: Icons.location_on,
                          hint: origin.isEmpty ? 'مبدا را وارد کنید' : origin,
                          onTap: () {},
                        ),
                        SizedBox(height: 8.sp),
                        buildLocationInput(
                          icon: Icons.location_on,
                          hint:
                              destination.isEmpty
                                  ? 'مقصد را وارد کنید'
                                  : destination,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

