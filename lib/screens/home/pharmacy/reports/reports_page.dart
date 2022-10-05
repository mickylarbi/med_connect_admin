import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/models/pharmacy/drug.dart';
import 'package:med_connect_admin/models/pharmacy/order.dart';
import 'package:med_connect_admin/screens/home/pharmacy/reports/drugs_report_screen.dart';
import 'package:med_connect_admin/screens/home/pharmacy/reports/orders_report_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';

class PharmacyReportsPage extends StatefulWidget {
  const PharmacyReportsPage({Key? key}) : super(key: key);

  @override
  State<PharmacyReportsPage> createState() => _PharmacyReportsPageState();
}

class _PharmacyReportsPageState extends State<PharmacyReportsPage> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(36, 150, 36, 50),
              child: FutureBuilder<List>(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {}
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        children: [
                          DrugsReportWidget(drugsList: snapshot.data![0]),
                          const Divider(height: 100),
                          OrdersReportWidget(
                            drugsList: snapshot.data![0],
                            ordersList: snapshot.data![1],
                          )
                        ],
                      );
                    }
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }),
            ),
          ),
          ...fancyAppBar(context, scrollController, 'Reports', []),
        ],
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

TextStyle get boldDigitStyle => const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

Future<List> getData() async {
  FirestoreService db = FirestoreService();

  QuerySnapshot<Map<String, dynamic>> drugsQuerySnapshot =
      await db.myDrugs.get();
  QuerySnapshot<Map<String, dynamic>> ordersQuerySnapshot =
      await db.myOrders.get();

  return [
    drugsQuerySnapshot.docs
        .map((e) => Drug.fromFirestore(e.data(), e.id))
        .toList(),
    ordersQuerySnapshot.docs
        .map((e) => Order.fromFirestore(e.data(), e.id))
        .toList(),
  ];
}
