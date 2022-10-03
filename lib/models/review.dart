import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Review {
  double? rating;
  String? userId;
  String? appointmentId;
  String? doctorId;
  String? patientId;
  String? comment;
  DateTime? dateTime;

  Review(
      {this.rating,
      this.userId,
      this.comment,
      this.dateTime,
      this.appointmentId,
      this.doctorId,
      this.patientId});

  Review.fromFirestore(
    Map<String, dynamic> map,
  ) {
    rating = map['rating'];
    userId = map['userId'];
    appointmentId = map['appointmentId'];
    doctorId = map['doctorId'];
    patientId = map['patientId'];
    comment = map['comment'];
    dateTime = DateTime.fromMillisecondsSinceEpoch(
        (map['dateTime'] as Timestamp).millisecondsSinceEpoch);
  }

 
}
