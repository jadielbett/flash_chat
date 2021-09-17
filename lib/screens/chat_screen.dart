// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

CollectionReference messages =
    FirebaseFirestore.instance.collection('messages');

User? loggedInUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static String id = '/chatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final fieldText = TextEditingController();

  String userText = '';
  String? userEmail;

  @override
  void initState() {
    super.initState();
    //gets the user's details immediately they enter the chat screen
    loggedInUser = _auth.currentUser!;
    userEmail = loggedInUser?.email.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Center(
          child: Hero(
            tag: 'logo',
            child: Text(
              '⚡',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
        title: const Center(child: Text('Flash Chat')),
        backgroundColor: Colors.purple,
        actions: [
          PopupMenuButton(itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: TextButton(
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    // signs out the user and takes them to the login screen
                    // _auth.signOut();
                    Navigator.popAndPushNamed(context, LoginScreen.id);
                  },
                ),
              )
            ];
          })
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextStream(),
              TextField(
                  controller: fieldText,
                  maxLines: null,
                  cursorColor: Colors.purpleAccent,
                  decoration: InputDecoration(
                    hintText: 'Type your message here...',
                    prefixIcon:
                        const Icon(Icons.emoji_emotions, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.grey,
                      onPressed: () {
                        // checks if the user has typed something before sending the user's message and
                        //email to the firebase database, then clears the textfield
                        if (fieldText.text.isNotEmpty) {
                          messages.add({
                            'sender': userEmail,
                            'text': userText,
                            'createdAt': Timestamp.now()
                          });
                          fieldText.clear();
                        }
                      },
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 0)),
                  ),
                  onChanged: (value) {
                    userText = value;
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

//The TextStream class is responsible for building the listview of messageBubbles seen
class TextStream extends StatelessWidget {
  const TextStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('createdAt').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final texts = snapshot.data?.docs.reversed;
        List<TextBubble> messageBubbles = [];
        if (texts != null) {
          for (var text in texts) {
            final textMessage = text.get('text');
            final textSender = text.get('sender');
            final isMe = textSender == loggedInUser?.email;

            final messageBubble = TextBubble(textSender, textMessage, isMe);

            messageBubbles.add(messageBubble);
          }
        }
        return Expanded(
          child: ListView(
            reverse: true,
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

//This class creates a beautiful bubble in which the user's text and email are displayed
class TextBubble extends StatelessWidget {
  const TextBubble(this.sender, this.text, this.isMe);

  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              sender,
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          Material(
              elevation: 5.0,
              borderRadius: (isMe)
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))
                  : const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
              color: isMe ? Colors.purple : Colors.black54,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
