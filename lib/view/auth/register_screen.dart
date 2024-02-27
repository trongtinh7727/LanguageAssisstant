import 'package:flutter/material.dart';
import 'package:languageassistant/routes/name_routes.dart';

import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/app_toast.dart';
import 'package:languageassistant/view_model/auth_provider.dart';
import 'package:languageassistant/widget/text_field_widget.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      body: Container(
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
                    color: AppStyle.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48),
                TextFieldWidget(
                    hint: 'Nhập email',
                    icon: Icons.email,
                    textEditingController: email),
                const SizedBox(height: 16),
                TextFieldWidget(
                    hint: 'Nhập họ và tên',
                    icon: Icons.person,
                    textEditingController: fullName),
                const SizedBox(height: 16),
                TextFieldWidget(
                    hint: 'Nhập mật khẩu',
                    icon: Icons.lock,
                    isPassword: true,
                    textEditingController: password),
                const SizedBox(height: 16),
                TextFieldWidget(
                    hint: 'Nhập lại mật khẩu',
                    icon: Icons.lock,
                    isPassword: true,
                    textEditingController: passwordConfirm),
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
                  onPressed: () async {
                    if (email.text.isEmpty) {
                      commonToast("Please enter email");
                    } else if (password.text.isEmpty) {
                      commonToast("Please enter password");
                    } else {
                      bool result =
                          await authProvider.signInWithEmailAndPassword(
                        email.text.toString(),
                        password.text.toString(),
                      );
                      if (result) {
                        Navigator.popAndPushNamed(
                            context, RouteName.homeScreen);
                      } else {
                        // Maybe show an error message
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.primaryColor,
                    fixedSize: const Size(295, 50),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: authProvider.isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text('Đăng nhập',
                          style: TextStyle(color: Colors.white)),
                ),
                if (authProvider.errorMessage.isNotEmpty)
                  Text(
                    authProvider.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // This centers the children horizontally
                    children: [
                      const Text(
                        'Bạn đã có tài khoản?',
                        style: TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Đăng nhập',
                          style: TextStyle(color: AppStyle.activeText),
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
}
