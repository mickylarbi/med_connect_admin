import 'package:flutter/material.dart';
import 'package:med_connect_admin/models/review.dart';
import 'package:med_connect_admin/screens/home/doctor/appointments/appointment_details_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect_admin/utils/dialogs.dart';

class ReviewListScreen extends StatelessWidget {
  final List<Review> reviews;
  const ReviewListScreen({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Review> sortedList = reviews;

    return Scaffold(
      body: SafeArea(
        child: StatefulBuilder(builder: (context, setState) {
          return Stack(
            children: [
              ListView.separated(
                padding: const EdgeInsets.fromLTRB(36, 88, 36, 36),
                physics: const BouncingScrollPhysics(),
                itemCount: reviews.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(height: 50);
                },
                itemBuilder: (BuildContext context, int index) {
                  return ReviewCard(review: reviews.reversed.toList()[index]);
                },
              ),
              CustomAppBar(
                leading: Icons.arrow_back,
                title: 'Reviews',
                actions: [
                  OutlineIconButton(
                    iconData: Icons.sort_rounded,
                    onPressed: () {
                      showCustomBottomSheet(
                        context,
                        [
                          ListTile(
                            title: const Text('Sort by date'),
                            onTap: () {
                              sortedList.sort(((a, b) =>
                                  a.dateTime!.compareTo(b.dateTime!)));
                              Navigator.pop(context);
                              setState(() {});
                            },
                          ),
                          ListTile(
                            title: const Text('Sort by rating'),
                            onTap: () {
                              sortedList.sort(
                                  ((a, b) => a.rating!.compareTo(b.rating!)));
                              Navigator.pop(context);
                              setState(() {});
                            },
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
