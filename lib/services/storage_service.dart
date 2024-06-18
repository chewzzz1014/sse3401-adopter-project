import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  StorageService() {}

  Future<String?> uploadUserProfilePicture({
    required File file,
    required String uid,
  }) async {
    Reference fileRef = _firebaseStorage
        .ref('users/pfps')
        .child('$uid${path.extension(file.path)}');

    UploadTask task = fileRef.putFile(file);
    return task.then(
      (p) {
        if (p.state == TaskState.success) {
          return fileRef.getDownloadURL();
        }
      },
    );
  }

  Future<String?> uploadImageToChat(
      {required File file, required String chatID}) async {
    Reference fileRef = _firebaseStorage.ref('chats/$chatID').child(
        '${DateTime.now().toIso8601String()}${path.extension(file.path)}');

    UploadTask task = fileRef.putFile(file);
    return task.then(
      (p) {
        if (p.state == TaskState.success) {
          return fileRef.getDownloadURL();
        }
      },
    );
  }

  Future<String?> loadLogoImage() async {
    String imagePath = 'app_logo.png';

    try {
      String downloadURL = await _firebaseStorage
          .ref(imagePath)
          .getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error retrieving image: $e');
    }
  }
}
