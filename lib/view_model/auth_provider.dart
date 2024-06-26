import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:languageassistant/model/models/user_model.dart';
import 'package:languageassistant/model/repository/user_repository.dart';
import 'package:languageassistant/utils/app_toast.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();

  UserModel? _userModel;

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  UserModel? get userModel => _userModel;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> registerWithEmailAndPassword(
      String fullname, String email, String password) async {
    setLoading(true);
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;
        tz.TZDateTime nowInTimeZone = tz.TZDateTime.now(
            tz.getLocation('Asia/Bangkok')); // Bangkok is UTC+7

        if (user != null) {
          UserModel newUser = UserModel(
              id: user.uid,
              name: fullname,
              email: user.email!,
              createTime: nowInTimeZone.millisecondsSinceEpoch,
              updateTime: nowInTimeZone.millisecondsSinceEpoch);
          await _userRepository.addUser(user.uid, newUser);
          setUserModel();
          setErrorMessage(''); // Clear any previous error messages
          setLoading(false);
          return true;
        }
      } else {
        setErrorMessage('Please fill in all fields.');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      setErrorMessage("Email đã được sử dụng!");
    } catch (e) {
      setLoading(false);
      setErrorMessage('Có lỗi xảy ra, thử lại sau!');
    }
    setLoading(false);
    return false;
  }

  void setUserModel() async {
    if (_auth.currentUser != null) {
      _userModel = await _userRepository.read(_auth.currentUser!.uid);
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    setLoading(true);
    try {
      var credential = EmailAuthProvider.credential(
          email: _userModel!.email, password: oldPassword);
      UserCredential result =
          await _auth.currentUser!.reauthenticateWithCredential(credential);
      await result.user!.updatePassword(newPassword);
      setErrorMessage('');
      setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      setErrorMessage('Mật khẩu cũ chưa chính xác!');
    } catch (e) {
      setErrorMessage('Có lỗi xảy ra, thử lại sau!');
    }
    setLoading(false);
    return false;
  }

  Future<void> updateUser() async {
    await _userRepository.update(_userModel!.id!, _userModel!);
    successToast('Cập nhật thành công!');
    notifyListeners();
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    setLoading(true);
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        setErrorMessage(''); // Clear any previous error messages
        setLoading(false);
        setUserModel();
        return true; // Sign-in successful
      } else {
        setErrorMessage('Email và mật khẩu không được bỏ trống.');
      }
    } on FirebaseAuthException catch (e) {
      setErrorMessage('Tài khoản hoặc mật khẩu không chính xác!');
    } catch (e) {
      setErrorMessage('Có lỗi xảy ra vui lòng thử lại sau!');
    }
    setLoading(false);
    return false; // Sign-in failed
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    setLoading(true);
    try {
      if (email.isNotEmpty) {
        await _auth.sendPasswordResetEmail(
          email: email,
        );
        setErrorMessage('');
        setLoading(false);
        setUserModel();
        return true;
      } else {
        setErrorMessage('Email và mật khẩu không được bỏ trống.');
      }
    } on FirebaseAuthException catch (e) {
      setErrorMessage('Tài khoản không tồn tại!');
    } catch (e) {
      setErrorMessage('Có lỗi xảy ra vui lòng thử lại sau!');
    }
    setLoading(false);
    return false; // Sign-in failed
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
    successToast('Đã đăngg xuất!');
  }
}
