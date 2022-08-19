import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Review {
  double? rating;
  String? userId;
  String? comment;
  DateTime? dateTime;

  Review({this.rating, this.userId, this.comment, this.dateTime});

  Review.fromFirestore(
    Map<String, dynamic> map,
  ) {
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

class ReviewCard extends StatelessWidget {
  final Review review;
  const ReviewCard({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Michael Larbi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat.yMd().add_jm().format(review.dateTime!),
                  style: const TextStyle(color: Colors.blueGrey),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            Text(
              review.rating!.toStringAsFixed(2),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(review.comment!),
      ],
    );
  }
}
