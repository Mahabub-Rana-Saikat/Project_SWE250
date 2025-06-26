import 'dart:convert'; // For jsonDecode if simulating or using real HTTP
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching external URLs

// --- Initiative Data Model ---
class ClimateInitiative {
  final String id;
  final String title;
  final String description;
  final String organization;
  final String location;
  final String status;
  final String? learnMoreUrl;

  ClimateInitiative({
    required this.id,
    required this.title,
    required this.description,
    required this.organization,
    required this.location,
    required this.status,
    this.learnMoreUrl,
  });

  factory ClimateInitiative.fromJson(Map<String, dynamic> json) {
    return ClimateInitiative(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      organization: json['organization'],
      location: json['location'],
      status: json['status'],
      learnMoreUrl: json['learnMoreUrl'],
    );
  }
}

// --- Climate Initiatives Page ---
class ClimateInitiativesPage extends StatefulWidget {
  const ClimateInitiativesPage({super.key});

  @override
  State<ClimateInitiativesPage> createState() => _ClimateInitiativesPageState();
}

class _ClimateInitiativesPageState extends State<ClimateInitiativesPage> {
  List<ClimateInitiative> _initiatives = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchInitiatives();
  }

  Future<void> _fetchInitiatives() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // --- SIMULATED API CALL ---
      // In a real application, you would replace this with an actual HTTP request
      // using the 'http' package to a real API endpoint.
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

      const String simulatedJsonData = """
      [
        {
          "id": "1",
          "title": "Global Reforestation Project",
          "description": "An initiative to plant 1 billion trees worldwide by 2030 to combat deforestation and sequester carbon. Focuses on areas with high ecological impact.",
          "organization": "Green Earth Alliance",
          "location": "Global",
          "status": "Ongoing",
          "learnMoreUrl": "https://www.globalforestwatch.org/about-us/tree-planting/"
        },
        {
          "id": "2",
          "title": "Ocean Plastic Cleanup",
          "description": "Developing innovative technologies and deploying cleanup operations to remove plastic waste from oceans, rivers, and coastlines.",
          "organization": "Ocean Savers Foundation",
          "location": "Pacific Ocean, Major Rivers",
          "status": "In Progress",
          "learnMoreUrl": "https://theoceancleanup.com/about-us/"
        },
        {
          "id": "3",
          "title": "Sustainable Urban Farming",
          "description": "Promoting and implementing vertical farms, rooftop gardens, and community plots in urban areas to enhance local food security and reduce transport emissions.",
          "organization": "City Harvest Network",
          "location": "Various Cities Worldwide",
          "status": "Expanding",
          "learnMoreUrl": "https://www.urbanfarming.org/what-we-do/"
        },
        {
          "id": "4",
          "title": "Renewable Energy Transition Fund",
          "description": "Providing financial support, grants, and technical assistance to accelerate the global transition from fossil fuels to clean, renewable energy sources.",
          "organization": "Clean Energy Investment Group",
          "location": "Worldwide",
          "status": "Active",
          "learnMoreUrl": "https://www.irena.org/Finance/Funding-and-Finance-Mechanisms"
        },
        {
          "id": "5",
          "title": "Coral Reef Restoration",
          "description": "Dedicated efforts to restore and protect endangered coral reef ecosystems through innovative scientific methods and community engagement.",
          "organization": "Reef Guardians",
          "location": "Caribbean, Great Barrier Reef",
          "status": "Active",
          "learnMoreUrl": "https://coral.org/coral-reefs-101/coral-reef-conservation/restoration/"
        },
        {
          "id": "6",
          "title": "Climate Education for Youth",
          "description": "Empowering the next generation with knowledge about climate change, its impacts, and solutions through educational programs and workshops.",
          "organization": "Future Climate Leaders",
          "location": "Schools Globally",
          "status": "Ongoing",
          "learnMoreUrl": "https://www.unicef.org/press-releases/climate-education-key-building-sustainable-future"
        }
      ]
      """;

      final List<dynamic> jsonList = json.decode(simulatedJsonData);
      final List<ClimateInitiative> loadedInitiatives = jsonList
          .map((json) => ClimateInitiative.fromJson(json))
          .toList();

      if (mounted) {
        setState(() {
          _initiatives = loadedInitiatives;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load initiatives: $e';
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
          "Climate Initiatives",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 62, 218, 134), // Main green
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 120, 230, 180), // Lighter green
              Color.fromARGB(255, 62, 218, 134), // Main green
              Color.fromARGB(255, 1, 89, 46), // Darker green
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _fetchInitiatives,
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
                              onPressed: _fetchInitiatives,
                              icon: const Icon(Icons.refresh,
                                  color: Color.fromARGB(255, 1, 39, 2)),
                              label: Text(
                                'Retry',
                                style: GoogleFonts.lato(
                                  color: Color.fromARGB(255, 1, 39, 2),
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
                  : _initiatives.isEmpty
                      ? Center(
                          child: Text(
                            "No climate initiatives found. Try again later!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                color: Colors.white70, fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: _initiatives.length,
                          itemBuilder: (context, index) {
                            final initiative = _initiatives[index];
                            return Card(
                              elevation: 5,
                              margin: const EdgeInsets.only(bottom: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              color: Colors.white.withOpacity(0.95), // Slightly transparent white
                              child: InkWell(
                                onTap: initiative.learnMoreUrl != null
                                    ? () => _launchURL(initiative.learnMoreUrl!)
                                    : null, // Only tap if URL exists
                                borderRadius: BorderRadius.circular(15),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        initiative.title,
                                        style: GoogleFonts.lato(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(255, 1, 39, 2),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        initiative.description,
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Organization: ${initiative.organization}',
                                                style: GoogleFonts.lato(
                                                  fontSize: 13,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              Text(
                                                'Location: ${initiative.location}',
                                                style: GoogleFonts.lato(
                                                  fontSize: 13,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: initiative.status == "Ongoing" || initiative.status == "Active"
                                                  ? Colors.green[100]
                                                  : Colors.orange[100],
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              initiative.status,
                                              style: GoogleFonts.lato(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: initiative.status == "Ongoing" || initiative.status == "Active"
                                                    ? Colors.green[800]
                                                    : Colors.orange[800],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (initiative.learnMoreUrl != null) ...[
                                        const SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'Tap to learn more',
                                            style: GoogleFonts.lato(
                                              fontSize: 13,
                                              color: Colors.blue[700],
                                              fontStyle: FontStyle.italic,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
        ),
      ),
    );
  }
}