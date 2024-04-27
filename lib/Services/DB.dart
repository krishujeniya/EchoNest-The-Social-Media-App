// ignore_for_file: file_names, avoid_print, non_constant_identifier_names


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echonest/Constants/Constants.dart';
import 'package:echonest/Models/Activity.dart';
import 'package:echonest/Models/Echo.dart';
import 'package:echonest/Models/UserModel.dart';
import 'package:flutter/material.dart';

class DatabaseServices {
  static Future<int> followersNum(String userId) async {
    QuerySnapshot followersSnapshot =
        await followersRef.doc(userId).collection('Followers').get();
    return followersSnapshot.docs.length;
  }
  
  

  static Future<int> followingNum(String userId) async {
    QuerySnapshot followingSnapshot =
        await followingRef.doc(userId).collection('Following').get();
    return followingSnapshot.docs.length;
  }

  static void updateUserData(UserModel user) {
    usersRef.doc(user.id).update({
      'name': user.name,
      'bio': user.bio,
      'profilePicture': user.profilePicture,
      'coverImage': user.coverImage,
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) async {
    Future<QuerySnapshot> users = usersRef
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThan: '${name}z')
        .get();

    return users;
  }

 static void followUser(String currentUserId, String visitedUserId) {
  followingRef
      .doc(currentUserId)
      .collection('Following')
      .doc(visitedUserId)
      .set({});
  followersRef
      .doc(visitedUserId)
      .collection('Followers')
      .doc(currentUserId)
      .set({});

  // Pass an empty Echo or create a default one as a placeholder
  Echo placeholderEcho = Echo(
    authorId: '',
    text: '',
    image: '',
    timestamp: Timestamp.now(),
    likes: 0,
    id: '',
  );

  addActivity(currentUserId, placeholderEcho, true, visitedUserId);
}


  static void unFollowUser(String currentUserId, String visitedUserId) {
    followingRef
        .doc(currentUserId)
        .collection('Following')
        .doc(visitedUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isFollowingUser(
      String currentUserId, String visitedUserId) async {
    DocumentSnapshot followingDoc = await followersRef
        .doc(visitedUserId)
        .collection('Followers')
        .doc(currentUserId)
        .get();
    return followingDoc.exists;
  }


static void createEcho(Echo Echo_1,BuildContext context) async {
  if (Echo_1.text.isEmpty && Echo_1.image.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Plz Enter Echo"),
      ),
    );    return;
  }
  String TT = Echo_1.text;
  String image = '';
  if (Echo_1.image.isNotEmpty) {
     
  if (Echo_1.text.isEmpty) {
    TT ='';
  }

    image = Echo_1.image;
  }

  echoRef.doc(Echo_1.authorId).set({'EchoTime': Echo_1.timestamp});
  echoRef.doc(Echo_1.authorId).collection('userEchoes').add({
    'text': TT,
    'image': image,
    "authorId": Echo_1.authorId,
    "timestamp": Echo_1.timestamp,
    'likes': Echo_1.likes,
  }).then((doc) async {
    QuerySnapshot followerSnapshot = await followersRef.doc(Echo_1.authorId).collection('Followers').get();

    for (var docSnapshot in followerSnapshot.docs) {
      feedRefs.doc(docSnapshot.id).collection('userFeed').doc(doc.id).set({
        'text': TT,
        'image': image,
        "authorId": Echo_1.authorId,
        "timestamp": Echo_1.timestamp,
        'likes': Echo_1.likes,
      });
    }
  });
}

  
  

  static Future<List> getUserEchoes(String userId) async {
    QuerySnapshot userEchoSnap = await echoRef
        .doc(userId)
        .collection('userEchoes')
        .orderBy('timestamp', descending: true)
        .get();
    List<Echo> userEchoes =
        userEchoSnap.docs.map((doc) => Echo.fromDoc(doc)).toList();

    return userEchoes;
  }

   static Future<List<Echo>> getHomeEchoes() async {
    List<Echo> allEchoes = [];

    // Query all echoes from all users
    QuerySnapshot<Map<String, dynamic>> allUsersEchoes =
        await echoRef.get();

    // Iterate through each user's echoes and add them to the allEchoes list
    for (QueryDocumentSnapshot<Map<String, dynamic>> userEchoDoc
        in allUsersEchoes.docs) {
      // Query the user's echoes collection
      QuerySnapshot<Map<String, dynamic>> userEchoes =
          await userEchoDoc.reference.collection('userEchoes').get();

      // Convert each Echo_1 document to a Echo object and add it to the allEchoes list
      allEchoes.addAll(userEchoes.docs.map((EchoDoc) {
        return Echo(
          id: EchoDoc.id,
          authorId: EchoDoc['authorId'],
          text: EchoDoc['text'],
          image: EchoDoc['image'],
          timestamp: EchoDoc['timestamp'],
          likes: EchoDoc['likes'],
        );
      }));
    }

    // Sort all echoes based on the number of likes
    allEchoes.sort((a, b) => b.likes.compareTo(a.likes));

    return allEchoes;
  }

static void likeEcho(String currentUserId, Echo Echo_1) {
  DocumentReference EchoDocProfile =
      echoRef.doc(Echo_1.authorId).collection('userEchoes').doc(Echo_1.id);
  EchoDocProfile.get().then((doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>
    int likes = data?['likes'] ?? 0;
    EchoDocProfile.update({'likes': likes + 1});
  });

  DocumentReference EchoDocFeed =
      feedRefs.doc(currentUserId).collection('userFeed').doc(Echo_1.id);
  EchoDocFeed.get().then((doc) {
    if (doc.exists) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>
      int likes = data?['likes'] ?? 0;
      EchoDocFeed.update({'likes': likes + 1});
    }
  });

  likesRef.doc(Echo_1.id).collection('EchoLikes').doc(currentUserId).set({});

  // Pass an empty string or a default value as a placeholder for followedUserId
  String placeholderFollowedUserId = '';

  addActivity(currentUserId, Echo_1, false, placeholderFollowedUserId);
}

static void unlikeEcho(String currentUserId, Echo Echo_1) {
  DocumentReference EchoDocProfile =
      echoRef.doc(Echo_1.authorId).collection('userEchoes').doc(Echo_1.id);
  EchoDocProfile.get().then((doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>
    int likes = data?['likes'] ?? 0;
    EchoDocProfile.update({'likes': likes - 1});
  });

  DocumentReference EchoDocFeed =
      feedRefs.doc(currentUserId).collection('userFeed').doc(Echo_1.id);
  EchoDocFeed.get().then((doc) {
    if (doc.exists) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>
      int likes = data?['likes'] ?? 0;
      EchoDocFeed.update({'likes': likes - 1});
    }
  });

