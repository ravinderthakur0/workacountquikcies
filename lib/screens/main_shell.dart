import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:myapp/services/offline_service.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late final WebViewController _controller;
  final String _url = 'https://studio--quickies-oy4lg.us-central1.hosted.app/feed';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
    _loadPage();
  }

  Future<void> _loadPage() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      final cachedPage = await OfflineService.loadPage();
      if (cachedPage != null) {
        _controller.loadHtmlString(cachedPage);
      } else {
        _controller.loadRequest(Uri.parse(_url));
      }
    } else {
      _controller.loadRequest(Uri.parse(_url));
      _controller.currentUrl().then((url) {
        if (url != null) OfflineService.savePage(url);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (await _controller.canGoBack()) {
          await _controller.goBack();
        } 
      },
      child: Scaffold(
        body: SafeArea(child: WebViewWidget(controller: _controller)),
      ),
    );
  }
}
