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
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            TabBar(
              indicatorWeight: 0.7,
              labelColor: Theme.of(context).colorScheme.tertiary,
              unselectedLabelColor: Colors.white,
              dividerColor: Colors.white,
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
            Expanded(
              child: TabBarView(
                children: [
                  UploadDocuments(),
                  const UploadLocation(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
