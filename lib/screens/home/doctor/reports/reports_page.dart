import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_services/auth_service.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/models/doctor/appointment.dart';
import 'package:med_connect_admin/models/review.dart';
import 'package:med_connect_admin/screens/home/doctor/reports/appointments_report_widget.dart';
import 'package:med_connect_admin/screens/home/doctor/reports/reviews_report_widget.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';

class DoctorReportPage extends StatefulWidget {
  const DoctorReportPage({super.key});

  @override
  State<DoctorReportPage> createState() => _DoctorReportPageState();
}

class _DoctorReportPageState extends State<DoctorReportPage> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(36, 150, 36, 50),
              child: FutureBuilder<List>(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {}
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<Review> reviewsList = snapshot.data![0];
                      List<Appointment> appointmentsList = snapshot.data![1];

                      return Column(
                        children: [
                          ReviewsReportWidget(reviewsList: reviewsList),
                          const Divider(height: 100),
                          AppointmentsReportWidget(appointmentsList: appointmentsList),
                        ],
                      );
                    }
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }),
            ),
          ),
          ...fancyAppBar(context, scrollController, 'Reports', []),
        ],
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

Future<List> getData() async {
  FirestoreService db = FirestoreService();
  AuthService auth = AuthService();

  QuerySnapshot<Map<String, dynamic>> reviewsQuerySnapshot = await db.instance
      .collection('doctor_reviews')
      .where('doctorId', isEqualTo: auth.uid)
      .get();
  QuerySnapshot<Map<String, dynamic>> appointmentsQuerySnapshot =
      await db.myAppointments.get();

  return [
    reviewsQuerySnapshot.docs
        .map((e) => Review.fromFirestore(e.data()))
        .toList(),
    appointmentsQuerySnapshot.docs
        .map((e) => Appointment.fromFirestore(e.data(), e.id))
        .toList(),
  ];
}
