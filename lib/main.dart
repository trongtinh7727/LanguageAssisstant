import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:languageassistant/firebase_options.dart';
import 'package:languageassistant/routes/name_routes.dart';
import 'package:languageassistant/routes/routes.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:provider/provider.dart';
import 'package:languageassistant/view_model/auth_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:window_manager/window_manager.dart';

void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  //window_manager on desktop app
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
      size: Size(500, 800),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      maximumSize: Size(500, 800));
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => TopicViewModel()),
        // Add other providers here
      ],
      child: MaterialApp(
        title: 'Flutter Firebase Auth',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: RouteName.splashScreen,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
