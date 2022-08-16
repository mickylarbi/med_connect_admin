import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Allergy {
  String? allergy;
  String? reaction;
  DateTime? dateOfLastOccurence;

  Allergy({this.allergy, this.reaction, this.dateOfLastOccurence});

  Allergy.fromMap(Map map) {
    allergy = map['allergy'];
    reaction = map['reaction'];
    dateOfLastOccurence = DateTime.fromMillisecondsSinceEpoch(
        (map['dateOfLastOccurence'] as Timestamp).millisecondsSinceEpoch);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'allergy': allergy,
      'reaction': reaction,
      'dateOfLastOccurence': dateOfLastOccurence
    };
  }

  @override
  bool operator ==(other) =>
      other is Allergy &&
      other.allergy == allergy &&
      other.reaction == reaction &&
      other.dateOfLastOccurence == dateOfLastOccurence;

  @override
  int get hashCode => hashValues(allergy, reaction, dateOfLastOccurence);
}
