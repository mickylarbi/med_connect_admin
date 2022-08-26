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
  String? name;

  AuthService auth = AuthService();
  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                CustomFlatButton(
                    child: const Text('Change name'),
                    onPressed: () {
                      if (name != null && name != widget.pharmacy.name) {
                        showConfirmationDialog(context,
                            message: 'Change pharmacy name?',
                            confirmFunction: () {
                          showLoadingDialog(context);
                          db.updateAdmin(Pharmacy(name: name)).then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }).onError((error, stackTrace) {
                            Navigator.pop(context);
                            showAlertDialog(context,
                                message: 'Error changing pharmacy name');
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
          initialValue: widget.pharmacy.name,
          onChanged: (value) {
            name = value;
          },
        ),
      ],
    );
  }
}
