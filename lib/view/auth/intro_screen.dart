import 'package:flutter/material.dart';

import '../../routes/name_routes.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/images/background.png'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            SizedBox(
                height: 250,
                width: 250,
                child: Image.asset('assets/images/logo.png')),
            const Text(
              'Excellent Experience',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Handle login
                Navigator.pushReplacementNamed(context, RouteName.loginScreen);
              },
              child: const Text('Đăng nhập'),
            ),
            TextButton(
              onPressed: () {
                // Handle sign up
              },
              child: const Text('Bạn chưa có tài khoản? Đăng kí'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
