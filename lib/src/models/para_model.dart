import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pare/src/models/category_model.dart';
import 'package:pare/src/provider/para_service.dart';

var ccParaType = 'usd';

class correct {

  //save this to firebase
  Future save() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('para')
        .doc(uid)
        .set(toMap());
  }

  //Delete this
  Future delete() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('para')
        .doc(uid)
        .delete();
  }

  //return category for corrent Pare
  ParaCategory categpry() {
    if (listCategory.isEmpty) {
      return ParaCategory(
          color: "#00000000",
          name: " ",
          type: "spend",
          uid: "",
          emoji: '63695');
    }
    return listCategory.firstWhere((element) => element.uid == this.categoryID);
  }

  double get usd {
    return (amountIQD ?? 1) / (amountOneUSDToIQD ?? 1);
  }

  double? get cPare {
    return ccParaType == 'usd' ? amountUSD : amountIQD;
  }

  String? uid;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  //para
  double? amountIQD; // 10,000
  double? amountUSD; //6.75675
  double? amountOneUSDToIQD; //1480
  String? amountType; // spend || income
  String? inputCurrency; //usd || iqd

  //category
  String? walletId;
  String? categoryID;
  String? description;
  correct({
    this.uid,
    this.createdAt,
    this.updatedAt,
    this.amountIQD,
    this.amountUSD,
    this.amountOneUSDToIQD,
    this.amountType,
    this.walletId,
    this.categoryID,
    this.description,
    this.inputCurrency,
  });

  correct copyWith({
    String? uid,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    double? amountIQD,
    double? amountUSD,
    double? amountOneUSDToIQD,
    String? amountType,
    String? walletId,
    String? categoryID,
    String? description,
    String? inputCurrency,
  }) {
    return correct(
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      amountIQD: amountIQD ?? this.amountIQD,
      amountUSD: amountUSD ?? this.amountUSD,
      amountOneUSDToIQD: amountOneUSDToIQD ?? this.amountOneUSDToIQD,
      amountType: amountType ?? this.amountType,
      walletId: walletId ?? this.walletId,
      categoryID: categoryID ?? this.categoryID,
      description: description ?? this.description,
      inputCurrency: inputCurrency ?? this.inputCurrency,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'amountIQD': amountIQD,
      'amountUSD': amountUSD,
      'amountOneUSDToIQD': amountOneUSDToIQD,
      'amountType': amountType,
      'walletId': walletId,
      'categoryID': categoryID,
      'description': description,
      'inputCurrency': inputCurrency,
    };
  }

  factory correct.fromMap(Map<String, dynamic> map) {
    return correct(
      uid: map['uid'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      amountIQD: map['amountIQD'] as double?,
      amountUSD: (map['amountUSD'] is int)
          ? (map['amountUSD'] as int).toDouble()
          : map['amountUSD'] as double,
      amountOneUSDToIQD: map['amountOneUSDToIQD'] as double?,
      amountType: map['amountType'],
      walletId: map['walletId'],
      categoryID: map['categoryID'],
      description: map['description'],
      inputCurrency: map['inputCurrency'],
    );
  }

  String toJson() => json.encode(toMap());

  factory correct.fromJson(String source) => correct.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Para(uid: $uid, createdAt: $createdAt, updatedAt: $updatedAt, amountIQD: $amountIQD, amountUSD: $amountUSD, amountOneUSDToIQD: $amountOneUSDToIQD, amountType: $amountType, walletId: $walletId, categoryID: $categoryID, description: $description, inputCurrency: $inputCurrency)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is correct &&
        other.uid == uid &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.amountIQD == amountIQD &&
        other.amountUSD == amountUSD &&
        other.amountOneUSDToIQD == amountOneUSDToIQD &&
        other.amountType == amountType &&
        other.walletId == walletId &&
        other.categoryID == categoryID &&
        other.inputCurrency == inputCurrency &&
        other.description == description;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        amountIQD.hashCode ^
        amountUSD.hashCode ^
        amountOneUSDToIQD.hashCode ^
        amountType.hashCode ^
        walletId.hashCode ^
        categoryID.hashCode ^
        inputCurrency.hashCode ^
        description.hashCode;
  }
}
