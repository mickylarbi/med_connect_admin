import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Reference profilePicturesRef =
      FirebaseStorage.instance.ref('profile_pictures/');

  Future<String> profileImageDownloadUrl([String? id]) =>
      profilePicturesRef.child(id ?? _auth.currentUser!.uid).getDownloadURL();

  UploadTask uploadProfileImage(XFile picture) => profilePicturesRef
      .child(_auth.currentUser!.uid)
      .putFile(File(picture.path));

  //DRUGS

  Reference drugsPicturesRef = FirebaseStorage.instance.ref('drugs/');

  Future<String> drugImageDownloadUrl({required String id}) =>
      drugsPicturesRef.child(id).getDownloadURL();

  UploadTask uploadDrugImage({required XFile picture, required String id}) =>
      drugsPicturesRef.child(id).putFile(File(picture.path));

  deleteDrugImage({required String id}) => drugsPicturesRef.child(id).delete();
}
