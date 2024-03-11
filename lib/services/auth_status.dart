import 'package:assignment/screens/email_verification.dart';
import 'package:assignment/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStatus extends StatefulWidget {
  @override
  _AuthStatusState createState() => _AuthStatusState();
}

class _AuthStatusState extends State<AuthStatus> {


  @override
  Widget build(BuildContext context) {
    return AuthService().handleAuth();
  }
}
