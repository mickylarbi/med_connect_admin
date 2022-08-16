import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorAppointment {
  String? id;
  String? location;
  String? doctorId;
  String? doctorName;
  String? patientId;
  String? patientName;
  String? service;
  DateTime? dateTime;
  List<String>? symptoms;
  List<String>? conditions;
  bool? isConfirmed;

  DoctorAppointment(
      {this.id,
      this.location,
      this.doctorId,
      this.doctorName,
      this.patientId,
      this.patientName,
      this.dateTime,
      this.service,
      this.conditions,
      this.symptoms,
      this.isConfirmed});

  DoctorAppointment.fromFirestore(Map<String, dynamic> map, String aId) {
    id = aId;
    location = map['location'] as String?;
    doctorId = map['doctorId'] as String?;
    doctorName = map['doctorName'] as String?;
    patientId = map['patientId'] as String?;
    patientName = map['patientName'] as String?;
    service = map['service'] as String?;

    dateTime = DateTime.fromMillisecondsSinceEpoch(
        (map['dateTime'] as Timestamp).millisecondsSinceEpoch);

    symptoms =
        (map['symptoms'] as List<dynamic>?)!.map((e) => e.toString()).toList();

    conditions = (map['conditions'] as List<dynamic>?)!
        .map((e) => e.toString())
        .toList();

    isConfirmed = map['isConfirmed'] as bool?;
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'patientId': patientId,
      'patientName': patientName,
      'service': service,
      'dateTime': dateTime,
      'symptoms': symptoms,
      'conditions': conditions,
      'isConfirmed': isConfirmed,
    };
  }

  @override
  bool operator ==(other) =>
      other is DoctorAppointment &&
      patientId == other.patientId &&
      patientName == other.patientName &&
      doctorId == other.doctorId &&
      dateTime == other.dateTime &&
      service == other.service &&
      symptoms == other.symptoms &&
      conditions == other.conditions &&
      other.location == other.location &&
      other.isConfirmed == isConfirmed;

  @override
  int get hashCode => hashValues(
        patientId,
        patientName,
        doctorId,
        dateTime,
        service,
        hashList(symptoms),
        hashList(conditions),
        location,
        isConfirmed,
      );
}
