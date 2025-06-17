import 'dart:io'; // For File operations (needed by image_picker)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:climate_hope/provider/user_provider.dart';
import 'package:climate_hope/authpages/signin.dart'; // For logout navigation
import 'package:image_picker/image_picker.dart'; // Import image_picker

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = "Loading...";
  String _userEmail = "loading@example.com";
  String _userAddress = "Loading...";
  String _userMobileNumber = "Loading...";
  // Initial default image path for assets
  String _profileImageUrl = "assets/images/placeholder_profile.png";

  bool _isEditingAboutMe = false; // State for editing "About Me"
  final TextEditingController _aboutMeController = TextEditingController(); // Controller for "About Me" text field
  
  // _isLoading is now primarily for the Logout button or any other future network operations.
  // It's removed from image/about me edit, as they are local.
  bool _isLoading = false; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData(); // Load user data when dependencies change
  }

  // Helper method to load user data from provider
  void _loadUserData() {
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.currentUser != null) {
      final user = userProvider.currentUser!;
      _userName = user['name'] ?? "No Name";
      _userEmail = user['email'] ?? "no_email@example.com";
      _userAddress = user['address'] ?? "No Address Provided";
      _userMobileNumber = user['mobileNumber'] ?? "No Mobile Number";
      
      // Update local _profileImageUrl from provider's current user data
      _profileImageUrl = user['profilePic'] != null && user['profilePic'].isNotEmpty
          ? user['profilePic']
          : "assets/images/placeholder_profile.png";

      // Update _aboutMeController text from provider's current user data
      _aboutMeController.text = user['aboutMe'] ?? "Passionate about climate action and environmental sustainability. Working towards a greener future.";
    }
  }

  // --- Image Picking and Local Update Function ---
  Future<void> _pickProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    // Use .gallery for photo library, .camera for camera
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return; // User cancelled picking

    // Get the UserProvider instance to update shared state
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Create a mutable copy of the current user data
    Map<String, dynamic> updatedUser = Map.from(userProvider.currentUser ?? {}); 
    
    // Update the 'profilePic' field in the map with the new image path
    updatedUser['profilePic'] = image.path; // Store the local file path

    // Update the UserProvider and notify listeners (ProfilePage will rebuild via _loadUserData)
    userProvider.setUser(updatedUser);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated locally!')),
      );
    }
  }

  // --- About Me Local Save Function ---
  void _saveAboutMe() {
    // Get the UserProvider instance to update shared state
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Create a mutable copy of the current user data
    Map<String, dynamic> updatedUser = Map.from(userProvider.currentUser ?? {});
    
    // Update the 'aboutMe' field in the map with the new text
    updatedUser['aboutMe'] = _aboutMeController.text.trim();

    // Update the UserProvider and notify listeners
    userProvider.setUser(updatedUser);

    setState(() {
      _isEditingAboutMe = false; // Exit editing mode
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('About Me updated locally!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF222222),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/signin_img.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        // Determine if it's a network URL or a local file path
                        backgroundImage: _profileImageUrl.startsWith('http') || _profileImageUrl.startsWith('https')
                            ? NetworkImage(_profileImageUrl) as ImageProvider<Object>
                            : FileImage(File(_profileImageUrl)), // Use FileImage for local paths
                        backgroundColor: Colors.grey[200],
                        onBackgroundImageError: (exception, stackTrace) {
                          // Fallback to asset image if file/network image fails to load
                          setState(() {
                            _profileImageUrl = "assets/images/placeholder_profile.png";
                          });
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickProfilePicture, // Call the local pick function
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary, // Use theme primary color
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _userName,
                    style: GoogleFonts.lato(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _userEmail,
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),

                  _buildProfileInfoCard(
                    title: "Address",
                    content: _userAddress,
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 20),

                  _buildProfileInfoCard(
                    title: "Mobile Number",
                    content: _userMobileNumber,
                    icon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 20),

                  // --- About Me Section (with Edit option) ---
                  _buildAboutMeCard(),
                  const SizedBox(height: 40),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () {
                        // Clear user data from the provider on logout
                        Provider.of<UserProvider>(context, listen: false).clearUser();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const Signin()),
                          (Route<dynamic> route) => false,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logged out successfully!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.black, width: 1.5),
                        ),
                        elevation: 2,
                        shadowColor: Colors.black,
                      ),
                      child: _isLoading // If you have other loading operations, keep this
                          ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black))
                          : Text(
                              "LOGOUT",
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- New Widget for About Me Card with Edit functionality ---
  Widget _buildAboutMeCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
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
                  controller: _aboutMeController,
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
                  _aboutMeController.text, // Display the stored content
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
        ],
      ),
    );
  }
}