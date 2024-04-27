// ignore_for_file: file_names, library_private_types_in_public_api, unused_field

import 'package:echonest/Models/Activity.dart';
import 'package:echonest/Services/DB.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:echonest/Constants/Constants.dart';
import 'package:echonest/Screens/Home.dart';
import 'package:echonest/Screens/Notification.dart';
import 'package:echonest/Screens/Profile.dart';
import 'package:echonest/Screens/Chat.dart';

class Feed extends StatefulWidget {
  final String currentUserId;

  const Feed({super.key, required this.currentUserId});
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  int _selectedTab = 0;
  bool hasUnreadNotifications = false; 
  List<Activity> _activities = []; 

  @override
  void initState() {
    super.initState();
    setupActivities(); 
  }

  setupActivities() async {
    List<Activity> activities =
        await DatabaseServices.getActivities(widget.currentUserId);
    if (mounted) {
      setState(() {
        _activities = activities;
        hasUnreadNotifications = true;

        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        Home(
          currentUserId: widget.currentUserId,
        ),
        
        Notifications(
          currentUserId: widget.currentUserId,
          onNotificationRead: () {
            setState(() {
              hasUnreadNotifications = false;
            });
          },
        ),
        UserList(currentUserId: widget.currentUserId,),
        // GeminiChat(
        //   currentUserId: widget.currentUserId,
        // ),
        ProfileP(
          currentUserId: widget.currentUserId,
          visitedUserId: widget.currentUserId,
        ),
      ].elementAt(_selectedTab),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
          // If index is 2 (Notifications), set hasUnreadNotifications to false
          if (index == 2) {
            setState(() {
              hasUnreadNotifications = false;
            });
          }
        },
        activeColor: ThemeMain,
        inactiveColor: Colors.grey,
        backgroundColor: ThemeMainBG,
        currentIndex: _selectedTab,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                if (hasUnreadNotifications) // Show green dot if there are unread notifications
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: ThemeMain,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.chat)),
          const BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
