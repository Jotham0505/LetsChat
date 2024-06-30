import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:letschat_app/models/user_profile.dart';
import 'package:letschat_app/services/auth_service.dart';

class DatabaseService { // this is class is used to 
  
  GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance; // To create a collection reference and store documents within it
  CollectionReference ? _usersCollection;
  DatabaseService(){
    _setupCollectionReference();
    _authService = _getIt.get<AuthService>();
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

  Stream<QuerySnapshot<UserProfile>> getUserProfile(){ // get info of the user from the database
    return _usersCollection?.where('uid',isNotEqualTo: _authService.user!.uid).snapshots() as Stream<QuerySnapshot<UserProfile>>;

  }

}