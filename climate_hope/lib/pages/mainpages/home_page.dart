import 'package:climate_hope/widget/build_user_info_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:climate_hope/classfolder/newsartical.dart';
import 'package:climate_hope/classfolder/newsservice.dart';
import 'package:climate_hope/widget/build_quick_action.dart';
import 'package:climate_hope/pages/climatepage/climate_news_section.dart';

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
      
              buildUserInfoSection(),
              const SizedBox(height: 30),
              buildQuickActions(context),
              const SizedBox(height: 40),
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
            ClimateNewsSection(
              isLoading: _isLoadingNews,
              errorMessage: _newsErrorMessage,
              climateNews: _climateNews,
              onRetry: _fetchNews,
            ),
            ],
          ),
        ),
      ),
    );
  }
}