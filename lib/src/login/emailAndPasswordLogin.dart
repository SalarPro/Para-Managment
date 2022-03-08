import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pare/src/home_screen/home_screen.dart';
import 'package:pare/src/tools/FadeAnimation.dart';
import 'package:pare/src/login/SignUpScreen.dart';
import 'package:pare/src/login/emailAndPasswordRegister.dart';
import 'package:pare/src/tools/utility.dart';
import 'package:pare/src/provider/user_provider.dart';
import 'package:pare/src/provider/para_service.dart';
import 'package:provider/provider.dart';

class LoginEmailAndPassword extends StatefulWidget {
  static String routeName = 'LoginEmailAndPassword';

  @override
  State<LoginEmailAndPassword> createState() => _LoginEmailAndPasswordState();
}

class _LoginEmailAndPasswordState extends State<LoginEmailAndPassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/background.png'),
                            fit: BoxFit.fill)),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 30,
                          width: 80,
                          height: 200,
                          child: FadeAnimation(
                              1,
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage('images/light-1.png'))),
                              )),
                        ),
                        Positioned(
                          left: 140,
                          width: 80,
                          height: 150,
                          child: FadeAnimation(
                              1.3,
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage('images/light-2.png'))),
                              )),
                        ),
                        Positioned(
                          right: 40,
                          top: 40,
                          width: 80,
                          height: 150,
                          child: FadeAnimation(
                              1.5,
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('images/clock.png'))),
                              )),
                        ),
                        Positioned(
                          child: FadeAnimation(
                              1.6,
                              Container(
                                margin: EdgeInsets.only(top: 50),
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(
                              1.8,
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(143, 148, 251, .2),
                                          blurRadius: 20.0,
                                          offset: Offset(0, 10))
                                    ]),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[100]!))),
                                      child: TextFormField(
                                        validator: (value) {
                                          return (value ?? '').isValidEmail()
                                              ? null
                                              : "Check your email";
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: emailTextEditingController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Email",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null ||
                                              value.length < 6) {
                                            return 'Password is incorrect';
                                          }
                                          return null;
                                        },
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        obscureText: true,
                                        controller:
                                            passwordTextEditingController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Password",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          FadeAnimation(
                              2,
                              GestureDetector(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      var userUID =
                                          await Provider.of<AuthProvider>(
                                                  context,
                                                  listen: false)
                                              .signIn(
                                                  emailTextEditingController
                                                      .text,
                                                  passwordTextEditingController
                                                      .text);
                                      var isUserAvailable =
                                          await Provider.of<AuthProvider>(
                                                  context,
                                                  listen: false)
                                              .fetchUserInfo(userUID);
                                      if (isUserAvailable) {
                                        await Provider.of<ParaService>(context,
                                                listen: false)
                                            .firstInitialize();

                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            HomeScreenView.routeName,
                                            (route) => false);
                                      } else {
                                        Navigator.pushNamed(
                                            context, SignUpScreen.routeName);
                                      }
                                    } catch (e) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Utility.showToast(msg: e.toString());
                                    }
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(colors: [
                                        Color.fromRGBO(143, 148, 251, 1),
                                        Color.fromRGBO(143, 148, 251, .6),
                                      ])),
                                  child: const Center(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )),
                          TextButton(
                              onPressed: () async {
                                if (emailTextEditingController.text
                                    .isValidEmail()) {
                                  try {
                                    await Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .resetPassword(
                                            emailTextEditingController.text);

                                    Utility.showToast(
                                        msg:
                                            'The reset password link have been sent to your email, please check your email to reset your passwords');
                                  } catch (error) {
                                    Utility.showToast(msg: error.toString());
                                  }
                                } else {
                                  Utility.showToast(msg: 'Your email is wrong');
                                }
                              },
                              child: const Text('I forgot my password!')),
                          const SizedBox(
                            height: 70,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RegisterEmailAndPassword.routeName);
                            },
                            child: Text(
                              'Dont have an account?\nRegister here',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoading
              ? Center(
                  child: Container(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator.adaptive()),
                )
              : Container()
        ],
      ),
    );
  }

  String? validateName(String value) {
    if (!(value.length > 1) && value.isNotEmpty) {
      return "please enter name correctly";
    }
    return null;
  }
}
