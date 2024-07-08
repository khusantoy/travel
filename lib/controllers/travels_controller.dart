import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel/services/travels_firebase_service.dart';

class TravelsController {
  final _travelsFirebaseService = TravelsFirebaseService();

  Stream<QuerySnapshot> get list async* {
    yield* _travelsFirebaseService.getTravels();
  }

  Future<void> addTravel({
    required String title,
    required String location,
    required File imageFile,
  }) async {
    await _travelsFirebaseService.addTravel(
        title: title, location: location, imageFile: imageFile);
  }

  Future<void> updateTravel({
    required String id,
    required String title,
    required String location,
    required File imageFile,
  }) async {
    await _travelsFirebaseService.updateTravel(
        id: id, title: title, location: location, imageFile: imageFile);
  }

  Future<void> updateSomeTravelFields({
    required String id,
    required String title,
    required String location,
  }) async {
    await _travelsFirebaseService.updateSomeTravelFields(
        id: id, title: title, location: location);
  }

  Future<void> deleteTravel(String id) async {
    await _travelsFirebaseService.deleteTravel(id);
  }
}
