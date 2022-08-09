import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/firebase_services/auth_service.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/models/doctor.dart';
import 'package:med_connect_admin/screens/onboarding/doctor_info_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/outline_icon_button.dart';
import 'package:med_connect_admin/utils/dialogs.dart';

class SummaryScreen extends StatelessWidget {
  final Doctor doctor;
  SummaryScreen({Key? key, required this.doctor}) : super(key: key);

  ScrollController scrollController = ScrollController();

  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(36),
              children: [
                const SizedBox(height: 130),
                const Text('Name'),
                Text(
                  '${doctor.firstName} ${doctor.surname}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                const Text('Current location:'),
                if (doctor.currentLocation == null) const Text('-'),
                if (doctor.currentLocation != null)
                  Text(
                    '${doctor.currentLocation!.location!} (since ${DateFormat.yMMMMd().format(doctor.currentLocation!.dateTimeRange!.start)})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 30),
                const Text('Experience:'),
                if (doctor.experiences!.isEmpty) const Text('-'),
                if (doctor.experiences!.isNotEmpty)
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: doctor.experiences!
                          .map((e) => Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                // crossAxisAlignment: WrapCrossAlignment,
                                runAlignment: WrapAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ' - ${e.location}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '   (${DateFormat.yMMMd().format(e.dateTimeRange!.start)} - ${DateFormat.yMMMd().format(e.dateTimeRange!.end)})',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ))
                          .toList()),
                const SizedBox(height: 20),
                const Text('Main Specialty:'),
                Text(
                  '${doctor.mainSpecialty}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text('Other specialties:'),
                if (doctor.otherSpecialties!.isEmpty) const Text('-'),
                if (doctor.otherSpecialties!.isNotEmpty)
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: doctor.otherSpecialties!
                          .map((e) => Text(
                                '- $e',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ))
                          .toList()),
                const SizedBox(height: 20),
                const Text('Services provided:'),
                if (doctor.services!.isEmpty) const Text('-'),
                if (doctor.services!.isNotEmpty)
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: doctor.services!
                          .map((e) => Text(
                                '- $e',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ))
                          .toList()),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 52 + 72,
                child: Padding(
                    padding: const EdgeInsets.all(36),
                    child: CustomFlatButton(
                        onPressed: () {
                          showConfirmationDialog(context, confirmFunction: () {
                            db.uploadDoctorInfo(context, doctor);
                          });
                        },
                        child: const Text('Done'))),
              ),
            ),
            ...fancyAppBar(
              context,
              scrollController,
              'Summary',
              [
                OutlineIconButton(
                  iconData: Icons.edit,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorInfoScreen(doctor: doctor),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
