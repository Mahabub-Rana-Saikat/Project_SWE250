import 'dart:io';
import 'package:climate_hope/widget/build_about_me_card.dart'; // Import the updated widget
import 'package:climate_hope/widget/buildprofile_info_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:climate_hope/provider/user_provider.dart';
import 'package:climate_hope/authpages/signin.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String userName = "Loading...";
  String userEmail = "loading@example.com";
  String userAddress = "Loading...";
  String userMobileNumber = "Loading...";
  String profileImageUrl = "assets/images/placeholder_profile.png";

  // These will now be managed by BuildAboutMeCard, but we need to pass initial data
  // bool isEditingAboutMe = false;
  // final TextEditingController _aboutMeController = TextEditingController();

  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  void _loadUserData() {
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.currentUser != null) {
      final user = userProvider.currentUser!;
      userName = user['name'] ?? "No Name";
      userEmail = user['email'] ?? "no_email@example.com";
      userAddress = user['address'] ?? "No Address Provided";
      userMobileNumber = user['mobileNumber'] ?? "No Mobile Number";

      // Update local _profileImageUrl from provider's current user data
      profileImageUrl = user['profilePic'] != null && user['profilePic'].isNotEmpty
          ? user['profilePic']
          : "assets/images/placeholder_profile.png";

      // The _aboutMeController will now be initialized within BuildAboutMeCard,
      // but we still get the initial 'aboutMe' text here to pass it.
      // _aboutMeController.text = user['aboutMe'] ?? "Passionate about climate action and environmental sustainability. Working towards a greener future.";
    }
  }

  Future<void> _pickProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    Map<String, dynamic> updatedUser = Map.from(userProvider.currentUser ?? {});
    updatedUser['profilePic'] = image.path;
    userProvider.setUser(updatedUser);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated locally!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context); // Access provider here to pass data
    final String initialAboutMe = userProvider.currentUser?['aboutMe'] ??
        "Passionate about climate action and environmental sustainability. Working towards a greener future.";

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
                        backgroundImage: profileImageUrl.startsWith('http') ||
                                profileImageUrl.startsWith('https')
                            ? NetworkImage(profileImageUrl) as ImageProvider<Object>
                            : FileImage(
                                File(profileImageUrl),
                              ), // Use FileImage for local paths
                        backgroundColor: Colors.grey[200],
                        onBackgroundImageError: (exception, stackTrace) {
                          // Fallback to asset image if file/network image fails to load
                          setState(() {
                            profileImageUrl = "assets/images/placeholder_profile.png";
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
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    userName,
                    style: GoogleFonts.lato(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userEmail,
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),

                  buildProfileInfoCard(
                    title: "Address",
                    content: userAddress,
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 20),

                  buildProfileInfoCard(
                    title: "Mobile Number",
                    content: userMobileNumber,
                    icon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 20),

                  // --- About Me Section (with Edit option) ---
                  // Now pass the initial aboutMe text to the BuildAboutMeCard widget
                  BuildAboutMeCard(
                    initialAboutMe: initialAboutMe,
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              // Clear user data from the provider on logout
                              Provider.of<UserProvider>(
                                context,
                                listen: false,
                              ).clearUser();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Signin(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Logged out successfully!'),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                        ),
                        elevation: 2,
                        shadowColor: Colors.black,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            )
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
}