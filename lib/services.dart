import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseServices {
  User? user =
      FirebaseAuth.instance.currentUser; //yeh error de rha tha nullable ka
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('user');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
//here we can save data for our polygon data
  CollectionReference Polygon_Cliper =
  FirebaseFirestore.instance.collection('Polygon_Cliper');

//sava data categories

  Future<void> savedata({
    required Map<String, dynamic> data,
    required CollectionReference ref,
    required String docName,
  }) async {
    // String id = await FirebaseFirestore.generateId();
    return ref.doc().set(data);
  }
}
// Map<String, dynamic> data,CollectionReference ref,
