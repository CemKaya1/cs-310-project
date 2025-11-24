import 'package:flutter/material.dart';

class OutfitlyHomePage extends StatelessWidget {
  const OutfitlyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                child: Image.network("https://cdn-icons-png.flaticon.com/512/6325/6325109.png"),
                //Icon(Icons.person_outline,color: scheme.primary,),
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
          ],
        ),
      ),
    );
  }
}
