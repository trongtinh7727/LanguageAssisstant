import 'package:flutter/material.dart';
import 'package:languageassistant/routes/name_routes.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/app_toast.dart';
import 'package:languageassistant/utils/app_validator.dart';
import 'package:languageassistant/view_model/auth_provider.dart';
import 'package:languageassistant/widget/text_field_widget.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                    validator: (p0) => Validator.email(value: p0),
                    icon: Icons.email,
                    textEditingController: emailController,
                  ),
                  const SizedBox(height: 16),
                  TextFieldWidget(
                    hint: 'Nhập họ và tên',
                    validator: (p0) => Validator.required(value: p0),
                    icon: Icons.person,
                    textEditingController: fullNameController,
                  ),
                  const SizedBox(height: 16),
                  TextFieldWidget(
                    hint: 'Nhập mật khẩu',
                    icon: Icons.lock,
                    validator: (p0) => Validator.validatePassword(password: p0),
                    isPassword: true,
                    textEditingController: passwordController,
                  ),
                  const SizedBox(height: 16),
                  TextFieldWidget(
                    hint: 'Nhập lại mật khẩu',
                    validator: (p0) => Validator.validatePasswordConfirm(
                        password: passwordController.text, confirmPassword: p0),
                    icon: Icons.lock,
                    isPassword: true,
                    textEditingController: passwordConfirmController,
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
                            await authProvider.registerWithEmailAndPassword(
                                fullNameController.text,
                                emailController.text,
                                passwordController.text);
                        if (result) {
                          Navigator.pushReplacementNamed(
                              context, RouteName.mainLayout);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyle.primaryColor,
                      fixedSize: const Size(295, 60),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 5),
                    ),
                    child: authProvider.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Đăng ký',
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
      ),
    );
  }

  bool _validateForm(BuildContext context) {
    final form = _formKey.currentState;

    if (form!.validate()) {
      return true;
    }

    return false;
  }
}
