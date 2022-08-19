import 'package:flutter/material.dart';

class Pharmacy {
  String? id;
  String? name;

  Pharmacy({this.id, this.name});

  Pharmacy.fromFirestore(Map<String, dynamic> map, String pId) {
    id = pId;
    map['name'];
  }

  Map<String, dynamic> toMap() => {'name': name};

  @override
  bool operator ==(other) =>
      other is Pharmacy && other.id == id && other.name == name;

  @override
  int get hashCode => hashValues(id, name);
}
