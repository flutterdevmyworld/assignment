import 'package:assignment/constants/constants.dart';
import 'package:assignment/screens/home.dart';
import 'package:assignment/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailVerificationPage extends StatefulWidget {
  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: w,
          height: h,
          child: Stack(
              children: [
                SizedBox(
                  height: h,
                  width: w,
                  child: Image.asset("assets/4i.png",fit: BoxFit.cover),
                ),
                Container(
                  color: Colors.black.withOpacity(0.68),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(CupertinoIcons.checkmark_seal, color: Colors.white, size: 180,),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Verify Your Account", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
                            Text("We send an email verification link on your email, please verify that", style: TextStyle(color: Colors.white),),
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: ()async{
                                await FirebaseAuth.instance.currentUser!.reload();
                                if(FirebaseAuth.instance.currentUser!.emailVerified){
                                  final pref = await SharedPreferences.getInstance();
                                  pref.setBool("vPending", false);
                                  Get.offAll(()=> const HomeScreen(),);
                                }else{
                                  Fluttertoast.showToast(msg: "Verification is pending");
                                }
                              },
                              child: Container(
                                height: 50,
                                width: w,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: YGradients,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: Colors.white,width: 0.3)
                                ),
                                child: const Center(child: Text("Refresh",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600))),
                              ),
                            ),
                            const SizedBox(height: 16,),
                            SizedBox(
                              height: 50,
                              child: MaterialButton(
                                minWidth: Size.infinite.width,
                                elevation: 8,
                                padding: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: const BorderSide(
                                        color: Colors.red,
                                        width: 1
                                    )
                                ),
                                onPressed: ()async{
                                  FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value){
                                    Fluttertoast.showToast(msg: "We have resent email verification link on your email, please verify that.");
                                  });
                                },
                                color: Colors.white.withOpacity(0.5),
                                child: const Text("Resend Link",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18),),
                              ),
                            ),
                            const SizedBox(height: 16.0,),
                            Center(
                              child: InkWell(
                                onTap: () async{
                                  final pref = await SharedPreferences.getInstance();
                                  await pref.clear();
                                  await FirebaseAuth.instance.signOut();
                                  Get.offAll(()=> LoginPage());
                                },
                                child: Text("Change Email", style: TextStyle(color: theamClr, fontSize: 16, fontWeight: FontWeight.w600)),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                loading ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: h,
                      width: w,
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                ) : Container(),
              ]
          ),
        )
    );
  }
}

