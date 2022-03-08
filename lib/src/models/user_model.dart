import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class GeneralUser {
  Future<bool> save() async {
    updatedAt = Timestamp.now();
    createdAt ??= Timestamp.now();
    await FirebaseFirestore.instance.collection('users').doc(uid).set(toMap());
    return true;
  }

  String? uid;
  String? firstName;
  String? lastName;
  String? phonenumber;
  String? email;

  Timestamp? createdAt;
  Timestamp? updatedAt;

  GeneralUser({
    this.uid,
    this.firstName,
    this.lastName,
    this.phonenumber,
    this.createdAt,
    this.updatedAt,
    this.email,
  });

  GeneralUser copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? phonenumber,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? email,
  }) {
    return GeneralUser(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phonenumber: phonenumber ?? this.phonenumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'phonenumber': phonenumber,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'email': email,
    };
  }

  factory GeneralUser.fromMap(Map<String, dynamic> map) {
    return GeneralUser(
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phonenumber: map['phonenumber'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GeneralUser.fromJson(String source) =>
      GeneralUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GeneralUser(uid: $uid, firstName: $firstName, lastName: $lastName, phonenumber: $phonenumber, createdAt: $createdAt, updatedAt: $updatedAt, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GeneralUser &&
        other.uid == uid &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.phonenumber == phonenumber &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.email == email;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        phonenumber.hashCode ^
        createdAt.hashCode ^
        email.hashCode ^
        updatedAt.hashCode;
  }
}
