import 'dart:convert';



/*
        NOTE: This object is not used in the current version
        in next version i have plane to use multiple Wallets

 */
class Wallet {
  String? uid;
  String? name;
  String? description;
  Wallet({
    this.uid,
    this.name,
    this.description,
  });

  Wallet copyWith({
    String? uid,
    String? name,
    String? description,
  }) {
    return Wallet(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
    };
  }

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      uid: map['uid'],
      name: map['name'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Wallet.fromJson(String source) => Wallet.fromMap(json.decode(source));

  @override
  String toString() =>
      'Wallet(uid: $uid, name: $name, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Wallet &&
        other.uid == uid &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => uid.hashCode ^ name.hashCode ^ description.hashCode;
}
