import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_connect_admin/firebase_services/storage_service.dart';
import 'package:med_connect_admin/models/admin.dart';
import 'package:med_connect_admin/models/doctor/doctor.dart';
import 'package:med_connect_admin/models/pharmacy/pharmacy.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_tab_view.dart';
import 'package:med_connect_admin/screens/home/pharmacy/pharmacy_tab_view.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';

class FirestoreService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  StorageService _storageService = StorageService();

  FirebaseFirestore instance = FirebaseFirestore.instance;

  // ADMIN

  DocumentReference<Map<String, dynamic>> get adminDocument =>
      instance.collection('admins').doc(_auth.currentUser!.uid);

  Future<void> addAdmin(Admin admin) => adminDocument.set(admin.toMap());

  Future<void> updateAdmin(Admin admin) => adminDocument.update(admin.toMap());

  // DOCTOR APPOINTMENT

  CollectionReference<Map<String, dynamic>> get doctorAppointmentsCollection =>
      instance.collection('doctor_appointments');

  Query<Map<String, dynamic>> get myAppointments => doctorAppointmentsCollection
      .where('doctorId', isEqualTo: _auth.currentUser!.uid);

  DocumentReference<Map<String, dynamic>> getappointmentById(String id) =>
      doctorAppointmentsCollection.doc(id);

  DocumentReference<Map<String, dynamic>> getpatientById(String id) =>
      instance.collection('patients').doc(id);

  // PHARMACY

  // uploadPharmacyInfo(BuildContext context, Pharmacy pharmacy, XFile picture) {
  //   showLoadingDialog(context);

  //   _storageService
  //       .uploadProfileImage(picture)
  //       .timeout(const Duration(minutes: 2))
  //       .then((p0) {
  //     instance
  //         .collection('admins')
  //         .doc(_auth.currentUser!.uid)
  //         .set(pharmacy.toMap())
  //         .timeout(ktimeout)
  //         .then((value) {
  //       adminDocument.get().timeout(ktimeout).then((value) {
  //         Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(builder: (context) => const PharmacyTabView()),
  //             (route) => false);
  //       }).onError((error, stackTrace) {
  //         Navigator.pop(context);
  //         showAlertDialog(context,
  //             message: 'Couldn\'t get profile info. Try again');
  //       });
  //     }).onError((error, stackTrace) {
  //       Navigator.pop(context);
  //       showAlertDialog(context,
  //           message: 'Couldn\'t upload profile info. Try again');
  //     });
  //   }).onError((error, stackTrace) {
  //     Navigator.pop(context);
  //     log(error.toString());
  //     showAlertDialog(context,
  //         message: 'Couldn\'t upload profile info. Try again');
  //   });
  // }
}
