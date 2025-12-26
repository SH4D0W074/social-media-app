import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/my_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // logout user
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),

      drawer: MyDrawer(),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text("Home Page"),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      elevation: 0,
      actions: [
        
      ]
    );
  }
}