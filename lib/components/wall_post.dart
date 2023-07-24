import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_walls/components/like_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  //user from firebase

  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  //toggle like

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //Access the dociment is Firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      //if the post is liked, then add the user's email to the 'Likes'
      postRef.update(
        {
          'Likes': FieldValue.arrayUnion([currentUser.email])
        },
      );
      return;
    }
    postRef.update(
      {
        'Likes': FieldValue.arrayRemove([currentUser.email])
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Column(
            children: [
              //profile pic

              //like button
              LikeButton(
                isLiked: isLiked,
                onTap: toggleLike,
              ),
              const SizedBox(
                height: 5.0,
              ),
              //like count
              Text(
                widget.likes.length.toString(),
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(
            width: 12.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(widget.message),
            ],
          )
        ],
      ),
    );
  }
}
