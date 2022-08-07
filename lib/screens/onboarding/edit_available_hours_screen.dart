import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect_admin/screens/shared/custom_app_bar.dart';

class EditAvailableHoursScreen extends StatefulWidget {
  const EditAvailableHoursScreen({Key? key}) : super(key: key);

  @override
  State<EditAvailableHoursScreen> createState() =>
      _EditAvailableHoursScreenState();
}

class _EditAvailableHoursScreenState extends State<EditAvailableHoursScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              // controller: controller,
              padding: const EdgeInsets.fromLTRB(36, 88, 36, 120),
              child: Column(
                children: [
                  // ElevatedButton(onPressed: () {}, child: Text('console print'))
                ],
              ),
            ),
            const CustomAppBar(
              leading: Icons.arrow_back,
              title: 'Available hours',
            )
          ],
        ),
      ),
    );
  }
}

List<int> hours = List.generate(12, (index) => index);
List<int> minutes = [00, 30];
List<String> timeOfDay = ['am', 'pm'];
