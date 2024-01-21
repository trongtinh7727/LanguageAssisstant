import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    setLoading(true);
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        setErrorMessage(''); // Clear any previous error messages
      } else {
        setErrorMessage('Email and password cannot be empty.');
      }
    } on FirebaseAuthException catch (e) {
      setErrorMessage(e.message ?? 'An unknown error occurred');
    } catch (e) {
      setErrorMessage('An error occurred. Please try again later.');
    }
    setLoading(false);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
