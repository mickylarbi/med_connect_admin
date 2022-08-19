import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/models/appointment.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_appointments/doctor_appointment_card.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';

class DoctorAppointmentsListPage extends StatefulWidget {
  const DoctorAppointmentsListPage({Key? key}) : super(key: key);

  @override
  State<DoctorAppointmentsListPage> createState() =>
      _DoctorAppointmentsListPageState();
}

class _DoctorAppointmentsListPageState
    extends State<DoctorAppointmentsListPage> {
  ScrollController scrollController = ScrollController();

  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    //TODO: calendar
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              controller: scrollController,
              children: [
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: db.myAppointments.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          children: [
                            const Text('Could not fetch appointments.'),
                            IconButton(
                                onPressed: () {
                                  setState(() {});
                                },
                                icon: const Icon(Icons.refresh))
                          ],
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }

                    List<DoctorAppointment> appointmentsList = snapshot
                        .data!.docs
                        .map((e) =>
                            DoctorAppointment.fromFirestore(e.data(), e.id))
                        .toList();
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 130),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      primary: false,
                      itemCount: appointmentsList.length,
                      itemBuilder: (context, index) => DoctorAppointmentCard(
                          appointment: appointmentsList[index]),
                      separatorBuilder: (context, index) =>
                          const Divider(height: 30),
                    );
                  },
                ),
              ],
            ),
            ...fancyAppBar(
              context,
              scrollController,
              'Appointments',
              [],
            ),
          ],
        ),
      ),
    );
  }
}