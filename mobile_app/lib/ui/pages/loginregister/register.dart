// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../../../core/services/auth_service.dart';
import '../../widgets/cstm_snackbar.dart';
import '../../widgets/cstm_textfield.dart';
import 'widgets/cstm_loginswitcher.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService authService = AuthService();

  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final OtpFieldController _otpController = OtpFieldController();
  String userType = 'user';

  String otp = '';
  int _currentStep = 0;

  void _tapped(int step) => setState(() => _currentStep = step);

  Future<void> _continued() async {
    switch (_currentStep) {
      case 0:
        if (_firstNameController.text.isNotEmpty &&
            _lastNameController.text.isNotEmpty) {
          setState(() => _currentStep++);
          _registerFormKey.currentState!.reset();
        } else {
          _registerFormKey.currentState!.validate();
        }
      case 2:
        if (_emailController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty) {
          _registerFormKey.currentState!.validate();
          String otpResult = await authService.getregisOTP(
            context: context,
            email: _emailController.text,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
          );
          if (otpResult == 'ok') {
            _registerFormKey.currentState!.reset();
            setState(() => _currentStep++);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              CstmSnackBar(
                text: otpResult,
                type: 'error',
              ),
            );
          }
        } else {
          _registerFormKey.currentState!.validate();
        }
        break;
      case 3:
        if (otp != '') {
          String verifyResult = await authService.verifyOTP(
            context: context,
            email: _emailController.text,
            otp: otp,
            purpose: 'registration to the app',
          );
          if (verifyResult == 'ok') {
            ScaffoldMessenger.of(context).showSnackBar(
              CstmSnackBar(
                text: 'OTP Verified!',
                type: 'success',
              ),
            );

            otp = '';
            _otpController.clear();
            setState(() => _currentStep++);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              CstmSnackBar(
                text: verifyResult,
                type: 'error',
              ),
            );
          }
        }
      case < 4:
        setState(() => _currentStep++);
        break;
      case 4:
        if (_registerFormKey.currentState!.validate()) {
          registerUser();
        }
        break;
    }
  }

  void _cancel() {
    switch (_currentStep) {
      case > 3:
        setState(() => _currentStep = 2);
      case > 0:
        setState(() => _currentStep--);
      case 0:
        Navigator.pop(context);
    }
  }

  void registerUser() async {
    await authService.registerUser(
      context: context,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      role: userType,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 70),
            const Text(
              'Create an account.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            Form(
              key: _registerFormKey,
              child: Column(
                children: [
                  Stepper(
                    physics: const NeverScrollableScrollPhysics(),
                    type: StepperType.vertical,
                    currentStep: _currentStep,
                    onStepTapped: _tapped,
                    onStepContinue: _continued,
                    onStepCancel: _cancel,
                    steps: <Step>[
                      Step(
                        title: const Text('Personal Information'),
                        content: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            children: <Widget>[
                              CstmTextField(
                                mainController: _firstNameController,
                                text: 'First Name',
                                inputType: TextInputType.name,
                              ),
                              CstmTextField(
                                mainController: _lastNameController,
                                text: 'Last Name',
                                inputType: TextInputType.name,
                              )
                            ],
                          ),
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 1
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: const Text('User Type'),
                        content: Column(
                          children: <Widget>[
                            RadioListTile(
                              activeColor:
                                  Theme.of(context).colorScheme.tertiary,
                              title: const Text('User'),
                              value: 'user',
                              groupValue: userType,
                              onChanged: (value) {
                                setState(() {
                                  userType = value.toString();
                                });
                              },
                            ),
                            RadioListTile(
                              activeColor:
                                  Theme.of(context).colorScheme.tertiary,
                              title: const Text('Worker'),
                              value: 'worker',
                              groupValue: userType,
                              onChanged: (value) {
                                setState(() {
                                  userType = value.toString();
                                });
                              },
                            ),
                          ],
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 2
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: const Text('Email and Phone'),
                        content: Column(
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                '* We will send the OTP for next step at this email. *',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            CstmTextField(
                              mainController: _emailController,
                              text: 'Email Address',
                              inputType: TextInputType.emailAddress,
                            ),
                            CstmTextField(
                              mainController: _phoneController,
                              text: 'Phone Number',
                              inputType: TextInputType.number,
                            ),
                          ],
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 3
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: const Text('Two factor authentication'),
                        content: Column(
                          children: <Widget>[
                            OTPTextField(
                              otpFieldStyle: OtpFieldStyle(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                                borderColor:
                                    Theme.of(context).colorScheme.primary,
                                focusBorderColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              controller: _otpController,
                              length: 5,
                              width: MediaQuery.of(context).size.width,
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldWidth: 45,
                              fieldStyle: FieldStyle.box,
                              style: const TextStyle(fontSize: 20),
                              onChanged: (pin) {
                                // do not remove onChanged
                                // print("Changed: " + pin);
                              },
                              onCompleted: (value) {
                                setState(() {
                                  otp = value;
                                });
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                '* Please enter the OTP we have sent you in the email. *',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            )
                          ],
                        ),
                        isActive: _currentStep >= 0,
                        state: StepState.disabled,
                      ),
                      Step(
                        title: const Text('Create a password'),
                        content: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            children: <Widget>[
                              CstmTextField(
                                mainController: _passwordController,
                                text: 'Password',
                                inputType: TextInputType.visiblePassword,
                              ),
                              CstmTextField(
                                mainController: _confirmPasswordController,
                                confirmController: _passwordController,
                                text: 'Confirm Password',
                                inputType: TextInputType.visiblePassword,
                              ),
                            ],
                          ),
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 5
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                    ],
                  ),
                  CstmLoginSwitcher(
                    preText: 'Already have an account?',
                    onpressed: () => Navigator.pop(context),
                    suffText: 'Sign In',
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
