import 'package:flutter/material.dart';
import 'package:mobile_app/core/providers/theme_provider.dart';
import 'package:mobile_app/ui/pages/admin/home.dart';
import 'package:mobile_app/ui/pages/worker/home.dart';
import 'package:mobile_app/ui/pages/kycForm/kyc.dart';
import 'package:provider/provider.dart';

import 'core/providers/currentuser_provider.dart';
import 'core/providers/loading_provider.dart';
import 'ui/pages/user/home.dart';
import 'ui/pages/loginregister/login.dart';
import 'ui/pages/loginregister/register.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
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
          theme: Provider.of<ThemeProvider>(context).themeData,
          debugShowCheckedModeBanner: false,
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/home': (context) {
              final currentUserRole =
                  Provider.of<CurrentUser>(context).user.role;
              if (currentUserRole.toLowerCase() == 'user') {
                return const HomePage();
              } else if (currentUserRole.toLowerCase() == 'worker') {
                return const WorkerHomePage();
              } else if (currentUserRole.toLowerCase() == 'admin') {
                return const AdminHomePage();
              } else {
                return const LoginPage();
              }
            },
            '/kyc': (context) => const KYCPage(),
          },
        ),
      ),
    );
  }
}
