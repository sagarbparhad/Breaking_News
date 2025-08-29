import 'dart:convert';
import 'package:breaking_news/newsdetail_screen.dart';
import 'package:breaking_news/views/news_articles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EntertainmentNewsScreen extends StatefulWidget {
  const EntertainmentNewsScreen({super.key});

  @override
  _EntertainmentNewsScreenState createState() =>
      _EntertainmentNewsScreenState();
}

class _EntertainmentNewsScreenState extends State<EntertainmentNewsScreen> {
  List<NewsEntertainment> entertainments = [];

  @override
  void initState() {
    super.initState();
    fetchentertainmentsNews();
  }

  Future<void> fetchentertainmentsNews() async {
    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=entertainment&apiKey=47d51d6d235e44099f1b6abebab2322b');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<NewsEntertainment> fetchedentertainments =
      (data['articles'] as List)
          .map((article) => NewsEntertainment.fromJson(article))
          .toList();

      setState(() {
        entertainments = fetchedentertainments;
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
              "Entertainment News",
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
      body: entertainments.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: entertainments.length,
        itemBuilder: (context, index) {
          final entertainment = entertainments[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(
                    article: NewsArticle( // ✅ convert Entertainment → NewsArticle
                      title: entertainment.title,
                      description: entertainment.description,
                      content: entertainment.content,
                      url: entertainment.url,
                      urlToImage: entertainment.urlToImage,
                      author: entertainment.author,
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
                      entertainment.urlToImage != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          entertainment.urlToImage!,
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
                              entertainment.title ?? 'No Title',
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
                              entertainment.description ?? 'No Description',
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

class NewsEntertainment {
  final String? title;
  final String? author;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  NewsEntertainment({
    this.title,
    this.author,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory NewsEntertainment.fromJson(Map<String, dynamic> json) {
    return NewsEntertainment(
      title: json['title'],
      author: json['author'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }
}
