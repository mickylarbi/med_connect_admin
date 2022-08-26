import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorAppointment {
  String? id;
  String? doctorId;
  String? doctorName;
  String? patientId;
  String? patientName;
  String? service;
  DateTime? dateTime;
  List<String>? symptoms;
  List<String>? conditions;
  bool? isConfirmed;
  String? venueString;
  Map? venueGeo;

  DoctorAppointment({
    this.id,
    this.doctorId,
    this.doctorName,
    this.patientId,
    this.patientName,
    this.dateTime,
    this.service,
    this.conditions,
    this.symptoms,
    this.isConfirmed,
    this.venueString,
    this.venueGeo,
  });

  DoctorAppointment.fromFirestore(Map<String, dynamic> map, String aId) {
    id = aId;
    doctorId = map['doctorId'] as String?;
    doctorName = map['doctorName'] as String?;
    patientId = map['patientId'] as String?;
    patientName = map['patientName'] as String?;
    service = map['service'] as String?;

    dateTime = DateTime.fromMillisecondsSinceEpoch(
        (map['dateTime'] as Timestamp).millisecondsSinceEpoch);

    symptoms = map['symptoms'] == null
        ? null
        : (map['symptoms'] as List<dynamic>?)!
            .map((e) => e.toString())
            .toList();

    conditions = map['conditions'] == null
        ? null
        : (map['conditions'] as List<dynamic>?)!
            .map((e) => e.toString())
            .toList();

    isConfirmed = map['isConfirmed'] as bool?;

    venueString = map['venueString'] as String?;

    venueGeo = map['venueGeo'];
  }
}
