import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WhiteBoardWidget extends StatelessWidget {
  final WebViewController controller;

  const WhiteBoardWidget({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.grey.shade200,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: WebViewWidget(controller: controller),
    );
  }
}
