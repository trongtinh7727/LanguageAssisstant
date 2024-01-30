import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:languageassistant/routes/name_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  @override
  void initState() {
    super.initState();
    _checkUser();
    Future.delayed(const Duration(seconds: 3), () {
      // Navigator.pushReplacementNamed(context, RouteName.mainLayout);

      if (_user == null) {
        // If the user is not authenticated, navigate to the login screen.
        Navigator.pushReplacementNamed(context, RouteName.loginScreen);
      } else {
        // If the user is authenticated, navigate to the home screen.
        Navigator.pushReplacementNamed(context, RouteName.mainLayout);
      }
    });
  }

  Future<void> _checkUser() async {
    User? user = _auth.currentUser;
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SizedBox(
                height: 200,
                width: 200,
                child: Image.asset('assets/images/logo.png'))));
  }
}
