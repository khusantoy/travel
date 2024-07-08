import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TravelsFirebaseService {
  final _travelCollection = FirebaseFirestore.instance.collection("travels");
  final _placeImageStorage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getTravels() async* {
    yield* _travelCollection.snapshots();
  }

  Future<void> addTravel({
    required String title,
    required String location,
    required File imageFile,
  }) async {
    final imageReference = _placeImageStorage
        .ref()
        .child("places")
        .child("images")
        .child("$title.jpg");

    final uploadTask = imageReference.putFile(imageFile);

    await uploadTask.whenComplete(() async {
      final imageUrl = await imageReference.getDownloadURL();
      await _travelCollection.add({
        "title": title,
        "location": location,
        "imageUrl": imageUrl,
      });
    });
  }

  Future<void> updateTravel({
    required String id,
    required String title,
    required String location,
    required File imageFile,
  }) async {
    final imageReference = _placeImageStorage
        .ref()
        .child("places")
        .child("images")
        .child("$title.jpg");

    final uploadTask = imageReference.putFile(imageFile);

    await uploadTask.whenComplete(() async {
      final imageUrl = await imageReference.getDownloadURL();
      await _travelCollection.doc(id).update({
        "title": title,
        "location": location,
        "imageUrl": imageUrl,
      });
    });
  }

  Future<void> updateSomeTravelFields({
    required String id,
    required String title,
    required String location,
  }) async {
    await _travelCollection.doc(id).update({
      "title": title,
      "location": location,
    });
  }

  Future<void> deleteTravel(String id) async {
    await _travelCollection.doc(id).delete();
  }
}
