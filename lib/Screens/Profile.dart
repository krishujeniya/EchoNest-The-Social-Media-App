// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:echonest/Constants/Constants.dart';
import 'package:echonest/Models/Echo.dart';
import 'package:echonest/Models/UserModel.dart';
import 'package:echonest/Screens/EditProfile.dart';
import 'package:echonest/Screens/Check.dart';
import 'package:echonest/Services/DB.dart';
import 'package:echonest/Services/Auth.dart';
import 'package:echonest/Component/EchoView.dart';

class ProfileP extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;

  const ProfileP({super.key, required this.currentUserId, required this.visitedUserId});
  @override
  _ProfilePState createState() => _ProfilePState();
}

class _ProfilePState extends State<ProfileP> {
  int _followersCount = 0;
  int _followingCount = 0;
  bool _isFollowing = false;
  int _profileSegmentedValue = 0;
  List<Echo> _allEchos = [];

  final Map<int, Widget> _profileTabs = <int, Widget>{
    0: const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Your Echoes',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: ThemeMainBG,
        ),
      ),
    ),
    
  };

  Widget buildProfileWidgets(UserModel author) {
    switch (_profileSegmentedValue) {
      case 0:
        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _allEchos.length,
            itemBuilder: (context, index) {
              return EchoView(
                currentUserId: widget.currentUserId,
                author: author,
                Echo_1: _allEchos[index],
              );
            });
      
      default:
        return const Center(
            child: Text('Something wrong', style: TextStyle(fontSize: 25)));
    }
  }

  getFollowersCount() async {
    int followersCount =
        await DatabaseServices.followersNum(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followersCount = followersCount;
      });
    }
  }

  getFollowingCount() async {
    int followingCount =
        await DatabaseServices.followingNum(widget.visitedUserId);
    if (mounted) {
      setState(() {
        _followingCount = followingCount;
      });
    }
  }

  followOrUnFollow() {
    if (_isFollowing) {
      unFollowUser();
    } else {
      followUser();
    }
  }

  unFollowUser() {
    DatabaseServices.unFollowUser(widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = false;
      _followersCount--;
    });
  }

  followUser() {
    DatabaseServices.followUser(widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = true;
      _followersCount++;
    });
  }

  setupIsFollowing() async {
    bool isFollowingThisUser = await DatabaseServices.isFollowingUser(
        widget.currentUserId, widget.visitedUserId);
    setState(() {
      _isFollowing = isFollowingThisUser;
    });
  }

  getAllEchos() async {
    List<Echo>? userEchoes =
        (await DatabaseServices.getUserEchoes(widget.visitedUserId)).cast<Echo>();
    if (mounted) {
      setState(() {
        _allEchos = userEchoes.toList();
       
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFollowersCount();
    getFollowingCount();
    setupIsFollowing();
    getAllEchos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeMainBG,
        body: FutureBuilder(
          future: usersRef.doc(widget.visitedUserId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(ThemeMain),
                ),
              );
            }
            UserModel userModel = UserModel.fromDoc(snapshot.data);
            return ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: ThemeMain,
                    image: userModel.coverImage.isEmpty
                        ? null
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(userModel.coverImage),
                          ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox.shrink(),
                        widget.currentUserId == widget.visitedUserId
    ? Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ThemeMain,
        ),
        child: IconButton(
          icon: const Icon(
            Icons.logout,
            color: ThemeMainBG,
            size: 30,
          ),
          onPressed: () {
            AuthService.logout();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Check(),
              ),
            );
          },
        ),
      )
    : Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ThemeMain,
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ThemeMainBG,
            size: 30,
          ),
          onPressed: () {
                                        Navigator.of(context).pop();

          },
        ),
      ),

                      ],
                    ),
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                         CircleAvatar(
  radius: 45,
  backgroundImage: userModel.profilePicture.isEmpty
      ? const AssetImage('assets/placeholder.png')
      : NetworkImage(userModel.profilePicture) as ImageProvider<Object>?,
),

                          widget.currentUserId == widget.visitedUserId
                              ? GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfile(
                                          user: userModel,
                                        ),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 35,
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: ThemeMainBG,
                                      border: Border.all(color: ThemeMain),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: ThemeMain,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: followOrUnFollow,
                                  child: Container(
                                    width: 100,
                                    height: 35,
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: _isFollowing
                                          ? ThemeMainBG
                                          : ThemeMain,
                                      border: Border.all(color: ThemeMain),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _isFollowing ? 'Unfollow' : 'Follow',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: _isFollowing
                                              ? ThemeMain
                                              : ThemeMainBG,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userModel.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userModel.bio,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            '$_followingCount Following',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '$_followersCount Followers',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CupertinoSlidingSegmentedControl(
                          groupValue: _profileSegmentedValue,
                          thumbColor: ThemeMain,
                          backgroundColor: Colors.blueGrey,
                          children: _profileTabs,
                          onValueChanged: (i) {
                            setState(() {
                              _profileSegmentedValue = i!;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                buildProfileWidgets(userModel),
              ],
            );
          },
        ));
  }
}
