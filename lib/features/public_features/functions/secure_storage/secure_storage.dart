import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  Future<String?>getUserToken()async{
    final token = await FlutterSecureStorage().read(key: 'token');
    return token;
  }
  Future<void>saveUserToken(token)async{
    await FlutterSecureStorage().write(key: 'token', value: token);
  }
  Future<void> deleteUserToken() async {
    FlutterSecureStorage().delete(key: 'token');
  }
}