import 'package:flutter/material.dart';

// reuseable textfield
// auto password hider in password fields

class CstmTextField extends StatefulWidget {
  final TextEditingController? mainController;
  final TextEditingController? confirmController;
  final String text;
  final IconData? prefixIcon;
  final TextInputType inputType;

  const CstmTextField({
    super.key,
    this.mainController,
    this.confirmController,
    required this.text,
    this.prefixIcon,
    required this.inputType,
  });

  @override
  State<CstmTextField> createState() => _CstmTextFieldState();
}

class _CstmTextFieldState extends State<CstmTextField> {
  bool _isPassword = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isPassword = isPassword();
    });
  }

  isPassword() {
    switch (widget.inputType) {
      case TextInputType.visiblePassword:
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: widget.mainController,
        obscureText: _isPassword,
        keyboardType: widget.inputType,
        decoration: InputDecoration(
          labelText: widget.text,
          labelStyle: const TextStyle(fontSize: 15),
          filled: true,
          focusColor: Theme.of(context).colorScheme.tertiary,
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.tertiary)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: const EdgeInsets.all(13),
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                )
              : null,
          suffixIcon: isPassword()
              ? PassHider(
                  obscureCheck: _isPassword,
                  onToggle: () {
                    setState(() {
                      _isPassword = !_isPassword;
                    });
                  },
                )
              : Icon(_getSuffixIcon(widget.text)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter ${widget.text}';
          }
          if (widget.text == 'Email Address' &&
              !RegExp(r'\S+@\S+\.\S+').hasMatch(widget.mainController!.text)) {
            return 'Invalid Email.';
          }
          if (widget.text == 'Password' &&
              widget.mainController!.text.length < 6) {
            return 'Password cannot be less than 6 characters.';
          }
          if (widget.text == 'Confirm Password' &&
              widget.mainController!.text != widget.confirmController!.text) {
            return 'Password do not match.';
          }
          return null;
        },
      ),
    );
  }

  IconData? _getSuffixIcon(String text) {
    switch (text) {
      case 'First Name':
      case 'Last Name':
        return Icons.person_outlined;
      case 'Date of Birth':
        return Icons.calendar_month_outlined;
      case 'Occupation':
        return Icons.work_outline;
      case 'Email Address':
        return Icons.mail_outline;
      case 'Phone Number':
        return Icons.phone_outlined;
      default:
        return null;
    }
  }
}

class PassHider extends StatelessWidget {
  final bool obscureCheck;
  final VoidCallback onToggle;

  const PassHider({
    super.key,
    required this.obscureCheck,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 20,
      icon: Icon(
        obscureCheck
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
      ),
      onPressed: onToggle,
    );
  }
}
