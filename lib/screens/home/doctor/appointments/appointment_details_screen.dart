import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/models/doctor/appointment.dart';
import 'package:med_connect_admin/models/doctor/prescription.dart';
import 'package:med_connect_admin/models/patient/patient.dart';
import 'package:med_connect_admin/models/pharmacy/drug.dart';
import 'package:med_connect_admin/models/review.dart';
import 'package:med_connect_admin/screens/home/doctor/appointments/appointment_card.dart';
import 'package:med_connect_admin/screens/home/doctor/appointments/patient_profile_screen.dart';
import 'package:med_connect_admin/screens/home/doctor/appointments/prescription_details_screen.dart';
import 'package:med_connect_admin/screens/home/doctor/appointments/prescription_form_screen.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drugs_search_delegate.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/header_text.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';
import 'package:med_connect_admin/utils/functions.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorAppointmentDetailsScreen extends StatefulWidget {
  final Appointment appointment;
  const DoctorAppointmentDetailsScreen({Key? key, required this.appointment})
      : super(key: key);

  @override
  State<DoctorAppointmentDetailsScreen> createState() =>
      _DoctorAppointmentDetailsScreenState();
}

class _DoctorAppointmentDetailsScreenState
    extends State<DoctorAppointmentDetailsScreen> {
  FirestoreService db = FirestoreService();
  late ValueNotifier<AppointmentStatus> status;

  @override
  void initState() {
    super.initState();

    status = ValueNotifier<AppointmentStatus>(widget.appointment.status!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 88),
              children: [
                if (widget.appointment.status == AppointmentStatus.confirmed ||
                    widget.appointment.status == AppointmentStatus.completed)
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: db.instance
                          .collection('prescriptions')
                          .doc(widget.appointment.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {}
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {}

                        return TextButton(
                          onPressed: snapshot.data == null ||
                                  snapshot.data!.exists
                              ? () {
                                  Prescription prescription =
                                      Prescription.fromFirestore(
                                          snapshot.data!.data()!,
                                          snapshot.data!.id);

                                  navigate(
                                      context,
                                      PrescriptionDetailsScreen(
                                          prescription: prescription));
                                }
                              : () {
                                  showLoadingDialog(context);
                                  db.drugsCollection
                                      .get()
                                      .timeout(ktimeout)
                                      .then((value) async {
                                    List<Drug> drugsList = value.docs
                                        .map((e) =>
                                            Drug.fromFirestore(e.data(), e.id))
                                        .toList();

                                    List<String> groups = [];

                                    for (Drug element in drugsList) {
                                      if (!groups.contains(element.group)) {
                                        groups.add(element.group!);
                                      }
                                    }

                                    Navigator.pop(context);
                                    var result = await showSearch(
                                        context: context,
                                        delegate: DrugSearchDelegate(
                                            drugsList, groups,
                                            isFromDoctor: true));

                                    if (result != null) {
                                      navigate(
                                          context,
                                          PrescriptionFormScreen(
                                              drug: result,
                                              appointmentId:
                                                  widget.appointment.id!));
                                    }
                                  }).onError((error, stackTrace) {});
                                },
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.blueGrey.withOpacity(.1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14))),
                          child: Text(
                              snapshot.data != null && snapshot.data!.exists
                                  ? 'View prescription'
                                  : 'Prescribe medication'),
                        );
                      }),
                const SizedBox(height: 20),
                if (widget.appointment.status == AppointmentStatus.completed)
                  ReviewColumn(appointment: widget.appointment),
                const SizedBox(height: 20),
                Material(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat.yMMMMEEEEd()
                              .format(widget.appointment.dateTime!),
                        ),
                        Text(
                          DateFormat.jm().format(widget.appointment.dateTime!),
                        ),
                      ],
                    ),
                  ),
                ),

                //SYMPTOMS

                if (widget.appointment.symptoms != null &&
                    widget.appointment.symptoms!.isNotEmpty)
                  const SizedBox(height: 20),

                if (widget.appointment.symptoms != null &&
                    widget.appointment.symptoms!.isNotEmpty)
                  Material(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Symptoms',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            primary: false,
                            itemBuilder: (context, index) => Text(
                                '- ${widget.appointment.symptoms![index]}'),
                            itemCount: widget.appointment.symptoms!.length,
                          ),
                        ],
                      ),
                    ),
                  ),

                //CONDITIONS
                if (widget.appointment.conditions != null &&
                    widget.appointment.conditions!.isNotEmpty)
                  const SizedBox(height: 20),

                if (widget.appointment.conditions != null &&
                    widget.appointment.conditions!.isNotEmpty)
                  Material(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Conditions',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            primary: false,
                            itemBuilder: (context, index) => Text(
                                '- ${widget.appointment.conditions![index]}'),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 5),
                            itemCount: widget.appointment.conditions!.length,
                          ),
                        ],
                      ),
                    ),
                  ),

                //LOCATION

                const SizedBox(height: 20),
                Material(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Venue',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          widget.appointment.venueString!,
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              Uri mapUri =
                                  Uri.https('www.google.com', '/maps/search/', {
                                'api': '1',
                                'query':
                                    '${widget.appointment.venueGeo!['lat']},${widget.appointment.venueGeo!['lng']}'
                              });

                              try {
                                if (await canLaunchUrl(mapUri)) {
                                  await launchUrl(mapUri);
                                } else {
                                  showAlertDialog(context);
                                }
                              } catch (e) {
                                showAlertDialog(context);
                              }
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
                            child: const Text('Open in Google Maps'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 70),

                //PATIENT

                Center(
                  child: ProfileImageWidget(
                    height: 150,
                    width: 150,
                    patientId: widget.appointment.patientId,
                  ),
                ),
                const SizedBox(height: 20),
                Center(child: Text(widget.appointment.patientName!)),
                Center(
                  child: TextButton(
                    onPressed: () {
                      navigate(
                          context,
                          PatientProfileScreen(
                              patientId: widget.appointment.patientId!));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.blueGrey.withOpacity(.2)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 14)),
                    ),
                    child: const Text('View patient info'),
                  ),
                )
              ],
            ),
            CustomAppBar(
              title: widget.appointment.service!,
              actions: [
                if (widget.appointment.status == AppointmentStatus.completed ||
                    widget.appointment.status == AppointmentStatus.canceled)
                  GestureDetector(
                    onTap: () {
                      showAlertDialog(context,
                          message: appointmentStatusMessage(
                              widget.appointment.status!),
                          icon: Icons.info_rounded,
                          iconColor: Colors.blue);
                    },
                    child: CircleAvatar(
                      backgroundColor:
                          appointmentStatusColor(widget.appointment.status!),
                      radius: 14,
                      child: Icon(
                        appointmentStatusIconData(widget.appointment.status!),
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (widget.appointment.status == AppointmentStatus.pending ||
                    widget.appointment.status == AppointmentStatus.confirmed)
                  ValueListenableBuilder<AppointmentStatus>(
                    valueListenable: status,
                    builder: (context, value, child) {
                      return widget.appointment.status ==
                                  AppointmentStatus.confirmed &&
                              widget.appointment.dateTime!
                                  .isAfter(DateTime.now())
                          ? const SizedBox()
                          : TextButton(
                              onPressed: () {
                                AppointmentStatus newStatus =
                                    widget.appointment.status ==
                                            AppointmentStatus.confirmed
                                        ? AppointmentStatus.completed
                                        : AppointmentStatus.confirmed;

                                showConfirmationDialog(
                                  context,
                                  message: widget.appointment.status ==
                                          AppointmentStatus.confirmed
                                      ? 'Set appointment status to completed?'
                                      : 'Confirm appointment?',
                                  confirmFunction: () {
                                    showLoadingDialog(context);
                                    db
                                        .getappointmentById(
                                            widget.appointment.id!)
                                        .update({'status': newStatus.index})
                                        .timeout(ktimeout)
                                        .then((val) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        })
                                        .onError((error, stackTrace) {
                                          Navigator.pop(context);
                                          showAlertDialog(context,
                                              message:
                                                  'Error confirming appointment.');
                                        });
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: widget.appointment.status ==
                                          AppointmentStatus.confirmed
                                      ? Colors.blue.withOpacity(.1)
                                      : Colors.green.withOpacity(.1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14)),
                              child: Text(
                                widget.appointment.status ==
                                        AppointmentStatus.confirmed
                                    ? 'Complete'
                                    : 'Confirm',
                                style: TextStyle(
                                  color: widget.appointment.status ==
                                          AppointmentStatus.confirmed
                                      ? Colors.blue
                                      : Colors.green,
                                ),
                              ),
                            );
                    },
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewColumn extends StatelessWidget {
  const ReviewColumn({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    FirestoreService db = FirestoreService();

    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: db.instance
              .collection('doctor_reviews')
              .doc(appointment.id)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {}
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data == null || !snapshot.data!.exists
                  ? const SizedBox()
                  : ReviewCard(
                      review: Review.fromFirestore(snapshot.data!.data()!));
            }

            return const SizedBox();
          });
    });
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;
  const ReviewCard({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirestoreService db = FirestoreService();

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: db.patientDocument(review.patientId!).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {}
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData ||
                snapshot.data == null ||
                !snapshot.data!.exists) {
              return const SizedBox();
            }

            Patient patient = Patient.fromFirestore(
                snapshot.data!.data()!, snapshot.data!.id);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ProfileImageWidget(height: 40, width: 40),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderText(text: patient.name),
                        Text(
                          DateFormat.yMd().add_jm().format(review.dateTime!),
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.star, color: Colors.yellow),
                    HeaderText(text: review.rating!.toStringAsFixed(1)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(review.comment!),
              ],
            );
          }
          return const SizedBox();
        });
  }
}
