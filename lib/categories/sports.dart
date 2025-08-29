import 'dart:convert';
import 'package:breaking_news/newsdetail_screen.dart';
import 'package:breaking_news/views/news_articles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;// ✅ Import common detail screen

class SportNewsScreen extends StatefulWidget {
  const SportNewsScreen({super.key});

  @override
  _SportNewsScreenState createState() => _SportNewsScreenState();
}

class _SportNewsScreenState extends State<SportNewsScreen> {
  List<NewsSport> sports = [];

  @override
  void initState() {
    super.initState();
    fetchsportsNews();
  }

  Future<void> fetchsportsNews() async {
    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=sports&apiKey=47d51d6d235e44099f1b6abebab2322b');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<NewsSport> fetchedsports = (data['articles'] as List)
          .map((article) => NewsSport.fromJson(article))
          .toList();

      setState(() {
        sports = fetchedsports;
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
              "Sports News",
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
      body: sports.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: sports.length,
        itemBuilder: (context, index) {
          final sport = sports[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(
                    article: NewsArticle(   // ✅ convert to NewsArticle
                      title: sport.title,
                      description: sport.description,
                      content: sport.content,
                      url: sport.url,
                      urlToImage: sport.urlToImage,
                      author: sport.author,
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
                      sport.urlToImage != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          sport.urlToImage!,
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
                              sport.title ?? 'No Title',
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
                              sport.description ?? 'No Description',
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

class NewsSport {
  final String? title;
  final String? author;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  NewsSport({
    this.title,
    this.author,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory NewsSport.fromJson(Map<String, dynamic> json) {
    return NewsSport(
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
