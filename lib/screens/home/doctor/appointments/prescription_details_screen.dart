import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/models/doctor/prescription.dart';
import 'package:med_connect_admin/models/pharmacy/drug.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drug_details_screen.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drugs_list_page.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';
import 'package:med_connect_admin/utils/functions.dart';

class PrescriptionDetailsScreen extends StatelessWidget {
  const PrescriptionDetailsScreen({super.key, required this.prescription});

  final Prescription prescription;

  @override
  Widget build(BuildContext context) {
    FirestoreService db = FirestoreService();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding:
                  const EdgeInsets.symmetric(vertical: 100, horizontal: 36),
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: prescription.cart!.length,
                  itemBuilder: (context, index) {
                    MapEntry<String, int> entry = prescription.cart!.entries
                        .map((e) =>
                            MapEntry<String, int>(e.key, e.value.toInt()))
                        .toList()[index];

                    return StatefulBuilder(builder: (context, setState) {
                      return FutureBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                        future: db.drugDocument(entry.key).get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: () {
                                      setState(() {});
                                    }));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Drug drug = Drug.fromFirestore(
                                snapshot.data!.data()!, snapshot.data!.id);

                            return GestureDetector(
                              onTap: () {
                                navigate(
                                    context, DrugDetailsScreen(drug: drug));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    DrugImageWidget(
                                      drugId: drug.id!,
                                      height: 70,
                                      width: 70,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            drug.brandName!,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            drug.genericName!,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            drug.group!,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'GH¢ ${drug.price!.toStringAsFixed(2)}',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                'Qty: ${entry.value.toString()}',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        },
                      );
                    });
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                ),
                const SizedBox(height: 30),
                if (prescription.otherDetails != null &&
                    prescription.otherDetails!.trim().isNotEmpty)
                  const Text(
                    'Other details',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 10),
                if (prescription.otherDetails != null &&
                    prescription.otherDetails!.trim().isNotEmpty)
                  Text(prescription.otherDetails!),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    showConfirmationDialog(context,
                        message: 'Revoke prescription?\nThis cannot be undone.',
                        confirmFunction: () {
                      showLoadingDialog(context);
                      db.instance
                          .collection('prescriptions')
                          .doc(prescription.id)
                          .delete()
                          .timeout(ktimeout)
                          .then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }).onError((error, stackTrace) {
                        Navigator.pop(context);
                        showAlertDialog(context,
                            message:
                                'Could not revoke prescription.\nTry again later.');
                      });
                    });
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(.1),
                      fixedSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))),
                  child: const Text(
                    'Revoke',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const CustomAppBar(
              title: 'Prescription Details',
              actions: [
                CircleAvatar()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
