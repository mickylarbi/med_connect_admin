import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicalHistoryEntry {
  String? illness;
  DateTime? dateOfOnset;

  MedicalHistoryEntry({this.illness, this.dateOfOnset});

  MedicalHistoryEntry.fromMap(Map map) {
    illness = map['illness'];
    dateOfOnset = DateTime.fromMillisecondsSinceEpoch(
        (map['dateOfOnset'] as Timestamp).millisecondsSinceEpoch);
  }

  Map<String, dynamic> toFirestore() {
    return {'illness': illness, 'dateOfOnset': dateOfOnset};
  }

  @override
  String toString() {
    return '$illness (${DateFormat.yMMMMd().format(dateOfOnset!)})';
  }

  @override
  bool operator ==(other) =>
      other is MedicalHistoryEntry &&
      other.illness == illness &&
      other.dateOfOnset == dateOfOnset;

  @override
  int get hashCode => hashValues(illness, dateOfOnset);
}
