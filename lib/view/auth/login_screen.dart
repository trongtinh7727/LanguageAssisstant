import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:languageassistant/utils/app_color.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/background.png'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    height: 250,
                    width: 250,
                    child: Image.asset('assets/images/logo.png')),
                Text(
                  'Excellent Experience',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48),
                _buildTextField(hint: 'Nhập email', icon: Icons.email),
                const SizedBox(height: 16),
                _buildTextField(
                    hint: 'Nhập mật khẩu', icon: Icons.lock, isPassword: true),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Quên mật khẩu',
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text('Đăng nhập'),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // This centers the children horizontally
                    children: [
                      const Text(
                        'Bạn chưa có tài khoản?',
                        style: TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Đăng ký',
                          style: TextStyle(color: lightBlueColor),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String hint, required IconData icon, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: 500), // Set your desired max width here
        child: TextField(
          maxLines: 1,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color.fromARGB(179, 48, 44, 44)),
            prefixIcon: Icon(icon, color: Colors.black54),
            filled: true,
            fillColor: const Color.fromARGB(60, 56, 54, 54),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blueAccent),
            ),
          ),
        ),
      ),
    );
  }
}
