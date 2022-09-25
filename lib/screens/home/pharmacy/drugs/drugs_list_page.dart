import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/firebase_services/storage_service.dart';
import 'package:med_connect_admin/models/pharmacy/drug.dart';
import 'package:med_connect_admin/models/pharmacy/pharmacy.dart';
import 'package:med_connect_admin/screens/home/doctor/appointments/patient_profile_screen.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/drugs_search_delegate.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/edit_drug_details_screen.dart';
import 'package:med_connect_admin/screens/home/pharmacy/drugs/pharmacy_profile_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect_admin/utils/functions.dart';

class DrugsListPage extends StatefulWidget {
  const DrugsListPage({Key? key}) : super(key: key);

  @override
  State<DrugsListPage> createState() => _DrugsListPageState();
}

class _DrugsListPageState extends State<DrugsListPage> {
  ScrollController scrollController = ScrollController();
  FirestoreService db = FirestoreService();

  List<Drug> drugsList = [];
  List<String> groups = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ListView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(36),
            children: [
              const SizedBox(height: 130),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: db.myDrugs.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Reload'),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  drugsList = snapshot.data!.docs
                      .map((e) => Drug.fromFirestore(e.data(), e.id))
                      .toList();

                  Map<String, List<Drug>> categories = {};

                  for (Drug element in drugsList) {
                    if (categories[element.group] == null) {
                      categories[element.group!] = [element];
                    } else {
                      categories[element.group!]!.add(element);
                    }
                  }

                  groups = categories.keys.toList()..sort();

                  groups.sort(
                      (a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

                  return ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: groups.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 50);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      List<Drug> categoryList = categories[groups[index]]!;
//TODO; sort by brand name then generic name
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            groups[index],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          GridView.builder(
                            shrinkWrap: true,
                            primary: false,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: .8,
                            ),
                            itemCount: categoryList.length,
                            itemBuilder:
                                (BuildContext context, int categoryIndex) {
                              return DrugCard(
                                drug: categoryList[categoryIndex],
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: FloatingActionButton(
                onPressed: () {
                  navigate(context, const EditDrugDetailsScreen());
                },
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
                      OutlineIconButton(
                        iconData: Icons.search,
                        onPressed: () {
                          showSearch(
                              context: context,
                              delegate: DrugSearchDelegate(drugsList, groups));
                        },
                      ),
                      const SizedBox(width: 10),
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

class DrugCard extends StatelessWidget {
  final Drug drug;
  const DrugCard({super.key, required this.drug});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigate(context, EditDrugDetailsScreen(drug: drug));
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: Center(child: DrugImageWidget(drugId: drug.id!))),
            const SizedBox(height: 10),
            Text(
              drug.genericName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              drug.brandName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'GH¢ ${drug.price!.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class DrugImageWidget extends StatelessWidget {
  final String drugId;
  final double? height;
  final double? width;
  DrugImageWidget({super.key, required this.drugId, this.height, this.width});

  StorageService storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return FutureBuilder(
          future: storage.drugImageDownloadUrl(id: drugId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: snapshot.data!,
                  height: height,
                  width: width ?? double.maxFinite,
                  fit: BoxFit.fitWidth,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator.adaptive(
                        value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.person)),
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          },
        );
      },
    );
  }
}
