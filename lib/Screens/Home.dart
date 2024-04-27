// ignore_for_file: file_names, library_private_types_in_public_api, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echonest/Screens/Profile.dart';
import 'package:flutter/material.dart';
import 'package:echonest/Constants/Constants.dart';
import 'package:echonest/Models/Echo.dart';
import 'package:echonest/Models/UserModel.dart';
import 'package:echonest/Screens/NewEcho.dart';
import 'package:echonest/Services/DB.dart';
import 'package:echonest/Component/EchoView.dart';

class Home extends StatefulWidget {
  final String currentUserId;

  const Home({super.key, required this.currentUserId});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _followingEchos = [];
  bool _loading = false;
   Future<QuerySnapshot>? _users;
  final TextEditingController _searchController = TextEditingController();

  clearSearch() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users = null;
    });
  }

  buildUserTile(UserModel user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: user.profilePicture.isNotEmpty
            ? NetworkImage(user.profilePicture)
            : const AssetImage('assets/placeholder.png') as ImageProvider<Object>?,
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          color: Colors.white, // Set the text color to white
          fontWeight: FontWeight.bold, // Add any additional styling as needed
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfileP(
              currentUserId: widget.currentUserId,
              visitedUserId: user.id,
            ),
          ),
        );
      },
    );
  }


  buildEchos(Echo echo1, UserModel author) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProfileP(
            currentUserId: widget.currentUserId,
            visitedUserId: author.id,
          ),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: EchoView(
        Echo_1: echo1,
        author: author,
        currentUserId: widget.currentUserId,
      ),
    ),
  );
}


  showFollowingEchos(String currentUserId) {
    List<Widget> followingEchosList = [];
    for (Echo Echo_1 in _followingEchos) {
      followingEchosList.add(FutureBuilder(
          future: usersRef.doc(Echo_1.authorId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              UserModel author = UserModel.fromDoc(snapshot.data);
              return buildEchos(Echo_1, author);
            } else {
              return const SizedBox.shrink();
            }
          }));
    }
    return followingEchosList;
  }

  setupFollowingEchos() async {
    setState(() {
      _loading = true;
    });
    List followingEchos =
        await DatabaseServices.getHomeEchoes();
    // Sort echoes based on the number of likes
    followingEchos.sort((a, b) => b.likes.compareTo(a.likes));
    if (mounted) {
      setState(() {
        _followingEchos = followingEchos;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupFollowingEchos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeMainBG,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeMain,
        child: const Icon(Icons.record_voice_over, color: ThemeMainBG),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewEcho(
                currentUserId: widget.currentUserId,
                key: null,
              ),
            ),
          );
        },
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true, // Center the title
        title: Image.asset(
          'assets/iw.png', // Replace with the actual path to your logo image in the assets
          height: 40, // Adjust the height as needed
        ),
        backgroundColor: ThemeMainBG,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: ThemeMain),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: ThemeMain),
                ),
                filled: true,
                fillColor: Colors.grey[800],
                hintText: 'Search Users...',
                hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    clearSearch();
                  },
                ),
              ),
              onChanged: (input) {
                if (input.isNotEmpty) {
                  setState(() {
                    _users = DatabaseServices.searchUsers(input);
                  });
                } else {
                  setState(() {
                    _users = null;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: _users == null
                ? RefreshIndicator(
                  color:ThemeMain,

        onRefresh: () => setupFollowingEchos(),
        child: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            
            _loading
                ? const LinearProgressIndicator( valueColor: AlwaysStoppedAnimation(ThemeMain),)
                : const SizedBox.shrink(),
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                            
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                    child:Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: ThemeMain,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                    'Trending Echoes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: ThemeMain,
                        ),
                      ),
                    ],
                  ),),
                ),
                const SizedBox(height: 10),
                Column(
                  children: _followingEchos.isEmpty && _loading == false
                      ? [
                          const SizedBox(height: 5),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              'There is No New Echoes',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          )
                        ]
                      : showFollowingEchos(widget.currentUserId),
                ),
              ],
            )
          ],
        ),
      )
                : FutureBuilder(
                    future: _users,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator( valueColor: AlwaysStoppedAnimation(ThemeMain),),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(
                          child: Text('No users found!'),
                        );
                      }

                      final users = snapshot.data!.docs;

                      if (users.isEmpty) {
                        return const Center(
                          child: Text('No users found!'),
                        );
                      }

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (BuildContext context, int index) {
                          UserModel user = UserModel.fromDoc(users[index]);
                          return buildUserTile(user);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
