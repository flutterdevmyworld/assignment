import 'package:assignment/constants/constants.dart';
import 'package:assignment/screens/email_verification.dart';
import 'package:assignment/screens/home.dart';
import 'package:assignment/services/auth_service.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _pinCotroller = TextEditingController();
  String _countryName = "India";
  String _countryCode = "+91";
  String? phoneNo="", verificationId, smsCode;
  String emailId="", password="", confirmPassword="";
  bool passwordShow = false;
  bool confirmPasswordShow = false;
  bool codeSent = false;
  bool loading = false;

  ConfirmationResult? confirmationResult;
  UserCredential? userCredential;
  FirebaseAuth auth = FirebaseAuth.instance;

  bool loginWithEmail = false;
  bool loginWithEmailForSignIn = true;

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
                  child: Image.asset("assets/b1c.png",fit: BoxFit.cover),
                ),
                Container(
                  color: Colors.black.withOpacity(0.68),
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Center(
                      child: SizedBox(
                        width: w>600?500:w,
                        child: Card(
                          color: Colors.transparent,
                          margin: EdgeInsets.zero,
                          //margin: EdgeInsets.only(top: w>600?20:0),
                          elevation: w>600?10:0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SafeArea(child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: w>600?30:0),
                                      child: ShaderMask(
                                        child: Center(child: Image.asset("assets/logo.png",width: 100,color: Colors.white,),),
                                        shaderCallback: (Rect bounds){
                                          return const LinearGradient(
                                            colors: YGradients,
                                          ).createShader(bounds);
                                        },
                                      ),
                                    )),
                                    const SizedBox(height: 50,),
                                    loginWithEmail ? Column(
                                      children: [
                                        SizedBox(
                                          height: 43,
                                          width: w,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      loginWithEmailForSignIn = true;
                                                    });
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.white, width: 1),
                                                          borderRadius: BorderRadius.circular(5),
                                                          gradient: loginWithEmailForSignIn ? const LinearGradient(
                                                              colors: YGradients
                                                          ) : null
                                                      ),
                                                      padding: const EdgeInsets.all(6),
                                                      child: const Center(
                                                        child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                                                      )
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12,),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      loginWithEmailForSignIn = false;
                                                    });
                                                  },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.white, width: 1),
                                                          borderRadius: BorderRadius.circular(5),
                                                          gradient: !loginWithEmailForSignIn ? const LinearGradient(
                                                              colors: YGradients
                                                          ) : null
                                                      ),
                                                      padding: const EdgeInsets.all(6),
                                                      child: const Center(
                                                        child: Text("Register", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 15,),
                                        SizedBox(
                                          height: 60,
                                          child: TextFormField(
                                            style: const TextStyle(color: Colors.white),
                                            keyboardType: TextInputType.emailAddress,
                                            onChanged: (v){
                                              setState(() {
                                                emailId = v;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                hintText: "Your Email",
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: const BorderSide(color: Colors.white,style: BorderStyle.solid,),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: const BorderSide(color: Colors.white,style: BorderStyle.solid,),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: const BorderSide(color: Colors.white,style: BorderStyle.solid,),
                                                ),
                                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                                                prefixIcon: const Icon(CupertinoIcons.mail, color: Colors.white,),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: const BorderSide(color: Colors.white,style: BorderStyle.solid,),
                                                )
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15,),
                                        SizedBox(
                                          height: 60,
                                          child: TextFormField(
                                            style: const TextStyle(color: Colors.white),
                                            keyboardType: TextInputType.text,
                                            onChanged: (v){
                                              setState(() {
                                                password = v;
                                              });
                                            },
                                            obscureText: !passwordShow,
                                            decoration: InputDecoration(
                                                hintText: "Your Password",
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: const BorderSide(color: Colors.white,style: BorderStyle.solid,),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: const BorderSide(color: Colors.white,style: BorderStyle.solid,),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: const BorderSide(color: Colors.white,style: BorderStyle.solid,),
                                                ),
                                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                                                prefixIcon: const Icon(CupertinoIcons.padlock, color: Colors.white,),
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      passwordShow = !passwordShow;
                                                    });
                                                  },
                                                  icon: Icon(passwordShow ? CupertinoIcons.eye : CupertinoIcons.eye_slash, color: Colors.white,),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: const BorderSide(color: Colors.white,style: BorderStyle.solid,),
                                                )
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15,),
                                        loginWithEmailForSignIn ? Container() : SizedBox(
                                          height: 60,
                                          child: TextFormField(
                                            style: const TextStyle(color: Colors.white),
                                            keyboardType: TextInputType.text,
                                            onChanged: (v){
                                              setState(() {
                                                confirmPassword = v;
                                              });
                                            },
                                            obscureText: !confirmPasswordShow,
                                            decoration: InputDecoration(
                                                hintText: "Confirm Password",
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: const BorderSide(color: Colors.white,style: BorderStyle.solid,),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: const BorderSide(color: Colors.white,style: BorderStyle.solid,),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: const BorderSide(color: Colors.white,style: BorderStyle.solid,),
                                                ),
                                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                                                prefixIcon: const Icon(CupertinoIcons.padlock, color: Colors.white,),
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      confirmPasswordShow = !confirmPasswordShow;
                                                    });
                                                  },
                                                  icon: Icon(confirmPasswordShow ? CupertinoIcons.eye : CupertinoIcons.eye_slash, color: Colors.white,),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: const BorderSide(color: Colors.white,style: BorderStyle.solid,),
                                                )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ) : Column(
                                      children: [
                                        Container(
                                          width: w,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              border: Border.all(color: Colors.white)
                                          ),
                                          child: Row(
                                            children: [
                                              CountryCodePicker(
                                                onChanged: (value){
                                                  print(value.flagUri);
                                                  setState(() {
                                                    _countryName = value.name!;
                                                    _countryCode = value.dialCode!;
                                                  });
                                                },
                                                padding: const EdgeInsets.only(left: 8,right: 0),
                                                showDropDownButton: false,
                                                dialogSize: Size(w*0.9,h*0.7),
                                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                                initialSelection: 'IN',
                                                favorite: const ['+91','IN'],
                                                // optional. Shows only country name and flag
                                                showCountryOnly: false,
                                                // optional. Shows only country name and flag when popup is closed.
                                                showOnlyCountryWhenClosed: false,
                                                // optional. aligns the flag and the Text left
                                                alignLeft: false,
                                                dialogBackgroundColor: Theme.of(context).cardColor,
                                                textStyle: const TextStyle(fontSize: 0,color: Colors.white),
                                              ),
                                              Text(_countryName,style: TextStyle(color: Colors.white),)
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 15,),
                                        SizedBox(
                                          height: 60,
                                          child: TextFormField(
                                            style: const TextStyle(color: Colors.white),
                                            keyboardType: TextInputType.number,
                                            onChanged: (v){
                                              setState(() {
                                                phoneNo = v;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                hintText: "Phone Number",
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: const BorderSide(color: Colors.white,style: BorderStyle.solid,),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: const BorderSide(color: Colors.white,style: BorderStyle.solid,),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: const BorderSide(color: Colors.white,style: BorderStyle.solid,),
                                                ),
                                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                                                prefixIcon: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const SizedBox(width: 18,),
                                                    Text(_countryCode,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                    const SizedBox(width: 20,),
                                                  ],
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                  borderSide: BorderSide(color: Colors.white,style: BorderStyle.solid,),
                                                )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15,),
                                    InkWell(
                                      onTap: ()async{
                                        FocusScope.of(context).unfocus();
                                        if(loginWithEmail){
                                          authForEmail();
                                        }else{
                                          authForPhoneNumber();
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
                                        child: const Center(child: Text("Next",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600))),
                                      ),
                                    ),
                                    Visibility(
                                      visible: loginWithEmailForSignIn && loginWithEmail,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: InkWell(
                                              onTap: (){
                                                TextEditingController emailController = TextEditingController();
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) => Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        const Text("Forgot password?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                                        const SizedBox(height: 10,),
                                                        TextFormField(
                                                          controller: emailController,
                                                          decoration: InputDecoration(
                                                            prefixIcon: const Icon(Icons.email_outlined),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(30)
                                                            ),
                                                            contentPadding: EdgeInsets.zero,
                                                            hintText: "Enter your email"
                                                          ),
                                                        ),
                                                        const SizedBox(height: 10,),
                                                        InkWell(
                                                          onTap: ()async{
                                                            FocusScope.of(context).unfocus();
                                                            if(emailController.text.trim().isNotEmpty){
                                                              try{
                                                                FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim()).then((value){
                                                                  showDialogAlert("The link has been sent to the provided email");
                                                                  // Fluttertoast.showToast(msg: "Password rest email sent successfully");
                                                                });
                                                              }on FirebaseAuthException catch(e){
                                                                Fluttertoast.showToast(msg: e.code);
                                                              }
                                                            }else{
                                                              Fluttertoast.showToast(msg: "Please enter valid email");
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
                                                            child: const Center(child: Text("Next",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600))),
                                                          ),
                                                        ),
                                                        SizedBox(height: MediaQuery.viewInsetsOf(context).bottom,)
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Text("Forgot password?", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 50,
                                    //   child: MaterialButton(
                                    //     minWidth: Size.infinite.width,
                                    //     padding: const EdgeInsets.all(8),
                                    //     shape: RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.circular(30)
                                    //     ),
                                    //     onPressed: ()async{
                                    //       if(phoneNo!.isNotEmpty){
                                    //         if(kIsWeb){
                                    //           try{
                                    //             setState(() {
                                    //               loading = true;
                                    //             });
                                    //             confirmationResult = await auth.signInWithPhoneNumber("+91"+this.phoneNo!,RecaptchaVerifier(
                                    //               onSuccess: () => Toast.show("reCAPTCHA Completed!",duration: 3,gravity: 10),
                                    //               onError: (FirebaseAuthException error) => showDialog(
                                    //                 context: context,
                                    //                 builder: (context) => AlertDialog(
                                    //                   title: Text("Error",style: TextStyle(color: Colors.red),),
                                    //                   content: Text("Try Again"),
                                    //                   actions: [
                                    //                     MaterialButton(
                                    //                       child: Text("Ok"),
                                    //                       onPressed: (){
                                    //                         //print(error);
                                    //                         Navigator.pop(context);
                                    //                       },
                                    //                     )
                                    //                   ],
                                    //                 ),
                                    //               ),
                                    //               onExpired: () => Toast.show("reCAPTCHA Expired!",duration: 3,gravity: 10),
                                    //             )).whenComplete(() =>
                                    //                 setState(() {
                                    //                   codeSent = true;
                                    //                   loading = false;
                                    //                 }));
                                    //           }catch(e){
                                    //             setState(() {
                                    //               codeSent = false;
                                    //               loading = false;
                                    //             });
                                    //             print(e);
                                    //             showDialog(
                                    //               context: context,
                                    //               builder: (context) => AlertDialog(
                                    //                 title: Text("Error",style: TextStyle(color: Colors.red),),
                                    //                 content: Text(e.toString()),
                                    //                 actions: [
                                    //                   MaterialButton(
                                    //                     onPressed: (){
                                    //                       Navigator.pop(context);
                                    //                     },
                                    //                     child: Text("OK"),
                                    //                   )
                                    //                 ],
                                    //               ),
                                    //             );
                                    //           }
                                    //         }else{
                                    //           setState((){
                                    //             phoneNo = "+91" + phoneNo!;
                                    //             loading = true;
                                    //           });
                                    //           await verifyPhone(phoneNo,context);
                                    //         }
                                    //       }
                                    //       else{
                                    //         showCupertinoDialog(
                                    //           context: context,
                                    //           builder: (context) => CupertinoAlertDialog(
                                    //             title: const Text("Alert"),
                                    //             content: const Text("Please fill the Phone Number"),
                                    //             actions: [
                                    //               MaterialButton(
                                    //                 child: const Text("Ok"),
                                    //                 onPressed: (){
                                    //                   Navigator.pop(context);
                                    //                 },
                                    //               )
                                    //             ],
                                    //           ),
                                    //         );
                                    //       }
                                    //     },
                                    //     child: const Text("Next",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 15),),
                                    //     color: Colors.red,
                                    //   ),
                                    // ),
                                    const SizedBox(height: 15,),
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
                                          if(kIsWeb){
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.setBool('google', true);
                                            await signInWithGoogleWeb();
                                            Get.offAll(()=> const HomeScreen());
                                          }else{
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.setBool('google', true);
                                            await signInWithGoogleMobile();
                                            Get.offAll(()=> const HomeScreen());
                                          }
                                        },
                                        color: Colors.white.withOpacity(0.5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image.asset("assets/Google.png"),
                                            const Text("Login with Google",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18),),
                                            Opacity(opacity: 0.0, child: Image.asset("assets/Google.png")),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15,),
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
                                          setState(() {
                                            loginWithEmail = !loginWithEmail;
                                          });
                                        },
                                        color: Colors.white.withOpacity(0.5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(!loginWithEmail ? CupertinoIcons.mail : CupertinoIcons.phone, color: Colors.white, size: 30,),
                                            Text(!loginWithEmail ? "Login with Email" : "Login with Phone",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18),),
                                            Opacity(
                                              opacity: 0.0,
                                              child: Icon(!loginWithEmail ? CupertinoIcons.mail : CupertinoIcons.phone, color: Colors.white, size: 30,),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15,),
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        Text("By Signing up, I agree to",style: TextStyle(color: Colors.red,fontSize: 13),),
                                        InkWell(
                                          onTap: (){},
                                          child: Text(" Term ",style: TextStyle(color: Colors.blue,fontSize: 13),),
                                        ),
                                        Text("and ",style: TextStyle(color: Colors.red,fontSize: 13),),
                                        InkWell(
                                          onTap: (){},
                                          child: Text("Conditions, ",style: TextStyle(color: Colors.blue,fontSize: 13),),
                                        ),
                                        Text("Including usage of Cookies",style: TextStyle(color: Colors.red,fontSize: 13),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              codeSent ? Stack(
                                children: [
                                  Container(
                                    height: h,
                                    width: w,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                  Positioned(
                                    top: 100,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Container(
                                        width: w>600?500*0.85:w*0.85,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ShaderMask(
                                              child: Image.asset("assets/otp.png",width: 100,color: Colors.white),
                                              shaderCallback: (Rect bounds){
                                                return const LinearGradient(
                                                  colors: YGradients,
                                                ).createShader(bounds);
                                              },
                                            ),
                                            //Center(child: Image.asset("assets/otp.png",width: 100,)),
                                            const SizedBox(height: 15,),
                                            const Text("OTP Verification",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                            const SizedBox(height: 15,),
                                            PinCodeTextField(
                                              backgroundColor: Colors.transparent,
                                              appContext: context,
                                              keyboardType: TextInputType.number,
                                              length: 6,
                                              controller: _pinCotroller,
                                              obscureText: true,
                                              onChanged: (pinCode) {
                                                print(pinCode);
                                              },
                                              onCompleted: (v)async{
                                                if(kIsWeb){
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  userCredential = await confirmationResult!.confirm(_pinCotroller.text).onError((error, stackTrace){
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                    return errorFun();
                                                  });
                                                  Get.offAll(()=> const HomeScreen());
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                }else{
                                                  setState(() {
                                                    loading = true;
                                                    this.smsCode = _pinCotroller.text;
                                                  });
                                                  if(codeSent)
                                                  {
                                                    AuthService().signInWithOTP(smsCode, verificationId,context,phoneNo);
                                                  }
                                                  else{
                                                    verifyPhone(phoneNo,context);
                                                  }
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                }
                                              },
                                              pinTheme: PinTheme(
                                                  shape: PinCodeFieldShape.box,
                                                  borderRadius: BorderRadius.circular(5),
                                                  fieldHeight: 45,
                                                  fieldWidth: 35,
                                                  activeFillColor: Colors.orange
                                              ),
                                            ),
                                            Text("Verification code has been send to $phoneNo"),
                                            const SizedBox(height: 10,),
                                            Wrap(
                                              children: [
                                                const Text("If not "),
                                                InkWell(
                                                  child: const Text("RESEND",style: TextStyle(color: Colors.blue),),
                                                  onTap: (){
                                                    verifyPhone(phoneNo,context).then((value){
                                                      Fluttertoast.showToast(msg: "OTP Resend Successfully");
                                                    });
                                                    _pinCotroller.clear();
                                                  },
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ) :  Container(),
                            ],
                          ),
                        ),
                      ),
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

  void authForEmail()async{

    String? validate(){
      if(emailId.trim().isEmpty){
        return "Please fill valid email";
      }else if(password.trim().length<8){
        return "Password length should be at least 8 character";
      }else if(!loginWithEmailForSignIn){
        if(password.trim().length!=confirmPassword.trim().length){
          return "Password not matching with Confirm Password";
        }
      }
    }

    if(validate()==null){
      final prefs = await SharedPreferences.getInstance();
      if(loginWithEmailForSignIn){
        try{
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailId.trim(), password: password.trim());
          if(userCredential.user!=null){
            //Navigate to home
            prefs.setBool('google', false);
            Get.offAll(()=> const HomeScreen());
          }else{
            showDialogAlert("Something went wrong, please try again.");
          }
        }on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            showDialogAlert('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            showDialogAlert('Wrong password provided for that user.');
          }else{
            showDialogAlert(e.code);
          }
        }
      }else{
        try{
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailId.trim(), password: password.trim());
          if(userCredential.user!=null){
            prefs.setBool("vPending", true);
            FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value){
              Fluttertoast.showToast(msg: "We have resent email verification link on your email, please verify that.");
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmailVerificationPage(),));
            //Navigate to Verification
          }else{
            showDialogAlert("Something went wrong, please try again.");
          }
        }on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            showDialogAlert("The password provided is too weak.");
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            showDialogAlert("The account already exists for that email.");
            print('The account already exists for that email.');
          }else{
            showDialogAlert(e.code);
          }
        } catch (e) {
          showDialogAlert("Something went wrong, please try again.");
          print(e);
        }
      }
    }else{
      Fluttertoast.showToast(msg: validate().toString());
    }
  }

  showDialogAlert(String message){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Alert"),
        content: Text(message),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void authForPhoneNumber()async{
    if(phoneNo!.isNotEmpty){
      if(kIsWeb){
        try{
          setState(() {
            loading = true;
          });
          confirmationResult = await auth.signInWithPhoneNumber("+91"+this.phoneNo!).whenComplete(() =>
              setState(() {
                codeSent = true;
                loading = false;
              }));
        }catch(e){
          setState(() {
            codeSent = false;
            loading = false;
          });
          print(e);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Error",style: TextStyle(color: Colors.red),),
              content: Text(e.toString()),
              actions: [
                MaterialButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                )
              ],
            ),
          );
        }
      }else{
        setState((){
          phoneNo = "+91" + phoneNo!;
          loading = true;
        });
        await verifyPhone(phoneNo,context);
      }
    }
    else{
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Alert"),
          content: const Text("Please fill the Phone Number"),
          actions: [
            MaterialButton(
              child: const Text("Ok"),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    }
  }

  Future<UserCredential> signInWithGoogleMobile() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  String? name;
  String? imageUrl;
  String? uid;
  String? userEmail;

  Future<String> signInWithGoogleWeb() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await Firebase.initializeApp();
    User? user;

    // The `GoogleAuthProvider` can only be used while running on the web
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential =
      await _auth.signInWithPopup(authProvider);

      user = userCredential.user;

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setBool('auth', true);
      // prefs.setBool('google', true);
      // prefs.setString('name', user!.displayName!);
      // prefs.setString('email', user.email!);
      // prefs.setString('url', user.photoURL!);
      // prefs.setString('phone', user.phoneNumber!);
      // prefs.setString('uid', user.uid);
      // print("Done");
    } catch (e) {
      print(e);
    }

    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      userEmail = user.email;
      imageUrl = user.photoURL;
      phoneNo = user.phoneNumber;
    }

    return user!.uid;
  }

  errorFun(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error",style: TextStyle(color: Colors.red),),
        content: Text("Invalid OTP, Please Try Again"),
        actions: [
          MaterialButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  Future<void> verifyPhone(phoneNo,context) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult,context,phoneNo);
    };

    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("Error"),
          content: Text('${authException.message}'),
          actions: [
            MaterialButton(
              child: Text("OK"),
              onPressed: (){
                setState(() {
                  loading = false;
                });
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int? forceResend]) {
      this.verificationId = verId;
      setState(() {
        loading = false;
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}

