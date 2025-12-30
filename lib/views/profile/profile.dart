import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Profile settings screen
//The dark mode state is controlled by the parent widget
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.isDarkModeEnabled,
    required this.onDarkModeChanged,
  });

  //Boolean value that indicates whether dark mode is enabled
  final bool isDarkModeEnabled;

  //Callback that notifies the parent when dark mode changes
  final ValueChanged<bool> onDarkModeChanged;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //Local dark mode state for the Switch widget
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    //Initialize local state from parent value
    _isDarkMode = widget.isDarkModeEnabled;
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    //If the parent widget updates the dark mode value,
    //sync the local state accordingly
    if (oldWidget.isDarkModeEnabled != widget.isDarkModeEnabled) {
      setState(() => _isDarkMode = widget.isDarkModeEnabled);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Theme color scheme
    final scheme = Theme.of(context).colorScheme;

    //Currently logged-in Firebase user
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: scheme.background,

      //App bar
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profile Settings",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      //Page content
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 32),

            //Profile picture
            CircleAvatar(
              radius: 48,
              backgroundColor: scheme.primaryContainer,
              child: Image.network(
                "https://cdn-icons-png.flaticon.com/512/6325/6325109.png",

                //Show a default icon if the image fails to load
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    size: 40,
                    color: scheme.onPrimaryContainer,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            //User role / static title
            Text(
              "Fashion Enthusiast",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: scheme.onBackground,
              ),
            ),

            //Display user's email if available
            if (user?.email != null) ...[
              const SizedBox(height: 6),
              Text(
                user!.email!,
                style: TextStyle(
                  fontSize: 14,
                  color: scheme.onBackground.withOpacity(0.7),
                ),
              ),
            ],
            const SizedBox(height: 32),

            //Dark mode settings container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: scheme.shadow.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.nights_stay_outlined, color: scheme.onSurface),
                  const SizedBox(width: 12),

                  //Dark mode label
                  Expanded(
                    child: Text(
                      "Dark Mode",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),

                  Switch(
                    value: _isDarkMode,
                    activeColor: scheme.primary,
                    onChanged: (val) {
                      // Update local state
                      setState(() => _isDarkMode = val);

                      //Notify parent widget
                      widget.onDarkModeChanged(val);
                    },
                  ),
                ],
              ),
            ),
             //Fills remaining space so the button stays at the bottom
            const Spacer(),

            //Log out button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  //Sign out from Firebase
                  await FirebaseAuth.instance.signOut();

                  if (!mounted) return;

                  //Navigate back to the root(login screen)
                  Navigator.of(context)
                      .popUntil((route) => route.isFirst);
                },
                child: const Text(
                  "Log Out",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
