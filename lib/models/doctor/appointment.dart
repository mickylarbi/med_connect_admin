import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  String? id;
  String? doctorId;
  String? doctorName;
  String? patientId;
  String? patientName;
  String? service;
  DateTime? dateTime;
  List<String>? symptoms;
  List<String>? conditions;
  AppointmentStatus? status;
  String? venueString;
  Map? venueGeo;

  Appointment({
    this.id,
    this.doctorId,
    this.doctorName,
    this.patientId,
    this.patientName,
    this.dateTime,
    this.service,
    this.conditions,
    this.symptoms,
this.status,    this.venueString,
    this.venueGeo,
  });

  Appointment.fromFirestore(Map<String, dynamic> map, String aId) {
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

    status = AppointmentStatus.values[map['status']];

    venueString = map['venueString'] as String?;

    venueGeo = map['venueGeo'];
  }
}

enum AppointmentStatus { canceled, completed, confirmed, pending }
