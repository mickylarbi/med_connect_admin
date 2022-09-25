import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/models/doctor/appointment.dart';
import 'package:med_connect_admin/screens/home/doctor/appointments/appointment_details_screen.dart';
import 'package:med_connect_admin/screens/home/doctor/appointments/patient_profile_screen.dart';
import 'package:med_connect_admin/screens/shared/header_text.dart';
import 'package:med_connect_admin/utils/functions.dart';

class AppointmentTodayCard extends StatelessWidget {
  const AppointmentTodayCard({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  final Appointment appointment;

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
                  child: ProfileImageWidget(
                    patientId: appointment.patientId!,
                    height: 40,
                    width: 40,
                    borderRadius: BorderRadius.circular(10),
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
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              appointment.patientName!,
              style: const TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
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
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                 CircleAvatar(
                backgroundColor: appointmentStatusColor(appointment.status!),
                radius: 10,
                child: Icon(
                  appointmentStatusIconData(appointment.status!),
                  size: 10,
                  color: Colors.white,
                ),
              )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
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
        navigate(context, DoctorAppointmentDetailsScreen(appointment: appointment));
      },
      child: Padding(
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
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      DateFormat.MMM().format(appointment.dateTime!),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Container(
                  height: 130,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText(text: appointment.service!),
                      Text(
                        appointment.doctorName!,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        DateFormat.jm().format(appointment.dateTime!),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              CircleAvatar(
                backgroundColor: appointmentStatusColor(appointment.status!),
                radius: 10,
                child: Icon(
                  appointmentStatusIconData(appointment.status!),
                  size: 10,
                  color: Colors.white,
                ),
              )
            ],
          )),
    );
  }
}


Color appointmentStatusColor(AppointmentStatus appointmentStatus) {
  switch (appointmentStatus) {
    case AppointmentStatus.pending:
      return Colors.grey;
    case AppointmentStatus.confirmed:
      return Colors.green;
    case AppointmentStatus.completed:
      return Colors.blue;
    case AppointmentStatus.canceled:
      return Colors.red;
    default:
      return Colors.grey;
  }
}

IconData appointmentStatusIconData(AppointmentStatus appointmentStatus) {
  switch (appointmentStatus) {
    case AppointmentStatus.pending:
      return Icons.more_horiz;
    case AppointmentStatus.confirmed:
      return Icons.done;
    case AppointmentStatus.completed:
      return Icons.done_all;
    case AppointmentStatus.canceled:
      return Icons.clear;
    default:
      return Icons.pending;
  }
}

String appointmentStatusMessage(AppointmentStatus appointmentStatus) {
  switch (appointmentStatus) {
    case AppointmentStatus.pending:
      return 'Appointment is pending confirmation';
    case AppointmentStatus.confirmed:
      return 'Appointment has been confirmed';
    case AppointmentStatus.completed:
      return 'Appointment has been completed';
    case AppointmentStatus.canceled:
      return 'Appointment has been canceled';
    default:
      return 'Appointment is pending';
  }
}
