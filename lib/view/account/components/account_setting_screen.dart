import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/routes/name_routes.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/app_toast.dart';
import 'package:languageassistant/utils/app_validator.dart';
import 'package:languageassistant/view_model/auth_provider.dart';
import 'package:languageassistant/widget/custom_button.dart';
import 'package:languageassistant/widget/text_field_widget.dart';
import 'package:provider/provider.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  late AuthenticationProvider authViewModel;
  TextEditingController textNameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? errorMessage = "";
  bool isEditing = false;
  @override
  void initState() {
    super.initState();
    authViewModel = Provider.of<AuthenticationProvider>(context, listen: false);
    textNameController.text = authViewModel.userModel!.name;
    birthdayController.text =
        authViewModel.userModel!.dataOfBirth ?? 'Chưa cập nhật';
    emailController.text = authViewModel.userModel!.email;
  }

  @override
  void dispose() {
    super.dispose();
    textNameController.dispose();
    birthdayController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Text('Cài đặt'),
            actions: [
              IconButton(
                  onPressed: () {
                    isEditing ? _save() : _edit();
                  },
                  icon: isEditing
                      ? Icon(
                          Icons.save_as_rounded,
                          color: AppStyle.activeText,
                        )
                      : Icon(
                          Icons.edit_note_outlined,
                          color: AppStyle.activeText,
                        ))
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(height: 1),
            )),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    'Tên:',
                    style: AppStyle.title,
                  ),
                ],
              ),
              TextFieldWidget(
                  isEnabled: isEditing,
                  paddingH: 8,
                  textEditingController: textNameController,
                  fillColor: errorMessage!.contains('Họ tên')
                      ? AppStyle.failedColor
                      : AppStyle.tabUnselectedColor),
              const SizedBox(
                height: 8,
              ),
              const Row(
                children: [
                  Text(
                    'Ngày sinh:',
                    style: AppStyle.title,
                  ),
                ],
              ),
              TextFieldWidget(
                  paddingH: 8,
                  validator: (value) => Validator.isValidDate(value: value),
                  hint: 'dd/mm/yyyy',
                  isEnabled: isEditing,
                  textEditingController: birthdayController,
                  fillColor: errorMessage!.contains('sinh')
                      ? AppStyle.failedColor
                      : AppStyle.tabUnselectedColor),
              const SizedBox(
                height: 8,
              ),
              const Row(
                children: [
                  Text(
                    'Email:',
                    style: AppStyle.title,
                  ),
                ],
              ),
              TextFieldWidget(
                  paddingH: 8,
                  hint: 'example@gmail.com',
                  isEnabled: false,
                  textEditingController: emailController,
                  fillColor: AppStyle.tabUnselectedColor),
              SizedBox(
                height: 26,
              ),
              ListTile(
                leading: Icon(
                  Icons.gpp_good_outlined,
                  color: Colors.black,
                ),
                title: Text('Chính sách bảo mật', style: AppStyle.title),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 15,
                ),
                shape: Border(
                  top: BorderSide(),
                  bottom: BorderSide(),
                ),
              ),
              ListTile(
                leading: Icon(Icons.article_outlined, color: Colors.black),
                title: Text('Chính sách bảo mật', style: AppStyle.title),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 15,
                ),
                shape: Border(
                  bottom: BorderSide(),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                      onContinue: () {
                        Navigator.pushNamed(
                            context, RouteName.changePasswordScreen);
                      },
                      word: 'Đổi mật khẩu',
                      width: 145),
                  CustomButton(
                    onContinue: _signOut,
                    word: 'Đăng xuất',
                    width: 145,
                  ),
                ],
              )
            ],
          ),
        ));
  }

  _signOut() {
    authViewModel.setErrorMessage('');
    authViewModel.signOut();
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, RouteName.loginScreen);
  }

  _save() {
    setState(() {
      errorMessage = Validator.maxLength(
          maxLength: 50,
          value: textNameController.text,
          message: 'Họ tên phải từ 5-50 ký tự');
      if (errorMessage != null) {
        errorToast(errorMessage!);
        return;
      }

      errorMessage = Validator.minLength(
          minLength: 5,
          value: textNameController.text,
          message: 'Họ tên phải từ 5-50 ký tự');
      if (errorMessage != null) {
        errorToast(errorMessage!);
        return;
      }
      errorMessage = Validator.isValidDate(
          value: birthdayController.text,
          message: 'Ngày sinh không hợp lệ (dd/mm/yyyy)!');
      if (errorMessage != null) {
        errorToast(errorMessage!);
        return;
      }
      errorMessage = '';
      authViewModel.userModel!.name = textNameController.text;
      authViewModel.userModel!.dataOfBirth = birthdayController.text;
      authViewModel.updateUser();

      isEditing = false;
    });
  }

  _edit() {
    setState(() {
      isEditing = true;
    });
  }
}
