import 'package:assignment/screens/home.dart';
import 'package:assignment/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  //Handles Auth
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          else {
            return LoginPage();
          }
        });
  }


  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn.games().signOut();
    GoogleSignIn _googleSignIn = GoogleSignIn();
    _googleSignIn.signOut();
    _googleSignIn.disconnect();
  }

  //SignIn
  signIn(AuthCredential authCreds,context, phoneNo) async{
    try{
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User? user = (await _auth.signInWithCredential(authCreds)).user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('google', false);
      Get.off(()=> const HomeScreen());
    }
    catch(e){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning,color: Colors.red,),
                Text("  Error",style: TextStyle(color: Colors.red),),
              ],
            ),
            content: Text(e.toString().replaceAll("firebase_auth/", "")),
            actions: [
              MaterialButton(onPressed: (){Navigator.pop(context);}, child: Text("OK"))
            ],
          );
        },
      );
    }
  }

  signInWithOTP(smsCode, verId,context,phoneNo) {
    AuthCredential authCreds = PhoneAuthProvider.credential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds,context,phoneNo);
  }
}

