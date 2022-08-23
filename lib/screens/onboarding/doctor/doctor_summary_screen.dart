import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/firebase_services/auth_service.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/models/doctor.dart';
import 'package:med_connect_admin/screens/onboarding/doctor/doctor_info_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/outline_icon_button.dart';
import 'package:med_connect_admin/utils/dialogs.dart';

class DoctorSummaryScreen extends StatelessWidget {
  final Doctor doctor;
  final XFile picture;
  DoctorSummaryScreen({Key? key, required this.doctor, required this.picture})
      : super(key: key);

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
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(picture.path),
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
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
                    doctor.currentLocation!.dateTimeRange == null
                        ? doctor.currentLocation!.location!
                        : '${doctor.currentLocation!.location!} (since ${DateFormat.yMMMMd().format(doctor.currentLocation!.dateTimeRange!.start)})',
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
                SizedBox(height: 50 + MediaQuery.of(context).padding.bottom)
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
                          showConfirmationDialog(context,
                              message: 'Upload info?', confirmFunction: () {
                            db.uploadDoctorInfo(context, doctor, picture);
                          });
                        },
                        child: const Text('Upload info'))),
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
                        builder: (context) => DoctorInfoScreen(
                          doctor: doctor,
                          picture: picture,
                        ),
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
