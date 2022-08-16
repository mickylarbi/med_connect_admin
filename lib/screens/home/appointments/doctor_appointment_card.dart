import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/models/appointment.dart';
import 'package:med_connect_admin/screens/home/appointments/doctor_appointment_details_screen.dart';
import 'package:med_connect_admin/screens/shared/header_text.dart';
import 'package:med_connect_admin/utils/functions.dart';

class DoctorAppointmentTodayCard extends StatelessWidget {
  const DoctorAppointmentTodayCard({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  final DoctorAppointment appointment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigate(
          context,
          DoctorAppointmentDetailsScreen(
            appointment: appointment,
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 200,
        width: 200,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(.1),
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //       blurRadius: 50,
          //       spreadRadius: -14,
          //       offset: Offset(0, 24),
          //       color: Colors.grey.withOpacity(.2)),
          // ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    //TODO:
                    'assets/images/humberto-chavez-FVh_yqLR9eA-unsplash.jpg',
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.blueGrey.withOpacity(.15)),
                  child: Text(
                    DateFormat.jm().format(appointment.dateTime!),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Text(
              appointment.patientName!,
              style: const TextStyle(fontSize: 18),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  appointment.service!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                if (appointment.isConfirmed != null && appointment.isConfirmed!)
                  const CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 10,
                    child: Icon(
                      Icons.done,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final DoctorAppointment appointment;
  final EdgeInsetsGeometry padding;
  const AppointmentCard(
      {Key? key,
      required this.appointment,
      this.padding = const EdgeInsets.symmetric(horizontal: 36)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigate(
            context, DoctorAppointmentDetailsScreen(appointment: appointment));
      },
      child: Padding(
          //TODO: show time
          padding: padding,
          child: Row(
            children: [
              Container(
                height: 100,
                width: 90,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat.d().format(appointment.dateTime!),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Text(
                      DateFormat.MMM().format(appointment.dateTime!),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 30),
              Container(
                height: 130,
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderText(text: appointment.service!),
                    Text(appointment.doctorName!),
                    Text(appointment.location!)
                  ],
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.withOpacity(.5),
                size: 40,
              )
            ],
          )),
    );
  }
}
