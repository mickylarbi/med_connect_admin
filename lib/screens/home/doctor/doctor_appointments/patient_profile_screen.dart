import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/firebase_services/storage_service.dart';
import 'package:med_connect_admin/models/patient/patient.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/utils/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientProfileScreen extends StatefulWidget {
  final String patientId;
  const PatientProfileScreen({Key? key, required this.patientId})
      : super(key: key);

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: db.patientDocument(widget.patientId).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        children: [
                          const Text('Couldn\'t get patient info.'),
                          IconButton(
                              onPressed: () {
                                setState(() {});
                              },
                              icon: const Icon(Icons.refresh))
                        ],
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    Patient patient = Patient.fromFirestore(
                        snapshot.data!.data()!, snapshot.data!.id);
                    return ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 88),
                      children: [
                        Center(
                          child: ProfileImageWidget(
                              patientId: patient.id!, height: 150, width: 150),
                        ),
                        const SizedBox(height: 20),
                        Center(
                            child: Text(
                          patient.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                        const SizedBox(height: 10),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              showCustomBottomSheet(
                                context,
                                [
                                  ListTile(
                                    onTap: () async {
                                      Navigator.pop(context);

                                      Uri phoneUri = Uri(
                                          scheme: 'tel', path: patient.phone!);

                                      try {
                                        if (await canLaunchUrl(phoneUri)) {
                                          await launchUrl(phoneUri);
                                        } else {
                                          showAlertDialog(context);
                                        }
                                      } catch (e) {
                                        showAlertDialog(context);
                                      }
                                    },
                                    leading: const Icon(Icons.call),
                                    title: const Text('Call patient'),
                                  ),
                                  ListTile(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      Uri smsUri = Uri(
                                        scheme: 'sms',
                                        path: patient.phone!,
                                        queryParameters: <String, String>{
                                          'body': Uri.encodeComponent(
                                            'From MedConnect App\n',
                                          ),
                                        },
                                      );

                                      try {
                                        if (await canLaunchUrl(smsUri)) {
                                          await launchUrl(smsUri);
                                        } else {
                                          showAlertDialog(context);
                                        }
                                      } catch (e) {
                                        showAlertDialog(context);
                                      }
                                    },
                                    leading: const Icon(Icons.sms),
                                    title: const Text('Send an SMS'),
                                  ),
                                ],
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.blueGrey.withOpacity(.2)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(horizontal: 14)),
                            ),
                            child: const Text('Contact'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            if (patient.dateOfBirth != null ||
                                patient.gender != null)
                              Expanded(
                                child: Center(
                                  child: Column(
                                    children: [
                                      if (patient.dateOfBirth != null)
                                        const Text(
                                          'Age',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      if (patient.dateOfBirth != null)
                                        Text(
                                            '${(DateTime.now().difference(patient.dateOfBirth!).inDays ~/ 365)} years'),
                                      if (patient.dateOfBirth != null &&
                                          patient.gender != null)
                                        const SizedBox(height: 20),
                                      if (patient.gender != null)
                                        const Text(
                                          'Gender',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      if (patient.gender != null)
                                        Text(patient.gender!),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                            if (patient.height != null ||
                                patient.weight != null)
                              Expanded(
                                child: Center(
                                  child: Column(
                                    children: [
                                      if (patient.height != null)
                                        const Text(
                                          'Height',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      if (patient.height != null)
                                        Text(
                                            '${patient.height!.toString()} cm'),
                                      if (patient.height != null &&
                                          patient.weight != null)
                                        const SizedBox(height: 20),
                                      if (patient.weight != null)
                                        const Text(
                                          'Weight',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      if (patient.weight != null)
                                        Text(
                                            '${patient.weight!.toString()} kg'),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (patient.bloodType != null)
                          const Divider(height: 70),
                        if (patient.bloodType != null)
                          const Text(
                            'Blood type',
                            style: TextStyle(color: Colors.grey),
                          ),
                        if (patient.bloodType != null) Text(patient.bloodType!),

                        //MEDICAL HISTORY

                        if (patient.medicalHistory != null &&
                            patient.medicalHistory!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(height: 70),
                              const Text(
                                'Immunization',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: const [
                                  Expanded(child: Text('Illness')),
                                  Expanded(
                                    child: Text('Date of onset'),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.blueGrey,
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                primary: false,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Text(patient
                                            .medicalHistory![index].illness!),
                                      ),
                                      Expanded(
                                        child: Text(DateFormat.yMMM().format(
                                            patient.medicalHistory![index]
                                                .dateOfOnset!)),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 5),
                                itemCount: patient.medicalHistory!.length,
                              ),
                            ],
                          ),

                        //IMMUNIZATION

                        if (patient.immunizations != null &&
                            patient.immunizations!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Divider(height: 70),
                              const Text(
                                'Immunization',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                primary: false,
                                itemBuilder: (context, index) {
                                  return Text(
                                      '- ${patient.immunizations![index].toString()}');
                                },
                                itemCount: patient.immunizations!.length,
                              ),
                            ],
                          ),

                        //ALLERGIES

                        if (patient.allergies != null &&
                            patient.allergies!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(height: 70),
                              const Text(
                                'Allergies',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: const [
                                  Expanded(child: Text('Allergy')),
                                  Expanded(child: Text('Reaction')),
                                  Expanded(
                                    child: Text('Date of last occurence'),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.blueGrey,
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                primary: false,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                            patient.allergies![index].allergy!),
                                      ),
                                      Expanded(
                                        child: Text(patient
                                            .allergies![index].reaction!),
                                      ),
                                      Expanded(
                                        child: Text(DateFormat.yMMM().format(
                                            patient.allergies![index]
                                                .dateOfLastOccurence!)),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 5),
                                itemCount: patient.allergies!.length,
                              ),
                            ],
                          ),

                        //FAMILY MEDICAL HISTORY

                        if (patient.familyMedicalHistory != null &&
                            patient.familyMedicalHistory!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(height: 70),
                              const Text(
                                'Family Medical History',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                primary: false,
                                itemBuilder: (context, index) {
                                  return Text(
                                      '- ${patient.familyMedicalHistory![index].toString()}');
                                },
                                itemCount: patient.familyMedicalHistory!.length,
                              ),
                            ],
                          ),

                        // SURGERIES

                        if (patient.surgeries != null &&
                            patient.surgeries!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(height: 70),
                              const Text(
                                'Surgeries',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 10),
                              LayoutBuilder(builder: (context, constraints) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Expanded(
                                            child: Text('Surgical procedure')),
                                        const Expanded(child: Text('Date')),
                                        if (constraints.maxWidth > 450)
                                          const Expanded(
                                              child: Text('Hospital')),
                                        if (constraints.maxWidth > 450)
                                          const Expanded(child: Text('Doctor')),
                                        if (constraints.maxWidth > 450)
                                          const Expanded(
                                              child: Text('Results')),
                                        if (constraints.maxWidth > 450)
                                          const Expanded(
                                              child: Text('Comments')),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.blueGrey,
                                    ),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      primary: false,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: Text(patient
                                                  .surgeries![index]
                                                  .surgicalProcedure!),
                                            ),
                                            Expanded(
                                              child: Text(DateFormat.yMMM()
                                                  .format(patient
                                                      .surgeries![index]
                                                      .date!)),
                                            ),
                                            if (constraints.maxWidth > 450)
                                              Expanded(
                                                child: Text(patient
                                                    .surgeries![index]
                                                    .hospital!),
                                              ),
                                            if (constraints.maxWidth > 450)
                                              Expanded(
                                                child: Text(patient
                                                    .surgeries![index].doctor!),
                                              ),
                                            if (constraints.maxWidth > 450)
                                              Expanded(
                                                child: Text(patient
                                                    .surgeries![index]
                                                    .results!),
                                              ),
                                            if (constraints.maxWidth > 450)
                                              Expanded(
                                                child: Text(patient
                                                    .surgeries![index]
                                                    .comments!),
                                              ),
                                          ],
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 5),
                                      itemCount: patient.surgeries!.length,
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                      ],
                    );
                  }

                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }),
            const CustomAppBar(
              backgroundColor: Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}

class ProfileImageWidget extends StatelessWidget {
  ProfileImageWidget({
    Key? key,
    this.patientId,
    required this.height,
    required this.width,
    this.borderRadius,
  }) : super(key: key);

  StorageService storage = StorageService();
  final String? patientId;
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        color: Colors.grey.withOpacity(.1),
        child: StatefulBuilder(builder: (context, setState) {
          return FutureBuilder<String>(
            future: storage.profileImageDownloadUrl(patientId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return GestureDetector(
                  onTap: () async {
                    setState(() {});
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Tap to reload',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Icon(
                        Icons.refresh,
                        color: Colors.grey,
                      )
                    ],
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return CachedNetworkImage(
                  imageUrl: snapshot.data!,
                  height: height,
                  width: width,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator.adaptive(
                        value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.person)),
                );
              }
              return const Center(child: CircularProgressIndicator.adaptive());
            },
          );
        }),
      ),
    );
  }
}
