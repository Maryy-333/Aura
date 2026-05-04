// ignore_for_file: strict_top_level_inference, use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_social_app/components/comment_button.dart';
import 'package:minimal_social_app/components/comments.dart';
import 'package:minimal_social_app/components/delete_button.dart';
import 'package:minimal_social_app/components/like_button.dart';
import 'package:minimal_social_app/helper/date_formatting.dart';

class MyListTile extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final String time;
  final List<String> likes;

  const MyListTile({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,

    required this.time,
  });

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;

  // text Controller
  final _commentTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser!.email);
  }

  // toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // access the document in the firestore
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.postId);

    if (isLiked) {
      // if the post is now liked add users email to the likes field
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser?.email]),
      });
    } else {
      // if the post is now unliked,remove the user email fro the likes field
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser?.email]),
      });
    }
  }

  // add a comment
  void addComment(String commentText) {
    // write the comment to firestore under the comment collection for this post
    FirebaseFirestore.instance
        .collection("Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
          "CommentText": commentText,
          "CommentedBy": currentUser?.email,
          "CommentTime": Timestamp.now(),
        });
  }

  // show a dialogue box for adding Controller
  void showCommentDialogue() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(hintText: "Write a Comment"),
        ),
        actions: [
          // post button
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);

              // pop the box
              Navigator.pop(context);

              // clear the controller
              _commentTextController.clear();
            },
            child: Text("Post"),
          ),

          // cancel button
          TextButton(
            onPressed: () {
              // pop the dailogue box
              Navigator.pop(context);

              //  clear the controller
              _commentTextController.clear();
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // delete post method
  void deletePost() {
    // show a dialogue box asking for confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Post"),
        content: Text("Are you sure you want to delete the post?"),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),

          // delete button
          TextButton(
            onPressed: () async {
              // delete the comments from firestore first
              final commentDocs = await FirebaseFirestore.instance
                  .collection("Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .get();

              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                    .collection("Posts")
                    .doc(widget.postId)
                    .collection('Comments')
                    .doc(doc.id)
                    .delete();
              }
              // then delete the post
              FirebaseFirestore.instance
                  .collection("Posts")
                  .doc(widget.postId)
                  .delete()
                  .then((value) => print("Post deleted"))
                  .catchError(
                    (error) => print("Failed to delete post: $error"),
                  );
              //dismiss the dialogue
              Navigator.pop(context);
            },

            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const SizedBox(height: 5),
            ListTile(
              // message
              title: SizedBox(
                width: 150,
                child: Text(
                  widget.message,
                  style: GoogleFonts.urbanist(
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              //  user email + time
              subtitle: Row(
                children: [
                  Text(
                    widget.user,
                    style: TextStyle(
                      color: Color(0xFF285A48),
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    " + ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.time,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              leading: Column(
                children: [
                  // like button
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
                  const SizedBox(height: 5),

                  // like count
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              trailing: Container(
                // color: Colors.amber,
                width: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        // comment button
                        CommentButton(onTap: showCommentDialogue),
                        const SizedBox(height: 5),

                        // coment count
                        Text("", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(width: 5),
                    if (widget.user == currentUser?.email)
                      DeleteButton(onTap: deletePost),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // comments under the post
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .orderBy("CommentTime", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // show loading circle if no data yet
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    // get the comment
                    final commentData = doc.data() as Map<String, dynamic>;
                    // return the comment
                    return Comment(
                      text: commentData["CommentText"],
                      user: commentData["CommentedBy"],
                      time: formatDate(commentData["CommentTime"]),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
