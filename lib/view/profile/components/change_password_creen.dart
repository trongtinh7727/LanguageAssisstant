import 'package:flutter/material.dart';
import 'package:languageassistant/routes/name_routes.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/app_toast.dart';
import 'package:languageassistant/utils/app_validator.dart';
import 'package:languageassistant/view_model/auth_provider.dart';
import 'package:languageassistant/widget/custom_button.dart';
import 'package:languageassistant/widget/text_field_widget.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late AuthenticationProvider authViewModel;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();
  String? errorMessage = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    authViewModel = Provider.of<AuthenticationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        authViewModel.setErrorMessage('');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    passwordConfirm.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Text('Đổi mật khẩu'),
            actions: [],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(height: 1),
            )),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      'Mật khẩu cũ:',
                      style: AppStyle.title,
                    ),
                  ],
                ),
                TextFieldWidget(
                  isPassword: true,
                  isEnabled: true,
                  paddingH: 8,
                  validator: (p0) => Validator.validatePassword(password: p0),
                  hint: 'Mật khẩu cũ',
                  textEditingController: oldPasswordController,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Row(
                  children: [
                    Text(
                      'Mật khẩu mới:',
                      style: AppStyle.title,
                    ),
                  ],
                ),
                TextFieldWidget(
                  isPassword: true,
                  paddingH: 8,
                  validator: (p0) => Validator.validatePassword(password: p0),
                  hint: 'Mật khẩu mới',
                  textEditingController: newPasswordController,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Row(
                  children: [
                    Text(
                      'Nhập lại mật khẩu mới:',
                      style: AppStyle.title,
                    ),
                  ],
                ),
                TextFieldWidget(
                  isPassword: true,
                  paddingH: 8,
                  hint: 'Nhập lại mật khẩu mới',
                  validator: (p0) => Validator.validatePasswordConfirm(
                      password: p0,
                      confirmPassword: newPasswordController.text),
                  textEditingController: passwordConfirm,
                ),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.primaryColor,
                    fixedSize: Size(295, 60),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  ),
                  child: authViewModel.isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Đổi mật khẩu',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                ),
                if (authViewModel.errorMessage.isNotEmpty)
                  Text(
                    authViewModel.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ));
  }

  _save() async {
    if (!authViewModel.isLoading) {
      final form = _formKey.currentState;
      if (form!.validate()) {
        setState(() {
          _saving = true;
        });

        bool result = await authViewModel.changePassword(
            oldPasswordController.text, newPasswordController.text);

        setState(() {
          _saving = false;
          if (result) {
            successToast('Đổi mật khẩu thành công');
            Navigator.pop(context);
          }
        });
      }
    }
  }
}
