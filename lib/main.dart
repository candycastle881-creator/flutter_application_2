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

// Ad Unit IDs - Update with your production IDs from AdMob console
// Test IDs (for debug builds)
const String _bannerAdUnitId_Test = 'ca-app-pub-3940256099942544/6300978111';
const String _rewardedAdUnitId_Test = 'ca-app-pub-3940256099942544/5224354917';
// Production IDs (for release builds)
const String _bannerAdUnitId_Prod = 'ca-app-pub-6695784329123227/XXXXXXXXXX';
const String _rewardedAdUnitId_Prod = 'ca-app-pub-6695784329123227/YYYYYYYYYY';

// Auto-select test IDs for debug, production IDs for release
final String bannerAdUnitId = kDebugMode ? _bannerAdUnitId_Test : _bannerAdUnitId_Prod;
final String rewardedAdUnitId = kDebugMode ? _rewardedAdUnitId_Test : _rewardedAdUnitId_Prod;
final List<List<Color>> warmPalettes = [
  [Color(0xFFC65D3A), Color(0xFFFFF1D6), Color(0xFF6B8E23)],
  [Color(0xFFCC5500), Color(0xFFC19A6B), Color(0xFFFFFFF0)],
  [Color(0xFFD4A017), Color(0xFF5A3A29), Color(0xFFF5F5DC)],
  [Color(0xFFFF7F50), Color(0xFFE4CDA7), Color(0xFFC9A227)],
  [Color(0xFFB7410E), Color(0xFF3F5D7D), Color(0xFFD2B48C)],
  [Color(0xFFFFB07C), Color(0xFFFAF9F6), Color(0xFFBDB76B)],
  [Color(0xFF800000), Color(0xFFA89F91), Color(0xFFB87333)],
  [Color(0xFF8B2E2E), Color(0xFFFAF0E6), Color(0xFF808000)],
  [Color(0xFF7B3F00), Color(0xFFC2B280), Color(0xFF3B2F2F)],
  [Color(0xFFFBCEB1), Color(0xFFA67B5B), Color(0xFFFFFDD0)],
  [Color(0xFFE6A817), Color(0xFF1F2A44), Color(0xFFF5F5DC)],
  [Color(0xFFB38B6D), Color(0xFF9CAF88), Color(0xFFFFFDD0)],
  [Color(0xFFB66A50), Color(0xFF36454F), Color(0xFFE3DAC9)],
  [Color(0xFF8D3F2F), Color(0xFFF8F8FF), Color(0xFF7A8450)],
  [Color(0xFFFD5E53), Color(0xFF6F4E37), Color(0xFFFFFFF0)],
  [Color(0xFFFFBF00), Color(0xFF4F7C7D), Color(0xFFE4CDA7)],
  [Color(0xFFAF6F09), Color(0xFF2C3E50), Color(0xFFFAF0E6)],
  [Color(0xFFF88379), Color(0xFFA89F91), Color(0xFFFFFDD0)],
  [Color(0xFFC65D3A), Color(0xFF1F2A44), Color(0xFFE3DAC9)],
  [Color(0xFFCD7F32), Color(0xFF228B22), Color(0xFFF5F5DC)],
  [Color(0xFFFF7518), Color(0xFF6A5ACD), Color(0xFFFFFDD0)],
  [Color(0xFFF4C430), Color(0xFF3B2F2F), Color(0xFFD2B48C)],
  [Color(0xFFC08081), Color(0xFFC19A6B), Color(0xFFFAF9F6)],
  [Color(0xFFE97451), Color(0xFF808000), Color(0xFFFAF0E6)],
  [Color(0xFFB87333), Color(0xFF36454F), Color(0xFFE6D3B1)],
  [Color(0xFFF4B49F), Color(0xFF8B8589), Color(0xFFFFFFF0)],
  [Color(0xFFE9967A), Color(0xFF7B3F00), Color(0xFFFFFDD0)],
  [Color(0xFFCC7722), Color(0xFF2F3B52), Color(0xFFE4CDA7)],
  [Color(0xFF8B2E2E), Color(0xFF928E85), Color(0xFFE3DAC9)],
  [Color(0xFF7B3F00), Color(0xFFFFFDD0), Color(0xFF6B8E23)],
  [Color(0xFFA52A2A), Color(0xFF36454F), Color(0xFFFAF9F6)],
  [Color(0xFFFFDF00), Color(0xFF1F2A44), Color(0xFFFAF0E6)],
  [Color(0xFFFF6F61), Color(0xFFBDB76B), Color(0xFFFFFDD0)],
  [Color(0xFF8A3324), Color(0xFF9CAF88), Color(0xFFF5F5DC)],
];

