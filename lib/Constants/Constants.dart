// ignore_for_file: file_names, constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

const Color ThemeMain = Colors.green;

const Color ThemeMainBG = Colors.black;

final _fireStore = FirebaseFirestore.instance;

final usersRef = _fireStore.collection('users');

final followersRef = _fireStore.collection('followers');

final followingRef = _fireStore.collection('following');

final storageRef = FirebaseStorage.instance.ref();

final echoRef = _fireStore.collection('echoes');

final feedRefs = _fireStore.collection('feeds');

final likesRef = _fireStore.collection('likes');

final activitiesRef = _fireStore.collection('activities');
