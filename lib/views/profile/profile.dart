import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Profil ayarları ekranı
//Dark mode state'i parent widget'tan gelir
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.isDarkModeEnabled,
    required this.onDarkModeChanged,
  });

  //Dark modun açılıp açılmadığını kontrol eden bool value
  final bool isDarkModeEnabled;

  //Dark mode değiştiğinde parent'a haber veren callback
  final ValueChanged<bool> onDarkModeChanged;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //Switch için lokal dark mode state'i
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();

    _isDarkMode = widget.isDarkModeEnabled;
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    //Parent widget dark mode değerini değiştirdiyse
    //bu ekranın state'ini de güncelle
    if (oldWidget.isDarkModeEnabled != widget.isDarkModeEnabled) {
      setState(() => _isDarkMode = widget.isDarkModeEnabled);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Tema renkleri
    final scheme = Theme.of(context).colorScheme;

    //Firebase'deki giriş yapmış kullanıcı
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: scheme.background,

      //Üst bar
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

      //Sayfa içeriği
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 32),

            //Profil fotoğrafı
            CircleAvatar(
              radius: 48,
              backgroundColor: scheme.primaryContainer,
              child: Image.network(
                "https://cdn-icons-png.flaticon.com/512/6325/6325109.png",

                //İnternet hatası olursa ikon göster
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

            //Kullanıcı rolü / sabit başlık
            Text(
              "Fashion Enthusiast",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: scheme.onBackground,
              ),
            ),

            //Kullanıcının emaili varsa göster
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

            //Dark Mode ayar kutusu
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

                  //Dark mode yazısı
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
                      //Lokal state güncellenir
                      setState(() => _isDarkMode = val);

                      //Parent widget'a haber verilir
                      widget.onDarkModeChanged(val);
                    },
                  ),
                ],
              ),
            ),
            //Sayfanın kalan kısmını boşluk ile kaplar, alt widget aşağı iner
            const Spacer(),

            //Log out butonu
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
                  //Firebase çıkışı
                  await FirebaseAuth.instance.signOut();

                  //Widget yok edildiyse işlem yapma
                  if (!mounted) return;

                  //Login ekranına dön
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
