import 'package:flutter/material.dart';
import 'package:med_connect_admin/models/admin.dart';

class Pharmacy extends Admin {
  String? name;
  String? phone;
  String? licenseId;
  bool? isVerified;

  Pharmacy({id, this.name, this.phone, this.licenseId, this.isVerified});

  @override
  Pharmacy fromFirestore(Map<String, dynamic> map, String aId) {
    id = aId;
    name = map['name'];
    phone = map['phone'];
    licenseId = map['licenseId'];
    isVerified = map['isVerified'];

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'licenseId': licenseId,
      'isVerified': isVerified,
      'adminRole': 'pharmacy',
    };
  }

  @override
  bool operator ==(other) =>
      other is Pharmacy &&
      other.id == id &&
      other.name == name &&
      phone == other.phone &&
      licenseId == other.licenseId &&
      isVerified == other.isVerified;

  @override
  int get hashCode => Object.hash(id, name, phone, licenseId, isVerified);
}
