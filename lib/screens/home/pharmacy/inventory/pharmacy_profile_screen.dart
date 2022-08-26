import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:med_connect_admin/models/pharmacy/pharmacy.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';

class PharmacyProfileScreen extends StatefulWidget {
  final Pharmacy pharmacy;
  const PharmacyProfileScreen({Key? key, required this.pharmacy}) : super(key: key);

  @override
  State<PharmacyProfileScreen> createState() => _PharmacyProfileScreenState();
}

class _PharmacyProfileScreenState extends State<PharmacyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: ListView()),
            CustomAppBar(
              title: 'Pharmacy Info',
            ),
          ],
        ),
      ),
    );
  }
}
