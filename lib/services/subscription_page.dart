import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final InAppPurchase _iap = InAppPurchase.instance;
  bool _available = false;
  List<ProductDetails> _products = [];
  final String productId = "sniperbot_premium";

  @override
  void initState() {
    super.initState();
    _initializeStore();
  }

  Future<void> _initializeStore() async {
    _available = await _iap.isAvailable();
    if (!_available) return;

    const Set<String> ids = {'sniperbot_premium'};
    final ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    if (response.error != null || response.notFoundIDs.isNotEmpty) {
      print("❌ Erreur produit : ${response.error}");
      return;
    }

    setState(() {
      _products = response.productDetails;
    });

    _iap.purchaseStream.listen((purchases) => _handlePurchaseUpdates(purchases));
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        await _activerAbonnementLocal();
        if (mounted) Navigator.pushReplacementNamed(context, '/sniperbot');
      }
    }
  }

  Future<void> _activerAbonnementLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sniperbot_abonnement_actif', true);
    await prefs.setString('abonnement_date', DateTime.now().toIso8601String());
    await prefs.setInt('upload_count', 0);
    print("✅ Abonnement activé localement");
  }

  Future<void> _acheterAbonnement() async {
    if (_products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produit non disponible. Réessaie plus tard.")),
      );
      return;
    }

    final ProductDetails product = _products.firstWhere((p) => p.id == productId);
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Abonnement SniperBot")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.star, size: 100, color: Colors.orangeAccent),
            const SizedBox(height: 20),
            const Text(
              "Débloque SniperBot IA 🔓",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Accède à 100 analyses IA par mois grâce à ton abonnement.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _acheterAbonnement,
              icon: const Icon(Icons.lock_open),
              label: const Text("Activer pour 14,99 €"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Durée : 30 jours\nLimite : 100 images/mois",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/promo'),
              icon: const Icon(Icons.card_giftcard, color: Colors.orange),
              label: const Text("J'ai un code promo", style: TextStyle(color: Colors.orange)),
            ),
          ],
        ),
      ),
    );
  }
}
