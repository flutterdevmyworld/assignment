import 'package:assignment/app_states/states.dart';
import 'package:assignment/screens/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assignment"),
        actions: [
          IconButton(
            onPressed: () async{
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn.games().signOut();
              final pref = await SharedPreferences.getInstance();
              pref.clear();
              Get.offAll(()=> const SplashScreen());
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/home.png"),
            const Text("Home, Welcome to my assignment !!"),
          ],
        ),
      ),
    );
  }
}
