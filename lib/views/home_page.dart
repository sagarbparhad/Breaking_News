import 'dart:async';
import 'dart:convert';
import 'package:breaking_news/bottomnavigation/notification.dart';
import 'package:breaking_news/categories/business.dart';
import 'package:breaking_news/categories/entertainment.dart';
import 'package:breaking_news/categories/politics.dart';
import 'package:breaking_news/categories/sports.dart';
import 'package:breaking_news/categories/technology.dart';
import 'package:breaking_news/categories/topheadline.dart';
import 'package:breaking_news/newsdetail_screen.dart';
import 'package:breaking_news/views/home_page.dart';
import 'package:breaking_news/views/news_articles.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  List<NewsArticle> articles = [];
  List<NewsArticle> filteredArticles = [];
  final TextEditingController _searchController = TextEditingController();

  Future<void> fetchNews({String query = 'latest'}) async {
    final url = Uri.parse(
      'https://newsapi.org/v2/everything?q=$query&sortBy=publishedAt&apiKey=47d51d6d235e44099f1b6abebab2322b',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'ok') {
          final List articlesJson = data['articles'];

          setState(() {
            articles = articlesJson
                .map((articleJson) => NewsArticle.fromJson(articleJson))
                .toList();
            filteredArticles = articles;
          });
        } else {
          print('API Error: ${data['message']}');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch news: $e');
    }
  }

  void _filterSearchResults() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredArticles = articles.where((article) {
        return (article.title?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterSearchResults);
    fetchNews(); // Fetch default news initially
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int unreadNotificationCount = 0; // Track the unread notification count

  // Update the unread count
  void updateNotificationCount(int count) {
    setState(() {
      unreadNotificationCount = count;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
        title: Padding(
          padding: const EdgeInsets.all(5),
          child: Text('Breaking News',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Ensure text is visible on background
            ),),
        ),
        backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
        automaticallyImplyLeading: false,
        actions: [
          // Notification icon with badge count
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 28,
                ),
                if (unreadNotificationCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        unreadNotificationCount.toString(),
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              // Pass the callback to the NotificationPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationPage(
                    onNotificationCountChanged: updateNotificationCount,
                  ),
                ),
              );
            },
          ),
        ],
      )
          : null, // AppBar is hidden for other pages
      body: IndexedStack(
        index: _selectedIndex, // This keeps the current page visible
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(height: 10),
                          /*Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Ensure text is visible on background
                            ),
                          ),*/
                          // SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildCategoryCard('Top Headlines', 'assets/topheadlines.jfif'),
                                _buildCategoryCard('Political News', 'assets/politics.jfif'),
                                _buildCategoryCard('Sports', 'assets/sports.jfif'),
                                _buildCategoryCard('Entertainment', 'assets/entertainment.jfif'),
                                _buildCategoryCard('Technology', 'assets/technology.jfif'),
                                _buildCategoryCard('Business', 'assets/business.jfif'),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),


                // Featured Products Section

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'News Articles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  children: [
                    // Other static content can go here...

                    // The scrollable article list
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7, // Adjust the height based on your needs
                      child: filteredArticles.isEmpty
                          ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      )
                          : ListView.builder(
                        itemCount: filteredArticles.length,
                        itemBuilder: (context, index) {
                          final article = filteredArticles[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsDetailScreen(article: article),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 8,
                                margin: EdgeInsets.all(0),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Article Image
                                      article.urlToImage != null
                                          ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          article.urlToImage!,
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
                                      SizedBox(width: 16),
                                      // Article Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              article.title ?? 'No Title',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            // Description (optional)
                                            Text(
                                              article.description ?? 'No Description',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            // Optional Button/Link (e.g. Read More)
                                            Text(
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
                    ),
                  ],
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
  // Inside HomePage
  Widget _buildCategoryCard(String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        if (title == 'Top Headlines') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TopHeadlineScreen()),
          );
        } else if (title == 'Political News') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PoliticalNewsScreen()),
          );
        } else if (title == 'Sports') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SportNewsScreen()),
          );
        } else if (title == 'Entertainment') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EntertainmentNewsScreen()),
          );
        } else if (title == 'Technology') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TechnologyScreen()),
          );
        } else if (title == 'Business') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BusinessScreen()),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1), // Transparent effect
          borderRadius: BorderRadius.circular(30), // Modern rounded corners
          border: Border.all(
            color: Colors.white.withOpacity(0.4), // Light border to give depth
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: Offset(0, 5), // shadow positioning
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                imagePath,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 8.0,
                    color: Colors.black.withOpacity(0.6),
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
// Method to build a product card
}






