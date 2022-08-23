import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_services/firestore_service.dart';
import 'package:med_connect_admin/screens/auth/auth_screen.dart';
import 'package:med_connect_admin/screens/home/doctor/doctor_tab_view.dart';
import 'package:med_connect_admin/screens/onboarding/onboarding_screen.dart';
import 'package:med_connect_admin/screens/onboarding/select_category_screen.dart';
import 'package:med_connect_admin/utils/constants.dart';
import 'package:med_connect_admin/utils/dialogs.dart';

class AuthService {
  FirestoreService _db = FirestoreService();

  FirebaseAuth instance = FirebaseAuth.instance;

  User? get currentUser => instance.currentUser;
  String get uid => currentUser!.uid;

  void signUp(BuildContext context,
      {required String email, required String password}) {
    showLoadingDialog(context, message: 'Creating account...');

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
        .timeout(ktimeout)
        .then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
          (route) => false);
    }).onError((error, stackTrace) {
      if (error is FirebaseAuthException) {
        if (error.code == 'weak-password') {
          showAlertDialog(context,
              message: 'The password provided is too weak.');
        } else if (error.code == 'email-already-in-use') {
          showAlertDialog(context,
              message: 'The account already exists for that email.');
        }
      } else {
        Navigator.pop(context);
        showAlertDialog(context);
      }
    });
  }

  signIn(BuildContext context,
      {required String email, required String password}) {
    showLoadingDialog(context);

    instance
        .signInWithEmailAndPassword(email: email, password: password)
        .timeout(ktimeout)
        .then((value) {
      _db.getAdminInfo.get().timeout(ktimeout).then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DoctorTabView()),
            (route) => false);
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

          Navigator.pop(context);
          showAlertDialog(context, message: 'An unknown error occured');
        }
      });
    }).onError((error, stackTrace) {
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          showAlertDialog(context, message: 'No user found for that email.');
        } else if (error.code == 'wrong-password') {
          showAlertDialog(context,
              message: 'Wrong password provided for that user.');
        }
      } else {
        Navigator.pop(context);
        showAlertDialog(context);
      }
    });
  }

  void signOut(BuildContext context) async {
    showLoadingDialog(context, message: 'Signing out...');

    instance.signOut().timeout(ktimeout).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const AuthScreen(authType: AuthType.login)),
          (route) => false);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      showAlertDialog(context, message: 'Error signing out');
    });
  }

  authFunction(BuildContext context) {}
}
