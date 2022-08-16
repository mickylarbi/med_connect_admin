import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Surgery {
  DateTime? date;
  String? doctor;
  String? hospital;
  String? surgicalProcedure;
  String? results;
  String? comments;

  Surgery(
      {this.date,
      this.doctor,
      this.hospital,
      this.surgicalProcedure,
      this.results,
      this.comments});

  Surgery.fromMap(Map map) {
    date = DateTime.fromMillisecondsSinceEpoch(
        (map['date'] as Timestamp).millisecondsSinceEpoch);
    doctor = map['doctor'] as String?;
    hospital = map['hospital'] as String?;
    surgicalProcedure = map['surgicalProcedure'] as String?;
    results = map['results'] as String?;
    comments = map['comments'] as String?;
  }

  Map toFirestore() => {
        'date': date,
        'doctor': doctor,
        'hospital': hospital,
        'surgicalProcedure': surgicalProcedure,
        'results': results,
        'comments': comments,
      };

  @override
  bool operator ==(other) =>
      other is Surgery &&
      other.date == date &&
      other.doctor == doctor &&
      other.hospital == hospital &&
      other.surgicalProcedure == surgicalProcedure &&
      other.results == results &&
      other.comments == comments;

  @override
  int get hashCode =>
      hashValues(date, doctor, hospital, surgicalProcedure, results, comments);
}
