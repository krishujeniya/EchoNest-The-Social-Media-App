// ignore_for_file: await_only_futures, file_names, library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:echonest/Constants/Constants.dart';
import 'package:echonest/Models/Echo.dart';
import 'package:echonest/Services/DB.dart';
import 'package:echonest/Services/FBStorage.dart';
import 'package:echonest/Component/SwipeB.dart';

class NewEcho extends StatefulWidget {
  final String currentUserId;

  const NewEcho({super.key, required this.currentUserId});

  @override
  _NewEchoState createState() => _NewEchoState();
}

class _NewEchoState extends State<NewEcho> {
  late String _tweetText = "";
  File? _pickedImage;
  bool _loading = false;

  Future<void> handleImageFromGallery() async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _pickedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Image.asset(
          'assets/iw.png',
          height: 40,
        ),
        backgroundColor: ThemeMainBG,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextField(
                maxLength: 280,
                maxLines: 7,
                decoration: const InputDecoration(
                  hintText: 'Enter your Echo',
                ),
                onChanged: (value) {
                  _tweetText = value;
                },
              ),
              const SizedBox(height: 10),
              _pickedImage == null
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: ThemeMain,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(_pickedImage!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
              GestureDetector(
                onTap: () async {
                  await handleImageFromGallery();
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ThemeMainBG,
                    border: Border.all(
                      color: ThemeMain,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: ThemeMain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              RoundedButton(
                btnText: 'Echo',
                onBtnPressed: () async {
                  setState(() {
                    _loading = true;
                  });

                  if (_tweetText.isNotEmpty && _pickedImage != null) {
                    String image = _pickedImage != null
                        ? await StorageService.uploadEchoPicture(_pickedImage!)
                        : '';

                    Echo echo1 = Echo(
                      text: _tweetText,
                      image: image,
                      authorId: widget.currentUserId,
                      likes: 0,
                      timestamp: Timestamp.fromDate(
                   DateTime.now(),
                         ),
                      id: '',
                    );

                    DatabaseServices.createEcho(echo1,context);
                    Navigator.pop(context);
                  } if (_tweetText == '' || _tweetText == "Enter your Echo") {
ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
        content: Text(
                    'Enter Echo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
      ),
    );                   }

                  setState(() {
                    _loading = false;
                  });
                },
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator( valueColor: AlwaysStoppedAnimation(ThemeMain),)
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
