import 'package:flutter/material.dart';
import 'package:med_connect_admin/models/admin.dart';

class Pharmacy extends Admin {
  String? name;
  String? phone;

  Pharmacy({id, this.name, this.phone});

  @override
  Pharmacy fromFirestore(Map<String, dynamic> map, String aId) {
    id = aId;
    name = map['name'];
    phone = map['phone'];

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'adminRole': 'pharmacy',
    };
  }

  @override
  bool operator ==(other) =>
      other is Pharmacy &&
      other.id == id &&
      other.name == name &&
      phone == other.phone;

  @override
  int get hashCode => hashValues(id, name, phone);
}
