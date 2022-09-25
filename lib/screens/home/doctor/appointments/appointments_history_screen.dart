import 'package:flutter/material.dart';

import 'package:med_connect_admin/models/doctor/appointment.dart';
import 'package:med_connect_admin/screens/home/doctor/appointments/appointment_card.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';

class AppointmentHistoryScreen extends StatelessWidget {
  final List<Appointment> appointmentsList;
  const AppointmentHistoryScreen({super.key, required this.appointmentsList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 88),
                itemBuilder: (BuildContext context, int index) {
                  return AppointmentCard(appointment: appointmentsList[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    height: 0,
                    indent: 126,
                    endIndent: 36,
                  );
                },
                itemCount: appointmentsList.length),
            const CustomAppBar(
              title: 'History',
            )
          ],
        ),
      ),
    );
  }
}
