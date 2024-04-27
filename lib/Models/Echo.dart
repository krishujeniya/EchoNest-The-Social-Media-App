// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Echo {
  String id;
  String authorId;
  String text;
  String image;
  Timestamp timestamp;
  int likes;

  Echo(
      {required this.id,
      required this.authorId,
      required this.text,
      required this.image,
      required this.timestamp,
      required this.likes,
});

  factory Echo.fromDoc(DocumentSnapshot doc) {
    return Echo(
      id: doc.id,
      authorId: doc['authorId'],
      text: doc['text'],
      image: doc['image'],
      timestamp: doc['timestamp'],
      likes: doc['likes'],
    );
  }
}
