import 'package:get/get.dart';
import 'package:login_app/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  SharedPreferences loginData;

  alreadylogin() async {
    SharedPreferences loginData = await SharedPreferences.getInstance();
    String login = loginData.getString('EmailLogin') ?? '';
    update();
    print("This is login " + login.toString());
    return login;
  }

  void logInSharedPref(String email) {
    loginData.setString('EmailLogin', email);
    update();
    print(email);
    Get.offAll(HomeScreen());
  }

  void logOutSharedPref() {
    loginData.remove('Login');
    update();
  }
}
