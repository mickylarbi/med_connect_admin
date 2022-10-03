class Prescription {
  String? id;
  Map<String, dynamic>? cart;
  double? totalPrice;
  String? otherDetails;
  bool? isUsed;

  Prescription(
      {this.id, this.cart, this.totalPrice, this.otherDetails, this.isUsed});

  Prescription.fromFirestore(Map<String, dynamic> map, String pId) {
    id = pId;
    cart = map['cart'];
    totalPrice = map['totalPrice'];
    otherDetails = map['otherDetails'];
    isUsed = map['isUsed'];
  }

  Map<String, dynamic> toMap() =>
      {'cart': cart,'totalPrice':totalPrice, 'otherDetails': otherDetails, 'isUsed': isUsed};
}
