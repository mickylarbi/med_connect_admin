import 'package:flutter/material.dart';
import 'package:med_connect_admin/models/review.dart';

double calculateRating(List<Review> reviewList) {
  if (reviewList.isEmpty) return 0.0;

  double? sum = 0;

  for (Review review in reviewList) {
    sum = review.rating;
  }

  return (sum! / reviewList.length);
}

void navigate(BuildContext context, Widget destination) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
}
