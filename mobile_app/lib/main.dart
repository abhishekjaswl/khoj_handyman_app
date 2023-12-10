import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/providers/currentuser_provider.dart';
import 'core/providers/loading_provider.dart';
import 'ui/pages/home/home.dart';
import 'ui/pages/loginregister/login.dart';
import 'ui/pages/loginregister/register.dart';
import 'ui/themes/dark_theme.dart';
import 'ui/themes/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  runApp(MyApp(initialRoute: token != null ? '/home' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

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
          initialRoute: initialRoute,
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/home': (context) => const HomePage(),
          },
        ),
      ),
    );
  }
}
