import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/screens/auth/auth_screen.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_tab_view.dart';
import 'package:med_connect_admin/screens/home/pharmacy/pharmacy_tab_view.dart';
import 'package:med_connect_admin/screens/onboarding/welcome_screen.dart';
import 'package:med_connect_admin/screens/onboarding/select_category_screen.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';

class AuthService {
  FirestoreService db = FirestoreService();

  FirebaseAuth instance = FirebaseAuth.instance;

  User? get currentUser => instance.currentUser;
  String get uid => currentUser!.uid;

  signUp(BuildContext context,
      {required String email, required String password}) async {
    showLoadingDialog(context, message: 'Creating account...');

    instance
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
        .timeout(ktimeout)
        .then((value) {
      authFunction(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);

      if (error is FirebaseAuthException) {
        if (error.code == 'weak-password') {
          showAlertDialog(context,
              message: 'The password provided is too weak.');
        } else if (error.code == 'email-already-in-use') {
          showAlertDialog(context,
              message: 'The account already exists for that email.');
        }
      } else {
        showAlertDialog(context);
      }
    });
  }

  signIn(BuildContext context,
      {required String email, required String password}) async {
    showLoadingDialog(context);

    instance
        .signInWithEmailAndPassword(email: email, password: password)
        .timeout(ktimeout)
        .then((value) {
      authFunction(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);

      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          showAlertDialog(context, message: 'No user found for that email.');
        } else if (error.code == 'wrong-password') {
          showAlertDialog(context,
              message: 'Wrong password provided for that user.');
        }
      } else {
        showAlertDialog(context);
      }
    });
  }

  signOut(BuildContext context) async {
    showLoadingDialog(context, message: 'Signing out...');

    instance.signOut().timeout(ktimeout).then((value) {
      authFunction(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showAlertDialog(context, message: 'Error signing out');
    });
  }

  authFunction(BuildContext context) {
    if (currentUser != null) {
      db.adminDocument.get().timeout(ktimeout).then((value) {
        if (value.data() == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              (route) => false);
        } else {
          String adminRole = value.data()!['adminRole'];

         

          if (adminRole == 'doctor') {
            kadminName = '${value.data()!['firstName']}';
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const DoctorTabView()),
                (route) => false);
          } else if (adminRole == 'pharmacy') {
            kadminName = '${value.data()!['name']}';
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const PharmacyTabView()),
                (route) => false);
          }
        }
      }).onError((error, stackTrace) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ErrorScreen()),
            (route) => false);
      });
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const AuthScreen(authType: AuthType.login)),
          (route) => false);
    }
  }
}

class ErrorScreen extends StatelessWidget {
  ErrorScreen({Key? key}) : super(key: key);

  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Error fetching info'),
            TextButton(
              onPressed: () {
                showLoadingDialog(context);
                auth.authFunction(context);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
