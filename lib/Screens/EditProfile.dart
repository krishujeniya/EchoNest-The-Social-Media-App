// ignore_for_file: unnecessary_null_comparison, file_names, library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:echonest/Constants/Constants.dart';
import 'package:echonest/Models/UserModel.dart';
import 'package:echonest/Services/DB.dart';
import 'package:echonest/Services/FBStorage.dart';

const AssetImage placeholderImage = AssetImage('assets/placeholder.png');

class EditProfile extends StatefulWidget {
  final UserModel user;

  const EditProfile({super.key, required this.user});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late String _name;
  late String _bio;
  File? _profileImage;
  File? _coverImage;
  late String _imagePickedType;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

displayCoverImage() {
  if (_coverImage != null) {
    return FileImage(_coverImage!);
  } else if (widget.user.coverImage.isNotEmpty) {
    return FileImage(File(widget.user.coverImage));
  } else {
    return null;
  }
}

displayProfileImage() {
  if (_profileImage != null) {
    return FileImage(_profileImage!);
  } else if (widget.user.profilePicture.isNotEmpty) {
    return FileImage(File(widget.user.profilePicture));
  } else {
    return placeholderImage;
  }
}

  saveProfile() async {
    _formKey.currentState?.save();
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      String profilePictureUrl = '';
      String coverPictureUrl = '';
      if (_profileImage != null) {
        profilePictureUrl = await StorageService.uploadProfilePicture(
            widget.user.profilePicture, _profileImage!);
      }
      if (_coverImage != null) {
        coverPictureUrl = await StorageService.uploadCoverPicture(
            widget.user.coverImage, _coverImage!);
      }
      UserModel user = UserModel(
        id: widget.user.id,
        name: _name,
        profilePicture: profilePictureUrl,
        bio: _bio,
        coverImage: coverPictureUrl,
        email: '',
      );

      DatabaseServices.updateUserData(user);
      Navigator.pop(context);
    }
  }

  Future<void> handleImageFromGallery() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        final imageFile = File(pickedImage.path);

        if (_imagePickedType == 'profile') {
          setState(() {
            _profileImage = imageFile;
          });
        } else if (_imagePickedType == 'cover') {
          setState(() {
            _coverImage = imageFile;
          });
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          GestureDetector(
            onTap: () {
              _imagePickedType = 'cover';
              handleImageFromGallery();
            },
            child: Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: ThemeMain,
                    image: displayCoverImage() != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: displayCoverImage()!,
                          )
                        : null,
                  ),
                ),
                Container(
                  height: 150,
                  color: ThemeMainBG,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 70,
                        color: Colors.white,
                      ),
                      Text(
                        'Change Cover Photo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0, -40, 0),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _imagePickedType = 'profile';
                        handleImageFromGallery();
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                displayProfileImage() ?? placeholderImage,
                          ),
                          const CircleAvatar(
                            radius: 45,
                            backgroundColor: ThemeMainBG,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Change Profile Photo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: saveProfile,
                      child: Container(
                        width: 100,
                        height: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ThemeMain,
                        ),
                        child: const Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      TextFormField(
                        initialValue: _name,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(color: ThemeMain),
                        ),
                        validator: (input) =>
                            input!.trim().length < 2 ? 'please enter valid name' : null,
                        onSaved: (value) {
                          _name = value!;
                        },
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        initialValue: _bio,
                        decoration: const InputDecoration(
                          labelText: 'Bio',
                          labelStyle: TextStyle(color: ThemeMain),
                        ),
                        onSaved: (value) {
                          _bio = value!;
                        },
                      ),
                      const SizedBox(height: 30),
                      _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(ThemeMain),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
