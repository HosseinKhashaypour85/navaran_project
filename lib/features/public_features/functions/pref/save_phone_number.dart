import 'package:shared_preferences/shared_preferences.dart';

class SavePhoneNumber {
  Future<void> savePhoneNumber({required String phoneNum}) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('phoneNum', phoneNum);
  }

  Future<String?> getPhoneNumber() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('phoneNum');
  }

  Future<void> clearPhoneNumber() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('phoneNum');
  }
}
