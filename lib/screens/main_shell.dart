import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
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
  bool _errorOccurred = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            // Do not save any content if an error occurred during page load.
            if (_errorOccurred) return;

            // Only save content from the legitimate URL, not internal error pages.
            if (!url.startsWith('http')) return;

            try {
              // Get the page's HTML content.
              // In modern versions of webview_flutter, this directly returns the
              // decoded Dart string, no JSON conversion is needed.
              final pageContent = await _controller.runJavaScriptReturningResult('document.documentElement.outerHTML');

              if (pageContent is String && pageContent.isNotEmpty) {
                  await OfflineService.savePage(url, pageContent);
              }
            } catch (e) {
              if (kDebugMode) {
                print("Could not save page to cache: $e");
              }
            }
          },
          onWebResourceError: (WebResourceError error) async {
            // A web error (like no internet) occurred.
            if (error.isForMainFrame ?? false) {
                setState(() {
                  _errorOccurred = true;
                });
                // Immediately try to load the page from the offline cache.
                await _loadFromCache();
            }
          },
        ),
      );
    _loadPage();
  }

  Future<void> _loadPage() async {
    // Check for connectivity before deciding to load from URL or cache.
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _errorOccurred = true;
      });
      await _loadFromCache();
    } else {
       setState(() {
        _errorOccurred = false;
      });
      _controller.loadRequest(Uri.parse(_url));
    }
  }

  Future<void> _loadFromCache() async {
    final cachedPage = await OfflineService.loadPage(_url);
    if (cachedPage != null) {
      // If a cached version exists, display it.
      _controller.loadHtmlString(cachedPage, baseUrl: _url);
    } else {
      // If there is no cached version, display a user-friendly offline page.
      _controller.loadHtmlString('''
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
              body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; text-align: center; background-color: #f8f9fa; color: #343a40; margin: 0; }
              .container { padding: 20px; }
              h1 { font-size: 20px; font-weight: 500; }
              p { font-size: 16px; color: #6c757d; }
            </style>
          </head>
          <body>
            <div class="container">
              <h1>No Internet Connection</h1>
              <p>Please check your connection. A cached version of this page is not available.</p>
            </div>
          </body>
        </html>
      ''', baseUrl: _url);
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
