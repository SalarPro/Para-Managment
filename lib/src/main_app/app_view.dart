import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pare/src/app_para_screen/add_para.dart';
import 'package:pare/src/category_editor_screen/category_editor.dart';
import 'package:pare/src/category_editor_screen/category_item_editor.dart';
import 'package:pare/src/login/SignUpScreen.dart';
import 'package:pare/src/login/emailAndPasswordLogin.dart';
import 'package:pare/src/login/emailAndPasswordRegister.dart';
import 'package:pare/src/login/main_login_screen.dart';
import 'package:pare/src/profile/profile_setting.dart';
import 'package:pare/src/provider/user_provider.dart';
import 'package:pare/src/provider/para_service.dart';
import 'package:pare/src/tools/SPColors.dart';
import 'package:provider/provider.dart';

import '../home_screen/home_screen.dart';
import '../splash_screen/splash_screen.dart';

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).theUser;
    if (FirebaseAuth.instance.currentUser != null)
      Provider.of<ParaService>(context, listen: false);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: SPColors.blueColor,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 255, 253, 253),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreenView(),
        HomeScreenView.routeName: (context) => HomeScreenView(),
        CategoryItemEditor.routeName: (context) => CategoryItemEditor(),
        CategoryEditor.routeName: (context) => CategoryEditor(),
        MainLoginScreen.routeName: (context) => MainLoginScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        AddPara.routeName: (context) => AddPara(),
        ProfileSetting.routeName: (context) => ProfileSetting(),
        LoginEmailAndPassword.routeName: (context) => LoginEmailAndPassword(),
        RegisterEmailAndPassword.routeName: (context) => RegisterEmailAndPassword(),
      },
    );
  }
}
