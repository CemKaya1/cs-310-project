import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs_310_project/services/firestore_service.dart';

//Home page widget
class OutfitlyHomePage extends StatefulWidget {
  const OutfitlyHomePage({super.key});

  @override
  State<OutfitlyHomePage> createState() => _OutfitlyHomePageState();
}

class _OutfitlyHomePageState extends State<OutfitlyHomePage> {
  final FirestoreService _service = FirestoreService();

  @override
  void initState() {
    super.initState();

    //If the user doesn't have a document in Firestore, it creates one
    _service.ensureUserDoc();
  }

  @override
  Widget build(BuildContext context) {
    //Theme colors
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    //Get logged-in user
    final user = FirebaseAuth.instance.currentUser;

    //If the user is not logged in
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("Not logged in"),
        ),
      );
    }
    //A stream that listens to user documentation in Firestore in real time
    final userDocStream = _service.userDocStream();

    return Scaffold(
      backgroundColor: scheme.background,
      //Top bar
      appBar: AppBar(
        automaticallyImplyLeading: false, //no back button
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

        //Clicking the profile icon in the upper right corner takes you to the profile page
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "/profile"),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: scheme.primaryContainer,

                //Profile picture (shows an icon if there is an error)
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

      //Page content
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Outfitly",
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: scheme.onBackground,
              ),
            ),

            const SizedBox(height: 8),

            //Welcome message
            Text("Welcome Back!",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: scheme.onBackground,
              ),
            ),

            const SizedBox(height: 12),

            //Explanatory text
            Text(
              "Organize your wardrobe and plan your perfect outfits",
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: scheme.onBackground.withOpacity(0.85),
              ),
            ),

            const SizedBox(height: 24),

            //Firestore real-time data display
            StreamBuilder(
              stream: userDocStream,
              builder: (context, snapshot) {
                //Veri henüz gelmediyse loading göster
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                //If there is no data
                if (!snapshot.hasData || snapshot.data == null) {
                  return Text(
                    "Loading user...",
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onBackground.withOpacity(0.85),
                    ),
                  );
                }

                //Convert Firestore data to Map
                final raw = snapshot.data!.data();
                final data = raw is Map<String, dynamic> ? raw : null;

                final email =
                    (data?["email"] as String?) ?? //Firestore is checked first
                    user.email ?? //If Firestore is null FirebaseAuth is checked
                    "unknown"; //Fallback if FirebaseAuth is null

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
