import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navaran_project/features/home_features/screen/home_screen.dart';
import 'package:navaran_project/features/profile_features/screen/profile_screen.dart';

import '../../../const/theme/colors.dart';
import '../logic/bottom_nav/bottom_nav_cubit.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  static const String screenId = 'bottomNav';

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  List<Widget> screenList = [
  HomeScreen(),
  Container(),
  ProfileScreen(),
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   BlocProvider.of<TokenCheckCubit>(context).tokenChecker();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit , int>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.black,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.black,
            selectedLabelStyle: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'peyda',
            ),
            unselectedLabelStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'peyda',
            ),
            items: [
              BottomNavigationBarItem(
                label: 'خانه',
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: 'تخفیف ها',
                icon: Icon(Icons.discount_outlined),
                activeIcon: Icon(Icons.discount),
              ),
              // BottomNavigationBarItem(
              //   label: 'اعلان ها',
              //   icon: Icon(Icons.notifications_outlined),
              //   activeIcon: Icon(Icons.notifications),
              // ),
              BottomNavigationBarItem(
                label: 'حساب کاربری',
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
              ),
            ],
            currentIndex: BlocProvider.of<BottomNavCubit>(context).currentIndex ,
            onTap: (value) {
              BlocProvider.of<BottomNavCubit>(context).changeIndex(value);
            },
          ),
          body: screenList.elementAt(BlocProvider.of<BottomNavCubit>(context).currentIndex),
        );
      },
    );
  }
}