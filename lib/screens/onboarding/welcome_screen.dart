import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/screens/onboarding/select_category_screen.dart';
import 'package:med_connect_admin/screens/shared/custom_buttons.dart';
import 'package:med_connect_admin/utils/constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

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
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/undraw_doctors_hwty.png', //TODO: better resolution
                    width: kScreenWidth(context) - 72,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Hey there...',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 10),
                const Text(
                    'Welcome to MedConnect.\nGetting appointments has never been easier'),
                const SizedBox(height: 100),
                CustomFlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Get started'),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const SelectCategoryScreen(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
