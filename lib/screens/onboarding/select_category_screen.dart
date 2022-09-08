import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:med_connect_admin/screens/onboarding/doctor/doctor_info_screen.dart';
import 'package:med_connect_admin/screens/onboarding/pharmacy/pharmacy_info.dart';
import 'package:med_connect_admin/utils/functions.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(36),
            // controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Where do you belong?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 50),
                CategoryTile(
                  text: 'Doctor',
                  destination: DoctorInfoScreen(),
                ),
                SizedBox(height: 20),
                CategoryTile(
                  text: 'Pharmacy',
                  destination: PharmacyInfoScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final Widget destination;
  final String text;
  const CategoryTile({
    Key? key,
    required this.destination,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueGrey[50],
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          navigate(context, destination);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.chevron_right)
            ],
          ),
        ),
      ),
    );
  }
}
