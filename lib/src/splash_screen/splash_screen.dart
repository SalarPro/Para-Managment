import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pare/src/home_screen/home_screen.dart';
import 'package:pare/src/login/main_login_screen.dart';
import 'package:pare/src/provider/app_provider.dart';
import 'package:pare/src/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreenView extends StatefulWidget {
  static var routeName = '/';

  const SplashScreenView({Key? key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override

  /*
  there is two posiblity for running openNExtScreen()
  one is timer
  second is by pressing the view
  if user presed the view it will show main view, after that the timer will not stop , so the timer also will open the main view
  to stop that we wll check if it;s opened before or not*/
  bool isScreenStated = false;

  // splash screen Will disappear after 4 seconds
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () => openNExtScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    openNExtScreen();
                  },
                  child: Center(
                    child: Container(
                        margin: const EdgeInsets.only(
                            top: 80.0, left: 20.0, right: 20.0),
                        child: Lottie.asset('assets/main_wallet_1.json')),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    openNExtScreen();
                  },
                  child: SizedBox(
                    width: 250.0,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                          color: Color.fromARGB(255, 82, 81, 81),
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                      child: AnimatedTextKit(
                        pause: Duration(seconds: 1),
                        animatedTexts: [
                          TypewriterAnimatedText('Pare Management',
                              textAlign: TextAlign.center,
                              speed: Duration(milliseconds: 100)),
                        ],
                        isRepeatingAnimation: false,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      openNExtScreen();
                    },
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      openNExtScreen();
                    },
                    child: Image.asset(
                      'images/rwanga_logo.png',
                      height: 50,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const Center(child: Text("Developed by Salar Pro")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future openNExtScreen() async {
    if (!isScreenStated) {
      isScreenStated = true;
      if (Provider.of<AuthProvider>(context, listen: false).theUser != null) {
        SharedPreferences.getInstance().then((value) {
          if (value.getBool("slpash_") ?? false) {
            Navigator.pushReplacementNamed(context, HomeScreenView.routeName);
          } else {
            Navigator.pushReplacementNamed(context, HomeScreenView.routeName);
          }
        });
      } else {
        Navigator.pushReplacementNamed(context, MainLoginScreen.routeName);
      }
    }
  }
}
