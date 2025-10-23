import 'package:flutter/material.dart';
import 'package:presales_app_store/src/common/widgets/common_app_bar.dart';
import 'package:presales_app_store/src/features/admin/presentation/upload_form.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(),
      body: UploadForm(),
    );
  }
}