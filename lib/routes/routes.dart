import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/view/auth/intro_screen.dart';
import 'package:languageassistant/view/auth/login_screen.dart';
import 'package:languageassistant/view/auth/register_screen.dart';
import 'package:languageassistant/view/home/home_screen.dart';
import 'package:languageassistant/view/learning/flashcard.dart';
import 'package:languageassistant/view/learning/result_screen.dart';
import 'package:languageassistant/view/learning/word_type.dart';
import 'package:languageassistant/view/library/add_topic_screen.dart';
import 'package:languageassistant/view/main_layout.dart';
import 'package:languageassistant/view/splash_screen.dart';
import 'package:languageassistant/view/topic_detail/topic_detail_screen.dart';
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
      case RouteName.registerScreen:
        return MaterialPageRoute(builder: (context) => RegisterScreen());
      case RouteName.addTopicScreen:
        return MaterialPageRoute(builder: (context) => AddTopicScreen());
      case RouteName.updateTopicScreen:
        final topic = settings.arguments as TopicModel;
        return MaterialPageRoute(
            builder: (context) => AddTopicScreen(
                  editTopicModel: topic,
                ));
      case RouteName.topicDetailScreen:
        final topic = settings.arguments as TopicModel;
        return MaterialPageRoute(
            builder: (context) => TopicDetailScreen(
                  topic: topic,
                ));

      case RouteName.mainLayout:
        return MaterialPageRoute(builder: (context) => MainLayout());
      case RouteName.flashCardScreen:
        return MaterialPageRoute(builder: (context) => FlashCardScreen());
      case RouteName.wordTypeScreen:
        return MaterialPageRoute(builder: (context) => WordTypeScreen());
      case RouteName.resultScreen:
        return MaterialPageRoute(builder: (context) => ResultScreen());
      case RouteName.loginScreen:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      default:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
    }
  }
}
