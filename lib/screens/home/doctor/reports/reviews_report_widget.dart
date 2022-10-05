import 'package:flutter/material.dart';
import 'package:med_connect_admin/models/review.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_home_page/doctor_profile/reviews_list_screen.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drug_details_screen.dart';
import 'package:med_connect_admin/screens/home/pharmacy/reports/reports_page.dart';
import 'package:med_connect_admin/utils/functions.dart';

class ReviewsReportWidget extends StatelessWidget {
  const ReviewsReportWidget({
    Key? key,
    required this.reviewsList,
  }) : super(key: key);

  final List<Review> reviewsList;

  @override
  Widget build(BuildContext context) {
    double totalRating = 0;

    if (reviewsList.isNotEmpty) {
      for (Review element in reviewsList) {
        totalRating += element.rating!;
      }
      totalRating /= reviewsList.length;
    }
    return Column(
      children: [
        const Icon(Icons.star, color: Colors.yellow),
        Text(
          totalRating.toStringAsFixed(1),
          style: boldDigitStyle,
        ),
        Text(
          reviewsList.isEmpty
              ? 'No reviews'
              : '${reviewsList.length} review${reviewsList.length == 1 ? "" : "s"}',
          style: labelTextStyle,
        ),
        if (reviewsList
            .where((element) =>
                element.comment != null && element.comment!.isNotEmpty)
            .isNotEmpty)
          TextButton(
            onPressed: () {
              navigate(context, ReviewListScreen(reviews: reviewsList));
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.blueGrey.withOpacity(.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text('View comments'),
          ),
      ],
    );
  }
}

