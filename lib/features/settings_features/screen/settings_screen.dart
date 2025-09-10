import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navaran_project/features/public_features/functions/navigator_animation/navigator_function.dart';
import 'package:navaran_project/features/public_features/screen/bottom_nav_bar_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const String screenId = "settings";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _locationEnabled = true;
  String _selectedLanguage = "فارسی";
  String _selectedTheme = "سیستم";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(onPressed: ()=> navigateWithFadeAndRemoveAll(context, BottomNavBarScreen()), icon: Icon(Icons.arrow_forward_ios))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Settings Section
            _buildSectionTitle("تنظیمات حساب کاربری"),
            SizedBox(height: 8.h),
            _buildSettingItem(
              icon: Icons.person_outline,
              title: "اطلاعات شخصی",
              subtitle: "مدیریت اطلاعات حساب شما",
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.lock_outline,
              title: "امنیت و حریم خصوصی",
              subtitle: "رمزعبور، حریم خصوصی",
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.payment_outlined,
              title: "روش های پرداخت",
              subtitle: "کارت های بانکی، کیف پول",
              onTap: () {},
            ),

            SizedBox(height: 24.h),

            // App Settings Section
            _buildSectionTitle("تنظیمات برنامه"),
            SizedBox(height: 8.h),
            _buildSettingItem(
              icon: Icons.notifications_none,
              title: "اعلان ها",
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                activeColor: Colors.blue,
              ),
            ),
            _buildSettingItem(
              icon: Icons.dark_mode_outlined,
              title: "حالت شب",
              trailing: Switch(
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
                activeColor: Colors.blue,
              ),
            ),
            _buildSettingItem(
              icon: Icons.language,
              title: "زبان",
              subtitle: _selectedLanguage,
              trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
              onTap: () {
                _showLanguageDialog();
              },
            ),
            _buildSettingItem(
              icon: Icons.brush_outlined,
              title: "تم",
              subtitle: _selectedTheme,
              trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
              onTap: () {
                _showThemeDialog();
              },
            ),

            SizedBox(height: 24.h),

            // Location Section
            _buildSectionTitle("موقعیت مکانی"),
            SizedBox(height: 8.h),
            _buildSettingItem(
              icon: Icons.location_on_outlined,
              title: "دسترسی به موقعیت مکانی",
              trailing: Switch(
                value: _locationEnabled,
                onChanged: (value) {
                  setState(() {
                    _locationEnabled = value;
                  });
                },
                activeColor: Colors.blue,
              ),
            ),

            SizedBox(height: 24.h),

            // Support Section
            _buildSectionTitle("پشتیبانی"),
            SizedBox(height: 8.h),
            _buildSettingItem(
              icon: Icons.help_outline,
              title: "راهنما و پشتیبانی",
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.info_outline,
              title: "درباره برنامه",
              onTap: () {},
            ),

            SizedBox(height: 32.h),

            // App Version
            Center(
              child: Text(
                "نسخه ۱.۰.۰",
                style: TextStyle(
                  fontFamily: 'peyda',
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'peyda',
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'peyda',
            fontSize: 15.sp,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'peyda',
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        )
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              "انتخاب زبان",
              style: TextStyle(fontFamily: 'peyda'),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageOption("فارسی", "fa"),
                _buildLanguageOption("English", "en"),
                _buildLanguageOption("العربية", "ar"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language, String code) {
    return ListTile(
      title: Text(language, style: TextStyle(fontFamily: 'peyda')),
      trailing: _selectedLanguage == language
          ? Icon(Icons.check, color: Colors.blue)
          : null,
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
        Navigator.of(context).pop();
      },
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              "انتخاب تم",
              style: TextStyle(fontFamily: 'peyda'),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildThemeOption("سیستم"),
                _buildThemeOption("روشن"),
                _buildThemeOption("تیره"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(String theme) {
    return ListTile(
      title: Text(theme, style: TextStyle(fontFamily: 'peyda')),
      trailing: _selectedTheme == theme
          ? Icon(Icons.check, color: Colors.blue)
          : null,
      onTap: () {
        setState(() {
          _selectedTheme = theme;
        });
        Navigator.of(context).pop();
      },
    );
  }
}