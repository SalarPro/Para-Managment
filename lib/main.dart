import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:pare/src/main_app/app_view.dart';
import 'package:pare/src/models/para_model.dart';
import 'package:pare/src/provider/app_provider.dart';
import 'package:pare/src/provider/user_provider.dart';
import 'package:pare/src/provider/para_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => debugPrint("firebase done"));

  SharedPreferences.getInstance().then((value) {
    ccParaType = value.getString('ccParaType') ?? 'usd';
  });

  runApp(MultiProvider(child: AppView(), providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => ParaAppProvider()),
    ChangeNotifierProvider(create: (context) => ParaService()),
  ]));
}