// Cool skin tone color palettes (shirt, pant, accent)
final List<List<Color>> coolPalettes = [
  [Color(0xFF1F2A44), Color(0xFFFFFFFF), Color(0xFFC0C0C0)],
  [Color(0xFF36454F), Color(0xFFD6EAF8), Color(0xFFFFFFFF)],
  [Color(0xFF007F66), Color(0xFF000000), Color(0xFF9EA0A1)],
  [Color(0xFF4169E1), Color(0xFFFFFFFF), Color(0xFF4682B4)],
  [Color(0xFF5A2A83), Color(0xFF708090), Color(0xFFC0C0C0)],
  [Color(0xFFE75480), Color(0xFF36454F), Color(0xFFFFFFFF)],
  [Color(0xFF008080), Color(0xFFD3D3D3), Color(0xFFFFFFFF)],
  [Color(0xFFB497BD), Color(0xFF1F2A44), Color(0xFFD8CFC4)],
  [Color(0xFF0047AB), Color(0xFFE5E4E2), Color(0xFFFFFFFF)],
  [Color(0xFF8A2D3C), Color(0xFF000000), Color(0xFF8B8589)],
  [Color(0xFF98FF98), Color(0xFF36454F), Color(0xFFFFFFFF)],
  [Color(0xFF0F52BA), Color(0xFF2A2A2A), Color(0xFFC0C0C0)],
  [Color(0xFFE8ADAA), Color(0xFFB2BEB5), Color(0xFFFFFFFF)],
  [Color(0xFFB22222), Color(0xFF1F2A44), Color(0xFFFFFFFF)],
  [Color(0xFFB0E0E6), Color(0xFF36454F), Color(0xFFFFFFFF)],
  [Color(0xFF9966CC), Color(0xFF708090), Color(0xFFF8F8FF)],
  [Color(0xFFC154C1), Color(0xFF000000), Color(0xFF71797E)],
  [Color(0xFF6A1B1A), Color(0xFF36454F), Color(0xFF808080)],
  [Color(0xFFF4C2C2), Color(0xFF1F2A44), Color(0xFFFFFFFF)],
  [Color(0xFF4F42B5), Color(0xFFD8CFC4), Color(0xFFFFFFFF)],
  [Color(0xFF7393B3), Color(0xFF000000), Color(0xFFFFFFFF)],
  [Color(0xFFC71585), Color(0xFF708090), Color(0xFF9EA0A1)],
  [Color(0xFFC8A2C8), Color(0xFF36454F), Color(0xFFFFFFFF)],
  [Color(0xFF3F00FF), Color(0xFFC0C0C0), Color(0xFF808080)],
  [Color(0xFF4682B4), Color(0xFFB2BEB5), Color(0xFFFFFFFF)],
  [Color(0xFF673147), Color(0xFF1F2A44), Color(0xFF808080)],
  [Color(0xFFD0E7F9), Color(0xFF2A2A2A), Color(0xFFFFFFFF)],
  [Color(0xFFDCAE96), Color(0xFF000000), Color(0xFFFFFFFF)],
  [Color(0xFF1F2A44), Color(0xFFE5E4E2), Color(0xFFC0C0C0)],
  [Color(0xFF8A2BE2), Color(0xFF36454F), Color(0xFFF8F8FF)],
  [Color(0xFFE5E4E2), Color(0xFF000000), Color(0xFFFFFFFF)],
  [Color(0xFF3AAFA9), Color(0xFF708090), Color(0xFFFFFFFF)],
  [Color(0xFF191970), Color(0xFFC0C0C0), Color(0xFF808080)],
];

