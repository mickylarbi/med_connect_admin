import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_connect_admin/models/patient/allergy.dart';
import 'package:med_connect_admin/models/patient/family_medical_history_entry.dart';
import 'package:med_connect_admin/models/patient/immunization.dart';
import 'package:med_connect_admin/models/patient/medical_history_entry.dart';
import 'package:med_connect_admin/models/patient/surgery.dart';

class Patient {
  String? id;
  String? firstName;
  String? surname;
  String? phone;
  DateTime? dateOfBirth;
  String? gender;
  double? height;
  double? weight;
  String? bloodType;
  List<MedicalHistoryEntry>? medicalHistory;
  List<Immunization>? immunizations;
  List<Allergy>? allergies;
  List<FamilyMedicalHistoryEntry>? familyMedicalHistory;
  List<Surgery>? surgeries;

  Patient({
    this.id,
    this.firstName,
    this.surname,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.height,
    this.weight,
    this.bloodType,
    this.medicalHistory,
    this.immunizations,
    this.allergies,
    this.familyMedicalHistory,
    this.surgeries,
  });

  Patient.fromFirestore(Map<String, dynamic> map, String pId) {
    id = pId;
    firstName = map['firstName'] as String?;
    surname = map['surname'] as String?;
    phone = map['phone'] as String?;

    dateOfBirth = DateTime.fromMillisecondsSinceEpoch(
        (map['dateOfBirth'] as Timestamp).millisecondsSinceEpoch);

    gender = map['gender'] as String?;
    height = map['height'] as double?;
    weight = map['weight'] as double?;
    bloodType = map['bloodType'] as String?;

    List? tempList = map['medicalHistory'] as List<dynamic>?;
    if (tempList != null) {
      medicalHistory = [];
      for (Map<String, dynamic> element in tempList) {
        medicalHistory!.add(MedicalHistoryEntry.fromMap(element));
      }
    }

    tempList = map['immunizations'] as List<dynamic>?;
    if (tempList != null) {
      immunizations = [];
      for (Map<String, dynamic> element in tempList) {
        immunizations!.add(Immunization.fromMap(element));
      }
    }

    tempList = map['allergies'] as List<dynamic>?;
    if (tempList != null) {
      allergies = [];
      for (Map<String, dynamic> element in tempList) {
        allergies!.add(Allergy.fromMap(element));
      }
    }

    tempList = map['familyMedicalHistory'] as List<dynamic>?;
    if (tempList != null) {
      familyMedicalHistory = [];
      for (Map<String, dynamic> element in tempList) {
        familyMedicalHistory!.add(FamilyMedicalHistoryEntry.fromMap(element));
      }
    }

    tempList = map['surgeries'] as List<dynamic>?;
    if (tempList != null) {
      surgeries = [];
      for (Map<String, dynamic> element in tempList) {
        surgeries!.add(Surgery.fromMap(element));
      }
    }
  }

  Map<String, dynamic> toFirestore() => {
        'firstName': firstName,
        'surname': surname,
        'phone': phone,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'height': height,
        'weight': weight,
        'bloodType': bloodType,
        if (medicalHistory != null)
          'medicalHistory':
              medicalHistory!.map((e) => e.toFirestore()).toList(),
        if (immunizations != null)
          'immunizations': immunizations!.map((e) => e.toFirestore()).toList(),
        if (allergies != null)
          'allergies': allergies!.map((e) => e.toFirestore()).toList(),
        if (familyMedicalHistory != null)
          'familyMedicalHistory':
              familyMedicalHistory!.map((e) => e.toFirestore()).toList(),
        if (surgeries != null)
          'surgeries': surgeries!.map((e) => e.toFirestore()).toList(),
      };

  String get name => '$firstName $surname';

  @override
  bool operator ==(other) =>
      other is Patient &&
      firstName == other.firstName &&
      surname == other.surname &&
      phone == other.phone &&
      dateOfBirth == other.dateOfBirth &&
      gender == other.gender &&
      height == other.height &&
      weight == other.weight &&
      bloodType == other.bloodType &&
      medicalHistory == other.medicalHistory &&
      immunizations == other.immunizations &&
      allergies == other.allergies &&
      familyMedicalHistory == other.familyMedicalHistory &&
      surgeries == other.surgeries;

  @override
  int get hashCode => hashValues(
        firstName,
        surname,
        phone,
        dateOfBirth,
        gender,
        height,
        weight,
        bloodType,
        hashList(medicalHistory),
        hashList(immunizations),
        hashList(allergies),
        hashList(familyMedicalHistory),
        hashList(surgeries),
      );
}
