import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_services/auth_service.dart';
import 'package:med_connect_admin/models/doctor.dart';
import 'package:med_connect_admin/screens/home/home_page/home_page.dart';
import 'package:med_connect_admin/screens/home/tab_view.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';

class FirestoreService {
  AuthService _auth = AuthService();

  FirebaseFirestore instance = FirebaseFirestore.instance;

  get getDoctorInfo => instance.collection('doctors').doc(_auth.uid).get();

  uploadDoctorInfo(BuildContext context, Doctor doctor) async {
    showLoadingDialog(context);

    await instance
        .collection('doctors')
        .doc(_auth.currentUser!.uid)
        .set(doctor.toMap())
        .timeout(const Duration(seconds: 30))
        .then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TabView()),
          (route) => false);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showAlertDialog(context,
          message: 'Couldn\'t upload profile info. Try again');
    });
  }

  editDoctorInfo(BuildContext context, Doctor doctor) async {
    showLoadingDialog(context);

    await instance
        .collection('doctors')
        .doc(_auth.currentUser!.uid)
        .update(doctor.toMap())
        .timeout(const Duration(seconds: 30))
        .then((value) {
      Navigator.pop(context);
      Navigator.pop(context, EditAction.edit);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showAlertDialog(context,
          message: 'Couldn\'t update profile info. Try again');
    });
  }

  Query<Map<String, dynamic>> get myAppointments => instance
      .collection('appointments')
      .where('doctorId', isEqualTo: _auth.uid);

  DocumentReference<Map<String, dynamic>> getappointmentById(String id) =>
      instance.collection('appointments').doc(id);

DocumentReference<Map<String, dynamic>> getpatientById(String id) =>
      instance.collection('patients').doc(id);

}
