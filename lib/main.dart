import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chefsysproject/pages/login.dart';
import 'package:chefsysproject/pages/notification.dart';
import 'package:chefsysproject/theme/theme.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RMS',
      theme: lightMode,
      darkTheme: darkMode,
      home: AnimatedSplashScreen(
        splash: Image(image: AssetImage('assets/logo.png')),
        duration: 1000,
        splashTransition: SplashTransition.rotationTransition,
        backgroundColor: Colors.white,
        nextScreen: Login(),
      ),
      navigatorKey: navigatorKey,
      routes: {
        '/notification_screen': (context) => const NotificationPage(),
      },
    );
  }
}
