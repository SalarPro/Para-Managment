import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pare/src/Analytic_views/main_analytic_view.dart';
import 'package:pare/src/api/carrency_api.dart';
import 'package:pare/src/models/category_model.dart';
import 'package:pare/src/models/para_model.dart';

List<ParaCategory> listCategory = [];

class ParaService extends ChangeNotifier {
  List<correct> listPara = [];

  double totalPrice = 0.0;

  setTotalPrice(double total) async {
    this.totalPrice = total;
    notifyListeners();
  }

  late double? uSDtoIQD;

  late Stream<QuerySnapshot> paraStream;

  late Stream<QuerySnapshot> paraCategoryStream;

  ParaService() {
    firstInitialize();
  }

  Future firstInitialize() async {
    paraCategoryStream = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('category')
        .snapshots();

    paraStream = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('para')
        .orderBy('createdAt', descending: true)
        .snapshots();

    getMonyPrice();

    paraCategoryStream.listen((event) {
      listCategory.clear();
      event.docs.forEach((element) {
        debugPrint((element.data() as Map<String, dynamic>).toString());
        listCategory
            .add(ParaCategory.fromMap(element.data() as Map<String, dynamic>));
      });

      debugPrint("===|=======|===== ${listCategory.length}");
      notifyListeners();
    });

    getPara();

    Future.delayed(Duration(seconds: 1)).then((onValue) => true);
    // sleep(const Duration(seconds: 1));
  }

  getPara() {
    //Timer(Duration(seconds: 4), () {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('para')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (event) {
        listPara.clear();
        event.docs.forEach((element) {
          listPara.add(correct.fromMap(element.data() as Map<String, dynamic>));
        });

        sortByMonth();
        calculate();

        debugPrint(
            "===|=======|===== paraaaa ${event.docs.length} :::: ${event.docChanges.length}");
        notifyListeners();
      },
    );
    // });
  }

  void getMonyPrice() async {
    uSDtoIQD = await Currency().oneUSDToIQD();
    notifyListeners();
  }

  var minBtSpend = 1.0;
  var minBtIncome = 1.0;

  Map<ParaCategory, List<correct>> itemsCategoriesSpend = {};
  Map<ParaCategory, List<correct>> itemsCategoriesIncome = {};
  Map<ParaCategory, List<correct>> itemsCategoriesAll = {};

  calculate() {
    var totalPrice = 0.0;

    itemsCategoriesSpend = listPara
        .where((element) => element.amountType == 'spend')
        .fold(<ParaCategory, List<correct>>{}, (previousValue, element) {
      var obj = element;

      var dateID = element.categpry();

      totalPrice += obj.cPare ?? 0.0;

      previousValue.putIfAbsent(dateID, () => []).add(obj);

      return previousValue;
    });

    minBtSpend = totalPrice / 100;

    totalPrice = 0.0;

    itemsCategoriesIncome = listPara
        .where((element) => element.amountType == 'income')
        .fold(<ParaCategory, List<correct>>{}, (previousValue, element) {
      var obj = element;

      var dateID = element.categpry();

      totalPrice += obj.cPare ?? 0.0;

      previousValue.putIfAbsent(dateID, () => []).add(obj);

      return previousValue;
    });

    minBtIncome = totalPrice / 100;
  }

  deleteAll() {
    listPara = [];
    listCategory = [];
    totalPrice = 0.0;
    uSDtoIQD = 0.0;
    minBtSpend = 0;
    minBtIncome = 0;
    itemsCategoriesSpend = {};
    itemsCategoriesIncome = {};
    itemsCategoriesAll = {};
  }

  Map<String, List<correct>> listParaDate = {};
  Map<DateTime, ParaAnalyser> listParaDateTime = {};

  sortByMonth() {
    listParaDate = listPara.fold(<String, List<correct>>{}, (a, b) {
      var obj = b;

      var dateID = DateFormat('yyyy-MM-dd')
          .format((obj.createdAt ?? Timestamp.now()).toDate());

      a.putIfAbsent(dateID, () => []).add(obj);
      return a;
    });

    Set<int> years = {};

    Map<DateTime, List<correct>> listParaDateTime =
        listPara.fold(<DateTime, List<correct>>{}, (a, b) {
      var obj = b;

      var dateID = (obj.createdAt ?? Timestamp.now()).toDate();

      var nDate = DateTime(dateID.year, dateID.month);
      years.add(dateID.year);

      a.putIfAbsent(nDate, () => []).add(obj);
      return a;
    });

    var sortYears = (years.toList());
    sortYears.sort();
    var cointer = 0;

    yearArr.clear();

    sortYears.forEach((element) {
      yearArr[cointer] = element;
      cointer++;
    });

    this.listParaDateTime =
        listParaDateTime.map<DateTime, ParaAnalyser>((key, value) {
      return MapEntry(key, ParaAnalyser(paraList: value));
    });

    debugPrint("Para month = ${listParaDateTime.length.toString()}");
    notifyListeners();
  }
}

class ParaAnalyser {
  var divisionSpend = 0.0;
  var divisionIncome = 0.0;
  var totalPriceSpend = 0.0;
  var totalPriceIncome = 0.0;

  var minSpend = double.infinity;
  var maxSpend = 0.0;
  var minIncome = double.infinity;
  var maxIncome = 0.0;

  Map<ParaCategory, List<correct>> itemsCategoriesSpend = {};
  Map<ParaCategory, List<correct>> itemsCategoriesIncome = {};

  ParaAnalyser({required List<correct> paraList}) {
    var totalPrice = 0.0;

    minSpend = double.infinity;
    itemsCategoriesSpend = paraList
        .where((element) => element.amountType == 'spend')
        .fold(<ParaCategory, List<correct>>{}, (previousValue, element) {
      var obj = element;

      if (element.amountUSD! < minSpend) {
        minSpend = element.amountUSD!;
      }

      if (element.amountUSD! > maxSpend) {
        maxSpend = element.amountUSD!;
      }

      debugPrint("${(element.amountUSD ?? 0) > maxSpend}");

      var dateID = element.categpry();

      totalPrice += obj.cPare ?? 0.0;

      previousValue.putIfAbsent(dateID, () => []).add(obj);

      return previousValue;
    });

    divisionSpend = totalPrice / 100;
    totalPriceSpend = totalPrice;

    totalPrice = 0.0;

    itemsCategoriesIncome = paraList
        .where((element) => element.amountType == 'income')
        .fold(<ParaCategory, List<correct>>{}, (previousValue, element) {
      var obj = element;

      if ((element.amountUSD ?? double.infinity) < minIncome) {
        minIncome = element.amountUSD!;
      }

      if ((element.amountUSD ?? double.infinity) > maxIncome) {
        maxIncome = element.amountUSD!;
      }

      var dateID = element.categpry();

      totalPrice += obj.cPare ?? 0.0;

      previousValue.putIfAbsent(dateID, () => []).add(obj);

      return previousValue;
    });

    divisionIncome = totalPrice / 100;
    totalPriceIncome = totalPrice;
  }
}
