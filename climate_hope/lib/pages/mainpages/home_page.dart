import 'package:climate_hope/widget/build_user_info_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:climate_hope/classfolder/newsartical.dart';
import 'package:climate_hope/widget/build_news_card.dart';
import 'package:climate_hope/classfolder/newsservice.dart';
import 'package:climate_hope/widget/build_quick_action.dart';

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

  // Static cache variables
  static List<NewsArticle>? _cachedClimateNews;
  static DateTime? _cacheTimestamp;
  static const Duration _cacheDuration = Duration(minutes: 5);

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

    // Check if cached news exists and is not stale
    if (_cachedClimateNews != null &&
        _cacheTimestamp != null &&
        DateTime.now().difference(_cacheTimestamp!) < _cacheDuration) {
      if (mounted) {
        setState(() {
          _climateNews = _cachedClimateNews!;
          _isLoadingNews = false;
        });
      }
      return; // Use cached data
    }

    // If no cache or cache is stale, fetch from API
    try {
      final news = await _newsService.fetchClimateNews();
      if (mounted) {
        setState(() {
          _climateNews = news;
          _cachedClimateNews = news; 
          _cacheTimestamp = DateTime.now(); 
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

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              buildUserInfoSection(),
              const SizedBox(height: 30),

              // --- Quick Actions/Navigation ---//

              buildQuickActions(context),
              const SizedBox(height: 40),

              // --- Climate News Section ---//
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
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  _climateNews.length > 5 ? 5 : _climateNews.length,
                              itemBuilder: (context, index) {
                                final article = _climateNews[index];
                                return buildNewsCard(article);
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
}