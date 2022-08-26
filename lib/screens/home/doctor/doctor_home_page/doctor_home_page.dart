import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/firebase_services/storage_service.dart';
import 'package:med_connect_admin/models/doctor_appointment.dart';
import 'package:med_connect_admin/models/doctor.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_appointments/doctor_appointment_card.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_home_page/doctor_profile/edit_doctor_profile_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/utils/functions.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({Key? key}) : super(key: key);

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  final ScrollController _scrollController = ScrollController();

  FirestoreService db = FirestoreService();
  StorageService storage = StorageService();

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
                        return appointmentsList.isEmpty
                            ? const Center(
                                child:
                                    Text('No appointments scheduled for today'),
                              )
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.none,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 36),
                                itemCount: appointmentsList.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
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
                        return appointmentsList.isEmpty
                            ? const Center(
                                child: Text(
                                    'No appointments pending confirmation'),
                              )
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.none,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 36),
                                itemCount: appointmentsList.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
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
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: db.getAdminInfo.snapshots(),
          builder: (context, snapshot) {
            return SizedBox(
              height: 138,
              child: Stack(
                children: fancyAppBar(
                  context,
                  _scrollController,
                  snapshot.hasError ||
                          snapshot.data == null ||
                          snapshot.data!.data() == null ||
                          snapshot.connectionState == ConnectionState.waiting
                      ? 'Hi'
                      : 'Hi ${snapshot.data!.data()!['firstName']}',
                  [
                    StatefulBuilder(
                      builder: (context, setState) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () async {
                              if (snapshot.data!.data() != null) {
                                await navigate(
                                    context,
                                    EditDoctorProfileScreen(
                                        doctor: Doctor.fromFireStore(
                                            snapshot.data!.data()!,
                                            snapshot.data!.id)));

                                setState(() {});
                              }
                            },
                            child: FutureBuilder<String>(
                              future: storage.profileImageDownloadUrl(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.refresh),
                                    ),
                                  );
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return CachedNetworkImage(
                                    imageUrl: snapshot.data,
                                    height: 44,
                                    width: 44,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator.adaptive(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        const Center(child: Icon(Icons.person)),
                                  );
                                }

                                return const Center(
                                    child:
                                        CircularProgressIndicator.adaptive());
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }
}
