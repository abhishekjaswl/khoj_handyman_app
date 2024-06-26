import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/services/anime_service.dart';
import '../../../core/services/auth_service.dart';
import '../../widgets/cstm_button.dart';
import '../../widgets/cstm_textfield.dart';
import 'register.dart';
import 'widgets/cstm_loginswitcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _loginFormKey = GlobalKey<FormState>();
  late final AnimationController _controller;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final AnimeService animeService = AnimeService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  void loginUser() async {
    await authService.loginUser(
      context: context,
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Login',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            Lottie.asset(
              'assets/lottie/khoj_lottie.json',
              width: MediaQuery.of(context).size.width,
              height: 200,
              reverse: true,
            ),
            Form(
              key: _loginFormKey,
              child: Column(
                children: [
                  CstmTextField(
                    mainController: _emailController,
                    text: 'Email Address',
                    inputType: TextInputType.emailAddress,
                  ),
                  CstmTextField(
                    mainController: _passwordController,
                    text: 'Password',
                    inputType: TextInputType.visiblePassword,
                  ),
                  CstmButton(
                    leadingIcon: const Icon(
                      Icons.login_outlined,
                      color: Colors.white,
                    ),
                    text: 'Log In',
                    onPressed: () => {
                      if (_loginFormKey.currentState!.validate()) {loginUser()}
                    },
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => {
                        // Navigator.of(context).push(
                        //     animeService.createRoute(const ResetPass()))
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  CstmLoginSwitcher(
                    preText: 'New Here?',
                    onpressed: () {
                      Navigator.of(context)
                          .push(animeService.createRoute(const RegisterPage()));
                    },
                    suffText: 'Sign Up',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