// Neutral skin tone color palettes (shirt, pant, accent)
final List<List<Color>> neutralPalettes = [
  [Color(0xFFF5F5DC), Color(0xFFFFFFFF), Color(0xFF000000)],
  [Color(0xFF8B8589), Color(0xFFFAF9F6), Color(0xFF36454F)],
  [Color(0xFFB8B1A9), Color(0xFF1F2A44), Color(0xFFFFFDD0)],
  [Color(0xFF928E85), Color(0xFF000000), Color(0xFFFFFFFF)],
  [Color(0xFFC19A6B), Color(0xFF808080), Color(0xFFFFFFF0)],
  [Color(0xFF6F4E37), Color(0xFFFAF9F6), Color(0xFF1F2A44)],
  [Color(0xFFA89F91), Color(0xFF9EA0A1), Color(0xFFFFFFFF)],
  [Color(0xFFC9A36B), Color(0xFF36454F), Color(0xFFFFFDD0)],
  [Color(0xFFE4CDA7), Color(0xFF000000), Color(0xFFFAF9F6)],
  [Color(0xFFB0A99F), Color(0xFF1F2A44), Color(0xFFFFFFFF)],
  [Color(0xFFA67B5B), Color(0xFF9EA0A1), Color(0xFFFFFFF0)],
  [Color(0xFFC4B5A5), Color(0xFF000000), Color(0xFFE3DAC9)],
  [Color(0xFFF5F5DC), Color(0xFF3F5D7D), Color(0xFFFFFFFF)],
  [Color(0xFFFFFDD0), Color(0xFF8B8589), Color(0xFF36454F)],
  [Color(0xFF9CAF88), Color(0xFF808080), Color(0xFFFFFFFF)],
  [Color(0xFFA57C52), Color(0xFF1F2A44), Color(0xFFFFFFF0)],
  [Color(0xFFC2B280), Color(0xFF000000), Color(0xFF928E85)],
  [Color(0xFFBCB0A4), Color(0xFFFFFFFF), Color(0xFF808080)],
  [Color(0xFFD6C4A8), Color(0xFF1F2A44), Color(0xFFFAF9F6)],
  [Color(0xFF928E85), Color(0xFFFFFDD0), Color(0xFF000000)],
  [Color(0xFFA89F91), Color(0xFF1F2A44), Color(0xFFFFFFFF)],
  [Color(0xFFFAF0E6), Color(0xFF36454F), Color(0xFFFFFFF0)],
  [Color(0xFFBDB76B), Color(0xFF808080), Color(0xFFFFFFFF)],
  [Color(0xFFE6B8B7), Color(0xFF8B8589), Color(0xFFFFFFFF)],
  [Color(0xFFD8CFC4), Color(0xFF1F2A44), Color(0xFF000000)],
  [Color(0xFFB0A99F), Color(0xFFFFFDD0), Color(0xFF36454F)],
  [Color(0xFFD2B48C), Color(0xFF000000), Color(0xFFFFFFF0)],
  [Color(0xFFCFC6B8), Color(0xFF1F2A44), Color(0xFFFFFFFF)],
  [Color(0xFFC9C2B8), Color(0xFF000000), Color(0xFFFFFDD0)],
  [Color(0xFFD1B48C), Color(0xFF36454F), Color(0xFFFFFFFF)],
  [Color(0xFFBFA58A), Color(0xFF808080), Color(0xFFFFFFF0)],
  [Color(0xFF8B6F47), Color(0xFFFAF9F6), Color(0xFF1F2A44)],
  [Color(0xFF000000), Color(0xFFFFFFFF), Color(0xFF808080)],
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const HueSenseApp());
}

