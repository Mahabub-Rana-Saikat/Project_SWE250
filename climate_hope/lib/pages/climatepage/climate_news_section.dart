import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:climate_hope/classfolder/newsartical.dart';
import 'package:climate_hope/widget/build_news_card.dart';
import 'package:url_launcher/url_launcher.dart';

class ClimateNewsSection extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final List<NewsArticle> climateNews;
  final VoidCallback onRetry;

  const ClimateNewsSection({
    Key? key,
    required this.isLoading,
    required this.errorMessage,
    required this.climateNews,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 10),
            Text(
              "Failed to load news: $errorMessage",
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: Color(0xFF012702)),
              label: Text(
                'Retry News',
                style: GoogleFonts.lato(color: Color(0xFF012702)),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            ),
          ],
        ),
      );
    }

    if (climateNews.isEmpty) {
      return Center(
        child: Text(
          "No climate news available at the moment.",
          style: GoogleFonts.lato(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: climateNews.length.clamp(0, 5),
          itemBuilder: (context, index) => buildNewsCard(climateNews[index]),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: () async {
              final Uri uri = Uri.parse(
                  'https://news.google.com/search?q=climate%20change');
              if (await canLaunchUrl(uri)) {
                launchUrl(uri);
              }
            },
            child: Text(
              "View More Climate News",
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
