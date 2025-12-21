import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OutfitlyHomePage extends StatefulWidget {
  const OutfitlyHomePage({super.key});

  @override
  State<OutfitlyHomePage> createState() => _OutfitlyHomePageState();
}

class _OutfitlyHomePageState extends State<OutfitlyHomePage> {
  @override
  void initState() {
    super.initState();
    _ensureUserDoc();
  }

  Future<void> _ensureUserDoc() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseFirestore.instance.collection("users").doc(user.uid);
    final snap = await ref.get();

    if (!snap.exists) {
      await ref.set({
        "uid": user.uid,
        "email": user.email ?? "",
        "createdAt": FieldValue.serverTimestamp(),
      });
    } else {
      // İstersen "last seen" güncelle (optional)
      await ref.update({
        "lastSeen": FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Not logged in")),
      );
    }

    final userDocStream =
    FirebaseFirestore.instance.collection("users").doc(user.uid).snapshots();

    return Scaffold(
      backgroundColor: scheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "/profile"),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: scheme.primaryContainer,
                child: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/6325/6325109.png",
                ),
              ),
            ),
          )
        ],
      ),
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
            Text(
              "Welcome Back!",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: scheme.onBackground,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Organize your wardrobe and plan your perfect outfits",
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: scheme.onBackground.withOpacity(0.85),
              ),
            ),

            const SizedBox(height: 24),


            StreamBuilder<DocumentSnapshot>(
              stream: userDocStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final data = snapshot.data!.data() as Map<String, dynamic>?;
                final email = data?["email"] ?? user.email ?? "unknown";

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
