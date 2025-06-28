import 'dart:convert'; 
import 'package:climate_hope/classfolder/climateclass/climateimpact.dart';
import 'package:climate_hope/classfolder/climateclass/globalmatric.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// --- Data Models ---



// --- Impact Page Widget ---
class ImpactPage extends StatefulWidget {
  const ImpactPage({super.key});

  @override
  State<ImpactPage> createState() => _ImpactPageState();
}

class _ImpactPageState extends State<ImpactPage> {
  List<GlobalMetric> _globalMetrics = [];
  List<ClimateImpactCategory> _impactCategories = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchImpactData();
  }

  Future<void> _fetchImpactData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      
      await Future.delayed(const Duration(seconds: 1));

      
      const String simulatedMetricsJson = """
      [
        {
          "label": "Current CO2 Level",
          "value": "425",
          "unit": "ppm",
          "description": "Parts per million. Highest in over 800,000 years, contributing significantly to global warming.",
          "learnMoreUrl": "https://climate.nasa.gov/vital-signs/carbon-dioxide/"
        },
        {
          "label": "Global Temperature Anomaly",
          "value": "+1.1",
          "unit": "°C",
          "description": "Increase above pre-industrial levels. Target is to limit warming to 1.5°C.",
          "learnMoreUrl": "https://climate.nasa.gov/vital-signs/global-temperature/"
        }
      ]
      """;

      const String simulatedCategoriesJson = """
      [
        {
          "id": "1",
          "title": "Rising Global Temperatures",
          "description": "The Earth's average surface temperature has risen by about 1.1 degrees Celsius (2.0 degrees Fahrenheit) since the late 19th century, driven by human activities. This warming accelerates climate impacts.",
          "iconName": "thermostat",
          "learnMoreUrl": "https://climate.nasa.gov/evidence/"
        },
        {
          "id": "2",
          "title": "Sea Level Rise",
          "description": "Global sea levels are rising at an accelerating rate due to thermal expansion of warming ocean water and melting ice sheets and glaciers, threatening coastal communities.",
          "iconName": "water_level",
          "learnMoreUrl": "https://climate.nasa.gov/vital-signs/sea-level/"
        },
        {
          "id": "3",
          "title": "Extreme Weather Events",
          "description": "Climate change is leading to more frequent and intense heatwaves, droughts, floods, wildfires, and powerful storms, causing widespread damage and disruption.",
          "iconName": "thunderstorm",
          "learnMoreUrl": "https://www.ipcc.ch/report/ar6/wg1/"
        },
        {
          "id": "4",
          "title": "Biodiversity Loss",
          "description": "Changes in temperature and precipitation, along with habitat destruction, are pushing many species to extinction, disrupting ecosystems and natural services.",
          "iconName": "forest",
          "learnMoreUrl": "https://www.worldwildlife.org/threats/climate-change-impacts-on-wildlife"
        },
        {
          "id": "5",
          "title": "Ocean Acidification",
          "description": "As oceans absorb more CO2, their pH levels decrease, making them more acidic. This harms marine life, particularly organisms with shells or skeletons like corals.",
          "iconName": "science",
          "learnMoreUrl": "https://www.noaa.gov/education/resource-collections/ocean-coasts/ocean-acidification"
        },
        {
          "id": "6",
          "title": "Impacts on Human Health",
          "description": "Climate change affects human health through heat stress, respiratory and cardiovascular diseases, spread of vector-borne illnesses, and food and water insecurity.",
          "iconName": "public_health",
          "learnMoreUrl": "https://www.who.int/news-room/fact-sheets/detail/climate-change-and-health"
        }
      ]
      """;

      final List<dynamic> metricsJsonList = json.decode(simulatedMetricsJson);
      final List<GlobalMetric> loadedMetrics =
          metricsJsonList.map((json) => GlobalMetric.fromJson(json)).toList();

      final List<dynamic> categoriesJsonList = json.decode(simulatedCategoriesJson);
      final List<ClimateImpactCategory> loadedCategories =
          categoriesJsonList.map((json) => ClimateImpactCategory.fromJson(json)).toList();

      if (mounted) {
        setState(() {
          _globalMetrics = loadedMetrics;
          _impactCategories = loadedCategories;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load impact data: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Climate Impact",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor:const Color.fromARGB(255, 1, 39, 2),  
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/signin_img.png'),
                  fit: BoxFit.cover,
                ),
        ),
        child: RefreshIndicator(
          onRefresh: _fetchImpactData,
          color: Colors.green,
          backgroundColor: Colors.white,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : _errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 50),
                            const SizedBox(height: 20),
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: _fetchImpactData,
                              icon: const Icon(Icons.refresh,
                                  color: Color.fromARGB(255, 1, 39, 2)),
                              label: Text(
                                'Retry',
                                style: GoogleFonts.lato(
                                  color: const Color.fromARGB(255, 1, 39, 2),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        // --- Section 1: Key Global Metrics ---
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Key Global Climate Metrics",
                                style: GoogleFonts.lato(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 15),
                              GridView.builder(
                                shrinkWrap: true, 
                                physics: const NeverScrollableScrollPhysics(), 
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 2.8, 
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: _globalMetrics.length,
                                itemBuilder: (context, index) {
                                  final metric = _globalMetrics[index];
                                  return Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)),
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: metric.learnMoreUrl != null
                                          ? () => _launchURL(metric.learnMoreUrl!)
                                          : null,
                                      borderRadius: BorderRadius.circular(15),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              metric.label,
                                              style: GoogleFonts.lato(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(255, 1, 39, 2),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.baseline,
                                              textBaseline: TextBaseline.alphabetic,
                                              children: [
                                                Text(
                                                  metric.value,
                                                  style: GoogleFonts.lato(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.red[700], 
                                                  ),
                                                ),
                                                Text(
                                                  ' ${metric.unit}',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              metric.description,
                                              style: GoogleFonts.lato(
                                                fontSize: 13,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            if (metric.learnMoreUrl != null)
                                              Align(
                                                alignment: Alignment.bottomRight,
                                                child: Text(
                                                  'Learn More',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    color: Colors.blue[700],
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        // --- Section 2: Types of Climate Impacts ---
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Types of Climate Impacts",
                                style: GoogleFonts.lato(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 15),
                              GridView.builder(
                                shrinkWrap: true, // Important for nested GridView
                                physics: const NeverScrollableScrollPhysics(), // Disable scrolling of inner GridView
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1, 
                                  childAspectRatio: 2.2, 
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: _impactCategories.length,
                                itemBuilder: (context, index) {
                                  final category = _impactCategories[index];
                                  return Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)),
                                    color: Colors.white.withOpacity(0.95),
                                    child: InkWell(
                                      onTap: category.learnMoreUrl != null
                                          ? () => _launchURL(category.learnMoreUrl!)
                                          : null,
                                      borderRadius: BorderRadius.circular(15),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(category.icon, size: 35, color: const Color.fromARGB(255, 1, 89, 46)),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    category.title,
                                                    style: GoogleFonts.lato(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: const Color.fromARGB(255, 1, 39, 2),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              category.description,
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                color: Colors.grey[700],
                                              ),
                                              maxLines: 3, // Limit description lines
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (category.learnMoreUrl != null)
                                              Align(
                                                alignment: Alignment.bottomRight,
                                                child: Text(
                                                  'Learn More',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    color: Colors.blue[700],
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        // --- Section 3: Additional Resources/Visualizations ---
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Explore More Data & Visualizations",
                                style: GoogleFonts.lato(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 15),
                              _buildExternalLinkButton(
                                context,
                                "NASA Climate Change",
                                "https://climate.nasa.gov/",
                                Icons.public,
                              ),
                              _buildExternalLinkButton(
                                context,
                                "NOAA Climate Data",
                                "https://www.noaa.gov/climate",
                                Icons.insights,
                              ),
                              _buildExternalLinkButton(
                                context,
                                "IPCC Reports",
                                "https://www.ipcc.ch/reports/",
                                Icons.description,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildExternalLinkButton(
      BuildContext context, String title, String url, IconData icon) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: InkWell(
        onTap: () => _launchURL(url),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(icon, size: 30, color: const Color.fromARGB(255, 1, 89, 46)),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 1, 39, 2),
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}