import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Order {
  String? id;
  String? patientId;
  Map<String, dynamic>? cart;
  String? locationString;
  GeoPoint? locationGeo;
  double? totalPrice;
  OrderStatus? status;
  bool? confirmDelivery;
  DateTime? dateTime;
  List<String>? pharmacyIds;

  Order({
    this.id,
    this.cart,
    this.pharmacyIds,
    this.locationString,
    this.locationGeo,
    this.totalPrice,
    this.status,
    this.confirmDelivery,
    this.dateTime,
  });

  Order.fromFirestore(Map<String, dynamic> map, String oId) {
    id = oId;
    patientId = map['patientId'];
    cart = map['cart'];
    locationString = map['locationString'];
    locationGeo = map['locationGeo'];
    totalPrice = map['totalPrice'].toDouble();
    status = OrderStatus.values[map['status']];
    confirmDelivery = map['confirmDelivery'];
    dateTime = DateTime.fromMillisecondsSinceEpoch(
        (map['dateTime'] as Timestamp).millisecondsSinceEpoch);
  }

  @override
  bool operator ==(other) =>
      other is Order &&
      cart == other.cart &&
      pharmacyIds == other.pharmacyIds &&
      locationString == other.locationString &&
      locationGeo == other.locationGeo &&
      totalPrice == other.totalPrice &&
      status == other.status &&
      dateTime == other.dateTime &&
      confirmDelivery == other.confirmDelivery;

  @override
  int get hashCode => hashValues(
        cart,
        hashList(pharmacyIds),
        locationString,
        locationGeo,
        totalPrice,
        status,
        confirmDelivery,
        dateTime,
      );
}

enum OrderStatus { delivered, enroute, pending, canceled }
