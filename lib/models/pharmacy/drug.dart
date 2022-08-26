import 'dart:ui';

class Drug {
  String? id;
  String? pharmacyId;
  String? group;
  String? genericName;
  String? brandName;
  String? dosageForm;
  DosageStrength? dosageStrength;
  Packaging? packaging;
}

class DosageStrength {
  double? quantity;
  String? unit;

  DosageStrength({this.quantity, this.unit});

  DosageStrength.fromMap(Map<String, dynamic> map) {
    quantity = map['quantity'];
    unit = map['unit'];
  }

  Map<String, dynamic> toMap() => {
        'quantity': quantity,
        'unit': unit,
      };

  @override
  bool operator ==(other) =>
      other is DosageStrength &&
      other.quantity == quantity &&
      other.unit == unit;

  @override
  int get hashCode => hashValues(quantity, unit);
}

class Packaging {
  double? quantityOfDosageForm;
  String? unit;
  int? numberOfPackages;
  String? package;

  Packaging({
    this.quantityOfDosageForm,
    this.unit,
    this.numberOfPackages,
    this.package,
  });

  Packaging.fromMap(Map<String, dynamic> map) {
    quantityOfDosageForm = map['quantityOfDosageForm'];
    unit = map['unit'];
    numberOfPackages = map['numberOfPackages'];
    package = map['package'];
  }

  Map<String, dynamic> toMap() => {
        'quantityOfDosageForm': quantityOfDosageForm,
        'unit': unit,
        'numberOfPackages': numberOfPackages,
        'package': package,
      };

  @override
  bool operator ==(other) =>
      other is Packaging &&
      other.quantityOfDosageForm == quantityOfDosageForm &&
      other.unit == unit &&
      other.numberOfPackages == numberOfPackages &&
      other.package == package;

  @override
  int get hashCode =>
      hashValues(quantityOfDosageForm, unit, numberOfPackages, package);
}
