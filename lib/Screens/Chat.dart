// ignore_for_file: file_names, library_private_types_in_public_api, body_might_complete_normally_catch_error, prefer_if_null_operators

import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:echonest/Constants/Constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:echonest/Models/UserModel.dart'; // Import UserModel
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GeminiChat extends StatefulWidget {
  final String currentUserId;

  const GeminiChat({super.key, required this.currentUserId});

  @override
  _GeminiChatState createState() => _GeminiChatState();
}

class _GeminiChatState extends State<GeminiChat> {
  ChatUser user = ChatUser(
    id: '1',
    firstName: 'Me',
  );

  ChatUser bot = ChatUser(
    id: '2',
    firstName: 'Gemini',
  );

  List<ChatMessage> messages = <ChatMessage>[];
  List<ChatUser> typing = [];

  final url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyAe0LBPLVCeR46aTvD-ipuOhl0C3pN4Lvo";
  final header = {"Content-Type": "application/json"};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Image.asset(
          'assets/iw.png',
          height: 40,
        ),
        backgroundColor: ThemeMainBG,
      ),
      body: DashChat(
        typingUsers: typing,
        currentUser: user,
        inputOptions: const InputOptions(
          cursorStyle: CursorStyle(color: ThemeMain),
          inputTextStyle: TextStyle(color: ThemeMainBG),
        ),
        onSend: (ChatMessage m) async {
          setState(() {
            messages.insert(0, m);
          });
          typing.add(bot);
          final con = {
            "contents": [
              {
                "parts": [
                  {"text": m.text}
                ]
              }
            ]
          };

          try {
            final response = await http.post(
              Uri.parse(url),
              headers: header,
              body: jsonEncode(con),
            );

            if (response.statusCode == 200) {
              var r = jsonDecode(response.body);
              ChatMessage m1 = ChatMessage(
                text: r['candidates'][0]['content']['parts'][0]['text'],
                user: bot,
                createdAt: DateTime.now(),
              );
              messages.insert(0, m1);
            } else {
              ChatMessage m1 = ChatMessage(
                text: "Sorry, I can't help you!",
                user: bot,
                createdAt: DateTime.now(),
              );
              messages.insert(0, m1);
            }
          } catch (e) {
            // Handle error
          }

          typing.remove(bot);
          setState(() {});
        },
        messages: messages,
      ),
    );
  }}

class UserList extends StatelessWidget {
  final String currentUserId;

  const UserList({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: ThemeMainBG,
        title: Image.asset(
          'assets/iw.png',
          height: 40,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator( valueColor: AlwaysStoppedAnimation(ThemeMain),);
          }

          // Create a list to hold list items
          List<Widget> listItems = [];

          // Add "My AI" list item
          listItems.add(
            ListTile(
              leading: const CircleAvatar(
                radius: 20,
                backgroundColor: ThemeMainBG,
                backgroundImage: AssetImage('assets/iw.png'),
              ),
              title: const Text(
                'My AI',
                style: TextStyle(
                  color: ThemeMain,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GeminiChat(currentUserId: currentUserId),
                  ),
                );
              },
            ),
          );

          // Add user list items
          listItems.addAll(
            snapshot.data!.docs.map<Widget>((DocumentSnapshot document) {
              UserModel user = UserModel.fromDoc(document);
               if (user.id == '1' || user.id == currentUserId) {
      return Container(); // Exclude the AI and current user from the list
    }
                  
                
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  if (user.id != currentUserId){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoom(currentUserId: currentUserId, selectedUserId: user.id),
                    ),
                  );}
                },
              );
            }).toList(),
          );

          // Build the ListView with the prepared list items
          return ListView(
            children: listItems,
          );
        },
      ),
    );
  }
}

class ChatRoom extends StatefulWidget {
  final String currentUserId;
  final String selectedUserId;

  const ChatRoom({super.key, required this.currentUserId, required this.selectedUserId});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}class _ChatRoomState extends State<ChatRoom> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ChatUser> typingUsers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
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
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection("users").doc(widget.selectedUserId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator( valueColor: AlwaysStoppedAnimation(ThemeMain),);
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Container(); // Return empty container if document doesn't exist
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final String userName = userData['name'] ?? '';
            return Text(userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
          },
        ),
        centerTitle: true,
        backgroundColor: ThemeMainBG,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chatroom')
            .doc(getChatRoomId())
            .collection('chats')
            .orderBy("time", descending: true) // Sort messages in descending order
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final List<ChatMessage> messages = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;

              return ChatMessage(
                text: data['message'],
                user: ChatUser(id: data['sendby'],),
                createdAt: (data['time'] as Timestamp).toDate(),
              );
            }).toList();

            return  DashChat(
              currentUser:ChatUser(
  id: widget.currentUserId,
),

              onSend: _onSendMessage,
              messages: messages,
              typingUsers: typingUsers,
              inputOptions: const InputOptions(
                cursorStyle: CursorStyle(color: ThemeMain),
                inputTextStyle: TextStyle(color: ThemeMainBG),
              ),
              messageListOptions: MessageListOptions(
                showDateSeparator: true, // Show date separators
                separatorFrequency: SeparatorFrequency.days, // Show date separator for each day
                dateSeparatorBuilder: (DateTime date) {
                  // Customize the appearance of the date separator
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      DateFormat('dd MMM yyyy').format(date), // Format the date
                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            );

          } else {
            return const Center(child: CircularProgressIndicator( valueColor: AlwaysStoppedAnimation(ThemeMain),));
          }
        },
      ),
    );
  }

  Future<void> _onSendMessage(ChatMessage message) async {
    final messageData = {
      "sendby": widget.currentUserId,
      "message": message.text,
      "type": "text",
      "time": Timestamp.now(),
    };

    await _firestore.collection('chatroom').doc(getChatRoomId()).collection('chats').add(messageData);
  }

  String getChatRoomId() {
    final List<String> userIds = [widget.currentUserId, widget.selectedUserId];
    userIds.sort();
    return userIds.join("_");
  }
}
