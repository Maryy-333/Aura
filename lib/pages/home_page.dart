// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_social_app/components/my_drawer.dart';
import 'package:minimal_social_app/components/my_list_tile.dart';
import 'package:minimal_social_app/components/my_post_button.dart';
import 'package:minimal_social_app/components/my_textfield.dart';
import 'package:minimal_social_app/database/firestore.dart';
import 'package:minimal_social_app/helper/date_formatting.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // firestore acces
  final FirestoreDatabase database = FirestoreDatabase();

  // text controller
  final TextEditingController newPostController = TextEditingController();

  // post message
  void postMessage() {
    // only post message if there is something in the textfield
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }

    // clear the controller
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text("W H I S P E R S", style: GoogleFonts.urbanist()),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          // textfeild for users to type
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                // textfield
                Expanded(
                  child: MyTextfield(
                    hintText: "Say something...",
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),

                // post button
                MyPostButton(onTap: postMessage),
              ],
            ),
          ),

          // POSTS
          StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, snapshot) {
              //  show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // get all posts
              final posts = snapshot.data!.docs;

              // no data?
              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No Posts.. Post something"),
                  ),
                );
              }
              // return a list
              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // get each individual post
                    final post = posts[index];
                    // get data drom each post
                    String message = post['PostMessage'];
                    String userEmail = post['UserEmail'];
                    String time = formatDate(post['Timestamp']);

                    // return as a list title
                    return MyListTile(
                      message: message,
                      user: userEmail,
                      postId: post.id,
                      likes: List<String>.from(post["Likes"] ?? []),
                      time: time,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
