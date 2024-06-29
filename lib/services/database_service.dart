import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:letschat_app/models/user_profile.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance; // To create a collection reference and store documents within it
  CollectionReference ? _usersCollection;
  DatabaseService(){
    _setupCollectionReference();
  }

  void _setupCollectionReference(){
    _usersCollection = _firebaseFirestore.collection('users').withConverter<UserProfile>(
          fromFirestore: (snapshots,_) => UserProfile.fromJson(snapshots.data()!),
          toFirestore: (userProfile,_) => userProfile.toJson(),
        );
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
     await _usersCollection!.doc(userProfile.uid).set(userProfile);
  }


}