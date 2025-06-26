import 'dart:convert';
import 'package:climate_hope/pages/climate_page.dart';
import 'package:climate_hope/pages/weather_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // For opening news links

// --- News Article Model ---
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NewsService _newsService = NewsService();
  List<NewsArticle> _climateNews = [];
  bool _isLoadingNews = true;
  String? _newsErrorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() {
      _isLoadingNews = true;
      _newsErrorMessage = null;
    });
    try {
      final news = await _newsService.fetchClimateNews();
      if (mounted) {
        setState(() {
          _climateNews = news;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _newsErrorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingNews = false;
        });
      }
    }
  }

  // Function to launch URL
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Global Climate Hub",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 62, 218, 134),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/signin_img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- User Info Section ---
              _buildUserInfoSection(),
              const SizedBox(height: 30),

              // --- Quick Actions/Navigation ---
              _buildQuickActions(context),
              const SizedBox(height: 40),

              // --- Climate News Section ---
              Text(
                "Latest Climate News",
                style: GoogleFonts.lato(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: const [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black38,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _isLoadingNews
                  ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : _newsErrorMessage != null
                  ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Failed to load news: $_newsErrorMessage",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _fetchNews,
                            icon: const Icon(
                              Icons.refresh,
                              color: Color.fromARGB(255, 1, 39, 2),
                            ),
                            label: Text(
                              'Retry News',
                              style: GoogleFonts.lato(
                                color: Color.fromARGB(255, 1, 39, 2),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : _climateNews.isEmpty
                  ? Center(
                    child: Text(
                      "No climate news available at the moment.",
                      style: GoogleFonts.lato(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  )
                  : ListView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // Important for nested scrolling
                    shrinkWrap: true,
                    itemCount:
                        _climateNews.length > 5
                            ? 5
                            : _climateNews.length, // Display top 5 articles
                    itemBuilder: (context, index) {
                      final article = _climateNews[index];
                      return _buildNewsCard(article);
                    },
                  ),
              const SizedBox(height: 20),
              if (_climateNews.isNotEmpty)
                Center(
                  child: TextButton(
                    onPressed: () {
                      _launchUrl(
                        'https://news.google.com/search?q=climate%20change',
                      );
                    },
                    child: Text(
                      "View More Climate News",
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white54),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Colors.green[800]),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, Climate Explorer!",
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: const [
                    Shadow(
                      blurRadius: 3.0,
                      color: Colors.black38,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Today: June 18, 2025", // Hardcoded date for now
                style: GoogleFonts.lato(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: GoogleFonts.lato(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: const [
              Shadow(
                blurRadius: 5.0,
                color: Colors.black38,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(
              context,
              icon: Icons.cloud,
              label: "Local Weather",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WeatherPage()),
                );
              },
            ),
            _buildActionButton(
              context,
              icon: Icons.eco,
              label: "Climate Learn",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClimatePage()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 40,
              color: const Color.fromARGB(255, 1, 89, 46),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildNewsCard(NewsArticle article) {
    return GestureDetector(
      onTap: () => _launchUrl(article.url),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    article.imageUrl!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 5),
              if (article.description != null)
                Text(
                  article.description!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    article.sourceName ?? 'Unknown Source',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  if (article.publishedAt != null)
                    Text(
                      '${article.publishedAt!.day}/${article.publishedAt!.month}/${article.publishedAt!.year}',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
