
class NewsArticle {
  final String title;
  final String? description;
  final String url;
  final String? imageUrl;
  final String? sourceName;
  final DateTime? publishedAt;

  NewsArticle({
    required this.title,
    this.description,
    required this.url,
    this.imageUrl,
    this.sourceName,
    this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      description: json['description'],
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'],
      sourceName: json['source']['name'],
      publishedAt:
          json['publishedAt'] != null
              ? DateTime.tryParse(json['publishedAt'])
              : null,
    );
  }
}
