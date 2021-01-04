import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:login_app/Login.dart';

class Resgistration extends StatefulWidget {
  Resgistration({Key key}) : super(key: key);

  @override
  ResgistrationState createState() => ResgistrationState();
}

class ResgistrationState extends State<Resgistration> {
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _confirmPassCtrl = TextEditingController();
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height / 3.4,
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
                      key: _formkey,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'CREATE ACCOUNT',
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
                            controller: _nameCtrl,
                            validator: (value) => validateName(value),
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.person_outline_outlined,
                                color: Color(0xff273377),
                              ),
                              labelText: 'Full Name',
                            ),
                          ),
                          SizedBox(
                            height: 20,
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
                          TextFormField(
                            controller: _confirmPassCtrl,
                            validator: (val) => confirmPassword(val),
                            obscureText: true,
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),
                              prefixIcon: Icon(Icons.lock_outline_rounded,
                                  color: Color(0xff273377)),
                              labelText: 'Confirm Password',
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
                              _signUp(_emailCtrl.text, _passCtrl.text);
                              // Get.to(LoginPage());
                              clearTextfilde();
                            },
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                  color: Color(0xff273377),
                                  fontSize: 17,
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
                                'Already a member ? ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff273377),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(LoginScreen());
                                  print('tapped');
                                },
                                child: Text(
                                  'Login',
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

  clearTextfilde() {
    _nameCtrl.clear();
    _emailCtrl.clear();
    _passCtrl.clear();
    _confirmPassCtrl.clear();
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
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      //move to next screen
    }
  }

//sample for registration
  void register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _passCtrl.text, password: _confirmPassCtrl.text);
      print(userCredential.additionalUserInfo.username);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

//sample for registration ----working--method---
  void _signUp(String email, String password) async {
    await Firebase.initializeApp();
    final User user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
        Get.to(LoginScreen());
        final user1 = _auth.currentUser;
      }
    }
  }
}
