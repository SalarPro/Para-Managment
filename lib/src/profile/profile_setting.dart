import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pare/src/models/para_model.dart';
import 'package:pare/src/provider/user_provider.dart';
import 'package:pare/src/provider/para_service.dart';
import 'package:pare/src/splash_screen/splash_screen.dart';
import 'package:pare/src/tools/SPColors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSetting extends StatefulWidget {
  static String routeName = 'profile_setting';
  ProfileSetting({Key? key}) : super(key: key);

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _secondTextController = TextEditingController();

  bool didSetNames = false;

  @override
  Widget build(BuildContext context) {
    if (!didSetNames) {
      didSetNames = true;
      _nameTextController.text =
          Provider.of<AuthProvider>(context).generalUser?.firstName ?? "";
      _secondTextController.text =
          Provider.of<AuthProvider>(context).generalUser?.lastName ?? "";
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Profile'),
            const Spacer(),
            GestureDetector(
                onTap: () async {
                  var result = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Are you sure you want to sign out!'),
                      content: const Text(
                          'All of your data are securely saved on the cloud, you will be able to access it by login in again in anytime later'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'NO'),
                          child: const Text('NO'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'signout'),
                          child: const Text('SIGN OUT'),
                        ),
                      ],
                    ),
                  );

                  if (result == 'signout') {
                    Provider.of<AuthProvider>(context, listen: false).logOut();
                    Provider.of<ParaService>(context, listen: false)
                        .deleteAll();

                    Navigator.pushReplacementNamed(
                        context, SplashScreenView.routeName);
                  }
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ))
          ],
        ),
        backgroundColor: SPColors.blueColor,
      ),
      body: bodyView(),
    );
  }

  Widget bodyView() {
    return ListView(
      children: [
        const SizedBox(
          height: 15,
        ),
        Provider.of<AuthProvider>(context, listen: true)
                    .generalUser
                    ?.phonenumber !=
                null
            ? Center(
                child: Text(
                    'Phone Number: ${Provider.of<AuthProvider>(context, listen: true).generalUser?.phonenumber ?? ""}'),
              )
            : Center(
                child: Text(
                    'Email: ${Provider.of<AuthProvider>(context, listen: true).generalUser?.email ?? ""}'),
              ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: TextField(
            controller: _nameTextController,
            decoration: const InputDecoration(
              icon: FaIcon(FontAwesomeIcons.userAstronaut),
              // border: InputBorder.none,
              hintText: 'First name',
            ),
            style: TextStyle(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: TextField(
            controller: _secondTextController,
            decoration: const InputDecoration(
              icon: FaIcon(FontAwesomeIcons.user),
              // border: InputBorder.none,
              hintText: 'Second Name',
            ),
            style: TextStyle(),
          ),
        ),
        Center(
          child: Container(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                // if (_nameTextController.text.length > 0 &&
                //     _secondTextController.text.length > 0) {
                Provider.of<AuthProvider>(context, listen: false)
                    .generalUser!
                    .firstName = _nameTextController.text;
                Provider.of<AuthProvider>(context, listen: false)
                    .generalUser!
                    .lastName = _secondTextController.text;
                Provider.of<AuthProvider>(context, listen: false)
                    .generalUser!
                    .save();
                //Navigator.pop(context);
                // } else {}
              },
              child: Row(
                children: [
                  Spacer(),
                  FaIcon(FontAwesomeIcons.save),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Save'),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
