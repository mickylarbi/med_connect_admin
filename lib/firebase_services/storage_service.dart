import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager_firebase/flutter_cache_manager_firebase.dart';
import 'package:med_connect_admin/firebase_services/auth_service.dart';

class StorageService {
  AuthService auth = AuthService();
  Reference storageRef = FirebaseStorage.instance.ref('profile_pictures');

  Future<String> get profileImageDownloadUrl => FirebaseStorage.instance
      .ref('profile_pictures/${auth.uid}')
      .getDownloadURL();
}

class ProfileImageBloc {
  late File _file;

  final _eventController = StreamController<dynamic>();
  final _stateController = StreamController<dynamic>();

  StreamSink get eventSink => _eventController.sink;
  Stream get stateStream => _stateController.stream;

  createInstance(String url) async {
    //TODO: create instance in splash screen along with getting name
    //TODO: error handling

    _eventController.stream.listen(_mapEventToState);
    eventSink.add(url);
  }

  void _mapEventToState(dynamic url) async {
    _file = await FirebaseCacheManager().getSingleFile(url);
    _stateController.sink.add(_file);
  }

  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
