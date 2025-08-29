import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FullArticleScreen extends StatefulWidget {
  final String url;
  final String imageUrl;

  const FullArticleScreen({Key? key, required this.url, required this.imageUrl})
      : super(key: key);

  @override
  _FullArticleScreenState createState() => _FullArticleScreenState();
}

class _FullArticleScreenState extends State<FullArticleScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final validUrl = widget.url.startsWith("http")
        ? widget.url
        : "https://${widget.url}"; // Fix missing scheme

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(validUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Full Article")),
      body: Column(
        children: [
          if (widget.imageUrl.isNotEmpty)
            Image.network(widget.imageUrl, height: 200, fit: BoxFit.cover),
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}
