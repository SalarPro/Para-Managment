import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:pare/src/home_screen/home_screen.dart';
import 'package:pare/src/login/SignUpScreen.dart';
import 'package:pare/src/login/emailAndPasswordLogin.dart';
import 'package:pare/src/login/verification_screen.dart';
import 'package:pare/src/provider/para_service.dart';
import 'package:pare/src/provider/user_provider.dart';
import 'package:pare/src/tools/SPColors.dart';
import 'package:pare/src/tools/app_dimens.dart';
import 'package:pare/src/tools/utility.dart';
import 'package:provider/provider.dart';

class MainLoginScreen extends StatefulWidget {
  static var routeName = '/login';
  MainLoginScreen();
  @override
  _MainLoginScreenState createState() => _MainLoginScreenState();
}

class _MainLoginScreenState extends State<MainLoginScreen> {
  late AppDimens appDimens;
  late TextEditingController textEditingController;
  late Size size;
  late MediaQueryData mediaQuerydata;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();

    ddd();
  }

  ddd() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

// use the returned token to send messages to users from your custom server
    String? token = await messaging.getToken();
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    mediaQuerydata = MediaQuery.of(context);
    size = MediaQuery.of(context).size;
    appDimens = new AppDimens(size);

    return Scaffold(
      backgroundColor: SPColors.backGroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                        maxHeight: size.height - mediaQuerydata.padding.top),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Spacer(),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          child: Lottie.asset(
                            'assets/moeny_tree.json',
                            height: 250,
                            fit: BoxFit.fill,
                          ),
                        ),
                        // Spacer(),
                        Container(
                          margin: EdgeInsets.only(top: appDimens.paddingw2),
                          alignment: Alignment.center,
                          child: Text(
                            "Login or Register",
                            style: TextStyle(
                              fontSize: appDimens.text20,
                              color: SPColors.greyText,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: appDimens.paddingw20,
                        ),
                        // emailMobileView(),
                        //phone fiels

                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('app_version_control')
                              .doc('features')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data == null) {
                              return Container();
                            }
                            if (((snapshot.data!.data()
                                        as Map<String, dynamic>)['phone']
                                    as bool) ==
                                false) {
                              return Container();
                            }
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                sPPhoneField(),
                                SizedBox(
                                  height: 0,
                                ),
                                Utility.loginButtonsWidget(
                                  "",
                                  "Continue With Phone",
                                  () {
                                    continueClick();
                                  },
                                  SPColors.blackColor,
                                  SPColors.blackColor,
                                  appDimens,
                                  SPColors.whiteColor,
                                ),
                              ],
                            );
                          },
                        ),
                        // Email
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('app_version_control')
                              .doc('features')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data == null) {
                              return Container();
                            }
                            if (((snapshot.data!.data()
                                        as Map<String, dynamic>)['email']
                                    as bool) ==
                                false) {
                              return Container();
                            }
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                SignInButton(Buttons.Email, onPressed: () {
                                  singInEmail();
                                }),
                              ],
                            );
                          },
                        ),

                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('app_version_control')
                              .doc('features')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data == null) {
                              return Container();
                            }
                            if (((snapshot.data!.data()
                                        as Map<String, dynamic>)['google']
                                    as bool) ==
                                false) {
                              return Container();
                            }
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                SignInButton(Buttons.GoogleDark, onPressed: () {
                                  singInGoogle();
                                }),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  color: SPColors.mainColor.withAlpha(150),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Loading', style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ))
          else
            Container(),
        ],
      ),
    );
  }

  Widget sPPhoneField() {
    return Container(
      padding: EdgeInsets.only(
        left: appDimens.paddingw16 * 2,
        right: appDimens.paddingw16 * 2,
        bottom: appDimens.paddingw16,
      ),
      child: IntlPhoneField(
        controller: textEditingController,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          border: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
        initialCountryCode: 'IQ',
        onChanged: (phone) {
          print(phone.completeNumber);
        },
      ),
    );
  }

  Widget emailMobileView() {
    return Container(
      margin: EdgeInsets.only(
        left: appDimens.paddingw16 * 2,
        right: appDimens.paddingw16 * 2,
        bottom: appDimens.paddingw16,
      ),
      decoration: BoxDecoration(
        color: SPColors.whiteColor,
        // boxShadow: [
        //   BoxShadow(
        //     offset: Offset(0, 1),
        //     blurRadius: 2,
        //     color: Colors.black54,
        //   ),
        // ],
        border: Border.all(color: SPColors.blackColor, width: 0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: appDimens.paddingw6,
              right: appDimens.paddingw6,
            ),
            child: Text(
              "+964",
              style: TextStyle(
                  fontSize: appDimens.text16, color: SPColors.greyText),
            ),
          ),
          Container(
            color: SPColors.blackColor,
            width: 0.5,
            height: 50,
          ),
          Padding(
            padding: EdgeInsets.only(
              right: appDimens.paddingw6,
            ),
          ),
          Expanded(
            child: TextFormField(
              style: TextStyle(
                  fontSize: appDimens.text16, color: SPColors.greyText),
              controller: textEditingController,
              maxLength: 10,
              decoration: InputDecoration(
                hintText: "Mobile Number",
                counterText: "",
                hintStyle: TextStyle(color: SPColors.greyText),
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
            ),
          )
        ],
      ),
    );
  }

  continueClick() async {
    if (textEditingController.text.length != 10) {
      Utility.showToast(msg: 'Please enter phone number correctly');
      return;
    }

    var internet = await Utility.checkInternet();
    if (internet) {
      FocusScope.of(context).requestFocus(new FocusNode());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
            mobile: textEditingController.text,
            countryCode: "+964",
          ),
        ),
      );
    } else {
      Utility.showToast(
          msg:
              'Please check your internet connection. Internet is required to sign in');
    }
  }

  singInEmail() async {
    var internet = await Utility.checkInternet();
    if (!internet) {
      Utility.showToast(
          msg:
              'Please check your internet connection. Internet is required to sign in');
      return;
    }

    Navigator.pushNamed(context, LoginEmailAndPassword.routeName);

    // setState(() {
    //   isLoading = true;
    // });
    // try {
    //   var suser = await signInWithGoogle();
    //   var user = suser?.user;

    //   if (user != null) {
    //     print(user);

    //     Provider.of<AuthProvider>(context, listen: false).setTheUser(user);

    //     // Navigator.pop(context);

    //     var isUserAvailable =
    //         await Provider.of<AuthProvider>(context, listen: false)
    //             .fetchUserInfo(user.uid);

    //     if (isUserAvailable) {
    //       await Provider.of<ParaService>(context, listen: false)
    //           .firstInitialize();

    //       Navigator.pushNamedAndRemoveUntil(
    //           context, HomeScreenView.routeName, (route) => false);
    //     } else {
    //       Navigator.pushNamedAndRemoveUntil(
    //           context, SignUpScreen.routeName, (route) => false);
    //     }
    //   } else {
    //     setState(() {
    //       isLoading = false;
    //     });
    //     Utility.showToast(msg: "Sign in failed");
    //   }
    // } catch (e) {
    //   Utility.showToast(msg: "Sign in with Google failed");
    //   setState(() {
    //     isLoading = true;
    //   });
    // }
  }

  singInGoogle() async {
    setState(() {
      isLoading = true;
    });
    try {
      var suser = await signInWithGoogle();
      var user = suser?.user;

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
        setState(() {
          isLoading = false;
        });
        Utility.showToast(msg: "Sign in failed");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      Utility.showToast(msg: "Sign in with Google failed");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn().catchError((onError) {
        print("Error $onError");
      });

      if (googleUser == null) {
        Utility.showToast(msg: 'Sign in failed');
        return Future.error('Sign in failed');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      if (googleAuth == null) {
        Utility.showToast(msg: 'Sign in failed');
        return Future.error('Sign in failed');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on PlatformException catch (e) {
      Utility.showToast(msg: 'Sign in failed ${e.toString()}');
    }
  }
}
