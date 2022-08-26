import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/models/doctor/doctor_appointment.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_appointments/patient_profile_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';
import 'package:med_connect_admin/utils/functions.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorAppointmentDetailsScreen extends StatefulWidget {
  final DoctorAppointment appointment;
  const DoctorAppointmentDetailsScreen({Key? key, required this.appointment})
      : super(key: key);

  @override
  State<DoctorAppointmentDetailsScreen> createState() =>
      _DoctorAppointmentDetailsScreenState();
}

class _DoctorAppointmentDetailsScreenState
    extends State<DoctorAppointmentDetailsScreen> {
  FirestoreService db = FirestoreService();
  ValueNotifier<bool> isConfirmed = ValueNotifier<bool>(false);

  @override
  void initState() {
    isConfirmed.value = widget.appointment.isConfirmed ?? false;
    super.initState();
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
              const SizedBox(height: 10),
              Material(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                          itemBuilder: (context, index) =>
                              Text('- ${widget.appointment.symptoms![index]}'),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/bruno-rodrigues-279xIHymPYY-unsplash.jpg',
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
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
              ValueListenableBuilder<bool>(
                  valueListenable: isConfirmed,
                  builder: (context, value, child) {
                    return TextButton(
                      onPressed: () {
                        showLoadingDialog(context);
                        db
                            .getappointmentById(widget.appointment.id!)
                            .update({'isConfirmed': !value})
                            .timeout(ktimeout)
                            .then((val) {
                              Navigator.pop(context);
                              isConfirmed.value = !value;
                            })
                            .onError((error, stackTrace) {
                              Navigator.pop(context);
                              showAlertDialog(context,
                                  message: 'Error confirming appointment.');
                            });
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(value
                              ? Colors.red.withOpacity(.2)
                              : Colors.green.withOpacity(.2)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 14))),
                      child: Text(
                        value ? 'Unconfirm' : 'Confirm',
                        style:
                            TextStyle(color: value ? Colors.red : Colors.green),
                      ),
                    );
                  })
            ],
          ),
        ],
      )),
    );
  }
}
