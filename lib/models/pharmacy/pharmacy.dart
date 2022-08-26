import 'package:flutter/material.dart';
import 'package:med_connect_admin/models/admin.dart';

class Pharmacy extends Admin {
  String? name;

  Pharmacy({id, this.name});

  @override
  Pharmacy fromFirestore(Map<String, dynamic> map, String aId) {
    id = aId;
    map['name'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() => {'name': name, 'adminRole': 'pharmacy'};

  @override
  bool operator ==(other) =>
      other is Pharmacy && other.id == id && other.name == name;

  @override
  int get hashCode => hashValues(id, name);
}
