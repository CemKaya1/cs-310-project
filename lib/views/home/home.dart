import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs_310_project/services/firestore_service.dart';

//Ana sayfa widgetı
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

    //Kullanıcının Firestore'da bir dokümanı yoksa oluşturur
    _service.ensureUserDoc();
  }

  @override
  Widget build(BuildContext context) {
    //Tema renkleri
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    //Giriş yapmış kullanıcıyı al
    final user = FirebaseAuth.instance.currentUser;

    //Eğer kullanıcı giriş yapmamışsa
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("Not logged in"),
        ),
      );
    }
    //Firestore'daki kullanıcı dokümanını gerçek zamanlı dinleyen stream
    final userDocStream = _service.userDocStream();

    return Scaffold(
      backgroundColor: scheme.background,
      //Üst bar
      appBar: AppBar(
        automaticallyImplyLeading: false, // geri tuşu olmasın
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

        //Sağ üst profil ikonuna tıklayınca profile sayfasına gider
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "/profile"),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: scheme.primaryContainer,

                //İnternetten alınan profil resmi (hata olursa ikon gösterir)
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

      //Sayfa içeriği
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

            //Karşılama mesajı
            Text("Welcome Back!",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: scheme.onBackground,
              ),
            ),

            const SizedBox(height: 12),

            //Açıklama metni
            Text(
              "Organize your wardrobe and plan your perfect outfits",
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: scheme.onBackground.withOpacity(0.85),
              ),
            ),

            const SizedBox(height: 24),

            //Firestore gerçek zamanlı veri gösterimi
            StreamBuilder(
              stream: userDocStream,
              builder: (context, snapshot) {
                //Veri henüz gelmediyse loading göster
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                //Veri yoksa
                if (!snapshot.hasData || snapshot.data == null) {
                  return Text(
                    "Loading user...",
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onBackground.withOpacity(0.85),
                    ),
                  );
                }

                //Firestore verisini Map'e çevir
                final raw = snapshot.data!.data();
                final data = raw is Map<String, dynamic> ? raw : null;

                //Email öncelik sırası:
                //Firestore
                //FirebaseAuth
                //fallback
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
