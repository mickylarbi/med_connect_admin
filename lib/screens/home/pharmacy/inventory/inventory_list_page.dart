import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/models/pharmacy/pharmacy.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_appointments/patient_profile_screen.dart';
import 'package:med_connect_admin/screens/home/pharmacy/inventory/pharmacy_profile_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/utils/functions.dart';

class InventoryListPage extends StatefulWidget {
  const InventoryListPage({Key? key}) : super(key: key);

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  ScrollController scrollController = ScrollController();
  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ListView(
            controller: scrollController,
            children: [],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ),
          ),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: db.adminDocument.snapshots(),
            builder: (context, snapshot) {
              return SizedBox(
                height: 138,
                child: Stack(
                  children: fancyAppBar(
                    context,
                    scrollController,
                    snapshot.hasError ||
                            snapshot.data == null ||
                            snapshot.data!.data() == null ||
                            snapshot.connectionState == ConnectionState.waiting
                        ? 'Hi'
                        : '${snapshot.data!.data()!['name']}',
                    [
                      StatefulBuilder(
                        builder: (context, setState) {
                          Pharmacy pharmacy = Pharmacy();

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: () async {
                                if (snapshot.data!.data() != null) {
                                  await navigate(
                                      context,
                                      PharmacyProfileScreen(
                                          pharmacy: pharmacy.fromFirestore(
                                              snapshot.data!.data()!,
                                              snapshot.data!.id)));

                                  setState(() {});
                                }
                              },
                              child: ProfileImageWidget(
                                height: 44,
                                width: 44,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
