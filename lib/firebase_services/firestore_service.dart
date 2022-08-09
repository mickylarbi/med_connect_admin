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
    try {
      await instance
          .collection('doctors')
          .doc(_auth.currentUser!.uid)
          .set(doctor.toMap())
          .timeout(const Duration(seconds: 30));

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TabView()),
          (route) => false);
    } catch (e) {
      Navigator.pop(context);
      showAlertDialog(context,
          message: 'Couldn\'t upload profile info. Try again');
    }
  }

  editDoctorInfo(BuildContext context, Doctor doctor) async {
    showLoadingDialog(context);
    try {
      await instance
          .collection('doctors')
          .doc(_auth.currentUser!.uid)
          .update(doctor.toMap())
          .timeout(const Duration(seconds: 30));

      Navigator.pop(context);
      Navigator.pop(context, EditAction.edit);
    } catch (e) {
      Navigator.pop(context);
      showAlertDialog(context,
          message: 'Couldn\'t update profile info. Try again');
    }
  }
}
