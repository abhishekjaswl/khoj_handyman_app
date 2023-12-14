import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/ui/widgets/cstm_datepicker.dart';
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

  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final OtpFieldController _otpController = OtpFieldController();

  String? userType;
  bool isLoading = false;
  int _currentStep = 0;

  void _tapped(int step) =>
      step != 3 ? setState(() => _currentStep = step) : null;

  Future<void> _continued() async {
    switch (_currentStep) {
      case 2:
        String emailCheckResult = await checkEmail();
        if (emailCheckResult == 'ok') {
          setState(() => _currentStep++);
        } else {
          Fluttertoast.showToast(
            msg: emailCheckResult,
            backgroundColor: Colors.red,
            fontSize: 16,
          );
        }
        break;
      case < 4:
        setState(() => _currentStep++);
        break;
      case 4:
        print('FirstName: ${_firstNameController.text}');
        print('Pass: ${_passwordController.text}');
        print('ConPass: ${_confirmPasswordController.text}');
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

  Future<String> checkEmail() async {
    return await authService.checkEmail(
      context: context,
      email: _emailController.text,
    );
  }

  void registerUser() async {
    print(userType);
    await authService.registerUser(
      context: context,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      dob: _dobController.text,
      role: userType!,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
    );
  }

  // @override
  // void dispose() {
  //   _firstNameController.dispose();
  //   _lastNameController.dispose();
  //   _dobController.dispose();
  //   _emailController.dispose();
  //   _phoneController.dispose();
  //   _passwordController.dispose();
  //   _confirmPasswordController.dispose();
  //   super.dispose();
  // }

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
                            ),
                            CstmDatePicker(
                              controller: _dobController,
                              onDateSelected: (formattedDate) {
                                setState(() {
                                  _dobController.text = formattedDate;
                                });
                              },
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
                    Step(
                      title: const Text('Email and Phone'),
                      content: Column(
                        children: <Widget>[
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
                    Step(
                      title: const Text('Create a password'),
                      content: Column(
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
    );
  }
}
