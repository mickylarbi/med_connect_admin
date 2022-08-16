import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Immunization {
  String? immunization;
  DateTime? date;

  Immunization({this.immunization, this.date});

  Immunization.fromMap(Map map) {
    immunization = map['immunization'];
    date = DateTime.fromMillisecondsSinceEpoch(
        (map['date'] as Timestamp).millisecondsSinceEpoch);
  }

  Map<String, dynamic> toFirestore() {
    return {'immunization': immunization, 'date': date};
  }

  @override
  String toString() {
    return '$immunization (${DateFormat.yMMMM().format(date!)})';
  }

  @override
  bool operator ==(other) =>
      other is Immunization &&
      other.immunization == immunization &&
      other.date == date;

  @override
  int get hashCode => hashValues(immunization, date);
}
