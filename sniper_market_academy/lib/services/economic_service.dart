import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class EconomicService {
  final String rssUrl = 'https://www.investing.com/rss/news_285.rss';

  Future<List<Map<String, String>>> fetchEconomicData() async {
    final response = await http.get(Uri.parse(rssUrl));

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);
      final items = document.findAllElements('item');

      return items.map((item) {
        final title = item.findElements('title').first.text;
        final pubDate = item.findElements('pubDate').first.text;
        final link = item.findElements('link').first.text;

        // ✅ On peut tenter d'extraire un pays ou priorité via le titre
        String country = _extractCountryCodeFromTitle(title);

        return {
          'title': title,
          'date': pubDate,
          'link': link,
          'country': country,
        };
      }).toList();
    } else {
      throw Exception('Erreur lors du chargement RSS : ${response.statusCode}');
    }
  }

  String _extractCountryCodeFromTitle(String title) {
    // Détection simple des pays via des mots-clés dans le titre
    final titleLower = title.toLowerCase();
    if (titleLower.contains("us") || titleLower.contains("federal")) return "United States";
    if (titleLower.contains("euro") || titleLower.contains("ecb")) return "Eurozone";
    if (titleLower.contains("china") || titleLower.contains("yuan")) return "China";
    if (titleLower.contains("japan") || titleLower.contains("yen")) return "Japan";
    if (titleLower.contains("uk") || titleLower.contains("boe") || titleLower.contains("british")) return "United Kingdom";
    if (titleLower.contains("germany")) return "Germany";
    if (titleLower.contains("france")) return "France";
    if (titleLower.contains("canada")) return "Canada";
    if (titleLower.contains("australia")) return "Australia";
    return "International";
  }
}
