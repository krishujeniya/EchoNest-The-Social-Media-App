// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  String id;
  String fromUserId;
  Timestamp timestamp;
  bool follow;
  bool isRead; // Add this property

  Activity({
    required this.id,
    required this.fromUserId,
    required this.timestamp,
    required this.follow,
    required this.isRead, // Include isRead in the constructor
  });

  factory Activity.fromDoc(DocumentSnapshot doc) {
    return Activity(
      id: doc.id,
      fromUserId: doc['fromUserId'],
      timestamp: doc['timestamp'],
      follow: doc['follow'],
      isRead: false, // Initialize isRead to a default value, e.g., false
    );
  }
}
