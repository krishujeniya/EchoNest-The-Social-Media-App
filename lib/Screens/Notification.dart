// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:echonest/Constants/Constants.dart';
import 'package:echonest/Models/Activity.dart';
import 'package:echonest/Models/UserModel.dart';
import 'package:echonest/Services/DB.dart';

class Notifications extends StatefulWidget {
  final String currentUserId;

  const Notifications({super.key, required this.currentUserId, required Null Function() onNotificationRead});
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Activity> _activities = [];

  setupActivities() async {
    List<Activity> activities =
        await DatabaseServices.getActivities(widget.currentUserId);
    if (mounted) {
      setState(() {
        _activities = activities;
      });
    }
  }

  buildActivity(Activity activity) {
    return FutureBuilder(
        future: usersRef.doc(activity.fromUserId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          } else {
            UserModel user = UserModel.fromDoc(snapshot.data);
            return Column(
              children: [
                ListTile(
  leading: CircleAvatar(
    radius: 20,
    backgroundImage: user.profilePicture.isEmpty
        ? const AssetImage('assets/placeholder.png')
        : NetworkImage(user.profilePicture) as ImageProvider<Object>?,
  ),
title: Text(
  activity.follow ? '${user.name} follows you' : '${user.name} liked your Echo',
  style: const TextStyle(
    color: Colors.white, // Set the text color to white
  ),
),

),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    color: ThemeMain,
                    thickness: 1,
                  ),
                )
              ],
            );
          }
        });
  }

  @override
  void initState() {
    super.initState();
    setupActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: false,
centerTitle: true, // Center the title
          title: Image.asset(
            'assets/iw.png', // Replace with the actual path to your logo image in the assets
            height: 40, // Adjust the height as needed
          ),        backgroundColor: ThemeMainBG,
      ),
        body: RefreshIndicator(
                            color:ThemeMain,

          onRefresh: () => setupActivities(),
          child: ListView.builder(
              itemCount: _activities.length,
              itemBuilder: (BuildContext context, int index) {
                Activity activity = _activities[index];
                return buildActivity(activity);
              }),
        ));
  }
}
