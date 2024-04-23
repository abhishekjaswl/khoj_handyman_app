import 'package:flutter/material.dart';

class TnC extends StatelessWidget {
  const TnC({super.key});

  final terms =
      'By accessing or using our mobile application, you agree to be bound by these terms and conditions. If you do not agree with any part of these terms, you may not use the application. Use of Cookies: Our application uses cookies to enhance user experience. By using the application, you consent to the use of cookies in accordance with our privacy policy.Privacy Policy: Our privacy policy outlines how we collect, use, and protect your personal information. By using the application, you agree to the terms of our privacy policy.Information Collection: We may collect certain information from users, including but not limited to device information, location data, and usage statistics. This information helps us improve our services and tailor content to user preferences.Third-Party Services: Our application may integrate with third-party services or include third-party content. We are not responsible for the content or privacy practices of these third parties. Intellectual Property: All content, trademarks, and intellectual property rights associated with the application are owned by us or our licensors. You may not use, reproduce, or distribute any content from the application without our prior written consent. Limitation of Liability: We are not liable for any damages arising from the use of our application, including but not limited to direct, indirect, incidental, or consequential damages. Governing Law: These terms and conditions are governed by the laws of I dont know. Any disputes arising from the use of the application shall be resolved in the courts of Supreme Court. Changes to Terms: We reserve the right to update or modify these terms and conditions at any time without prior notice. By continuing to use the application after any such changes, you agree to be bound by the updated terms. Contact Us: If you have any questions or concerns about these terms and conditions, please contact us at 6942069420.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acceptance of Terms:')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(terms, textAlign: TextAlign.justify),
        ),
      ),
    );
  }
}
