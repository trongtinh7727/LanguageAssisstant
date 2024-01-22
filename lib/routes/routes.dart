import 'package:flutter/material.dart';
import 'package:languageassistant/view/auth/intro_screen.dart';
import 'package:languageassistant/view/auth/login_screen.dart';
import 'package:languageassistant/view/home_screen.dart';
import 'package:languageassistant/view/splash_screen.dart';
import 'name_routes.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RouteName.homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case RouteName.introScreen:
        return MaterialPageRoute(builder: (context) => IntroScreen());

      case RouteName.loginScreen:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      default:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
    }
  }
}
