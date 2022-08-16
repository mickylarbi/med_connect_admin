import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_services/auth_service.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/firebase_services/storage_service.dart';
import 'package:med_connect_admin/models/doctor.dart';
import 'package:med_connect_admin/screens/home/home_page/profile/edit_doctor_profile_screen.dart';
import 'package:med_connect_admin/screens/home/home_page/profile/review_card.dart';
import 'package:med_connect_admin/screens/home/home_page/profile/reviews_list_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/header_text.dart';
import 'package:med_connect_admin/screens/shared/outline_icon_button.dart';
import 'package:med_connect_admin/utils/dialogs.dart';
import 'package:med_connect_admin/utils/functions.dart';

class DoctorProfileDetailsScreen extends StatelessWidget {
  DoctorProfileDetailsScreen({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();
  final FirestoreService db = FirestoreService();
  final StorageService storage = StorageService();

  Doctor? doctor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 88.0, bottom: 120),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: db.getDoctorInfo,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Column(
                          children: [
                            const Text('Couldn\'t fetch profile info'),

                            //TODO: add button to set state
                          ],
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }

                      doctor = Doctor.fromFireStore(
                          snapshot.data!.data()!, _auth.uid);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: StatefulBuilder(
                                    builder: (context, setState) {
                                  return Container(
                                    height: 120,
                                    width: 110,
                                    alignment: Alignment.center,
                                    color: Colors.grey.withOpacity(.1),
                                    child: FutureBuilder<String>(
                                        future: storage.profileImageDownloadUrl,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return GestureDetector(
                                              onTap: () async {
                                                setState(() {});
                                              },
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  Text(
                                                    'Tap to reload',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  Icon(
                                                    Icons.refresh,
                                                    color: Colors.grey,
                                                  )
                                                ],
                                              ),
                                            );
                                          }

                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return Image.network(
                                              snapshot.data!,
                                              height: 120,
                                              width: 110,
                                              fit: BoxFit.cover,
                                            );
                                          }

                                          return const CircularProgressIndicator
                                              .adaptive();
                                        }),
                                  );
                                }),
                              ),
                              const SizedBox(width: 30),
                              Container(
                                height: 150,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 30),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doctor!.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      doctor!.mainSpecialty!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '${doctor!.currentLocation!.location}',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color:
                                              Color.fromARGB(80, 252, 228, 6),
                                        ),
                                        Text(calculateRating(doctor!.reviews)
                                            .toStringAsFixed(2)),
                                        const SizedBox(width: 10),
                                        Text(
                                          '(${doctor!.reviews != null ? doctor!.reviews!.length : 0} reviews)',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),

                          //BIO

                          if (doctor!.bio != null) const SizedBox(height: 30),
                          if (doctor!.bio != null)
                            const HeaderText(text: 'Bio'),
                          if (doctor!.bio != null) const SizedBox(height: 2.5),
                          if (doctor!.bio != null) Text(doctor!.bio!),
                          const Divider(height: 50),

                          //OTHER SPECIALTIES

                          if (doctor!.otherSpecialties != null &&
                              doctor!.otherSpecialties!.isNotEmpty)
                            const SizedBox(height: 30),
                          if (doctor!.otherSpecialties != null &&
                              doctor!.otherSpecialties!.isNotEmpty)
                            const HeaderText(text: 'Other specialties'),
                          if (doctor!.otherSpecialties != null &&
                              doctor!.otherSpecialties!.isNotEmpty)
                            ...doctor!.otherSpecialties!
                                .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.5),
                                      child: Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 2,
                                            backgroundColor: Colors.blueGrey,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(e),
                                        ],
                                      ),
                                    ))
                                .toList(),

                          ///EXPERIENCE

                          if (doctor!.experiences != null &&
                              doctor!.experiences!.isNotEmpty)
                            const SizedBox(height: 30),
                          if (doctor!.experiences != null &&
                              doctor!.experiences!.isNotEmpty)
                            const HeaderText(text: 'Experience'),
                          if (doctor!.experiences != null &&
                              doctor!.experiences!.isNotEmpty)
                            ...doctor!.experiences!
                                .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const CircleAvatar(
                                            radius: 2,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(e
                                              .toString()), //TODO: check upon this
                                        ],
                                      ),
                                    ))
                                .toList(),

                          ///SERVICES

                          if (doctor!.services != null &&
                              doctor!.services!.isNotEmpty)
                            const SizedBox(height: 30),
                          if (doctor!.services != null &&
                              doctor!.services!.isNotEmpty)
                            const HeaderText(text: 'Services Offered'),
                          if (doctor!.services != null &&
                              doctor!.services!.isNotEmpty)
                            ...doctor!.services!
                                .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.5),
                                      child: Row(
                                        children: [
                                          const CircleAvatar(
                                            radius: 2,
                                            backgroundColor: Colors.blueGrey,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(e)
                                        ],
                                      ),
                                    ))
                                .toList(),

                          ///REVIEWS

                          if (doctor!.reviews != null &&
                              doctor!.reviews!.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const HeaderText(text: 'Reviews'),
                                TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              vertical: 14))),
                                  onPressed: () {
                                    navigate(
                                        context,
                                        ReviewListScreen(
                                            reviews: doctor!.reviews!));
                                  },
                                  child: const Text('See all'),
                                ),
                              ],
                            ),
                          if (doctor!.reviews != null &&
                              doctor!.reviews!.isNotEmpty)
                            ReviewCard(
                              review: doctor!.reviews!
                                  .where((element) =>
                                      element.comment != null &&
                                      element.comment!.isNotEmpty)
                                  .toList()[0],
                            ),
                          const SizedBox(height: 30),
                        ],
                      );
                    }),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 52 + 72,
                child: Padding(
                  padding: const EdgeInsets.all(36),
                  child: CustomFlatButton(
                    onPressed: () {
                      showConfirmationDialog(
                        context,
                        message: 'Sign out?',
                        confirmFunction: () {
                          _auth.signOut(context);
                        },
                      );
                    },
                    backgroundColor: Colors.red[900],
                    child: const Text('Sign out'),
                  ),
                ),
              ),
            ),
            CustomAppBar(
              leading: Icons.arrow_back,
              title: 'Profile',
              actions: [
                OutlineIconButton(
                  iconData: Icons.edit,
                  onPressed: () {
                    if (doctor != null) {
                      navigate(
                          context, EditDoctorProfileScreen(doctor: doctor!));
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
