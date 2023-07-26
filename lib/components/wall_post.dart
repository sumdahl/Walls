import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_walls/components/comment_button.dart';
import 'package:the_walls/components/comments.dart';
import 'package:the_walls/components/like_button.dart';
import 'package:the_walls/helper/helper_methods.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  //user from firebase

  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  final _commentTextController = TextEditingController();

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

  //add a comment
  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add(
      {
        "CommentText": commentText,
        "CommentedBy": currentUser.email,
        "CommentTime": Timestamp.now(), //format later
      },
    );
  }

  //show a dialog box for adding comment
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(hintText: "Write a comment..."),
        ),
        actions: [
          //cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              //cleart the controller
              _commentTextController.clear();
            },
            child: const Text("Cancel"),
          ),
          //save button
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              Navigator.pop(context);

              //clear the comment controller
              _commentTextController.clear();
            },
            child: const Text("Post"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //wallpost
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.message),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
                  Text(
                    widget.user,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    " • ",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    widget.time,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //like
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
                children: [
                  //profile pic
                  //like button
                  CommentButton(
                    onTap: () => showCommentDialog(),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  //like count
                  Text(
                    '0',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          //comments under the post

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              //show loading circle
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap:
                    true, //for nested lists to get better scrolling view
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  //get the comment from firebase
                  final commentData = doc.data() as Map<String, dynamic>;

                  //return the comment

                  return Comment(
                    text: commentData["CommentText"],
                    user: commentData["CommentedBy"],
                    time: formatDate(commentData["CommentTime"]),
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
