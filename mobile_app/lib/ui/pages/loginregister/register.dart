import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../../../core/services/auth_service.dart';
import '../../widgets/cstm_textfield.dart';
import 'widgets/cstm_loginswitcher.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService authService = AuthService();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final OtpFieldController _otpController = OtpFieldController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? userType;
  bool isLoading = false;
  int _currentStep = 0;

  void _tapped(int step) =>
      step != 3 ? setState(() => _currentStep = step) : null;

  void _continued() => _currentStep < 4 ? setState(() => _currentStep++) : null;

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

  void registerUser() {
    authService.loginUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Create an account.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: [
              Stepper(
                physics: const NeverScrollableScrollPhysics(),
                type: StepperType.vertical,
                currentStep: _currentStep,
                onStepTapped: _tapped,
                onStepContinue: _continued,
                onStepCancel: _cancel,
                steps: <Step>[
                  _buildStep(
                    title: 'Personal Information',
                    fields: [
                      FieldInfo(
                        'First Name',
                        _firstNameController,
                        TextInputType.text,
                      ),
                      FieldInfo(
                        'Last Name',
                        _lastNameController,
                        TextInputType.text,
                      ),
                      FieldInfo(
                        'Date of Birth',
                        _dobController,
                        TextInputType.datetime,
                      ),
                    ],
                    step: 0,
                  ),
                  Step(
                    title: const Text('User Type'),
                    content: Column(
                      children: <Widget>[
                        RadioListTile(
                          activeColor: Theme.of(context).colorScheme.primary,
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
                          activeColor: Theme.of(context).colorScheme.primary,
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
                  _buildStep(
                    title: 'Email and Phone',
                    fields: [
                      FieldInfo(
                        'Email Address',
                        _emailController,
                        TextInputType.emailAddress,
                      ),
                      FieldInfo(
                        'Phone Number',
                        _phoneController,
                        TextInputType.number,
                      ),
                    ],
                    step: 2,
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
                            borderColor: Theme.of(context).colorScheme.primary,
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
                            // print("Changed: " + pin);
                          },
                          onCompleted: (pin) {
                            // print("Completed: " + pin);
                            _continued();
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
                    state: _currentStep >= 4
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  _buildStep(
                    title: 'Create a password',
                    fields: [
                      FieldInfo(
                        'Password',
                        _passwordController,
                        TextInputType.visiblePassword,
                      ),
                      FieldInfo(
                        'Confirm Password',
                        _confirmPasswordController,
                        TextInputType.visiblePassword,
                      ),
                    ],
                    step: 4,
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
        ],
      ),
    );
  }

  Step _buildStep(
      {required String title,
      required List<FieldInfo> fields,
      required int step}) {
    return Step(
      title: Text(
        title,
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          children: fields
              .map((field) => CstmTextField(
                    mainController: field.controller,
                    text: field.label,
                    inputType: field.inputType,
                  ))
              .toList(),
        ),
      ),
      isActive: _currentStep >= 0,
      state: _currentStep >= step + 1 ? StepState.complete : StepState.disabled,
    );
  }
}

class FieldInfo {
  final String label;
  final TextEditingController controller;
  final TextInputType inputType;

  FieldInfo(
    this.label,
    this.controller,
    this.inputType,
  );
}
