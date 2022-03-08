import 'dart:io';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:pare/src/Analytic_views/main_analytic_view.dart';
import 'package:pare/src/home_screen/home_view_page.dart';
import 'package:pare/src/profile_views/profile_view.dart';
import 'package:pare/src/provider/app_provider.dart';
import 'package:pare/src/tools/SPColors.dart';
import 'package:pare/src/tools/web.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenView extends StatefulWidget {
  static String routeName = 'homeView';
  HomeScreenView({Key? key}) : super(key: key);

  @override
  _HomeScreenViewState createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  @override
  void initState() {
    super.initState();
    //save that the aplash is viewd, to not shoed again.
    SharedPreferences.getInstance()
        .then((value) => value.setBool("slpash_", true));
    Future<PermissionStatus> permissionStatus =
        NotificationPermissions.getNotificationPermissionStatus();

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
    if (!Provider.of<ParaAppProvider>(context, listen: true).isAppVialed) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Please update your app on ${Platform.isAndroid ? "PlayStore" : 'AppStore'}'),
              TextButton(
                  onPressed: () {
                    //if ios or android
                    if (Platform.isAndroid) {
                      // Android-specific code
                      //https://play.google.com/store/apps/details?id=com.salarpro.paramanager
                      launchInBrowser(
                          'https://play.google.com/store/apps/details?id=com.salarpro.paramanager');
                    } else if (Platform.isIOS || Platform.isMacOS) {
                      // iOS-specific code
                      //https://apps.apple.com/us/app/pare-manager/id1611643341
                      launchInBrowser(
                          'https://apps.apple.com/us/app/pare-manager/id1611643341');
                    }
                  },
                  child: const Text('Click me to update'))
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        // appBar: AppBar(
        //   title: const Text("Para Managment"),
        // ),
        backgroundColor: SPColors.blueColor,
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.chartBar,
                  color: Provider.of<ParaAppProvider>(context, listen: true)
                              .selectedIndex ==
                          0
                      ? SPColors.mainColor
                      : Colors.grey,
                ),
                label: 'Analytic'),
            BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.solidMoneyBillAlt,
                  color: Provider.of<ParaAppProvider>(context, listen: true)
                              .selectedIndex ==
                          1
                      ? SPColors.mainColor
                      : Colors.grey,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.userAstronaut,
                  color: Provider.of<ParaAppProvider>(context, listen: true)
                              .selectedIndex ==
                          2
                      ? SPColors.mainColor
                      : Colors.grey,
                ),
                label: 'Profile'),
          ],
          onTap: (index) {
            setState(() {
              Provider.of<ParaAppProvider>(context, listen: false)
                  .setIdex(index);
            });
          },
          currentIndex:
              Provider.of<ParaAppProvider>(context, listen: true).selectedIndex,
          selectedItemColor: SPColors.mainColor,
          unselectedItemColor: Colors.grey,
          enableFeedback: false,
          showSelectedLabels: true,
          showUnselectedLabels: false,
        ),
        body: SafeArea(
            child: currentView(
                Provider.of<ParaAppProvider>(context, listen: true)
                    .selectedIndex)),
      );
    }
  }

  Widget currentView(int index) {
    switch (index) {
      case 0:
        return MainAnalyticView();
      case 1:
        return HomeViewPage();
      case 2:
        return ProfileView();

      default:
        return HomeViewPage();
    }
  }
}
