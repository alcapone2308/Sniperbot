import 'package:flutter/material.dart';

class GlossaryPage extends StatelessWidget {
  const GlossaryPage({super.key});

  final List<Map<String, String>> glossary = const [
    {
      'term': 'BOS (Break of Structure)',
      'definition': 'Cassure d\'un plus haut ou plus bas marquant un changement de structure possible.',
      'details': 'Le BOS indique un changement potentiel dans la dynamique du marché. '
          'Un BOS haussier se produit lorsque le prix dépasse un sommet précédent, '
          'tandis qu\'un BOS baissier se produit lorsque le prix descend en dessous d\'un creux précédent.'
    },
    {
      'term': 'Accumulation',
      'definition': 'Phase où les institutions achètent des actifs à bas prix.',
      'details': 'Souvent observée après une tendance baissière, l\'accumulation prépare le terrain pour une future hausse.'
    },
    {
      'term': 'Distribution',
      'definition': 'Phase où les institutions vendent des actifs à des prix élevés.',
      'details': 'Se produit généralement après une tendance haussière, signalant un potentiel retournement.'
    },
    {
      'term': 'Swing High/Low',
      'definition': 'Points de retournement sur un graphique.',
      'details': 'Un swing high est un sommet local, tandis qu\'un swing low est un creux local. Ils aident à identifier la structure du marché.'
    },
    {
      'term': 'FVG (Fair Value Gap)',
      'definition': 'Zone de déséquilibre entre les bougies, souvent revisitée.',
      'details': 'Les FVG sont des zones où le prix a rapidement évolué, laissant un vide. '
          'Ces zones sont souvent des cibles pour les traders cherchant à entrer dans le marché.'
    },
    {
      'term': 'OTE (Optimal Trade Entry)',
      'definition': 'Zone de retracement entre 62%-79% idéale pour entrer après impulsion.',
      'details': 'L\'OTE est une zone de prix où les traders peuvent entrer après un mouvement impulsif, '
          'en utilisant des niveaux de retracement de Fibonacci pour maximiser le potentiel de profit.'
    },
    {
      'term': 'Liquidity',
      'definition': 'Zone visée par les Smart Money pour piéger les traders.',
      'details': 'Les zones de liquidité sont des niveaux de prix où les ordres stop-loss des traders sont souvent placés. '
          'Les institutions cherchent à atteindre ces niveaux pour accumuler des positions.'
    },
    {
      'term': 'CHoCH (Change of Character)',
      'definition': 'Premier signal de retournement de tendance après un mouvement soutenu.',
      'details': 'Le CHoCH indique un changement dans la structure du marché, signalant un potentiel retournement de tendance. '
          'C\'est un indicateur clé pour les traders cherchant à anticiper des mouvements de prix.'
    },
    {
      'term': 'Order Block',
      'definition': 'Dernière bougie de manipulation avant une impulsion forte.',
      'details': 'Les Order Blocks sont des zones où les institutions ont accumulé des positions avant de provoquer un mouvement de prix. '
          'Ces zones sont souvent utilisées comme points d\'entrée stratégiques.'
    },
    {
      'term': 'Displacement',
      'definition': 'Impulsion violente du prix laissant un gap/FVG.',
      'details': 'Mouvement rapide montrant l\'intervention des institutions. Précède souvent un changement de tendance.'
    },
    {
      'term': 'Smart Money',
      'definition': 'Acteurs institutionnels influençant le marché.',
      'details': 'Banques et hedge funds qui créent les tendances. Leur objectif : chasser la liquidité retail.'
    },
    {
      'term': 'Market Structure Shift',
      'definition': 'Changement confirmé de la tendance.',
      'details': 'Validation d\'un nouveau sommet/creux + changement des highs/lows. Signal forte probabilité.'
    },
    {
      'term': 'Liquidity Void',
      'definition': 'Zone sans ordres significatifs.',
      'details': 'Espace où le prix peut accélérer rapidement. Cible des institutions pour exécuter gros volumes.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Glossaire SMC'),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menu_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: glossary.length,
          itemBuilder: (context, index) {
            final item = glossary[index];
            return _buildGlossaryCard(
              item['term']!,
              item['definition']!,
              item['details']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildGlossaryCard(String term, String definition, String details) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepOrange, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          term,
          style: const TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        collapsedBackgroundColor: Colors.transparent,
        children: [
          Padding(
            padding: const EdgeInsets.all(16).copyWith(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  definition,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  details,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}