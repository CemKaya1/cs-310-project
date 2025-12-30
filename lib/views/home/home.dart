import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs_310_project/services/firestore_service.dart';

//Home page
//Displays a welcome message and basic user information
class OutfitlyHomePage extends StatefulWidget {
  const OutfitlyHomePage({super.key});

  @override
  State<OutfitlyHomePage> createState() => _OutfitlyHomePageState();
}

class _OutfitlyHomePageState extends State<OutfitlyHomePage> {
  /// Firestore service for user-related database operations
  final FirestoreService _service = FirestoreService();

  @override
  void initState() {
    super.initState();

    //Ensures that the logged-in user has a document in Firestore
    //If it does not exist, it is created automatically
    _service.ensureUserDoc();
  }

  @override
  Widget build(BuildContext context) {
    //Theme colors and text styles
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    //Currently authenticated Firebase user
    final user = FirebaseAuth.instance.currentUser;

    //If the user is not authenticated, show a fallback screen
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("Not logged in"),
        ),
      );
    }

    //Stream that listens to the user's Firestore document in real time
    final userDocStream = _service.userDocStream();

    return Scaffold(
      backgroundColor: scheme.background,

      //App Bar
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes back button
        backgroundColor: scheme.surface,
        elevation: 0,
        centerTitle: true,

        title: Text(
          "Home",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: scheme.onSurface,
          ),
        ),

        / Profile icon navigates to the profile page
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "/profile"),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: scheme.primaryContainer,

                //Profile image (falls back to icon if loading fails)
                child: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/6325/6325109.png",
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      color: scheme.onPrimaryContainer,
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),

      //Page Content
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Outfitly",
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: scheme.onBackground,
              ),
            ),

            const SizedBox(height: 8),

            //Welcome message
            Text(
              "Welcome Back!",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: scheme.onBackground,
              ),
            ),

            const SizedBox(height: 12),

            //Short description of the app
            Text(
              "Organize your wardrobe and plan your perfect outfits",
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: scheme.onBackground.withOpacity(0.85),
              ),
            ),

            const SizedBox(height: 24),

            //Firestore Real-time Data
            StreamBuilder(
              stream: userDocStream,
              builder: (context, snapshot) {
                //Show loading indicator while waiting for Firestore data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                //Fallback if no data is available
                if (!snapshot.hasData || snapshot.data == null) {
                  return Text(
                    "Loading user...",
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onBackground.withOpacity(0.85),
                    ),
                  );
                }

                //Extract Firestore document data
                final raw = snapshot.data!.data();
                final data = raw is Map<String, dynamic> ? raw : null;

                //Email resolution priority:
                //Firestore user document
                //FirebaseAuth user email
                //Fallback value
                final email =
                    (data?["email"] as String?) ??
                    user.email ??
                    "unknown";

                return Text(
                  "Logged in as: $email",
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onBackground.withOpacity(0.85),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
