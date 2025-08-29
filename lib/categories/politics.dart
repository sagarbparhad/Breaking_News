import 'dart:convert';
import 'package:breaking_news/newsdetail_screen.dart';
import 'package:breaking_news/views/news_articles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
 // ✅ import common detail screen

class PoliticalNewsScreen extends StatefulWidget {
  const PoliticalNewsScreen({super.key});

  @override
  _PoliticalNewsScreenState createState() => _PoliticalNewsScreenState();
}

class _PoliticalNewsScreenState extends State<PoliticalNewsScreen> {
  List<NewsPolitical> politics = [];

  @override
  void initState() {
    super.initState();
    fetchpoliticsNews();
  }

  Future<void> fetchpoliticsNews() async {
    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=politics&apiKey=47d51d6d235e44099f1b6abebab2322b');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<NewsPolitical> fetchedpolitics = (data['articles'] as List)
          .map((article) => NewsPolitical.fromJson(article))
          .toList();

      setState(() {
        politics = fetchedpolitics;
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
              "Political News",
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
      body: politics.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: politics.length,
        itemBuilder: (context, index) {
          final political = politics[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(
                    article: NewsArticle( // ✅ convert to NewsArticle
                      title: political.title,
                      description: political.description,
                      content: political.content,
                      url: political.url,
                      urlToImage: political.urlToImage,
                      author: political.author,
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
                      political.urlToImage != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          political.urlToImage!,
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
                              political.title ?? 'No Title',
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
                              political.description ?? 'No Description',
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

class NewsPolitical {
  final String? title;
  final String? author;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  NewsPolitical({
    this.title,
    this.author,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory NewsPolitical.fromJson(Map<String, dynamic> json) {
    return NewsPolitical(
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
