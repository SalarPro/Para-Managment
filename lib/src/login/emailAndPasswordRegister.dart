import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pare/src/home_screen/home_screen.dart';
import 'package:pare/src/tools/FadeAnimation.dart';
import 'package:pare/src/tools/utility.dart';
import 'package:pare/src/models/user_model.dart';
import 'package:pare/src/provider/user_provider.dart';
import 'package:pare/src/provider/para_service.dart';
import 'package:pare/src/tools/SPColors.dart';
import 'package:pare/src/tools/new_user_data.dart';
import 'package:provider/provider.dart';

class RegisterEmailAndPassword extends StatefulWidget {
  static String routeName = 'RegisterEmailAndPassword';

  @override
  State<RegisterEmailAndPassword> createState() =>
      _RegisterEmailAndPasswordState();
}

class _RegisterEmailAndPasswordState extends State<RegisterEmailAndPassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController firstNameTextEditingController =
      TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();

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
                                margin: const EdgeInsets.only(top: 50),
                                child: const Center(
                                  child: Text(
                                    "Register",
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
                                              : "Type your email in the correct way";
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
                                    //Password
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[100]!))),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null ||
                                              value.length < 6) {
                                            return 'Password should be 6 or more character';
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
                                    ),
                                    //First Name
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[100]!))),
                                      child: TextFormField(
                                        validator: (value) {
                                          return null;
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller:
                                            firstNameTextEditingController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "First name (optional)",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                      ),
                                    ),
                                    //Last Name
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        validator: (value) {
                                          return null;
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller:
                                            lastNameTextEditingController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Last Name (optional)",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                      ),
                                    ),
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
                                  register();
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
                                      "Register",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 70,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: SPColors.mainColor.withAlpha(100),
                  child: Center(
                    child: Container(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator.adaptive()),
                  ),
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

  register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        var userUID = await Provider.of<AuthProvider>(context, listen: false)
            .registerWithEmailAndPassword(emailTextEditingController.text,
                passwordTextEditingController.text);

        GeneralUser generalUser = GeneralUser(
            uid: FirebaseAuth.instance.currentUser!.uid,
            phonenumber: FirebaseAuth.instance.currentUser!.phoneNumber,
            email: FirebaseAuth.instance.currentUser?.email,
            firstName: firstNameTextEditingController.text,
            lastName: lastNameTextEditingController.text);

        Provider.of<AuthProvider>(context, listen: false).generalUser =
            generalUser;

        await Provider.of<AuthProvider>(context, listen: false)
            .generalUser!
            .save();

        await Provider.of<ParaService>(context, listen: false)
            .firstInitialize();

        await NewUserData().getCategoryList(context);

        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreenView.routeName,
          (route) => false,
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        Utility.showToast(msg: e.toString());
      }
    }
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
