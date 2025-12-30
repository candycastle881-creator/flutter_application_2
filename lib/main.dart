import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animations/animations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image/image.dart' as img;

// AdMob Ad Unit IDs
const String _bannerAdUnitId_Test = 'ca-app-pub-3940256099942544/6300978111';
const String _rewardedAdUnitId_Test = 'ca-app-pub-3940256099942544/5224354917';
const String _bannerAdUnitId_Prod = 'ca-app-pub-6695784329123227/8146534934';
const String _rewardedAdUnitId_Prod = 'ca-app-pub-6695784329123227/1927776799';

final String bannerAdUnitId = kDebugMode ? _bannerAdUnitId_Test : _bannerAdUnitId_Prod;
final String rewardedAdUnitId = kDebugMode ? _rewardedAdUnitId_Test : _rewardedAdUnitId_Prod;

// 10 Premium Outfit Color Ideas (Warm, Cool, Neutral)
final List<OutfitIdea> premiumOutfits = [
  OutfitIdea('Warm Autumn', Color(0xFFC65D3A), Color(0xFF8B4513), Color(0xFFFFA500)),
  OutfitIdea('Cool Blue', Color(0xFF4169E1), Color(0xFF000080), Color(0xFFFFFFFF)),
  OutfitIdea('Neutral Beige', Color(0xFFFAF9F6), Color(0xFF8B8589), Color(0xFF000000)),
  OutfitIdea('Warm Coral', Color(0xFFFF7F50), Color(0xFFA0522D), Color(0xFFFFEBCD)),
  OutfitIdea('Cool Lavender', Color(0xFFE6E6FA), Color(0xFF9370DB), Color(0xFF4B0082)),
  OutfitIdea('Warm Gold', Color(0xFFFFD700), Color(0xFF8B7355), Color(0xFFFF8C00)),
  OutfitIdea('Cool Silver', Color(0xFFC0C0C0), Color(0xFF36454F), Color(0xFFFFFFFF)),
  OutfitIdea('Neutral Taupe', Color(0xFFB38B6D), Color(0xFF3E2723), Color(0xFFE3DAC9)),
  OutfitIdea('Warm Rust', Color(0xFFB7410E), Color(0xFF654321), Color(0xFFFFF8DC)),
  OutfitIdea('Cool Teal', Color(0xFF008080), Color(0xFF004D4D), Color(0xFFE0FFFF)),
];

class OutfitIdea {
  final String name;
  final Color shirtColor;
  final Color pantsColor;
  final Color accentColor;

  OutfitIdea(this.name, this.shirtColor, this.pantsColor, this.accentColor);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const HueSenseApp());
}

