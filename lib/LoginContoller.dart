import 'package:get/get.dart';
import 'package:login_app/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  @override
  void onInit() {
    check_alreadylogin();
    print('HomePageController initialized');
  }

  SharedPreferences loginData;
  bool new_user;

  void check_alreadylogin() async {
    loginData = await SharedPreferences.getInstance();
    new_user = (loginData.getBool('Login') ?? true);
    print(new_user);
    Get.offAll(HomeScreen());
  }

  void logInSharedPref() {
    loginData.setBool('Login', false);
  }

  void logOutSharedPref() {
    loginData.setBool('Login', true);
  }
}
