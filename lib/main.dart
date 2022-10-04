import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:med_connect_admin/firebase_options.dart';
import 'package:med_connect_admin/src.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Src());

  //TODO: account deletion
}
