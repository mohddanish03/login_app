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
    return ListView(
      children: [
        SizedBox(
          height: 30,
        ),
        Column(
          children: [
            Text(
              "Create Account",
              style: TextStyle(fontSize: 20),
            ),
            Container(
              width: 360,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameCtrl,
                          validator: (value) => validateName(value),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person_outline_outlined),
                              border: OutlineInputBorder(),
                              labelText: 'Full Name'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: _emailCtrl,
                          validator: (value) => validateEmail(value),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(),
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
                        TextFormField(
                          controller: _confirmPassCtrl,
                          validator: (val) => confirmPassword(val),
                          obscureText: true,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline),
                              border: OutlineInputBorder(),
                              labelText: 'Confirm Password'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                          color: Colors.green,
                          onPressed: () {
                            checkValidation();
                            _signUp(_emailCtrl.text, _confirmPassCtrl.text);
                            clearTextfilde();
                          },
                          child: Text('Register'),
                        ),
                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                          color: Colors.green,
                          onPressed: () {
                            Get.to(LoginScreen());
                          },
                          child: Text('Already SignedIn'),
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
        print(user1.displayName);
      }
    }
  }
}
