import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:navaran_project/const/shape/media_query.dart';
import 'package:navaran_project/const/theme/colors.dart';
import 'package:navaran_project/features/finding_driver_features/screen/finding_driver_screen.dart';
import 'package:navaran_project/features/map_features/logic/req_new_trip_bloc.dart';
import 'package:navaran_project/features/map_features/widget/discount_field_widget.dart';
import 'package:navaran_project/features/map_features/widget/trip_options_widget.dart';
import 'package:navaran_project/features/public_features/functions/navigator_animation/navigator_function.dart';
import 'package:navaran_project/features/public_features/functions/price_format/price_format_function.dart';
import 'package:navaran_project/features/public_features/screen/bottom_nav_bar_screen.dart';
import 'package:navaran_project/features/public_features/widget/loading_states_widget.dart';
import 'package:navaran_project/features/public_features/widget/null_location_widget.dart';

import '../../../const/shape/border_radius.dart';
import '../../public_features/widget/snack_bar_widget.dart';
import '../widget/location_input_widget.dart';
import '../widget/service_card_widget.dart';

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
  final MapController _mapController = MapController();
  bool showLocationBox = true;
  double? normalTripPrice;
  double? vipTripPrice;
  bool isNormalServicesSelected = true;
  final TextEditingController discountController = TextEditingController();

  final Dio dio = Dio(
    BaseOptions(
      headers: {"User-Agent": "FlutterApp"},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        if (mounted) {
          setState(() => isLoading = false);
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() => isLoading = false);
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        if (mounted) {
          setState(() => isLoading = false);
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout:
            () => Position.fromMap({
              'latitude': currentPosition?.latitude ?? 35.6892,
              'longitude': currentPosition?.longitude ?? 51.3890,
              'timestamp': DateTime.now().millisecondsSinceEpoch,
              'accuracy': 0.0,
            }),
      );

      final originAddress = await getAddressFormat(
        position.latitude,
        position.longitude,
      );

      if (mounted) {
        setState(() {
          currentPosition = LatLng(position.latitude, position.longitude);
          origin = originAddress;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Location error: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> calculatePrices(LatLng origin, LatLng destination) async {
    try {
      final url =
          'https://router.project-osrm.org/route/v1/driving/'
          '${origin.longitude},${origin.latitude};'
          '${destination.longitude},${destination.latitude}?overview=false';

      final response = await dio.get(url);

      final distanceMeters = response.data['routes'][0]['distance'];
      final durationSeconds = response.data['routes'][0]['duration'];

      // Calculate prices
      double normalBaseFare = 20000;
      double normalPricePerKm = 5000;
      double normalPricePerMin = 1000;

      double distanceKm = distanceMeters / 1000;
      double durationMin = durationSeconds / 60;

      double normalTotalPrice =
          normalBaseFare +
          (distanceKm * normalPricePerKm) +
          (durationMin * normalPricePerMin);

      double vipBaseFare = 50000;
      double vipPricePerKm = 20000;
      double vipPricePerMin = 3000;

      double vipTotalPrice =
          vipBaseFare +
          (distanceKm * vipPricePerKm) +
          (durationMin * vipPricePerMin);

      setState(() {
        normalTripPrice = normalTotalPrice;
        vipTripPrice = vipTotalPrice;
      });
    } on DioException catch (e) {
      print(e);
      getSnackBarWidget(context, 'خطا در محاسبه قیمت', Colors.red);
    }
  }

  Future<void> showModalBottomNav(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Wrap(
              // این باعث میشه ارتفاع به اندازه محتوا باشه
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min, // ارتفاع برابر با محتوا
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: DiscountCodeField(controller: discountController),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // کدت اینجا
                      },
                      child: Text('تایید کد تخفیف'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _autoCalculatePrice() async {
    if (currentPosition != null && destinationPosition != null) {
      await calculatePrices(currentPosition!, destinationPosition!);
    } else {
      setState(() {
        normalTripPrice = null;
        vipTripPrice = null;
      });
    }
  }

  Future<String> getAddressFormat(double lat, double lng) async {
    try {
      final url =
          "https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&zoom=18&addressdetails=1";
      final response = await dio.get(url);
      if (!mounted) return "آدرس پیدا نشد";
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
      return const LoadingStatesWidget(stuffObjectName: 'نقشه');
    }

    if (currentPosition == null) {
      return const NullLocationWidget();
    }

    final double bottomContainerHeight = getHeight(context, 0.2.sp);
    final double fabSize = 56;

    return BlocListener<ReqNewTripBloc, ReqNewTripState>(
      listener: (context, state) {
        if (state is ReqNewTripCompletedState) {
          getSnackBarWidget(
            context,
            'درخواست سفر با موفقیت ثبت شد',
            Colors.green,
          );
          // Navigate to trip tracking screen or home
          Navigator.pushNamedAndRemoveUntil(
            context,
            FindingDriverScreen.screenId,
                (route) => false, // این خط تمام صفحات قبلی را پاک می‌کند
            arguments: {
              'id': state.newTripModel.trips?.first.id, // استفاده از اولین trip در لیست
              'state': 'tryToFind',
            },
          );
        } else if (state is ReqNewTripErrorState) {
          getSnackBarWidget(
            context,
            state.error.errorMsg.toString(),
            Colors.red,
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.sp),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    navigateWithFadeAndRemoveAll(
                      context,
                      const BottomNavBarScreen(),
                    );
                  },
                  icon: Icon(Icons.arrow_forward, color: primaryColor),
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentPosition!,
                initialZoom: 15,
                onTap: (tapPosition, point) async {
                  setState(() {
                    destinationPosition = point;
                    destination = "در حال دریافت آدرس...";
                    normalTripPrice = null;
                    vipTripPrice = null;
                  });
                  final address = await getAddressFormat(
                    point.latitude,
                    point.longitude,
                  );
                  if (!mounted) return;
                  setState(() {
                    destination = address;
                  });
                  await _autoCalculatePrice();
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
                          onTap: () {
                            setState(() {
                              destinationPosition = null;
                              destination = '';
                              showLocationBox = true;
                              normalTripPrice = null;
                              vipTripPrice = null;
                            });
                          },
                          child: const Icon(
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
              ],
            ),
            if (showLocationBox)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: Container(
                    width: getAllWidth(context),
                    height: bottomContainerHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: getBorderRadiusFunc(10),
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
                        SizedBox(height: 8.sp),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary2Color,
                            fixedSize: Size(
                              getWidth(context, 0.8.sp),
                              getHeight(context, 0.06.sp),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: getBorderRadiusFunc(10),
                            ),
                          ),
                          onPressed:
                              destinationPosition != null
                                  ? () {
                                    calculatePrices(
                                      currentPosition!,
                                      destinationPosition!,
                                    );
                                    setState(() {
                                      showLocationBox = false;
                                    });
                                  }
                                  : null,
                          child: Text(
                            'تایید مقصد',
                            style: TextStyle(
                              fontFamily: 'kalameh',
                              color: Colors.white,
                              fontSize: 17.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
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
                    children: [
                      if (normalTripPrice != null && vipTripPrice != null)
                        Column(
                          children: [
                            buildServiceCard(
                              title: 'سرویس ویژه',
                              imagePath: 'assets/images/car.png',
                              price: vipTripPrice!,
                              isSelected: !isNormalServicesSelected,
                              context: context,
                              onTap: () {
                                if (destinationPosition == null ||
                                    destination.isEmpty) {
                                  setState(() {
                                    showLocationBox = true;
                                  });
                                }
                                setState(() {
                                  isNormalServicesSelected = false;
                                });
                              },
                            ),
                            buildServiceCard(
                              title: 'سرویس عادی',
                              imagePath: 'assets/images/car2.png',
                              price: normalTripPrice!,
                              isSelected: isNormalServicesSelected,
                              context: context,
                              onTap: () {
                                if (destinationPosition == null ||
                                    destination.isEmpty) {
                                  setState(() {
                                    showLocationBox = true;
                                  });
                                }
                                setState(() {
                                  isNormalServicesSelected = true;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildTripOptionsWidget(
                                  Icons.discount,
                                  'کد تخفیف',
                                  () {
                                    // showModalBottomSheet(context: context, builder: (context) {
                                    //   return Container();
                                    // },);
                                    showModalBottomNav(context);
                                  },
                                ),
                                buildTripOptionsWidget(
                                  Icons.list,
                                  'گزینه های سفر',
                                  () {},
                                ),
                              ],
                            ),
                          ],
                        )
                      else
                        Text(
                          'در حال محاسبه قیمت...',
                          style: TextStyle(
                            fontFamily: 'kalameh',
                            fontSize: 16.sp,
                          ),
                        ),
                      SizedBox(height: 10.sp),
                      BlocBuilder<ReqNewTripBloc, ReqNewTripState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary2Color,
                              minimumSize: Size(double.infinity, 50.sp),
                              shape: RoundedRectangleBorder(
                                borderRadius: getBorderRadiusFunc(10),
                              ),
                            ),
                            onPressed:
                                state is ReqNewTripLoadingState
                                    ? null
                                    : () {
                                      if (destinationPosition != null &&
                                          destination.isNotEmpty) {
                                        context.read<ReqNewTripBloc>().add(
                                          CallReqNewTrip(
                                            passengerId: '09121000892',
                                            // Replace with actual user ID
                                            origin: origin,
                                            destination: destination,
                                          ),
                                        );
                                      } else {
                                        getSnackBarWidget(
                                          context,
                                          'لطفاً مقصد را انتخاب کنید',
                                          Colors.red,
                                        );
                                      }
                                    },
                            child:
                                state is ReqNewTripLoadingState
                                    ? SpinKitThreeBounce(
                                      color: Colors.white,
                                      size: 15.sp,
                                    )
                                    : Text(
                                      'درخواست خودرو',
                                      style: TextStyle(
                                        fontFamily: 'kalameh',
                                        color: Colors.white,
                                        fontSize: 17.sp,
                                      ),
                                    ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              bottom:
                  showLocationBox
                      ? bottomContainerHeight + 20
                      : (normalTripPrice != null && vipTripPrice != null)
                      ? getHeight(context, 0.45.sp)
                      : getHeight(context, 0.2.sp),
              right: 20,
              child: FloatingActionButton(
                backgroundColor: primary2Color,
                onPressed: () {
                  if (currentPosition != null) {
                    _mapController.move(currentPosition!, 15);
                  }
                },
                child: const Icon(
                  Icons.my_location_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
