import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  double? rating;
  String? userId;
  String? comment;
  DateTime? dateTime;

  Review({this.rating, this.userId, this.comment, this.dateTime});

  Review.fromFirestore(Map<String, dynamic> map, ) {
    rating = map['rating'];
    userId = map['userId'];
    comment = map['comment'];
     dateTime = DateTime.fromMillisecondsSinceEpoch(
       (map['dateTime'] as Timestamp).millisecondsSinceEpoch);
  }

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'userId': userId,
      'comment': comment,
      'dateTime': dateTime
    };
  }
}
