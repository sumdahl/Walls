import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_walls/components/text_field.dart';
import 'package:the_walls/components/wall_post.dart';
import 'package:the_walls/helper/helper_methods.dart';
import 'package:the_walls/pages/profile_page.dart';

import '../components/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  final textContoller = TextEditingController();

  //post message method
  void postMessage() {
    //only post if there is something in the textfield
    if (textContoller.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add(
        {
          'UserEmail': currentUser.email,
          'Message': textContoller.text,
          'TimeStamp': Timestamp.now(),
          'Likes': [],
        },
      );
    }

    //clear the textfield

    setState(() {
      textContoller.clear();
    });
  }

//signout the current user
  void signOutUser() {
    FirebaseAuth.instance.signOut();
  }

//navigate to profile page

  void goToProfilePage() {
    //pop the menu drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("The Walls"),
        centerTitle: true,
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOutUser,
      ),
      body: Center(
        child: Column(
          children: [
            //the walls
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy(
                      "TimeStamp",
                      descending: false,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        //get message
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                          likes: List<String>.from(
                            post['Likes'] ?? [],
                          ),
                          time: formatDate(post['TimeStamp']),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            //post message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  //textfield
                  Expanded(
                    child: MyTextField(
                      controller: textContoller,
                      hintText: "Write something on the wall...",
                      obscureText: false,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(4)),
                    child: IconButton(
                      onPressed: postMessage,
                      icon: const Icon(Icons.arrow_circle_up),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            //logged in user
            Text(
              "Logged in as: ${currentUser.email!}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
