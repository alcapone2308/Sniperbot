import 'package:flutter/material.dart';
import '../services/economic_service.dart';
import '../screens/economic_announcements_page.dart';

class EconomicScrollingBanner extends StatefulWidget {
  const EconomicScrollingBanner({super.key});

  @override
  State<EconomicScrollingBanner> createState() => _EconomicScrollingBannerState();
}

class _EconomicScrollingBannerState extends State<EconomicScrollingBanner> {
  late Future<List<Map<String, String>>> _economicData;

  @override
  void initState() {
    super.initState();
    _economicData = EconomicService().fetchEconomicData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.campaign_rounded, color: Colors.amber, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: FutureBuilder<List<Map<String, String>>>(
              future: _economicData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    "Chargement...",
                    style: TextStyle(color: Colors.white),
                  );
                } else if (snapshot.hasError) {
                  return const Text(
                    "Erreur",
                    style: TextStyle(color: Colors.red),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text(
                    "Aucune annonce disponible",
                    style: TextStyle(color: Colors.white70),
                  );
                } else {
                  final titles = snapshot.data!
                      .map((e) => e['title'] ?? '')
                      .where((title) => title.isNotEmpty)
                      .take(10)
                      .toList();

                  final scrollingText = titles.join("   •   ");

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      AnimatedBuilder(
                        animation: Listenable.merge([]), // aucune animation, juste static scroll
                        builder: (context, _) {
                          return MarqueeText(scrollingText);
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EconomicAnnouncementsPage()),
              );
            },
            child: const Text(
              "Tout voir",
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Widget personnalisé pour défilement horizontal automatique
class MarqueeText extends StatefulWidget {
  final String text;

  const MarqueeText(this.text, {super.key});

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 45),
    )..repeat();

    _controller.addListener(() {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _controller.value * _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 2200, // longueur fictive, assez longue pour défilement
      child: ListView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        children: [
          Text(
            widget.text,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
