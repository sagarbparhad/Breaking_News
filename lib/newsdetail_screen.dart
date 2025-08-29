import 'package:breaking_news/views/home_page.dart';
import 'package:breaking_news/views/news_articles.dart';
import 'package:breaking_news/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({Key? key, required this.article}) : super(key: key);

  // Method to launch article URL
  Future<void> _launchURL(String? url) async {
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Merge description + content to make article feel complete
    final String fullContent = [
      article.description,
      article.content,
    ].where((e) => e != null && e.isNotEmpty).join("\n\n");

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          article.title ?? 'News Detail',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            // Article Image with Hero animation
            if (article.urlToImage != null)
              Hero(
                tag: article.urlToImage!,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                  child: Image.network(
                    article.urlToImage!,
                    width: double.infinity,
                    // height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image, size: 80, color: Colors.grey),
              ),

            // Article Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title ?? 'No Title',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Author + Source
                  Row(
                    children: [
                      Icon(Icons.person, size: 18, color: Colors.grey.shade600),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          article.author ?? 'Unknown Author',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Description
                  if (article.description != null)
                    Text(
                      article.description!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Content
                  Text(
                    fullContent.isNotEmpty
                        ? fullContent
                        : "No full content available for this article.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Read Full Article Button
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      icon: const Icon(Icons.open_in_new, color: Colors.white),
                      label: const Text(
                        "Read Full Article",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Get.to(() => FullArticleScreen(
                          url: article.url!,
                          imageUrl: article.urlToImage!,
                        ));
                      },

                    ),

                  ),
                  SizedBox(height: 10,),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