  likesRef
      .doc(Echo_1.id)
      .collection('EchoLikes')
      .doc(currentUserId)
      .get()
      .then((doc) => doc.reference.delete());
}

  static Future<bool> isLikeEcho(String currentUserId, Echo Echo_1) async {
    DocumentSnapshot userDoc = await likesRef
        .doc(Echo_1.id)
        .collection('EchoLikes')
        .doc(currentUserId)
        .get();

    return userDoc.exists;
  }

  static Future<List<Activity>> getActivities(String userId) async {
    QuerySnapshot userActivitiesSnapshot = await activitiesRef
        .doc(userId)
        .collection('userActivities')
        .orderBy('timestamp', descending: true)
        .get();

    List<Activity> activities = userActivitiesSnapshot.docs
        .map((doc) => Activity.fromDoc(doc))
        .toList();

    return activities;
  }

  static void addActivity(
      String currentUserId, Echo Echo_1, bool follow, String followedUserId) {
    if (follow) {
      activitiesRef.doc(followedUserId).collection('userActivities').add({
        'fromUserId': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        "follow": true,
      });
    } else {
      //like
      activitiesRef.doc(Echo_1.authorId).collection('userActivities').add({
        'fromUserId': currentUserId,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        "follow": false,
      });
    }
  }
}
