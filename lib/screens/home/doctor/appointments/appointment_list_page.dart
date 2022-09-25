import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_services/auth_service.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/models/doctor/appointment.dart';
import 'package:med_connect_admin/screens/home/doctor/appointments/appointments_history_screen.dart';
import 'package:med_connect_admin/screens/home/doctor/appointments/calendar_view_screen.dart';
import 'package:med_connect_admin/screens/home/doctor/appointments/appointment_card.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect_admin/utils/functions.dart';

class AppointmentsListPage extends StatefulWidget {
  const AppointmentsListPage({Key? key}) : super(key: key);

  @override
  State<AppointmentsListPage> createState() => _AppointmentsListPageState();
}

class _AppointmentsListPageState extends State<AppointmentsListPage> {
  final ScrollController _scrollController = ScrollController();

  AuthService auth = AuthService();
  FirestoreService db = FirestoreService();

  ValueNotifier<List<Appointment>> appointmentsListNotifier =
      ValueNotifier<List<Appointment>>([]);

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
            children: <Widget>[
              const SizedBox(height: 138),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: db.myAppointments.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  appointmentsListNotifier.value = [
                    ...snapshot.data!.docs
                        .map(
                          (e) => Appointment.fromFirestore(e.data(), e.id),
                        )
                        .toList()
                  ];

                  appointmentsListNotifier.value.sort((a, b) =>
                      a.dateTime!.millisecondsSinceEpoch.toString().compareTo(
                          b.dateTime!.millisecondsSinceEpoch.toString()));

                  appointmentsListNotifier.value =
                      appointmentsListNotifier.value.reversed.toList();

                  List<Appointment> currentAppointmentsList =
                      appointmentsListNotifier.value
                          .where((element) =>
                              element.status == AppointmentStatus.pending ||
                              element.status == AppointmentStatus.confirmed)
                          .toList();

                  return ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: currentAppointmentsList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 0,
                        indent: 126,
                        endIndent: 36,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return AppointmentCard(
                          appointment: currentAppointmentsList[index]);
                    },
                  );
                },
              ),
            ],
          ),
        ),
        ...fancyAppBar(
          context,
          _scrollController,
          'Appointments',
          [
            OutlineIconButton(
              iconData: Icons.calendar_month_rounded,
              onPressed: () {
                if (appointmentsListNotifier.value.isNotEmpty) {
                  navigate(
                      context,
                      CalendarViewScreen(
                          appointmentList: appointmentsListNotifier.value));
                }
              },
            ),
            const SizedBox(width: 10),
            OutlineIconButton(
              iconData: Icons.history,
              onPressed: () {
                navigate(
                  context,
                  AppointmentHistoryScreen(
                    appointmentsList: appointmentsListNotifier.value
                        .where((element) =>
                            element.status == AppointmentStatus.canceled ||
                            element.status == AppointmentStatus.completed)
                        .toList(),
                  ),
                );
              },
            )
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    appointmentsListNotifier.dispose();
    super.dispose();
  }
}
