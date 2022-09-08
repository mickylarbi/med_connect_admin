import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';

class Drug {
  String? id;
  String? pharmacyId;
  String? group;
  String? genericName;
  String? brandName;
  double? price;
  int? quantityInStock;
  String? otherDetails;

  Drug({
    this.id,
    this.pharmacyId,
    this.group,
    this.genericName,
    this.brandName,
    this.price,
    this.quantityInStock,
    this.otherDetails,
  });

  Drug.fromFirestore(Map<String, dynamic> map, String dId) {
    id = dId;
    pharmacyId = map['pharmacyId'];
    group = map['group'];
    genericName = map['genericName'];
    brandName = map['brandName'];
    price = map['price'].toDouble();
    quantityInStock = map['quantityInStock'].toInt();
    otherDetails = map['otherDetails'];
  }

  Map<String, dynamic> toMap() => {
        'pharmacyId': FirebaseAuth.instance.currentUser!.uid,
        'group': group,
        'genericName': genericName,
        'brandName': brandName,
        'price': price,
        'quantityInStock': quantityInStock,
        'otherDetails': otherDetails,
      };

  @override
  bool operator ==(other) =>
      other is Drug &&
      group == other.group &&
      genericName == other.genericName &&
      brandName == other.brandName &&
      price == other.price &&
      quantityInStock == other.quantityInStock &&
      otherDetails == other.otherDetails;

  @override
  int get hashCode => hashValues(
        group,
        genericName,
        brandName,
        price,
        quantityInStock,
        otherDetails,
      );
}

// class DosageStrength {
//   double? quantity;
//   String? unit;

//   DosageStrength({this.quantity, this.unit});

//   DosageStrength.fromMap(Map<String, dynamic> map) {
//     quantity = map['quantity'];
//     unit = map['unit'];
//   }

//   Map<String, dynamic> toMap() => {
//         'quantity': quantity,
//         'unit': unit,
//       };

//   @override
//   bool operator ==(other) =>
//       other is DosageStrength &&
//       other.quantity == quantity &&
//       other.unit == unit;

//   @override
//   int get hashCode => hashValues(quantity, unit);
// }

// class Packaging {
//   double? quantityOfDosageForm;
//   String? unit;
//   int? numberOfPackages;
//   String? package;

//   Packaging({
//     this.quantityOfDosageForm,
//     this.unit,
//     this.numberOfPackages,
//     this.package,
//   });

//   Packaging.fromMap(Map<String, dynamic> map) {
//     quantityOfDosageForm = map['quantityOfDosageForm'];
//     unit = map['unit'];
//     numberOfPackages = map['numberOfPackages'];
//     package = map['package'];
//   }

//   Map<String, dynamic> toMap() => {
//         'quantityOfDosageForm': quantityOfDosageForm,
//         'unit': unit,
//         'numberOfPackages': numberOfPackages,
//         'package': package,
//       };

//   @override
//   bool operator ==(other) =>
//       other is Packaging &&
//       other.quantityOfDosageForm == quantityOfDosageForm &&
//       other.unit == unit &&
//       other.numberOfPackages == numberOfPackages &&
//       other.package == package;

//   @override
//   int get hashCode =>
//       hashValues(quantityOfDosageForm, unit, numberOfPackages, package);
// }
