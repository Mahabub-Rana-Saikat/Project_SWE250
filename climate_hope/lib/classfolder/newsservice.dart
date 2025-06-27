import 'package:http/http.dart' as http;
import 'package:climate_hope/classfolder/newsartical.dart';
import 'dart:convert';

class NewsService {
  static const String _apiKey = 'a45fc5391fc04a95a7945f6fd9b110b8';
  static const String _baseUrl = 'https://newsapi.org/v2/everything';

  Future<List<NewsArticle>> fetchClimateNews() async {
    if (_apiKey == 'YOUR_NEWS_API_KEY' || _apiKey.isEmpty) {
      throw Exception(
        'NewsAPI Key is not set. Please get one from newsapi.org',
      );
    }

    final uri = Uri.parse(
      '$_baseUrl?qInTitle=climate%20change%20OR%20global%20warming%20OR%20environment&language=en&sortBy=publishedAt&apiKey=$_apiKey',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'ok') {
          List<dynamic> articlesJson = jsonResponse['articles'];
          return articlesJson
              .map((json) => NewsArticle.fromJson(json))
              .where((article) => article.url.isNotEmpty)
              .toList();
        } else {
          throw Exception('News API status not OK: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
          'Failed to load news: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      print('Error fetching news: $e');
      throw Exception('Error fetching news: $e');
    }
  }
}
