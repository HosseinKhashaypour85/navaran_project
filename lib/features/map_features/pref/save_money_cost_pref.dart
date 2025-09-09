import 'package:shared_preferences/shared_preferences.dart';

class SaveMoneyCostPref {
  late SharedPreferences pref;

  Future<double> getNormalTripMoneyCost() async {
    pref = await SharedPreferences.getInstance();
    final status = pref.getDouble('NormalMoneyCost') ?? 0;
    return status;
  }

  Future<void> setNormalTripMoneyCost(double value) async {
    pref = await SharedPreferences.getInstance();
    await pref.setDouble('NormalMoneyCost', value);
  }

  Future<double> getVipTripMoneyCost() async {
    pref = await SharedPreferences.getInstance();
    final status = pref.getDouble('VipMoneyCost') ?? 0;
    return status;
  }

  Future<void> setVipTripMoneyCost(double value) async {
    pref = await SharedPreferences.getInstance();
    await pref.setDouble('VipMoneyCost', value);
  }

  Future<double> getTripCost() async {
    final normal = await getNormalTripMoneyCost();
    final vip = await getVipTripMoneyCost();
    if (normal != null || normal != 0) {
      return normal;
    } else {
      return vip;
    }
  }
}
