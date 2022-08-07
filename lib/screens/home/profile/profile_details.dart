import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_services/auth_service.dart';
import 'package:med_connect_admin/models/doctor.dart';
import 'package:med_connect_admin/models/experience.dart';
import 'package:med_connect_admin/screens/home/profile/edit_profile_screen.dart';
import 'package:med_connect_admin/screens/home/profile/review_card.dart';
import 'package:med_connect_admin/screens/home/profile/reviews_list_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/header_text.dart';
import 'package:med_connect_admin/screens/shared/outline_icon_button.dart';
import 'package:med_connect_admin/utils/dialogs.dart';
import 'package:med_connect_admin/utils/functions.dart';

class ProfileDetailsScreen extends StatelessWidget {
  ProfileDetailsScreen({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  final Doctor doctor = Doctor(
    firstName: 'Michael',
    surname: 'Larbi',
    mainSpecialty: 'Oncology',
    currentLocation: Experience(location: 'Tech Hospital'),
    bio: 'Random stuff about me',
    otherSpecialties: ['General Surgery'],
    experiences: [
      Experience(
          location: 'UCC Hospital',
          dateTimeRange:
              DateTimeRange(start: DateTime.now(), end: DateTime.now())),
    ],
    services: ['Consult', 'Endorectomy;D'],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(36, 88, 36, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/usman-yousaf-pTrhfmj2jDA-unsplash.jpg',
                            height: 100,
                            width: 100, //TODO: scroll controller thing
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        HeaderText(
                            text: '${doctor.firstName} ${doctor.surname}'),
                        const SizedBox(height: 10),
                        Text(
                          doctor.mainSpecialty!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${doctor.currentLocation}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color.fromARGB(80, 252, 228, 6),
                            ),
                            Text(calculateRating(doctor.reviews)
                                .toStringAsFixed(2)),
                            const SizedBox(width: 10),
                            Text(
                              '(${doctor.reviews != null ? doctor.reviews!.length : 0} reviews)',
                              style: const TextStyle(color: Colors.grey),
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  if (doctor.otherSpecialties != null &&
                      doctor.otherSpecialties!.isNotEmpty)
                    const SizedBox(height: 30),
                  if (doctor.otherSpecialties != null &&
                      doctor.otherSpecialties!.isNotEmpty)
                    const HeaderText(text: 'Other specialties'),
                  if (doctor.otherSpecialties != null &&
                      doctor.otherSpecialties!.isNotEmpty)
                    ...doctor.otherSpecialties!
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.5),
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

                  ///SERVICES

                  if (doctor.services != null && doctor.services!.isNotEmpty)
                    const SizedBox(height: 30),
                  if (doctor.services != null && doctor.services!.isNotEmpty)
                    const HeaderText(text: 'Services Offered'),
                  if (doctor.services != null && doctor.services!.isNotEmpty)
                    ...doctor.services!
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.5),
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

                  ///EXPERIENCE

                  if (doctor.experiences != null &&
                      doctor.experiences!.isNotEmpty)
                    const SizedBox(height: 30),
                  if (doctor.experiences != null &&
                      doctor.experiences!.isNotEmpty)
                    const HeaderText(text: 'Experience'),
                  if (doctor.experiences != null &&
                      doctor.experiences!.isNotEmpty)
                    ...doctor.experiences!
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const CircleAvatar(
                                    radius: 2,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(e.toString()), //TODO: check upon this
                                ],
                              ),
                            ))
                        .toList(),
                  if (doctor.bio != null) const SizedBox(height: 30),
                  if (doctor.bio != null) const HeaderText(text: 'Bio'),
                  if (doctor.bio != null) const SizedBox(height: 2.5),
                  if (doctor.bio != null) Text(doctor.bio!),
                  const Divider(height: 50),

                  ///REVIEWS

                  if (doctor.reviews != null && doctor.reviews!.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const HeaderText(text: 'Reviews'),
                        TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 14))),
                          onPressed: () {
                            navigate(context,
                                ReviewListScreen(reviews: doctor.reviews!));
                          },
                          child: const Text('See all'),
                        ),
                      ],
                    ),
                  if (doctor.reviews != null &&
                      doctor.reviews!
                          .isNotEmpty) //TODO: check if comment is empty
                    ReviewCard(
                      review: doctor.reviews!
                          .where((element) =>
                              element.comment != null &&
                              element.comment!.isNotEmpty)
                          .toList()[0],
                    ),
                  const SizedBox(height: 30),
                  CustomFlatButton(
                    child: const Text('Sign out'),
                    onPressed: () {
                      showConfirmationDialog(
                        context,
                        message: 'Sign out?',
                        confirmFunction: () {
                          _auth.signOut(context);
                          navigate(context, const EditProfileScreen());
                        },
                      );
                    },
                    backgroundColor: Colors.red[900],
                  ),
                ],
              ),
            ),
            CustomAppBar(
              leading: Icons.arrow_back,
              title: 'Profile',
              actions: [
                OutlineIconButton(
                  iconData: Icons.edit,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
