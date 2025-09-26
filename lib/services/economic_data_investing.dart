// lib/services/economic_data_investing.dart
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class EconomicEvent {
  final String title;
  final String pubDate;

  EconomicEvent({required this.title, required this.pubDate});
}

class InvestingRssService {
  static const String feedUrl = 'https://www.investing.com/rss/news_301.rss'; // 📡 Fil d’actu économie

  static Future<List<EconomicEvent>> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse(feedUrl));

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final items = document.findAllElements('item');

        return items.map((item) {
          final title = item.findElements('title').first.text;
          final pubDate = item.findElements('pubDate').first.text;
          return EconomicEvent(title: title, pubDate: pubDate);
        }).toList();
      } else {
        throw Exception('Échec du chargement des données : code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors du chargement des données : $e');
    }
  }
}
