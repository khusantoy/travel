import 'package:cloud_firestore/cloud_firestore.dart';

class Travel {
  String id;
  String title;
  String imageUrl;
  String location;

  Travel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.location,
  });

  factory Travel.fromQuerySnapshot(QueryDocumentSnapshot query) {
    return Travel(
      id: query.id,
      title: query['title'],
      imageUrl: query['imageUrl'],
      location: query['location'],
    );
  }
}
