import 'package:flutter/material.dart';
import 'package:languageassistant/routes/name_routes.dart';

import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/app_toast.dart';
import 'package:languageassistant/view_model/auth_provider.dart';
import 'package:languageassistant/widget/text_field_widget.dart';
import 'package:languageassistant/utils/app_validator.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: Image.asset('assets/images/logo.png'),
                  ),
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
                    validator: (value) => Validator.email(value: value),
                    icon: Icons.email,
                    textEditingController: emailController,
                  ),
                  const SizedBox(height: 16),
                  TextFieldWidget(
                    hint: 'Nhập mật khẩu',
                    icon: Icons.lock,
                    validator: (p0) => Validator.required(value: p0),
                    isPassword: true,
                    textEditingController: passwordController,
                  ),
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
                      if (_validateForm(context)) {
                        bool result =
                            await authProvider.signInWithEmailAndPassword(
                          emailController.text,
                          passwordController.text,
                        );
                        if (result) {
                          Navigator.pushReplacementNamed(
                              context, RouteName.mainLayout);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyle.primaryColor,
                      fixedSize: Size(295, 60),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 5),
                    ),
                    child: authProvider.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Đăng nhập',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                  if (authProvider.errorMessage.isNotEmpty)
                    Text(
                      authProvider.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Bạn chưa có tài khoản?',
                          style: TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RouteName.registerScreen);
                          },
                          child: Text(
                            'Đăng ký',
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
      ),
    );
  }

  bool _validateForm(BuildContext context) {
    final form = _formKey.currentState;

    form!.validate();
    if (Validator.email(value: emailController.text) != null) {
      errorToast("Please enter email");
      return false;
    } else if (Validator.required(value: passwordController.text) != null) {
      errorToast("Please enter password");
      return false;
    } else {
      return true;
    }
    // return false;
  }
}
