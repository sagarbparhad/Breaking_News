import 'dart:convert';
import 'package:breaking_news/newsdetail_screen.dart';
import 'package:breaking_news/newsdetail_screen.dart';
import 'package:breaking_news/views/news_articles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // import your detail screen

class TopHeadlineScreen extends StatefulWidget {
  const TopHeadlineScreen({super.key});

  @override
  _TopHeadlineScreenState createState() => _TopHeadlineScreenState();
}

class _TopHeadlineScreenState extends State<TopHeadlineScreen> {
  List<NewsTopHeadlines> topheadlines = [];

  @override
  void initState() {
    super.initState();
    fetchtopheadlinesNews();
  }

  Future<void> fetchtopheadlinesNews() async {
    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=47d51d6d235e44099f1b6abebab2322b');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<NewsTopHeadlines> fetchedtopheadlines = (data['articles'] as List)
          .map((article) => NewsTopHeadlines.fromJson(article))
          .toList();

      setState(() {
        topheadlines = fetchedtopheadlines;
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.0),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 10),
            const Text(
              "Top Headlines",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
      ),
      body: topheadlines.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: topheadlines.length,
        itemBuilder: (context, index) {
          final topheadline = topheadlines[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(
                    article: NewsArticle(   // 🔑 Convert TopHeadline → NewsArticle
                      title: topheadline.title,
                      description: topheadline.description,
                      content: topheadline.content,
                      url: topheadline.url,
                      urlToImage: topheadline.urlToImage,
                      author: topheadline.author,
                    ),
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      topheadline.urlToImage != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          topheadline.urlToImage!,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topheadline.title ?? 'No Title',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              topheadline.description ?? 'No Description',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Read More...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
