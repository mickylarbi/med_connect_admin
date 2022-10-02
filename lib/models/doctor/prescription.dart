class Prescription {
  String? id;
  Map<String, dynamic>? cart;
  String? otherDetails;
  bool? isUsed;

  Prescription({this.id, this.cart, this.otherDetails, this.isUsed});

  Prescription.fromFirestore(Map<String, dynamic> map, String pId) {
    id = pId;
    cart = map['cart'];
    otherDetails = map['otherDetails'];
    isUsed = map['isUsed'];
  }

  Map<String, dynamic> toMap() =>
      {'cart': cart, 'otherDetails': otherDetails, 'isUsed': isUsed};
}
