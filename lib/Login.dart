import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:login_app/HomePage.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  final _auth = FirebaseAuth.instance;

  final formkey = GlobalKey<FormState>();

  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: ListView(
        children: [
          SizedBox(
            height: 30,
          ),
          Column(
            children: [
              Text(
                "Sign In",
                style: TextStyle(fontSize: 20),
              ),
              Container(
                width: 360,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailCtrl,
                            validator: (value) => validateEmail(value),
                            decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                prefixIcon: Icon(Icons.email_outlined),
                                labelText: 'Email'),
                          ),
                          SizedBox(
                            height: 30,
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
                                prefixIcon: Icon(Icons.lock_open),
                                border: OutlineInputBorder(),
                                labelText: 'Password'),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          RaisedButton(
                            padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                            color: Colors.green,
                            onPressed: () {
                              checkValidation();
                              signInWithEmailAndPass(
                                  _emailCtrl.text, _passCtrl.text);
                              // Get.to(LoginPage());
                              clearTextfilde();
                            },
                            child: Text('SIGN IN'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      )),
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
