import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/models/appointment.dart';
import 'package:med_connect_admin/models/doctor.dart';
import 'package:med_connect_admin/screens/home/appointments/doctor_appointment_card.dart';
import 'package:med_connect_admin/screens/home/home_page/profile/doctor_profile_details_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/header_text.dart';
import 'package:med_connect_admin/utils/functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 138,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(36, 36, 36, 24),
                child: Text(
                  'Today\'s appointments',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: StatefulBuilder(builder: (context, setState) {
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: db.myAppointments.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Something went wrong'),
                                IconButton(
                                    onPressed: () {
                                      setState(
                                        () {},
                                      );
                                    },
                                    icon: const Icon(Icons.refresh))
                              ],
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }

                        List<DoctorAppointment> appointmentsList = snapshot
                            .data!.docs
                            .map((e) =>
                                DoctorAppointment.fromFirestore(e.data(), e.id))
                            .toList()
                            .where((element) =>
                                element.dateTime!.year == DateTime.now().year &&
                                element.dateTime!.month ==
                                    DateTime.now().month &&
                                element.dateTime!.day == DateTime.now().day)
                            .toList();
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          itemCount: appointmentsList.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 24);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            DoctorAppointment appointment =
                                appointmentsList[index];

                            return DoctorAppointmentTodayCard(
                                appointment: appointment);
                          },
                        );
                      });
                }),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.fromLTRB(36, 36, 36, 24),
                child: Text(
                  'Pending confirmation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: StatefulBuilder(builder: (context, setState) {
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: db.myAppointments
                          .where('isConfirmed', isEqualTo: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Something went wrong'),
                                IconButton(
                                    onPressed: () {
                                      setState(
                                        () {},
                                      );
                                    },
                                    icon: const Icon(Icons.refresh))
                              ],
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }

                        List<DoctorAppointment> appointmentsList = snapshot
                            .data!.docs
                            .map((e) =>
                                DoctorAppointment.fromFirestore(e.data(), e.id))
                            .toList()
                            .where((element) =>
                                element.dateTime!.isAfter(DateTime.now()))
                            .toList();
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          itemCount: appointmentsList.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 24);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            DoctorAppointment appointment =
                                appointmentsList[index];

                            return DoctorAppointmentTodayCard(
                                appointment: appointment);
                          },
                        );
                      });
                }),
              ),
            ],
          ),
        ),
        ...fancyAppBar(
          context,
          _scrollController,
          'Hi Name',
          [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  navigate(context, DoctorProfileDetailsScreen());
                },
                child: Image.asset(
                  'assets/images/bruno-rodrigues-279xIHymPYY-unsplash.jpg',
                  height: 44,
                  width: 44,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
