import 'package:daakia_vc_flutter_sdk/resources/colors/color.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebPreview extends StatefulWidget {
  final String url;
  const WebPreview({required this.url, super.key});

  @override
  State<WebPreview> createState() => _WebPreviewState();
}

class _WebPreviewState extends State<WebPreview> {

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('Loading progress: $progress%');
          },
          onPageStarted: (String url) {
            debugPrint('Started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Finished loading: $url');
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('Navigating to: ${request.url}');
            // For other URLs, allow the WebView to load them
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        iconTheme: const IconThemeData(color: Colors.white), // Set icon color to white
        title: const Text(
          '',
          style: TextStyle(color: Colors.white), // Set title text color to white
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}