class HueSenseApp extends StatelessWidget {
  const HueSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hue Sense',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Inter'),
        scaffoldBackgroundColor: const Color(0xFF0E0E10),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? image;
  String undertone = '';
  bool premiumUnlocked = false;
  final ImagePicker picker = ImagePicker();
  BannerAd? topBannerAd;
  BannerAd? bottomBannerAd;

  @override
  void initState() {
    super.initState();
    _loadBannerAds();
  }

  void _loadBannerAds() {
    // Top Banner Ad
    topBannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
      request: const AdRequest(),
    )..load();

    // Bottom Banner Ad
    bottomBannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
      request: const AdRequest(),
    )..load();
  }

  String detectUndertone() {
    if (image == null) return "Neutral";
    try {
      final imageBytes = image!.readAsBytesSync();
      final decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) return "Neutral";

      final leftCheekX = decodedImage.width ~/ 3;
      final rightCheekX = (decodedImage.width * 2) ~/ 3;
      final cheekY = (decodedImage.height * 0.55);

      int redSum = 0, greenSum = 0, blueSum = 0;
      int sampleCount = 0;

      for (int x = (leftCheekX - 60).clamp(0, decodedImage.width - 1);
           x < (leftCheekX + 60).clamp(0, decodedImage.width);
           x++) {
        for (int y = (cheekY.toInt() - 60).clamp(0, decodedImage.height - 1);
             y < (cheekY.toInt() + 60).clamp(0, decodedImage.height);
             y++) {
          final pixel = decodedImage.getPixelSafe(x, y);
          redSum += (pixel.r as num).toInt();
          greenSum += (pixel.g as num).toInt();
          blueSum += (pixel.b as num).toInt();
          sampleCount++;
        }
      }

      for (int x = (rightCheekX - 60).clamp(0, decodedImage.width - 1);
           x < (rightCheekX + 60).clamp(0, decodedImage.width);
           x++) {
        for (int y = (cheekY.toInt() - 60).clamp(0, decodedImage.height - 1);
             y < (cheekY.toInt() + 60).clamp(0, decodedImage.height);
             y++) {
          final pixel = decodedImage.getPixelSafe(x, y);
          redSum += (pixel.r as num).toInt();
          greenSum += (pixel.g as num).toInt();
          blueSum += (pixel.b as num).toInt();
          sampleCount++;
        }
      }

      if (sampleCount == 0) return "Neutral";

      final avgRed = redSum ~/ sampleCount;
      final avgBlue = blueSum ~/ sampleCount;
      final warmth = avgRed - avgBlue;

      if (warmth > 20) return "Warm";
      if (warmth < -20) return "Cool";
      return "Neutral";
    } catch (_) {
      return "Neutral";
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (picked == null) return;

    final File pickedFile = File(picked.path);
    final String detected = detectUndertone();

    setState(() {
      image = pickedFile;
      undertone = detected;
    });

    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            image: pickedFile,
            undertone: detected,
            premiumUnlocked: premiumUnlocked,
            onUnlock: _unlockPremium,
          ),
        ),
      );
    }
  }

  void _unlockPremium() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.show(
            onUserEarnedReward: (_, __) {
              setState(() => premiumUnlocked = true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🎉 Premium unlocked!'), duration: Duration(seconds: 2)),
              );
            },
          );
        },
        onAdFailedToLoad: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ad loading failed. Try again.'), duration: Duration(seconds: 2)),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    topBannerAd?.dispose();
    bottomBannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10),
      body: Stack(
        children: [
          // Wavy background
          CustomPaint(
            painter: WavyBackgroundPainter(),
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
          ),
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Top Banner Ad
                  if (topBannerAd != null)
                    SizedBox(
                      height: topBannerAd!.size.height.toDouble(),
                      width: double.infinity,
                      child: AdWidget(ad: topBannerAd!),
                    ),
                  const SizedBox(height: 20),
                  // App Title
                  const Text(
                    'Hue Sense',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Discover Your Undertone',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Camera/Gallery buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => pickImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Camera'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => pickImage(ImageSource.gallery),
                            icon: const Icon(Icons.image),
                            label: const Text('Gallery'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade600,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Image preview
                  if (image != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(image!, fit: BoxFit.cover),
                      ),
                    ),
                  if (undertone.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Undertone: $undertone',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (!premiumUnlocked)
                      ElevatedButton(
                        onPressed: _unlockPremium,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade600,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        ),
                        child: const Text(
                          'Watch Ad for 10 Outfit Ideas',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      )
                    else
                      Column(
                        children: [
                          const Text(
                            '✨ Premium Unlocked! ✨',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.greenAccent),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.2,
                              ),
                              itemCount: premiumOutfits.length,
                              itemBuilder: (context, index) {
                                final outfit = premiumOutfits[index];
                                return OutfitCard(outfit: outfit);
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                  const SizedBox(height: 30),
                  // Bottom Banner Ad
                  if (bottomBannerAd != null)
                    SizedBox(
                      height: bottomBannerAd!.size.height.toDouble(),
                      width: double.infinity,
                      child: AdWidget(ad: bottomBannerAd!),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OutfitCard extends StatelessWidget {
  final OutfitIdea outfit;

  const OutfitCard({required this.outfit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Text(
            outfit.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColorCircle(color: outfit.shirtColor, label: 'S'),
              const SizedBox(width: 6),
              ColorCircle(color: outfit.pantsColor, label: 'P'),
              const SizedBox(width: 6),
              ColorCircle(color: outfit.accentColor, label: 'A'),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class ColorCircle extends StatelessWidget {
  final Color color;
  final String label;

  const ColorCircle({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.white70)),
      ],
    );
  }
}

class ResultScreen extends StatelessWidget {
  final File image;
  final String undertone;
  final bool premiumUnlocked;
  final Function onUnlock;

  const ResultScreen({
    required this.image,
    required this.undertone,
    required this.premiumUnlocked,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Results'),
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: WavyBackgroundPainter(),
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.file(image, fit: BoxFit.cover),
                  ),
                ),
                Text(
                  'Your Undertone',
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  undertone,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                const SizedBox(height: 30),
                if (!premiumUnlocked)
                  ElevatedButton(
                    onPressed: () => onUnlock(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade600,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    ),
                    child: const Text('Unlock 10 Outfit Ideas', style: TextStyle(fontSize: 16)),
                  )
                else
                  const Text('✨ Premium Features Unlocked!', style: TextStyle(fontSize: 16, color: Colors.greenAccent)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WavyBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(size.width, size.height),
        [
          const Color(0xFF0A0E27),
          const Color(0xFF1a1f4d),
          const Color(0xFF0f1e3f),
          const Color(0xFF1a3a52),
        ],
        [0.0, 0.3, 0.6, 1.0],
      );

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw wavy lines
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 2;

    for (int i = 0; i < 5; i++) {
      final path = Path();
      final yOffset = size.height * 0.2 * (i + 1);
      path.moveTo(0, yOffset);

      for (double x = 0; x < size.width; x += 20) {
        final y = yOffset + sin((x + DateTime.now().millisecondsSinceEpoch / 1000) * 0.005) * 20;
        path.lineTo(x, y);
      }

      canvas.drawPath(path, wavePaint);
    }
  }

  @override
  bool shouldRepaint(WavyBackgroundPainter oldDelegate) => true;
}
