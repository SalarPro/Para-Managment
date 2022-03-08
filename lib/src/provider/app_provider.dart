import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ParaAppProvider extends ChangeNotifier {
  static String appVersion = 'sp02';
  int selectedIndex = 1;
  void setIdex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  bool isAppVialed = true;
  setValidation(bool isAppVialed) {
    this.isAppVialed = isAppVialed;
    notifyListeners();
  }

  ParaAppProvider() {
    checkValidation();
  }

  checkValidation() {
    FirebaseFirestore.instance
        .collection('app_version_control')
        .doc('flutter')
        .snapshots()
        .listen((event) {
      debugPrint(event.data().toString());
      debugPrint((event.data()!['ver'] as Map<String, dynamic>).toString());

      if (event.data()?['ver'] != null) {
        setValidation(
            ((event.data()!['ver'] as Map<String, dynamic>)['sp04_android'] as bool));
      } else {
        setValidation(true);
      }
    });
  }
}
