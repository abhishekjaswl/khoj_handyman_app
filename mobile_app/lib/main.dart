import 'package:flutter/material.dart';
import 'package:mobile_app/ui/pages/profile/profile.dart';
import 'package:provider/provider.dart';

import 'core/providers/currentuser_provider.dart';
import 'core/providers/loading_provider.dart';
import 'ui/pages/home/home.dart';
import 'ui/pages/loginregister/login.dart';
import 'ui/pages/loginregister/register.dart';
import 'ui/themes/dark_theme.dart';
import 'ui/themes/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => CurrentUser(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => IsLoadingData(),
        ),
      ],
      child: SafeArea(
        child: MaterialApp(
          title: 'Khoj',
          theme: lightTheme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/home': (context) => const HomePage(),
            '/profile': (context) => ProfilePage(),
          },
        ),
      ),
    );
  }
}
