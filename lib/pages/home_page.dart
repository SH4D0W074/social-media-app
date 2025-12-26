import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/my_drawer.dart';
import 'package:socialmediaapp/components/my_list_tile.dart';
import 'package:socialmediaapp/components/my_post_button.dart';
import 'package:socialmediaapp/components/my_textfield.dart';
import 'package:socialmediaapp/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // firestore access 
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: appBar(context),

      drawer: MyDrawer(),
      body: Column(
        children: [
          // Textfield box for user to type
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                // textfield
                Expanded(
                  child: MyTextfield(
                    hintText: "Say Something",  
                    obscureText: false, 
                    controller: newPostController),
                ),
              
              
              // post button
                MyPostButton(
                  onTap: postMessage,
                ),
              ],

            ),
          ),

          // POSTS
          StreamBuilder(
            stream: database.getPostsStream(), 
            builder: (context, snapshot) {
              // show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              // get all posts
              final posts = snapshot.data!.docs;

              // no data?
              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No Posts.. Post something!"),
                  ),
                );
              }

              // return as a list
              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // get each individual post
                    final post = posts[index];

                    // get data from each post
                    String message = post['PostMessage'];
                    String UserEmail = post['UserEmail'];
                    Timestamp timestamp = post['TimeStamp'];

                    // return as a list tile
                    return MyListTile(title: message, subTitle: UserEmail);

                  },
                )
              );
            }, 
          )

        ],
      )
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text("W A L L"),
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      elevation: 0,
    );
  }
}