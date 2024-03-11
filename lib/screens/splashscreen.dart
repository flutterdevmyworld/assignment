import 'dart:async';

import 'package:assignment/screens/email_verification.dart';
import 'package:assignment/services/auth_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(const Duration(milliseconds: 1300), () async{
      final pref = await SharedPreferences.getInstance();
      bool? vPending = pref.getBool("vPending");
      if(vPending==true){
        Get.offAll(() => EmailVerificationPage());
      }else{
        Get.offAll(()=> AuthStatus());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png", width: 100,),
            const SizedBox(height: 30,),
            const Text("Welcome to my assignment", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.red,), textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}
