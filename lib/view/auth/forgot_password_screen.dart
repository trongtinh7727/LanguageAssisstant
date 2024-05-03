import 'dart:async';
import 'package:flutter/material.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/app_toast.dart';
import 'package:languageassistant/view_model/auth_provider.dart';
import 'package:languageassistant/widget/text_field_widget.dart';
import 'package:languageassistant/utils/app_validator.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isResendEnabled = true;
  int _countDownSeconds = 60;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  void startCountDownTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (_countDownSeconds <= 0) {
          _timer!.cancel();
          _isResendEnabled =
              true; // Kích hoạt nút gửi lại sau khi kết thúc đếm ngược
        } else {
          _countDownSeconds--;
        }
      });
    });
  }

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
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_isResendEnabled) {
                        return;
                      }
                      if (_validateForm(context)) {
                        setState(() {
                          _isResendEnabled = false;
                          _countDownSeconds = 60;
                        });

                        startCountDownTimer(); // Bắt đầu đếm ngược
                        bool result = await authProvider.sendPasswordResetEmail(
                          emailController.text,
                        );
                        if (result) {
                          successToast(
                              'Vui lòng kiểm tra email để đặt lại mật khẩu');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isResendEnabled
                          ? AppStyle.primaryColor
                          : AppStyle.greyColor_100,
                      fixedSize: Size(295, 60),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 5),
                    ),
                    child: authProvider.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Xác nhận',
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
                  ),
                  if (!_isResendEnabled)
                    Text(
                      'Đợi ${_countDownSeconds}s để gửi lại',
                      style: TextStyle(color: Colors.grey),
                    ),
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
      errorToast("Vui lòng nhập email");
      return false;
    } else {
      return true;
    }
    // return false;
  }
}
