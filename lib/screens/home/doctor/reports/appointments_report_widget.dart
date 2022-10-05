import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/models/doctor/appointment.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drug_details_screen.dart';
import 'package:med_connect_admin/screens/home/pharmacy/reports/reports_page.dart';

class AppointmentsReportWidget extends StatelessWidget {
  const AppointmentsReportWidget({
    Key? key,
    required this.appointmentsList,
  }) : super(key: key);

  final List<Appointment> appointmentsList;

  @override
  Widget build(BuildContext context) {
    //average appointments per day
    List<DateTime> dates = [];
    for (Appointment appointment in appointmentsList
        .where((element) => element.status == AppointmentStatus.completed)) {
      Iterable results = dates.where((element) =>
          element.year == appointment.dateTime!.year &&
          element.month == appointment.dateTime!.month &&
          element.day == appointment.dateTime!.day);
      if (results.isEmpty) {
        dates.add(appointment.dateTime!);
      }
    }
    print(dates);

    //services booked
    Map<String, int> servicesBooked = {};
    for (Appointment appointment in appointmentsList
        .where((element) => element.status == AppointmentStatus.completed)) {
      servicesBooked[appointment.service!] =
          (servicesBooked[appointment.service] ?? 0) + 1;
    }
    List<Color> serviceColors = List.generate(servicesBooked.length,
        (index) => Colors.primaries[Random().nextInt(Colors.primaries.length)]);

    return Column(
      children: [
        Row(
          children: [
            Column(
              children: [
                Text(
                  'Average orders per day',
                  style: labelTextStyle,
                ),
                Text(
                  (appointmentsList
                              .where((element) =>
                                  element.status == AppointmentStatus.completed)
                              .length /
                          dates.length)
                      .round()
                      .toString(),
                  style: boldDigitStyle,
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                  'Appointments completed',
                  style: labelTextStyle,
                ),
                Text(
                  appointmentsList
                      .where((element) =>
                          element.status == AppointmentStatus.completed)
                      .length
                      .toString(),
                  style: boldDigitStyle,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30),
        const SizedBox(height: 30),
        Text(
          'Services booked',
          style: labelTextStyle,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: List.generate(
                serviceColors.length,
                (index) => PieChartSectionData(
                  value: (servicesBooked.values.toList()[index]) * 360,
                  title: servicesBooked.values.toList()[index].toString(),
                  titleStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  color: serviceColors[index],
                ),
              ),
            ),
            swapAnimationDuration: const Duration(milliseconds: 150),
            swapAnimationCurve: Curves.linear,
          ),
        ),
        const SizedBox(height: 20),
        Column(
          children: List.generate(
            serviceColors.length,
            (index) => Row(
              children: [
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: serviceColors[index],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 10),
                Text(servicesBooked.keys.toList()[index]),
              ],
            ),
          ),
        )
      ],
    );
  }
}
