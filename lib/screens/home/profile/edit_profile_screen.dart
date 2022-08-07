import 'package:flutter/material.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/custom_textformfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              // controller: controller,
              padding: const EdgeInsets.fromLTRB(36, 88, 36, 24),
              child: Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/usman-yousaf-pTrhfmj2jDA-unsplash.jpg',
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Material(
                              color: Colors.black.withOpacity(.3),
                              child: InkWell(
                                onTap: () {
                                  //TODO: bottom sheet things
                                },
                                child: const Center(
                                  child: Icon(
                                    Icons.photo_camera,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(hintText: 'First name'),
                    const SizedBox(height: 10),
                    CustomTextFormField(hintText: 'Last name'),
                    const SizedBox(height: 10),
                    CustomTextFormField(hintText: 'Main specialty'),

                    //TODO: other specialties
                    //TODO: services offered
                    const SizedBox(height: 10),
                    CustomTextFormField(hintText: 'Current location'),
                    //TODO: start date

                    //TODO: Experience
                    const SizedBox(height: 10),
                    CustomTextFormField(hintText: 'Bio'),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                child: SizedBox(
                  height: 50,
                  child: CustomFlatButton(
                    child: const Text('Save changes'),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            const CustomAppBar(
              title: 'Edit Profile',
              leading: Icons.arrow_back,
            ),
          ],
        ),
      ),
    );
  }
}
