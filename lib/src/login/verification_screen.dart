import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:pare/src/home_screen/home_screen.dart';
import 'package:pare/src/login/SignUpScreen.dart';
import 'package:pare/src/tools/app_dimens.dart';
import 'package:pare/src/tools/utility.dart';
import 'package:pare/src/provider/user_provider.dart';
import 'package:pare/src/provider/para_service.dart';
import 'package:pare/src/tools/SPColors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatefulWidget {
  String countryCode;
  String mobile;
  VerificationScreen({required this.mobile, required this.countryCode});
  @override
  _VerificationScreenPageState createState() => _VerificationScreenPageState();
}

class _VerificationScreenPageState extends State<VerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  // TextEditingController controller1 = TextEditingController();
  // TextEditingController controller2 = TextEditingController();
  // TextEditingController controller3 = TextEditingController();
  // TextEditingController controller4 = TextEditingController();
  // TextEditingController controller5 = TextEditingController();
  // TextEditingController controller6 = TextEditingController();
  FocusNode controller1fn = FocusNode();
  // FocusNode controller2fn = FocusNode();
  // FocusNode controller3fn = FocusNode();
  // FocusNode controller4fn = FocusNode();
  // FocusNode controller5fn = FocusNode();
  // FocusNode controller6fn = FocusNode();
  static const double dist = 3.0;
  TextEditingController currController = TextEditingController();
  String otp = "";
  late AppDimens appDimens;
  bool isLoading = false;
  String? _verificationId;
  bool autovalidate = false;
  FirebaseAuth? _auth = FirebaseAuth.instance;

  bool isCodeSent = false;

  @override
  void initState() {
    super.initState();
    // currController = controller1;
    _verifyPhoneNumber();
  }

  void _verifyPhoneNumber() async {
    if (mounted) {
      try {
        setState(() {
          isLoading = true;
        });
      } catch (e) {
        print('Build is not called yet :OOO');
        print(e.toString());
      }
    }

    if (_auth == null) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }

    await _auth!
        .verifyPhoneNumber(
            phoneNumber: widget.countryCode + widget.mobile,
            timeout: const Duration(seconds: 60),
            verificationCompleted:
                (PhoneAuthCredential phoneAuthCredential) async {
              print("verificationCompleted");
            },
            verificationFailed: (FirebaseAuthException authException) {
              Utility.showToast(msg: authException.message!);
              print(authException.code);
              print(authException.message);
              // sleep(Duration(seconds: 1));
            },
            codeSent: (String verificationId, int? forceResendingToken) async {
              print("codeSent");
              print(verificationId);
              Utility.showToast(
                  msg: "Please check your phone for the verification code.");
              setState(() {
                _verificationId = verificationId;
                isCodeSent = true;
                controller1fn.requestFocus();
              });
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              print("codeAutoRetrievalTimeout");
              setState(() {
                _verificationId = verificationId;
                isCodeSent = true;
                controller1fn.requestFocus();
              });
            })
        .then((value) {
      print("then");
    }).catchError((onError) {
      print(onError);
    });

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _signInWithPhoneNumber(String otp) async {
    _showProgressDialog(true);
    if (_verificationId == null) return;

    if (await Utility.checkInternet()) {
      try {
        final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: otp,
        );
        final User? user =
            (await _auth?.signInWithCredential(credential))?.user;
        if (_auth == null) return;
        final User? currentUser = _auth!.currentUser;
        if (user != null) {
          assert(user.uid == currentUser!.uid);
        }

        _showProgressDialog(false);
        if (user != null) {
          print(user);

          Provider.of<AuthProvider>(context, listen: false).setTheUser(user);

          // Navigator.pop(context);

          var isUserAvailable =
              await Provider.of<AuthProvider>(context, listen: false)
                  .fetchUserInfo(user.uid);

          if (isUserAvailable) {
            await Provider.of<ParaService>(context, listen: false)
                .firstInitialize();

            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreenView.routeName, (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, SignUpScreen.routeName, (route) => false);
          }
        } else {
          Utility.showToast(msg: "Sign in failed");
        }
      } catch (e) {
        print(e);

        Utility.showToast(msg: e.toString());
        _showProgressDialog(false);
      }
    } else {
      _showProgressDialog(false);
      Utility.showToast(msg: "No internet connection");
    }
  }

  _showProgressDialog(bool isloadingstate) {
    if (mounted) {
      setState(() {
        isLoading = isloadingstate;
      });
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   controller1.dispose();
  //   controller2.dispose();
  //   controller3.dispose();
  //   controller4.dispose();
  //   controller5.dispose();
  //   controller6.dispose();
  // }

  verifyOtp(String otpText) async {
    _signInWithPhoneNumber(otpText);
  }

  @override
  Widget build(BuildContext context) {
    appDimens = AppDimens(MediaQuery.of(context).size);

    return Scaffold(
      backgroundColor: SPColors.backGroundColor,
      appBar: AppBar(
        title: const Text('Verification'),
        iconTheme: IconThemeData(
          color: SPColors.whiteColor,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: SPColors.blueColor,
      ),
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onDoubleTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SafeArea(
              top: false,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: SPColors.backGroundColor,
                body: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(appDimens.paddingw16),
                          child: Center(
                            child: Text(
                              "An SMS with the verification code has been sent to your registered mobile number",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: SPColors.blackColor,
                                fontSize: appDimens.text16,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: appDimens.paddingw16),
                          child: Visibility(
                            visible: widget.mobile == null ? false : true,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  widget.countryCode + " " + widget.mobile,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: SPColors.blackColor,
                                    fontSize: appDimens.text20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.edit),
                                  color: SPColors.blackColor,
                                  iconSize: appDimens.iconsize,
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: appDimens.paddingw16),
                          child: Center(
                            child: Text(
                              "Enter 6 digits code",
                              style: TextStyle(
                                color: SPColors.blackColor,
                                fontSize: appDimens.text12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.90,
                          child: PinCodeTextField(
                            // autoFocus: true,
                            focusNode: controller1fn,
                            length: 6,
                            obscureText: false,
                            animationType: AnimationType.scale,
                            pinTheme: PinTheme(
                              inactiveColor: SPColors.blueColor,
                              inactiveFillColor: Colors.red.withAlpha(0),
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(10),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeFillColor: Colors.white,
                            ),
                            animationDuration: Duration(milliseconds: 300),
                            //backgroundColor: Colors.blue.shade50,
                            enableActiveFill: true,
                            //errorAnimationController: errorController,
                            controller: textEditingController,
                            onCompleted: (v) {
                              print("Completed");
                              _signInWithPhoneNumber(v);
                            },
                            onChanged: (value) {
                              print(value);
                              // setState(() {
                              //   currentText = value;
                              // });
                            },
                            useHapticFeedback: true,
                            keyboardType: TextInputType.number,

                            beforeTextPaste: (text) {
                              print("Allowing to paste $text");
                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc

                              try {
                                int.parse(text.toString());
                                textEditingController.text = text.toString();
                              } catch (e) {
                                print(e.toString());
                              }
                              return false;
                            },
                            appContext: context,
                          ),
                        ),
                        SizedBox(height: 10),
                        if (isCodeSent)
                          TweenAnimationBuilder<Duration>(
                            duration: Duration(seconds: 59),
                            tween: Tween(
                                begin: Duration(seconds: 59),
                                end: Duration.zero),
                            onEnd: () {
                              print('Timer ended');
                            },
                            builder: (BuildContext context, Duration value,
                                Widget? child) {
                              final minutes = value.inMinutes;
                              final seconds = value.inSeconds % 60;
                              if (seconds == 0) {
                                isCodeSent = false;
                                _verifyPhoneNumber();
                              }
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  'Send again after ${seconds}s',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              );
                            },
                          )
                        else
                          Container()
                        // InkWell(
                        //   onTap: () {
                        //     _verifyPhoneNumber();
                        //   },
                        //   child: Container(
                        //     alignment: Alignment.center,
                        //     padding:
                        //         EdgeInsets.only(top: appDimens.paddingw6),
                        //     child: Row(
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: <Widget>[
                        //         Spacer(),
                        //         Text(
                        //           "Didn't receive " + "SMS? ",
                        //           style: TextStyle(
                        //             // color: SPColors.whiteColor,
                        //             fontSize: appDimens.text16,
                        //           ),
                        //         ),
                        //         Text(
                        //           "Resend",
                        //           style: TextStyle(
                        //             color: SPColors.blueColor,
                        //             fontSize: appDimens.text16,
                        //             fontWeight: FontWeight.w900,
                        //           ),
                        //         ),
                        //         Spacer(),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
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
              : Container(),
          isCodeSent
              ? Container()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Container(
                    color: SPColors.mainColor.withAlpha(200),
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Lottie.asset('assets/plane_paper.json',
                                width: MediaQuery.of(context).size.width * 1),
                            const Text(
                              'Sending the Code please wait',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
