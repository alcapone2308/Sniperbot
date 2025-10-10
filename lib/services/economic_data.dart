import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class EconomicEvent {
  final String title;
  final String link;
  final String countryCode;

  EconomicEvent({
    required this.title,
    required this.link,
    required this.countryCode,
  });

  factory EconomicEvent.fromRssItem(Map<String, dynamic> item) {
    final title = item['title'] ?? '';
    final link = item['link'] ?? '';
    final countryCode = _extractCountryCodeFromTitle(title);
    return EconomicEvent(title: title, link: link, countryCode: countryCode);
  }

  static String _extractCountryCodeFromTitle(String title) {
    final keywords = {
      'US': ['Fed', 'United States', 'US', 'Dollar'],
      'EU': ['ECB', 'Europe', 'Eurozone', 'EUR'],
      'DE': ['Germany', 'Bundesbank'],
      'FR': ['France', 'French'],
      'JP': ['Japan', 'Yen', 'BoJ'],
      'CN': ['China', 'Yuan'],
      'IN': ['India', 'INR'],
      'UK': ['UK', 'BoE', 'Pound', 'Britain', 'GBP'],
      'AU': ['Australia', 'AUD'],
      'CA': ['Canada', 'CAD'],
    };

    for (final entry in keywords.entries) {
      if (entry.value.any((kw) => title.toLowerCase().contains(kw.toLowerCase()))) {
        return entry.key;
      }
    }

    return '🌍'; // inconnu ou global
  }
}

class EconomicDataService {
  static Future<List<EconomicEvent>> fetchEconomicEvents() async {
    final url = 'https://www.investing.com/rss/news_301.rss';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);
      final items = document.findAllElements('item');

      return items.map((item) {
        final title = item.findElements('title').first.text;
        final link = item.findElements('link').first.text;
        return EconomicEvent.fromRssItem({'title': title, 'link': link});
      }).take(5).toList();
    } else {
      throw Exception('Erreur chargement des annonces économiques');
    }
  }
}
