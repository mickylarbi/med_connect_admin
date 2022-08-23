import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_services/auth_service.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/screens/auth/auth_screen.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_tab_view.dart';
import 'package:med_connect_admin/screens/onboarding/select_category_screen.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0;

  AuthService auth = AuthService();
  FirestoreService db = FirestoreService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      opacity = 1;
      setState(() {});
      Future.delayed(const Duration(seconds: 4), () {
        if (auth.currentUser == null) {
          // if user isn't signed in

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const AuthScreen(authType: AuthType.signUp)),
            (route) => false,
          );
        } else {
          // if user is signed in

          db.getAdminInfo.get().timeout(ktimeout).then((value) {
            // check if user is in firebase

            if (value.data() == null) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const SelectCategoryScreen()),
                (route) => false,
              );
            }

            if (value.data() != null &&
                value.data()!['adminRole'] == 'doctor') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const DoctorTabView()),
                (route) => false,
              );
            }
          }).onError((error, stackTrace) {
            if (error is FirebaseException && error.code == 'not-found') {
              // if user doesn't exist in firebase

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const SelectCategoryScreen()),
                (route) => false,
              );
            } else {
              // can't check if user is in firebase

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ErrorScreen()),
                (route) => false,
              );
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(seconds: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png'),
              const SizedBox(height: 20),
              const Text(
                'Admin',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  ErrorScreen({Key? key}) : super(key: key);

  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Something went wrong'),
            TextButton(
              onPressed: () {
                showLoadingDialog(context);

                db.getAdminInfo.get().timeout(ktimeout).then((value) {
                  // check if user is in firebase

                  if (value.data() == null) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectCategoryScreen()),
                      (route) => false,
                    );
                  }

                  if (value.data() != null &&
                      value.data()!['adminRole'] == 'doctor') {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DoctorTabView()),
                      (route) => false,
                    );
                  }
                }).onError((error, stackTrace) {
                  if (error is FirebaseException && error.code == 'not-found') {
                    // if user doesn't exist in firebase

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectCategoryScreen()),
                      (route) => false,
                    );
                  } else {
                    // can't check if user is in firebase

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => ErrorScreen()),
                      (route) => false,
                    );
                  }
                });
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
