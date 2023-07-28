import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  bool isLoggedIn = false;
  String phoneNumber = '';

  Future<void> signIn(String phone) async {
    phoneNumber = phone;
    isLoggedIn = true;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isLoggedIn', isLoggedIn);
    await preferences.setString('phoneNumber', phoneNumber);
  }

  Future<void> signOut() async {
    phoneNumber = '';
    isLoggedIn = false;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('isLoggedIn');
    await preferences.remove('phoneNumber');
  }

  Future<void> checkAuthState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoggedIn = preferences.getBool('isLoggedIn') ?? false;
    phoneNumber = preferences.getString('phoneNumber') ?? '';
  }

  bool isAuthenticated() {
    return isLoggedIn;
  }
}
