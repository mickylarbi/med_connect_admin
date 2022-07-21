import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Experience {
  String? location;
  DateTime? startDate;
  DateTime? endDate;

  Experience(this.location, this.startDate, this.endDate);

  Experience.fromFirestore(Map<String, dynamic> map) {
    location = map['location'];
    startDate = DateTime.fromMillisecondsSinceEpoch(
        (map['startDate'] as Timestamp).millisecondsSinceEpoch);
    endDate = DateTime.fromMillisecondsSinceEpoch(
        (map['endDate'] as Timestamp).millisecondsSinceEpoch);
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  @override
  String toString() {
    return '$location (${DateFormat.yMMMd().format(startDate ?? DateTime(1))} - ${DateFormat.yMMMd().format(endDate ?? DateTime(1))})';
  }
}
