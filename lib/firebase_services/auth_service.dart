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
          bool? isVerified = value.data()!['isVerified'];

          String adminRole = value.data()!['adminRole'];

          if (isVerified == null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const PendingScreen()),
                (route) => false);
          } else if (isVerified == false) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const UnapprovedScreen()),
                (route) => false);
          } else {
            if (adminRole == 'doctor') {
              kadminName = '${value.data()!['firstName']}';
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DoctorTabView()),
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
        }
      }).onError((error, stackTrace) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ErrorScreen()),
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
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService auth = AuthService();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/error.png',
              width: kScreenWidth(context) - 72,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 50),
            const Text(
              'Error fetching info',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
                onPressed: () {
                  showLoadingDialog(context);
                  auth.authFunction(context);
                },
                label: const Text('Retry'),
                icon: const Icon(Icons.refresh)),
          ],
        ),
      ),
    );
  }
}

class PendingScreen extends StatelessWidget {
  const PendingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService auth = AuthService();

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(36),
          children: [
            Image.asset(
              'assets/images/pending.png',
              // width: kScreenWidth(context) - 72,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 50),
            const Text(
              'Your license ID is pending approval',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                showLoadingDialog(context);
                auth.authFunction(context);
              },
              label: const Text('Reload'),
              icon: const Icon(Icons.refresh),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
                onPressed: () {
                  showConfirmationDialog(
                    context,
                    message: 'Sign out?',
                    confirmFunction: () {
                      auth.signOut(context);
                    },
                  );
                },
                label: const Text(
                  'Sign out',
                  style: TextStyle(color: Colors.red),
                ),
                icon: const Icon(
                  Icons.logout,
                  color: Colors.red,
                )),
          ],
        ),
      ),
    );
  }
}

class UnapprovedScreen extends StatelessWidget {
  const UnapprovedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService auth = AuthService();

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(36),
          children: [
            Image.asset(
              'assets/images/unapproved.png',
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 50),
            const Text(
              'Your license ID was unapproved.\nIf there is any issue contact Tech Support on +233559100608 for assistance',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
                onPressed: () {
                  auth.signOut(context);
                },
                label: const Text('Sign out'),
                icon: const Icon(Icons.logout)),
          ],
        ),
      ),
    );
  }
}