// Glassmorphic container widget with backdrop blur
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blurAmount;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final double? height;
  final double? width;

  const GlassContainer({
    super.key,
    required this.child,
    this.blurAmount = 10,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
      child: Container(
        margin: margin,
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        ),
        padding: padding,
        child: child,
      ),
    );
  }
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
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Inter',
        ),
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
  bool proUnlocked = false;

  final ImagePicker picker = ImagePicker();
  BannerAd? bannerAd;

  @override
  void initState() {
    super.initState();
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      listener: BannerAdListener(),
      request: const AdRequest(),
    )..load();
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
            proUnlocked: proUnlocked,
            onUnlock: unlockPro,
          ),
        ),
      );
    }
  }

  String detectUndertone() {
    // Real pixel-based undertone detection from the image
    // Samples cheek area (face approximation: lower-center region)
    if (image == null) return "Neutral";
    
    try {
      final imageBytes = image!.readAsBytesSync();
      final decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) return "Neutral";
      
      // Approximate cheek area: lower-left and lower-right regions
      // Typical face position: center-upper area of image
      final leftCheekX = decodedImage.width ~/ 3;
      final rightCheekX = (decodedImage.width * 2) ~/ 3;
      final cheekY = (decodedImage.height * 0.55);
      
      int redSum = 0, greenSum = 0, blueSum = 0;
      int sampleCount = 0;
      
      // Sample left cheek
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
      
      // Sample right cheek
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
      final avgGreen = greenSum ~/ sampleCount;
      final avgBlue = blueSum ~/ sampleCount;
      
      // Analyze undertone: if Red is significantly higher → Warm; Blue higher → Cool
      // For skin tone: warm has higher Red, cool has higher Blue/Green
      final warmth = avgRed - avgBlue;
      if (warmth > 20) return "Warm";
      if (warmth < -20) return "Cool";
      return "Neutral";
    } catch (_) {
      return "Neutral";
    }
  }

  void unlockPro() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.show(
            onUserEarnedReward: (_, __) {
              setState(() => proUnlocked = true);
            },
          );
        },
        onAdFailedToLoad: (error) {},
      ),
    );
  }

  List<Color> outfitColors() {
    switch (undertone) {
      case "Warm":
        return [Colors.orange, Colors.brown, Colors.green];
      case "Cool":
        return [Colors.blue, Colors.purple, Colors.grey];
      default:
        return [const Color(0xFFF5F5DC), Colors.black, Colors.white];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0E27),
            Color(0xFF1a1f4d),
            Color(0xFF0f1e3f),
            Color(0xFF1a3a52),
          ],
          stops: [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Hue Sense',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
        ),
        bottomNavigationBar: bannerAd == null
            ? null
            : SizedBox(
                height: bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: bannerAd!),
              ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 28),

                  OpenContainer(
                    transitionDuration: const Duration(milliseconds: 600),
                    closedColor: Colors.transparent,
                    openColor: Colors.transparent,
                    closedBuilder: (_, open) => GestureDetector(
                      onTap: open,
                      child: Container(
                        height: 260,
                        width: 260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1F1C2C), Color(0xFF928DAB)],
                          ),
                        ),
                        child: image == null
                            ? const Center(child: Text("Tap to Scan", style: TextStyle(color: Colors.white70)))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.file(image!, fit: BoxFit.cover),
                              ),
                      ),
                    ),
                    openBuilder: (_, __) => FullImagePage(
                      image: image,
                      onCamera: () => pickImage(ImageSource.camera),
                      onGallery: () => pickImage(ImageSource.gallery),
                    ),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        LiquidPageRoute(
                          builder: (_) => OutfitSuggestionsScreen(
                            undertone: undertone,
                            proUnlocked: proUnlocked,
                            onUnlock: unlockPro,
                          ),
                        ),
                      );
                    },
                    child: GlassContainer(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.all(14),
                      height: 120,
                      borderRadius: 14,
                      blurAmount: 0,
                      child: Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [Colors.cyanAccent, Colors.purpleAccent],
                              ),
                            ),
                            child: const Icon(Icons.palette, color: Colors.black, size: 34),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Outfit Color Suggestions',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  proUnlocked
                                      ? 'Personalized for your undertone'
                                      : 'Unlock with Premium or Watch Ad',
                                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            proUnlocked ? Icons.lock_open : Icons.lock,
                            color: proUnlocked ? Colors.greenAccent : Colors.orangeAccent,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (undertone.isNotEmpty && !proUnlocked)
                    ElevatedButton(
                      onPressed: unlockPro,
                      child: const Text("Unlock Outfit Colors (Watch Ad)"),
                    ),

                  if (proUnlocked)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: outfitColors()
                            .map(
                              (c) => Container(
                                margin: const EdgeInsets.all(8),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: c,
                                  shape: BoxShape.circle,
                                ),
                              ).animate().scale(),
                            )
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FullImagePage extends StatelessWidget {
  final File? image;
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  const FullImagePage({
    super.key,
    required this.image,
    required this.onCamera,
    required this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Image
          if (image != null)
            Positioned.fill(
              child: Image.file(image!, fit: BoxFit.cover),
            )
          else
            Positioned.fill(
              child: Container(
                color: Colors.black87,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt, size: 64, color: Colors.white54),
                    const SizedBox(height: 16),
                    const Text('Select photo', style: TextStyle(color: Colors.white54)),
                  ],
                ),
              ),
            ),
          // Grid overlay
          Positioned.fill(
            child: GridOverlay(),
          ),
          // Oval face guide
          // Oval face guide removed per request (keeps only grid overlay)
          // Bottom button row
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt, size: 32, color: Colors.white),
                  onPressed: onCamera,
                ),
                IconButton(
                  icon: const Icon(Icons.photo, size: 32, color: Colors.white),
                  onPressed: onGallery,
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 32, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GridOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GridPainter(),
      size: Size.infinite,
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1.0;

    // Draw 3x3 grid
    final cellWidth = size.width / 3;
    final cellHeight = size.height / 3;

    // Vertical lines
    canvas.drawLine(Offset(cellWidth, 0), Offset(cellWidth, size.height), paint);
    canvas.drawLine(Offset(cellWidth * 2, 0), Offset(cellWidth * 2, size.height), paint);

    // Horizontal lines
    canvas.drawLine(Offset(0, cellHeight), Offset(size.width, cellHeight), paint);
    canvas.drawLine(Offset(0, cellHeight * 2), Offset(size.width, cellHeight * 2), paint);
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
}

