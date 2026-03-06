import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/offline_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            final content = await _controller.runJavaScriptReturningResult('document.documentElement.outerHTML');
            await OfflineService.savePage(url, content.toString());
          },
        ),
      );
    _loadPage();
  }

  Future<void> _loadPage() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      final cachedPage = await OfflineService.loadPage(_url);
      if (cachedPage != null) {
        _controller.loadHtmlString(cachedPage, baseUrl: _url);
      } else {
        // Handle case where there is no internet and no cached page
        _controller.loadHtmlString('<h1>No Internet Connection</h1>', baseUrl: _url);
      }
    } else {
      _controller.loadRequest(Uri.parse(_url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
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
