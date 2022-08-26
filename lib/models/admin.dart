import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Admin {
  String? id;
  String? adminRole;

  Admin fromFirestore(Map<String, dynamic> map, String aId);
  Map<String, dynamic> toMap();
}
