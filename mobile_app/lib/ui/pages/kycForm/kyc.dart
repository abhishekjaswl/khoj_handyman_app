import 'package:flutter/material.dart';
import 'package:mobile_app/ui/pages/kycForm/pages/upload_documents.dart';
import 'package:mobile_app/ui/pages/kycForm/pages/upload_location.dart';

class KYCPage extends StatefulWidget {
  const KYCPage({super.key});

  @override
  State<KYCPage> createState() => _KYCPageState();
}

class _KYCPageState extends State<KYCPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('KYC Form'),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Theme.of(context).colorScheme.tertiary,
            dividerColor: Colors.black,
            labelStyle: const TextStyle(
              fontSize: 15,
            ),
            tabs: const [
              Tab(
                text: 'Verification Details',
              ),
              Tab(
                text: 'Location',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            UploadDocuments(),
            UploadLocation(),
          ],
        ),
      ),
    );
  }
}
