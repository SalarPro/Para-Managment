import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pare/src/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ParaCategory {

  //save this to firebase
  Future save(BuildContext context) async {
    uid ??= Uuid().v1().toString();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(
            Provider.of<AuthProvider>(context, listen: false).generalUser!.uid!)
        .collection('category')
        .doc(uid)
        .set(toMap());

    return;
  }

  //just for analitics
  double totalPrice = 0.0;

  String? color; //#F512EE
  String? uid;
  String? name; //Car
  String? emoji; //icon code
  String? type; // spend|income|both

  ParaCategory({
    this.color,
    this.uid,
    this.name,
    this.emoji,
    this.type,
  });

  ParaCategory copyWith({
    String? color,
    String? uid,
    String? name,
    String? emoji,
    String? type,
  }) {
    return ParaCategory(
      color: color ?? this.color,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      type: emoji ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'color': color,
      'uid': uid,
      'name': name,
      'emoji': emoji,
      'type': type,
    };
  }

  factory ParaCategory.fromMap(Map<String, dynamic> map) {
    return ParaCategory(
      color: map['color'],
      uid: map['uid'],
      name: map['name'],
      emoji: map['emoji'],
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ParaCategory.fromJson(String source) =>
      ParaCategory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ParaCategory(color: $color, uid: $uid, name: $name, emoji: $emoji, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ParaCategory &&
        other.color == color &&
        other.uid == uid &&
        other.name == name &&
        other.type == type &&
        other.emoji == emoji;
  }

  @override
  int get hashCode {
    return color.hashCode ^
        uid.hashCode ^
        name.hashCode ^
        emoji.hashCode ^
        type.hashCode;
  }
}