// Oval face guide painter removed intentionally.

class ResultScreen extends StatelessWidget {
  final File? image;
  final String undertone;
  final bool proUnlocked;
  final VoidCallback onUnlock;

  const ResultScreen({
    super.key,
    required this.image,
    required this.undertone,
    required this.proUnlocked,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Result')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (image != null)
                ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.file(image!, width: 220, height: 220, fit: BoxFit.cover)),
              const SizedBox(height: 16),
              Text('Undertone: $undertone', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.orangeAccent)),
              const SizedBox(height: 12),
              const Text('Shade: Medium', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (proUnlocked) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => OutfitSuggestionsScreen(undertone: undertone, proUnlocked: proUnlocked, onUnlock: onUnlock)));
                  } else {
                    onUnlock();
                  }
                },
                child: Text(proUnlocked ? 'View Outfit Suggestions' : 'Watch Ad to Unlock Outfit Suggestions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OutfitSuggestionsScreen extends StatefulWidget {
  final String undertone;
  final bool proUnlocked;
  final VoidCallback onUnlock;

  const OutfitSuggestionsScreen({
    super.key,
    required this.undertone,
    required this.proUnlocked,
    required this.onUnlock,
  });

  @override
  State<OutfitSuggestionsScreen> createState() => _OutfitSuggestionsScreenState();
}

