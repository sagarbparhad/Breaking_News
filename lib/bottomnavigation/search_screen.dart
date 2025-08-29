import 'dart:convert';
import 'package:breaking_news/newsdetail_screen.dart';
import 'package:breaking_news/views/home_page.dart';
import 'package:breaking_news/views/news_articles.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<NewsArticle> searchResults = [];

  void _searchNews(String query) {
    if (query.isNotEmpty) {
      fetchNews(query: query);
    } else {
      setState(() {
        searchResults = [];
      });
    }
  }

  Future<void> fetchNews({String query = ''}) async {
    String urlString = 'https://newsapi.org/v2/everything?q=$query&apiKey=47d51d6d235e44099f1b6abebab2322b';

    final url = Uri.parse(urlString);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<NewsArticle> fetchedArticles = (data['articles'] as List)
          .map((articleJson) => NewsArticle.fromJson(articleJson))
          .toList();

      setState(() {
        searchResults = fetchedArticles;
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

          const Text(
            "Search News",
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search News by Title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onChanged: _searchNews,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final article = searchResults[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: article.urlToImage != null
                          ? Image.network(
                        article.urlToImage!,
                        width: 80,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                          : Container(width: 80, height: 80, color: Colors.grey),
                      title: Text(article.title ?? 'No Title'),
                      subtitle: Text(article.description ?? 'No Description'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailScreen(article: article),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
