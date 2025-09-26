import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/economic_service.dart';

class EconomicAnnouncementsPage extends StatefulWidget {
  const EconomicAnnouncementsPage({super.key});

  @override
  State<EconomicAnnouncementsPage> createState() => _EconomicAnnouncementsPageState();
}

class _EconomicAnnouncementsPageState extends State<EconomicAnnouncementsPage> {
  final EconomicService _economicService = EconomicService();
  late Future<List<Map<String, String>>> _economicData;

  String selectedCountry = 'all';

  final List<String> availableCountries = [
    'all',
    'United States',
    'France',
    'Germany',
    'Japan',
    'China',
    'United Kingdom',
    'Canada',
    'Mexico',
    'Sweden',
    'Australia',
    'International',
  ];

  @override
  void initState() {
    super.initState();
    _economicData = _economicService.fetchEconomicData();
  }

  void _onCountrySelected(String country) {
    setState(() {
      selectedCountry = country;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📊 Annonces Économiques"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedCountry,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              items: availableCountries.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(
                    country == 'all' ? '🌍 Tous les pays' : country,
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) _onCountrySelected(value);
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, String>>>(
              future: _economicData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erreur : ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Aucune donnée disponible"));
                } else {
                  final allData = snapshot.data!;
                  final filteredData = selectedCountry == 'all'
                      ? allData
                      : allData.where((item) => item['country'] == selectedCountry).toList();

                  return ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final item = filteredData[index];

                      final title = item['title'] ?? 'Titre inconnu';
                      final date = item['date'] ?? 'Date inconnue';
                      final country = item['country'] ?? 'International';
                      final link = item['link'] ?? '';

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: Colors.grey.shade900,
                        child: ListTile(
                          title: Text(title, style: const TextStyle(color: Colors.white)),
                          subtitle: Text(date, style: const TextStyle(color: Colors.white70)),
                          trailing: const Icon(Icons.open_in_new, color: Colors.amber),
                          onTap: () {
                            if (link.isNotEmpty) {
                              launchURL(link);
                            }
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Impossible d'ouvrir l’URL : $url");
    }
  }
}
