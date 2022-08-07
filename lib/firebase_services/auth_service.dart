import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/screens/auth/auth_screen.dart';
import 'package:med_connect_admin/screens/onboarding/onboarding_screen.dart';
import 'package:med_connect_admin/utils/dialogs.dart';

class AuthService {
  FirebaseAuth instance = FirebaseAuth.instance;

  User? get currentUser => instance.currentUser;

  void signUp(BuildContext context,
      {required String email, required String password}) async {
    showLoadingDialog(context, message: 'Creating account...');

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        showAlertDialog(context, message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showAlertDialog(context,
            message: 'The account already exists for that email.');
      }
    } catch (e) {
      Navigator.pop(context);
      showAlertDialog(context);
    }
  }

  signIn(BuildContext context,
      {required String email, required String password}) async {
    showLoadingDialog(context);

    try {
      await instance.signInWithEmailAndPassword(
          email: email, password: password);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AuthWidget()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        showAlertDialog(context, message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showAlertDialog(context,
            message: 'Wrong password provided for that user.');
      }
    } catch (e) {
      Navigator.pop(context);
      showAlertDialog(context);
    }
  }

  void signOut(BuildContext context) async {
    showLoadingDialog(context, message: 'Signing out...');
    try {
      await instance.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AuthWidget()),
          (route) => false);
    } catch (e) {
      Navigator.pop(context);
      showAlertDialog(context, message: 'Something went wrong');
    }
  }
}
