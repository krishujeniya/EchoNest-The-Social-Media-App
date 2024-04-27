// ignore_for_file: file_names, library_private_types_in_public_api, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:echonest/Constants/Constants.dart';
import 'package:echonest/Models/Echo.dart';
import 'package:echonest/Models/UserModel.dart';
import 'package:echonest/Services/DB.dart';

class EchoView extends StatefulWidget {
  final Echo Echo_1;
  final UserModel author;
  final String currentUserId;

  const EchoView(
      {super.key,
      required this.Echo_1,
      required this.author,
      required this.currentUserId});
  @override
  _EchoContainerState createState() => _EchoContainerState();
}

class _EchoContainerState extends State<EchoView> {
  int _likesCount = 0;
  bool _isLiked = false;

  initEchoLikes() async {
    bool isLiked =
        await DatabaseServices.isLikeEcho(widget.currentUserId, widget.Echo_1);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  likeEcho() {
    if (_isLiked) {
      DatabaseServices.unlikeEcho(widget.currentUserId, widget.Echo_1);
      setState(() {
        _isLiked = false;
        _likesCount--;
      });
    } else {
      DatabaseServices.likeEcho(widget.currentUserId, widget.Echo_1);
      setState(() {
        _isLiked = true;
        _likesCount++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _likesCount = widget.Echo_1.likes;
    initEchoLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.author.profilePicture.isEmpty
                    ? const AssetImage('assets/placeholder.png')
                    : NetworkImage(widget.author.profilePicture)
                        as ImageProvider<Object>?,
              ),
              const SizedBox(width: 10),
              Text(
                widget.author.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            widget.Echo_1.text,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          widget.Echo_1.image.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    const SizedBox(height: 15),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                          color: ThemeMain,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.Echo_1.image),
                          )),
                    )
                  ],
                ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.green : Colors.grey,
                    ),
                    onPressed: likeEcho,
                  ),
                  Text(
                    '$_likesCount Likes',
                  ),
                ],
              ),
              Text(
                widget.Echo_1.timestamp.toDate().toString().substring(0, 19),
                style: const TextStyle(color: Colors.grey),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Divider()
        ],
      ),
    );
  }
}
