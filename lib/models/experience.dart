import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Experience {
  String? location;
  DateTimeRange? dateTimeRange;

  Experience({this.location, this.dateTimeRange});

  Experience.fromFirestore(Map<String, dynamic> map) {
    location = map['location'];
    dateTimeRange = map['startDate'] == null && map['endDate'] == null
        ? null
        : DateTimeRange(
            start: DateTime.fromMillisecondsSinceEpoch(
                (map['startDate'] as Timestamp).millisecondsSinceEpoch),
            end: DateTime.fromMillisecondsSinceEpoch(
                (map['endDate'] as Timestamp).millisecondsSinceEpoch));
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'startDate': dateTimeRange!.start,
      'endDate': dateTimeRange!.end,
    };
  }

  @override
  String toString() {
    return '$location\n(${DateFormat.yMMMd().format(dateTimeRange!.start)} - ${DateFormat.yMMMd().format(dateTimeRange!.end)})';
  }

  @override
  bool operator ==(other) =>
      other is Experience &&
      location == other.location &&
      dateTimeRange == other.dateTimeRange;

  @override
  int get hashCode => hashValues(location, dateTimeRange);
}
