import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  StorageService(){} // this class enables us to upload a user's profile picture and return the download  link for the actual profile picture where we can use the profile picture in different places in the app

  Future<String ?> uploadUserPFP({required File file, required String uid}) async{

    Reference fileRef = _firebaseStorage
        .ref('users/pfps')
        .child('$uid${p.extension(file.path)}'); // create a path in the firebase storage

    UploadTask TASK = fileRef.putFile(file); // to put the file in the storage

    return TASK.then(
      (p) {
        if (p.state == TaskState.success) {
          return fileRef.getDownloadURL(); // to download the url
        }
      },
    );
  }


}