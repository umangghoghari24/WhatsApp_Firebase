import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//provider
final firebaseStorageClassProvider = Provider(
      (ref) => FirebaseStorageClass(
    firebaseStorage: FirebaseStorage.instance,
  ),
);

class FirebaseStorageClass {
  final FirebaseStorage firebaseStorage;

  FirebaseStorageClass({
    required this.firebaseStorage,
  });

  Future<String> uploadFiles(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
   }
}