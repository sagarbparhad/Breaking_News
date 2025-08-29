import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationPage extends StatefulWidget {
  final Function(int unreadCount) onNotificationCountChanged;

  const NotificationPage({super.key, required this.onNotificationCountChanged});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLatestNews();
  }

  Future<void> fetchLatestNews() async {
    const apiKey = "47d51d6d235e44099f1b6abebab2322b";
    final DateTime now = DateTime.now();
    final String fromDate = now.subtract(Duration(days: 2)).toIso8601String().substring(0, 10);
    final String toDate = now.toIso8601String().substring(0, 10);

    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=apple&from=$fromDate&to=$toDate&sortBy=popularity&apiKey=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == "ok") {
          final articles = data["articles"] as List;

          setState(() {
            notifications = articles.map((article) {
              return {
                "title": article["title"] ?? "No Title",
                "time": article["publishedAt"] != null
                    ? DateTime.parse(article["publishedAt"]).toLocal().toString().substring(0, 16)
                    : "Unknown Time",
                "read": false,
              };
            }).toList();
            isLoading = false;
          });

          // Update unread notification count
          widget.onNotificationCountChanged(getUnreadNotificationCount());
        } else {
          setState(() => isLoading = false);
          print("Error from API: ${data["message"]}");
        }
      } else {
        setState(() => isLoading = false);
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching news: $e");
    }
  }

  int getUnreadNotificationCount() {
    return notifications.where((notification) => !notification["read"]).length;
  }

  void markAllAsRead() {
    setState(() {
      notifications = notifications.map((n) => {...n, "read": true}).toList();
    });
    widget.onNotificationCountChanged(0); // Reset count after marking all as read
  }

  void deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
    widget.onNotificationCountChanged(getUnreadNotificationCount());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24.0,  // Adjust size as per your design
              ),
              onPressed: () {
                // Navigate back to the previous screen (pop the current screen off the stack)
                Navigator.pop(context);  // This will pop the current page and return to the previous one
              },
            ),
            SizedBox(width: 10,),
            Text("Latest News",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Ensure text is visible on background
              ),),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
        actions: [
          if (notifications.any((n) => !n["read"]))
            TextButton(
              onPressed: markAllAsRead,
              child: Text("Mark All as Read", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? Center(child: Text("No new notifications"))
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];

          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => deleteNotification(index),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              leading: Icon(
                Icons.newspaper,
                color: notification["read"] ? Colors.grey : Colors.blue,
              ),
              title: Text(
                notification["title"],
                style: TextStyle(
                  fontWeight: notification["read"] ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Text(notification["time"]),
              tileColor: notification["read"] ? Colors.white : Colors.blue[50],
              onTap: () {
                setState(() {
                  notifications[index]["read"] = true;
                });
                widget.onNotificationCountChanged(getUnreadNotificationCount());
              },
            ),
          );
        },
      ),
    );
  }
}
