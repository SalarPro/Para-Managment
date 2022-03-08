import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pare/src/category_editor_screen/category_editor.dart';
import 'package:pare/src/login/main_login_screen.dart';
import 'package:pare/src/models/para_model.dart';
import 'package:pare/src/profile/profile_setting.dart';
import 'package:pare/src/provider/user_provider.dart';
import 'package:pare/src/provider/para_service.dart';
import 'package:pare/src/tools/SPColors.dart';
import 'package:pare/src/tools/web.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool isProfileSettingShow = false;

  int segmentedControlGroupValue = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("USD \$"),
    1: Text("IQD"),
  };

  @override
  void initState() {
    super.initState();
    segmentedControlGroupValue = ccParaType == 'usd' ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isProfileSettingShow
            ? Stack(
                children: [
                  ProfileSetting(),
                  Positioned(
                      right: 50,
                      bottom: 50,
                      left: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isProfileSettingShow = !isProfileSettingShow;
                            });
                          },
                          child: Row(
                            children: [
                              Spacer(),
                              FaIcon(FontAwesomeIcons.arrowLeft),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Back'),
                              Spacer(),
                            ],
                          )))
                ],
              )
            : Center(
                child: Container(
                  child: Column(
                    children: [
                      Provider.of<AuthProvider>(context, listen: true)
                                  .generalUser ==
                              null
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, MainLoginScreen.routeName);
                              },
                              child: Text('sign in'))
                          : userProfile(context)
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget userProfile(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              SPColors.blueColor,
                              SPColors.lighten(SPColors.blueColor, 0.2)
                            ]),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            "Hello ${Provider.of<AuthProvider>(context, listen: true).generalUser!.firstName}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: SPColors.whiteColor,
                                fontSize: 33,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isProfileSettingShow = !isProfileSettingShow;
                            });
                            // Navigator.pushNamed(context, ProfileSetting.routeName);
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Spacer(),
                                  FittedBox(
                                    child: Image.asset(
                                      'images/user.png',
                                      height:
                                          ((MediaQuery.of(context).size.width /
                                                  2) *
                                              0.5),
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  2) *
                                              0.5,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "Profile",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, CategoryEditor.routeName);
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  const Spacer(),
                                  FittedBox(
                                    child: Image.asset(
                                      'images/categories_icone.png',
                                      height:
                                          (MediaQuery.of(context).size.width /
                                                  2) *
                                              0.5,
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  2) *
                                              0.5,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    "Categories",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    print('object');
                    launchInBrowser('https://salarpro.com');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: FaIcon(
                            FontAwesomeIcons.link,
                            size: 13,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          'Pare app is developed by ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            // decoration: TextDecoration.underline,
                            // decorationThickness: 1,
                            // decorationColor: Colors.blue,
                          ),
                        ),
                        Text(
                          'Salar Pro',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[700],
                            // decoration: TextDecoration.underline,
                            // decorationThickness: 1,
                            // decorationColor: Colors.blue,
                          ),
                        ),
                        Text(
                          ' with much love',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            // decoration: TextDecoration.underline,
                            // decorationThickness: 1,
                            // decorationColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 0, bottom: 5, left: 20, right: 20),
                      child: Text(
                        'Main Currency',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 0, bottom: 5, left: 20, right: 20),
                        child: CupertinoSlidingSegmentedControl(
                            padding: EdgeInsets.all(5),
                            groupValue: segmentedControlGroupValue,
                            children: myTabs,
                            onValueChanged: (i) {
                              setState(() {
                                segmentedControlGroupValue =
                                    i is int ? i as int : 0;
                                SharedPreferences.getInstance().then((value) =>
                                    value.setString(
                                        "ccParaType",
                                        segmentedControlGroupValue == 0
                                            ? 'usd'
                                            : 'iqd'));
                                ccParaType = segmentedControlGroupValue == 0
                                    ? 'usd'
                                    : 'iqd';
                              });

                              Provider.of<ParaService>(context, listen: false)
                                  .sortByMonth();
                              Provider.of<ParaService>(context, listen: false)
                                  .calculate();
                            }),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                  child: Text(
                    'This is just for view stuff and what you prefer, if you select one you will be able to use others as will',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.black45),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
