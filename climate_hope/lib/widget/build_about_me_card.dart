import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; 
import 'package:climate_hope/provider/user_provider.dart'; 


class BuildAboutMeCard extends StatefulWidget {
  final String initialAboutMe; 

  const BuildAboutMeCard({Key? key, required this.initialAboutMe}) : super(key: key);

  @override
  _BuildAboutMeCardState createState() => _BuildAboutMeCardState();
}

class _BuildAboutMeCardState extends State<BuildAboutMeCard> {
  late TextEditingController _aboutMeController; 
  bool _isEditingAboutMe = false;

  @override
  void initState() {
    super.initState();
    _aboutMeController = TextEditingController(text: widget.initialAboutMe);
  }

  @override
  void dispose() {
    _aboutMeController.dispose();
    super.dispose();
  }

  void _saveAboutMe() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Get a mutable copy of the current user data
    Map<String, dynamic> updatedUser = Map.from(userProvider.currentUser ?? {});

    // Update the 'aboutMe' field
    updatedUser['aboutMe'] = _aboutMeController.text.trim();

    // Set the updated user data in the provider
    userProvider.setUser(updatedUser);

    setState(() {
      _isEditingAboutMe = false; // Exit editing mode
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('About Me updated locally!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white, size: 28),
                  const SizedBox(width: 16),
                  Text(
                    "About Me",
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _isEditingAboutMe ? Icons.check_circle_outline : Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (_isEditingAboutMe) {
                    _saveAboutMe(); // Save changes when pressing check icon
                  }
                  setState(() {
                    _isEditingAboutMe = !_isEditingAboutMe; // Toggle editing mode
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          _isEditingAboutMe
              ? TextFormField(
                  controller: _aboutMeController, // Use the local controller
                  maxLines: 4,
                  minLines: 1,
                  style: GoogleFonts.lato(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Tell us about yourself...',
                    hintStyle: GoogleFonts.lato(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF333333),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onFieldSubmitted: (_) => _saveAboutMe(), // Save on keyboard submit
                )
              : Text(
                  _aboutMeController.text, // Display text from the local controller
                  style: GoogleFonts.lato(fontSize: 16, color: Colors.white70),
                ),
        ],
      ),
    );
  }
}