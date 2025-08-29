class NewsArticle {
  final String? title;
  final String? author;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? content;

  NewsArticle({
    this.title,
    this.author,
    this.description,
    this.url,
    this.urlToImage,
    this.content,
  });

  // Factory constructor to create a NewsArticle from JSON
  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'],
      author: json['author'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      content: json['content'],
    );
  }
}




class NewsTopHeadlines {
  final String? title;
  final String? author;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  NewsTopHeadlines({
    this.title,
    this.author,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory NewsTopHeadlines.fromJson(Map<String, dynamic> json) {
    return NewsTopHeadlines(
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