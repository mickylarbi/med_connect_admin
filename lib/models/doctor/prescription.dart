class Prescription {
  String? id;
  Map<String, dynamic>? cart;
  double? totalPrice;
  String? otherDetails;
  List<String>? pharmacyIds;
  bool? isUsed;

  Prescription(
      {this.id, this.cart, this.totalPrice, this.otherDetails,this.pharmacyIds, this.isUsed});

  Prescription.fromFirestore(Map<String, dynamic> map, String pId) {
    id = pId;
    cart = map['cart'];
    totalPrice = map['totalPrice'];
    otherDetails = map['otherDetails'];
    pharmacyIds = map['pharmacyIds'];
    isUsed = map['isUsed'];
  }

  Map<String, dynamic> toMap() => {
        'cart': cart,
        'totalPrice': totalPrice,
        'otherDetails': otherDetails,
        'pharmacyIds': pharmacyIds,
        'isUsed': isUsed
      };
}
