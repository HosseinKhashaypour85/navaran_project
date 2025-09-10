import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navaran_project/features/home_features/widget/services_type_widget.dart';
import 'package:navaran_project/features/home_features/widget/webviews_screen.dart';
import 'package:navaran_project/features/public_features/functions/navigator_animation/navigator_function.dart';
import 'package:navaran_project/features/settings_features/screen/settings_screen.dart';
import '../../map_features/screen/map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String screenId = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color(0xFFF8FAFD),
            elevation: 0,
            pinned: true,
            floating: true,
            expandedHeight: 0,
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20.sp,
                    child: IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.grey.shade700,
                        size: 22.sp,
                      ),
                      onPressed: () => navigateWithFadeAndRemoveAll(context, SettingsScreen()),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ✅ Header Section
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // متن خوشامدگویی (فعلاً کامنت شده بود)
                    // Text(
                    //   'سلام!',
                    //   textDirection: TextDirection.rtl,
                    //   style: TextStyle(
                    //     fontFamily: 'kalameh',
                    //     fontSize: 24.sp,
                    //     color: Colors.black,
                    //     fontWeight: FontWeight.w800,
                    //   ),
                    // ),
                    SizedBox(height: 4.h),
                    // Text(
                    //   'چه خدمتی نیاز دارید؟',
                    //   textDirection: TextDirection.rtl,
                    //   style: TextStyle(
                    //     fontFamily: 'kalameh',
                    //     fontSize: 16.sp,
                    //     color: Colors.grey.shade600,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),

          // ✅ Services Grid
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildListDelegate([
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ServicesTypeWidget(
                    label: 'درخواست سرویس',
                    imagePath: 'assets/images/car.png',
                    backgroundColor: const Color(0xFF2D5BFF),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2D5BFF), Color(0xFF4D7AFF)],
                    ),
                    onTap: () {
                      navigateWithFadeAndRemoveAll(context, const MapScreen());
                    },
                  ),
                ),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ServicesTypeWidget(
                      label: 'درخواست بلیط هواپیما',
                      imagePath: 'assets/images/plane.png',
                      backgroundColor: const Color(0xFF6A5AE0),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF6A5AE0), Color(0xFF9087E5)],
                      ),

                      onTap: () =>
                          Navigator.pushNamed(context, CustomWebViews.screenId)
                  ),
                ),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ServicesTypeWidget(
                    label: 'رزرو هتل',
                    imagePath: 'assets/images/hotel.png',
                    backgroundColor: const Color(0xFF20BF6B),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF20BF6B), Color(0xFF7DE6A8)],
                    ),
                      onTap: () =>
                          Navigator.pushNamed(context, CustomWebViews.screenId)
                  ),
                ),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ServicesTypeWidget(
                    label: 'تورهای گردشگری',
                    imagePath: 'assets/images/tourism.png',
                    backgroundColor: const Color(0xFFFD746C),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFD746C), Color(0xFFFF9068)],
                    ),
                      onTap: () =>
                          Navigator.pushNamed(context, CustomWebViews.screenId)
                  ),
                ),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ServicesTypeWidget(
                    label: 'رستوران‌ها',
                    imagePath: 'assets/images/restaurant.png',
                    backgroundColor: const Color(0xFFFF8A00),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFF8A00), Color(0xFFFFB267)],
                    ),
                      onTap: () =>
                          Navigator.pushNamed(context, CustomWebViews.screenId)
                  ),
                ),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ServicesTypeWidget(
                    label: 'خرید آنلاین',
                    imagePath: 'assets/images/online-shop.png',
                    backgroundColor: const Color(0xFF8E44AD),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF8E44AD), Color(0xFFBB8FCE)],
                    ),
                      onTap: () =>
                          Navigator.pushNamed(context, CustomWebViews.screenId)
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
