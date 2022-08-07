import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:med_connect_admin/screens/auth/auth_screen.dart';
import 'package:med_connect_admin/screens/onboarding/doctor_info_screen.dart';
import 'package:med_connect_admin/screens/onboarding/edit_available_hours_screen.dart';

class Src extends StatelessWidget {
  const Src({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: AuthWidget(),
      home: DoctorInfoScreen(),
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        primarySwatch: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.blueGrey),
        textTheme: GoogleFonts.openSansTextTheme(
          const TextTheme(
            bodyText2: TextStyle(color: Colors.blueGrey, letterSpacing: .2),
          ),
        ),
      ),
    );
  }
}
