import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_services/auth_service.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/models/pharmacy/pharmacy.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_home_page/doctor_profile/edit_doctor_profile_screen.dart';
import 'package:med_connect_admin/screens/onboarding/pharmacy/pharmacy_info.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/screens/shared/custom_icon_buttons.dart';
import 'package:med_connect_admin/screens/shared/custom_textformfield.dart';
import 'package:med_connect_admin/utils/dialogs.dart';

class PharmacyProfileScreen extends StatefulWidget {
  final Pharmacy pharmacy;
  const PharmacyProfileScreen({Key? key, required this.pharmacy})
      : super(key: key);

  @override
  State<PharmacyProfileScreen> createState() => _PharmacyProfileScreenState();
}

class _PharmacyProfileScreenState extends State<PharmacyProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  AuthService auth = AuthService();
  FirestoreService db = FirestoreService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameController.text = widget.pharmacy.name!;
    phoneController.text = widget.pharmacy.phone!;
  }

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
              Center(
                  child: ListView(
                padding: const EdgeInsets.fromLTRB(36, 88, 36, 50),
                shrinkWrap: true,
                children: [
                  const ChangeProfileImageWidget(),
                  const Divider(height: 100),
                  nameColumn(),
                  const SizedBox(height: 20),
                  phoneColumn(),
                  const SizedBox(height: 20),
                  licenseIdColumn(),
                  const SizedBox(height: 50),
                  CustomFlatButton(
                      child: const Text('Save changes'),
                      onPressed: () {
                        if (nameController.text.trim().isEmpty) {
                          showAlertDialog(context,
                              message: 'Please enter a name for your pharmacy');
                        } else if (phoneController.text.trim().isEmpty) {
                          showAlertDialog(context,
                              message: 'Please enter a phone number');
                        } else if (phoneController.text.trim().length != 9) {
                          showAlertDialog(context,
                              message: 'Please enter a valid phone number');
                        } else {
                          showConfirmationDialog(context,
                              message: 'Save changes to pharmacy?',
                              confirmFunction: () {
                            showLoadingDialog(context);
                            db
                                .updateAdmin(Pharmacy(
                                    name: nameController.text.trim(),
                                    phone: phoneController.text.trim()))
                                .then((value) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              Navigator.pop(context);
                              showAlertDialog(context,
                                  message: 'Error updating pharmacy info');
                            });
                          });
                        }
                      })
                ],
              )),
              CustomAppBar(
                title: 'Pharmacy Info',
                actions: [
                  SolidIconButton(
                    iconData: Icons.logout,
                    onPressed: () {
                      showConfirmationDialog(context, confirmFunction: () {
                        auth.signOut(context);
                      });
                    },
                    color: Colors.red,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  nameColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageViewHeaderText('Name of pharmacy'),
        const SizedBox(height: 20),
        CustomTextFormField(
          hintText: 'Pharmacy name',
          controller: nameController,
        ),
      ],
    );
  }

  phoneColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageViewHeaderText('How should we contact you?'),
        const SizedBox(height: 20),
        CustomTextFormField(
          hintText: 'Phone number',
          keyboardType: TextInputType.phone,
          controller: phoneController,
          prefix: const Text('+233'),
        ),
      ],
    );
  }

  licenseIdColumn() {
    return TextButton(
        onPressed: null,
        style: TextButton.styleFrom(
            backgroundColor: Colors.grey.withOpacity(.1),
            foregroundColor: Colors.blueGrey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            fixedSize: const Size(double.maxFinite, 48)),
        child: Text(
          widget.pharmacy.licenseId!,
          style: const TextStyle(color: Colors.blueGrey),
        ));
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();

    super.dispose();
  }
}
