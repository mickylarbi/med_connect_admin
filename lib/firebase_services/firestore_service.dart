import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_connect_admin/firebase_services/storage_service.dart';
import 'package:med_connect_admin/models/admin.dart';
import 'package:med_connect_admin/models/doctor/doctor.dart';
import 'package:med_connect_admin/models/pharmacy/drug.dart';
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

  // DOCTOR Drug

  CollectionReference<Map<String, dynamic>> get doctorAppointmentsCollection =>
      instance.collection('doctor_appointments');

  Query<Map<String, dynamic>> get myAppointments => doctorAppointmentsCollection
      .where('doctorId', isEqualTo: _auth.currentUser!.uid);

  DocumentReference<Map<String, dynamic>> getappointmentById(String id) =>
      doctorAppointmentsCollection.doc(id);

  DocumentReference<Map<String, dynamic>> getpatientById(String id) =>
      instance.collection('patients').doc(id);

  // DRUGS

  CollectionReference<Map<String, dynamic>> get drugsCollection =>
      instance.collection('drugs');

  Query<Map<String, dynamic>> get myDrugs =>
      drugsCollection.where('pharmacyId', isEqualTo: _auth.currentUser!.uid);

  Future<DocumentReference<Map<String, dynamic>>> addDrug(Drug drug) =>
      drugsCollection.add(drug.toMap());

  Future<void> updateDrug(Drug drug) =>
      drugsCollection.doc(drug.id).update(drug.toMap());

  Future<void> deleteDrug(String drugId) =>
      drugsCollection.doc(drugId).delete();

  // ORDERS

  CollectionReference<Map<String, dynamic>> get ordersCollection =>
      instance.collection('orders');

  Query<Map<String, dynamic>> get myOrders =>
      ordersCollection.where('pharmacyIds', arrayContains: _auth.currentUser!.uid);
}
