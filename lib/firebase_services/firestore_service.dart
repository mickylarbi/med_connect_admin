import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_connect_admin/firebase_services/storage_service.dart';
import 'package:med_connect_admin/models/doctor.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_tab_view.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';

class FirestoreService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  StorageService _storageService = StorageService();

  FirebaseFirestore instance = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> get getAdminInfo =>
      instance.collection('admins').doc(_auth.currentUser!.uid);

  uploadDoctorInfo(BuildContext context, Doctor doctor, XFile picture) {
    showLoadingDialog(context);

    _storageService
        .uploadProfileImage(picture)
        .timeout(const Duration(minutes: 2))
        .then((p0) {
      instance
          .collection('admins')
          .doc(_auth.currentUser!.uid)
          .set(doctor.toMap())
          .timeout(ktimeout)
          .then((value) {
        getAdminInfo.get().timeout(ktimeout).then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DoctorTabView()),
              (route) => false);
        }).onError((error, stackTrace) {
          Navigator.pop(context);
          showAlertDialog(context,
              message: 'Couldn\'t get profile info. Try again');
        });
      }).onError((error, stackTrace) {
        Navigator.pop(context);
        showAlertDialog(context,
            message: 'Couldn\'t upload profile info. Try again');
      });
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      log(error.toString());
      showAlertDialog(context,
          message: 'Couldn\'t upload profile info. Try again');
    });
  }

  editDoctorInfo(BuildContext context, Doctor doctor) {
    showLoadingDialog(context);

    instance
        .collection('admins')
        .doc(_auth.currentUser!.uid)
        .update(doctor.toMap())
        .timeout(const Duration(seconds: 30))
        .then((value) {
      Navigator.pop(context);
      Navigator.pop(context, EditObject(action: EditAction.edit));
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showAlertDialog(context,
          message: 'Couldn\'t update profile info. Try again');
    });
  }

  // DOCTOR APPOINTMENT

  CollectionReference<Map<String, dynamic>> get doctorAppointmentsCollection =>
      instance.collection('doctor_appointments');

  Query<Map<String, dynamic>> get myAppointments => doctorAppointmentsCollection
      .where('doctorId', isEqualTo: _auth.currentUser!.uid);

  DocumentReference<Map<String, dynamic>> getappointmentById(String id) =>
      doctorAppointmentsCollection.doc(id);

  DocumentReference<Map<String, dynamic>> getpatientById(String id) =>
      instance.collection('patients').doc(id);
}
