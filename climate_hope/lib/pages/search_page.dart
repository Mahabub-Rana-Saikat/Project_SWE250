import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _allItems = [
    "Climate Change",
    "Global Warming",
    "Renewable Energy",
    "Sustainable Living",
    "Deforestation",
    "Greenhouse Gases",
    "Recycling",
    "Environmental Policies",
  ];

  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
  }

  void _filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _allItems;
      } else {
        _filteredItems = _allItems
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: _filterSearchResults,
          ),
        ),
        Expanded(
          child: _filteredItems.isEmpty
              ? const Center(child: Text("No results found"))
              : ListView.builder(
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_filteredItems[index]),
                leading: const Icon(Icons.eco, color: Colors.green),
                onTap: () {
                  // Handle search item click
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
