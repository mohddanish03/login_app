import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:login_app/HomePage.dart';
import 'package:login_app/LoginContoller.dart';
import 'package:login_app/Registration.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  final _auth = FirebaseAuth.instance;

  final LoginController controller = Get.put(LoginController());

  final formkey = GlobalKey<FormState>();

  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height / 2.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Cafe-Logo.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(120.00),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Color(0xff273377))),
                child: Container(
                  width: 380,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'SIGN IN  ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Color(0xff273377),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _emailCtrl,
                            validator: (value) => validateEmail(value),
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Color(0xff273377),
                              ),
                              labelText: 'Email',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _passCtrl,
                            validator: (val) {
                              if (val.isEmpty)
                                return 'Please Input Password';
                              else if (val.length < 8)
                                return 'Atleast 8 character';
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),
                              prefixIcon: Icon(Icons.vpn_key_outlined,
                                  color: Color(0xff273377)),
                              labelText: 'Password',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            padding: EdgeInsets.fromLTRB(100, 15, 100, 15),
                            onPressed: () {
                              checkValidation();
                              signInWithEmailAndPass(
                                  _emailCtrl.text, _passCtrl.text);
                              // Get.to(LoginPage());
                              clearTextfilde();
                              controller.logInSharedPref();
                            },
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  color: Color(0xff273377),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an Account ?",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff273377),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(Resgistration());
                                  print('tapped');
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                      color: Color(0xff273377),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void signInWithEmailAndPass(String email, String pass) async {
    await Firebase.initializeApp();
    try {
      final User user =
          (await _auth.signInWithEmailAndPassword(email: email, password: pass))
              .user;
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      Get.to(HomeScreen());
      print(user.uid + "this is unique id ");
    } catch (e) {
      print(e + 'This is errrrroooorrr');
    }
  }

  clearTextfilde() {
    _emailCtrl.clear();
    _passCtrl.clear();
  }

  validateName(String fullname) {
    if (fullname.isEmpty) {
      return 'Enter your name';
    }
    return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Enter a valid email address';
    else
      return null;
  }

  String confirmPassword(String password) {
    if (password.isEmpty) return 'Please Comfirm Password';
    if (password != _passCtrl.text) return 'Password Do not match';
    return null;
  }

  checkValidation() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      //move to next screen
    }
  }
}
