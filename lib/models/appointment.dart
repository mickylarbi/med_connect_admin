import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Appointment {
  String? id;

  String? patientId;
  String? patientName;

  String? doctorId;
  String? doctorName;

  DateTime? dateTime;

  String? service;
  List<String>? symptoms;
  List<String>? conditions;

  String? location;

  Appointment({
    this.id,
    this.patientId,
    this.patientName,
    this.doctorId,
    this.doctorName,
    this.dateTime,
    this.service,
    this.conditions,
    this.symptoms,
    this.location,
  });

  Appointment.fromFirestore(Map<String, dynamic> map, String aId) {
    id = aId;

    patientId = map['patientId'] as String?;
    patientName = map['patientName'] as String?;

    doctorId = map['doctorId'] as String?;
    doctorName = map['doctorName'] as String?;

    dateTime = DateTime.fromMillisecondsSinceEpoch(
        (map['dateTime'] as Timestamp).millisecondsSinceEpoch);

    service = map['service'] as String?;

    symptoms =
        (map['symptoms'] as List<dynamic>?)!.map((e) => e.toString()).toList();

    conditions = (map['conditions'] as List<dynamic>?)!
        .map((e) => e.toString())
        .toList();

    location = map['location'] as String?;
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'dateTime': dateTime,
      'service': service,
      'symptoms': symptoms,
      'conditions': conditions,
      'location': location,
    };
  }

  @override
  bool operator ==(other) =>
      other is Appointment &&
      patientId == other.patientId &&
      doctorId == other.doctorId &&
      dateTime == other.dateTime &&
      service == other.service &&
      symptoms == other.symptoms &&
      conditions == other.conditions &&
      other.location == other.location;

  @override
  int get hashCode => hashValues(
        patientId,
        doctorId,
        dateTime,
        service,
        hashList(symptoms),
        hashList(conditions),
        location,
      );
}
