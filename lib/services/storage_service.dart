import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  StorageService() {}

  Future<File> compressImage(File file) async {
    final tempDir = await getTemporaryDirectory();
    final tempFinalPath = path.join(tempDir.path, 'temp_${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}');

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      tempFinalPath,
      minWidth: 800,
      minHeight: 800,
      quality: 80
    );

    return File(result!.path); // Convert Xfile to File
  }

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

  Future<String?> uploadImageToChat({
    required File file,
    required String chatID
  }) async {
    Reference fileRef = _firebaseStorage
        .ref('chats/$chatID')
        .child('${DateTime.now().toIso8601String()}${path.extension(file.path)}');

    UploadTask task = fileRef.putFile(file);
    return task.then(
      (p) {
        if (p.state == TaskState.success) {
          return fileRef.getDownloadURL();
        }
      },
    );
  }

  Future<String?> uploadAnimalsImage({
    required File file,
    required String petName,
  }) async {
    File compressedImage = await compressImage(file);

    Reference fileRef = _firebaseStorage
        .ref('users/animals')
        .child('$petName${DateTime.now().toIso8601String()}${path.extension(compressedImage.path)}');

    UploadTask task = fileRef.putFile(compressedImage);
    return task.then(
          (p) {
        if (p.state == TaskState.success) {
          return fileRef.getDownloadURL();
        }
      },
    );
  }

  Future<String?> uploadHealthDoc({
    required File file,
    required String petName,
  }) async {
    Reference fileRef = _firebaseStorage
        .ref('users/docs')
        .child('$petName${DateTime.now().toIso8601String()}${path.extension(file.path)}');

    UploadTask task = fileRef.putFile(file);
    return task.then(
          (p) {
        if (p.state == TaskState.success) {
          return fileRef.getDownloadURL();
        }
      },
    );
  }
}