class _OutfitSuggestionsScreenState extends State<OutfitSuggestionsScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // A compact representation of a palette: shirt and pant colors (plus optional accent)
  List<Map<String, Color>> _allPalettes() {
    // Return palettes based on undertone
    switch (widget.undertone) {
      case "Warm":
        return warmPalettes.map((p) => {'shirt': p[0], 'pant': p[1], 'accent': p[2]}).toList();
      case "Cool":
        return coolPalettes.map((p) => {'shirt': p[0], 'pant': p[1], 'accent': p[2]}).toList();
      default:
        return neutralPalettes.map((p) => {'shirt': p[0], 'pant': p[1], 'accent': p[2]}).toList();
    }
  }

  String _hex(Color c) => '#${(c.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

  // Simple heuristic: classify a color as warm/cool/neutral
  String _temp(Color c) {
    final r = c.red;
    final g = c.green;
    final b = c.blue;
    if (r > b + 20) return 'Warm';
    if (b > r + 20) return 'Cool';
    return 'Neutral';
  }

  // Score palettes according to undertone preference
  List<Map<String, Color>> _topPalettesForTone(String tone) {
    final palettes = _allPalettes();
    // Return first 10 from the curated list (already sorted by suitability)
    return palettes.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tone = widget.undertone.isEmpty ? 'Neutral' : widget.undertone;
    final suggestions = widget.proUnlocked ? _topPalettesForTone(tone) : <Map<String, Color>>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Outfit Suggestions')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: widget.proUnlocked
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Top 10 palettes for $tone', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: suggestions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, idx) {
                        final p = suggestions[idx];
                        final shirt = p['shirt']!;
                        final pant = p['pant']!;
                        final accent = p['accent']!;
                        return GlassContainer(
                          padding: const EdgeInsets.all(12),
                          borderRadius: 12,
                          blurAmount: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('#${idx + 1} - $tone Outfit', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.cyanAccent)),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Container(width: 56, height: 56, decoration: BoxDecoration(color: shirt, borderRadius: BorderRadius.circular(8))),
                                      const SizedBox(height: 6),
                                      const Text('Shirt', style: TextStyle(fontSize: 11, color: Colors.white70)),
                                      Text(_hex(shirt), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(width: 56, height: 56, decoration: BoxDecoration(color: pant, borderRadius: BorderRadius.circular(8))),
                                      const SizedBox(height: 6),
                                      const Text('Pant', style: TextStyle(fontSize: 11, color: Colors.white70)),
                                      Text(_hex(pant), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(width: 56, height: 56, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(8))),
                                      const SizedBox(height: 6),
                                      const Text('Accent', style: TextStyle(fontSize: 11, color: Colors.white70)),
                                      Text(_hex(accent), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock, size: 72, color: Colors.orangeAccent),
                    const SizedBox(height: 12),
                    const Text('Content Locked', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    const Text('Return to main menu to unlock'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Back to Main Menu'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

// Liquid wave painter for shader-based transitions
class LiquidWavePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  LiquidWavePainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = size.height * 0.2;
    const waveFrequency = 2.0;

    path.moveTo(0, size.height * 0.5);

    for (double x = 0; x <= size.width; x += 5) {
      final y = size.height * 0.5 +
          waveHeight *
              sin((x / size.width * waveFrequency * pi) +
                  (animationValue * pi * 2));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LiquidWavePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

// Liquid transition page route
class LiquidPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  final String? name;

  LiquidPageRoute({
    required this.builder,
    this.name,
    RouteSettings? settings,
  }) : super(settings: settings);

  @override
  Color? get barrierColor => null;

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 1200);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return Stack(
      children: [
        // Previous page fades out
        Opacity(
          opacity: 1.0 - animation.value,
          child: Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: child,
          ),
        ),
        // Liquid wave animation
        Positioned.fill(
          child: CustomPaint(
            painter: LiquidWavePainter(
              animationValue: animation.value,
              color: Colors.cyanAccent.withOpacity(0.3),
            ),
          ),
        ),
        // New page slides and fades in
        Positioned.fill(
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
            ),
            child: FadeTransition(
              opacity: animation,
              child: builder(context),
            ),
          ),
        ),
      ],
    );
  }
}
