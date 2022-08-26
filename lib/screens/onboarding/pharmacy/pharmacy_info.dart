import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_connect_admin/firebase_services/auth_service.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/firebase_services/storage_service.dart';
import 'package:med_connect_admin/models/pharmacy/pharmacy.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/custom_textformfield.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';

class PharmacyInfoScreen extends StatefulWidget {
  const PharmacyInfoScreen({Key? key}) : super(key: key);

  @override
  State<PharmacyInfoScreen> createState() => _PharmacyInfoScreenState();
}

class _PharmacyInfoScreenState extends State<PharmacyInfoScreen> {
  TextEditingController nameController = TextEditingController();
  ValueNotifier<XFile?> pictureNotifier = ValueNotifier<XFile?>(null);

  FirestoreService db = FirestoreService();
  StorageService storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 150),
                child: Center(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    shrinkWrap: true,
                    children: [
                      photoColumn(),
                      const Divider(height: 100),
                      nameColumn(),
                    ],
                  ),
                ),
              ),
              createPharmacyButton(),
              const CustomAppBar(),
            ],
          ),
        ),
      ),
    );
  }

  Align createPharmacyButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 52 + 72,
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: CustomFlatButton(
            onPressed: () {
              if (pictureNotifier.value != null &&
                  nameController.text.trim().isNotEmpty) {
                showLoadingDialog(context);
                storage
                    .uploadProfileImage(pictureNotifier.value!)
                    .timeout(const Duration(minutes: 2))
                    .then((value) {
                  db
                      .addAdmin(Pharmacy(name: nameController.text.trim()))
                      .timeout(ktimeout)
                      .then((value) {
                    AuthService auth = AuthService();
                    auth.authFunction(context);
                  }).onError((error, stackTrace) {
                    Navigator.pop(context);
                    showAlertDialog(context,
                        message: 'Error while creating pharmacy');
                  });
                }).onError((error, stackTrace) {
                  Navigator.pop(context);
                  showAlertDialog(context,
                      message: 'Error while creating pharmacy');
                });
              } else if (nameController.text.trim().isEmpty) {
                showAlertDialog(context,
                    message: 'Please enter a name for your pharmacy');
              } else if (pictureNotifier.value == null) {
                showAlertDialog(context, message: 'Please add a logo');
              } else if (nameController.text.trim().isEmpty) {
                showAlertDialog(context,
                    message: 'Please enter a name for your pharmacy');
              }
            },
            child: const Text('Create pharmacy'),
          ),
        ),
      ),
    );
  }

  nameColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageViewHeaderText('What\'s the name of your pharmacy?'),
        const SizedBox(height: 20),
        CustomTextFormField(
          hintText: 'Pharmacy name',
          controller: nameController,
        ),
      ],
    );
  }

  photoColumn() {
    return ValueListenableBuilder<XFile?>(
        valueListenable: pictureNotifier,
        builder: (context, value, child) {
          final ImagePicker picker = ImagePicker();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageViewHeaderText('Add a logo'),
              const SizedBox(height: 20),
              if (value != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      File(value.path),
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    showCustomBottomSheet(
                      context,
                      [
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Take a photo'),
                          onTap: () async {
                            picker
                                .pickImage(source: ImageSource.camera)
                                .then((value) {
                              Navigator.pop(context);
                              if (value != null) {
                                pictureNotifier.value = value;
                              }
                            }).onError((error, stackTrace) {
                              showAlertDialog(context);
                            });
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo),
                          title: const Text('Choose from gallery'),
                          onTap: () async {
                            picker
                                .pickImage(source: ImageSource.gallery)
                                .then((value) {
                              Navigator.pop(context);
                              if (value != null) {
                                pictureNotifier.value = value;
                              }
                            }).onError((error, stackTrace) {
                              showAlertDialog(context);
                            });
                          },
                        ),
                      ],
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    backgroundColor: Colors.blueGrey.withOpacity(.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(value == null ? 'Choose photo' : 'Change photo'),
                ),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    nameController.dispose();
    pictureNotifier.dispose();
    super.dispose();
  }
}

class PageViewHeaderText extends StatelessWidget {
  final String text;
  const PageViewHeaderText(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }
}
