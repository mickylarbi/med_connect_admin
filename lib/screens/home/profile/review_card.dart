import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/models/review.dart';
import 'package:med_connect_admin/screens/shared/header_text.dart';

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
                const HeaderText(text: 'Michael Larbi'),
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
            HeaderText(text: review.rating!.toStringAsFixed(2)),
          ],
        ),
        const SizedBox(height: 10),
        Text(review.comment!),
      ],
    );
  }
}
