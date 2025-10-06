class QuizData {
  final String id;
  final String title;
  final String category;
  final String difficulty; // 'easy', 'medium', 'hard'
  final String description;
  final List<QuizQuestion> questions;
  final int xpReward;

  QuizData({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.description,
    required this.questions,
    required this.xpReward,
  });

  static List<QuizData> getAllQuizzes() {
    return [
      // ============ QUIZ MARKET STRUCTURE ============
      QuizData(
        id: 'market_structure_1',
        title: 'Structure de Marché - Niveau 1',
        category: 'Market Structure',
        difficulty: 'easy',
        description: 'Testez vos connaissances sur les bases de la structure de marché',
        xpReward: 50,
        questions: [
          QuizQuestion(
            question: 'Que signifie "HH" en structure de marché ?',
            options: [
              'High Hope',
              'Higher High',
              'Horizontal High',
              'Hard High',
            ],
            correctAnswer: 1,
            explanation: 'HH signifie Higher High (Sommet plus haut), indicateur d\'une tendance haussière.',
          ),
          QuizQuestion(
            question: 'Dans une tendance haussière, qu\'observe-t-on ?',
            options: [
              'Lower Lows et Lower Highs',
              'Higher Highs et Higher Lows',
              'Seulement des Higher Highs',
              'Aucune structure claire',
            ],
            correctAnswer: 1,
            explanation: 'Une tendance haussière se caractérise par des Higher Highs (HH) et Higher Lows (HL).',
          ),
          QuizQuestion(
            question: 'Qu\'est-ce qu\'un "HL" (Higher Low) ?',
            options: [
              'Un creux plus bas que le précédent',
              'Un creux plus haut que le précédent',
              'Un sommet plus haut',
              'Une zone de consolidation',
            ],
            correctAnswer: 1,
            explanation: 'Un Higher Low est un creux qui se forme plus haut que le creux précédent, signe de force haussière.',
          ),
          QuizQuestion(
            question: 'Comment identifier une tendance baissière ?',
            options: [
              'Prix fait des HH et HL',
              'Prix fait des LH et LL',
              'Prix est en range',
              'Prix ne bouge pas',
            ],
            correctAnswer: 1,
            explanation: 'Une tendance baissière montre des Lower Highs (LH) et Lower Lows (LL).',
          ),
          QuizQuestion(
            question: 'Qu\'est-ce qu\'un range (consolidation) ?',
            options: [
              'Une forte hausse',
              'Une forte baisse',
              'Le prix oscille entre support et résistance',
              'Le prix fait des HH',
            ],
            correctAnswer: 2,
            explanation: 'Un range est une période où le prix oscille entre un support et une résistance sans direction claire.',
          ),
        ],
      ),

      // ============ QUIZ BOS/CHOCH ============
      QuizData(
        id: 'bos_choch_1',
        title: 'BOS & CHoCH - Niveau 1',
        category: 'BOS/CHoCH',
        difficulty: 'medium',
        description: 'Maîtrisez les concepts de Break of Structure et Change of Character',
        xpReward: 75,
        questions: [
          QuizQuestion(
            question: 'Que signifie "BOS" ?',
            options: [
              'Break of Support',
              'Break of Structure',
              'Buy On Support',
              'Best Order Setup',
            ],
            correctAnswer: 1,
            explanation: 'BOS signifie Break of Structure - la cassure d\'un niveau important de la structure.',
          ),
          QuizQuestion(
            question: 'Un BOS haussier se produit quand :',
            options: [
              'Le prix casse un Low précédent',
              'Le prix casse un High précédent',
              'Le prix reste en range',
              'Le prix fait un Doji',
            ],
            correctAnswer: 1,
            explanation: 'Un BOS haussier se produit quand le prix casse un sommet (High) précédent vers le haut.',
          ),
          QuizQuestion(
            question: 'Que signifie "CHoCH" ?',
            options: [
              'Change of Chart',
              'Choose Chart',
              'Change of Character',
              'Chart of Change',
            ],
            correctAnswer: 2,
            explanation: 'CHoCH signifie Change of Character - signal potentiel de changement de tendance.',
          ),
          QuizQuestion(
            question: 'Un CHoCH haussier indique :',
            options: [
              'Continuation de la baisse',
              'Possibilité de retournement vers la hausse',
              'Range confirmé',
              'Pas de signification',
            ],
            correctAnswer: 1,
            explanation: 'Un CHoCH haussier suggère que la tendance baissière pourrait se transformer en hausse.',
          ),
          QuizQuestion(
            question: 'Quelle est la différence entre BOS et CHoCH ?',
            options: [
              'Aucune différence',
              'BOS confirme la tendance, CHoCH suggère un changement',
              'CHoCH est toujours haussier',
              'BOS est plus faible que CHoCH',
            ],
            correctAnswer: 1,
            explanation: 'Le BOS confirme la continuation de la tendance actuelle, tandis que le CHoCH suggère un potentiel changement de direction.',
          ),
          QuizQuestion(
            question: 'Après un BOS haussier, que fait généralement le prix ?',
            options: [
              'Chute immédiatement',
              'Reste immobile',
              'Continue la hausse ou retest la zone',
              'Forme un range permanent',
            ],
            correctAnswer: 2,
            explanation: 'Après un BOS haussier, le prix tend à continuer la hausse ou revenir tester la zone cassée avant de repartir.',
          ),
        ],
      ),

      // ============ QUIZ FVG ============
      QuizData(
        id: 'fvg_advanced',
        title: 'Fair Value Gap - Avancé',
        category: 'FVG',
        difficulty: 'hard',
        description: 'Quiz approfondi sur les Fair Value Gaps et leur utilisation',
        xpReward: 100,
        questions: [
          QuizQuestion(
            question: 'Qu\'est-ce qu\'un Fair Value Gap (FVG) ?',
            options: [
              'Un support horizontal',
              'Une zone de déséquilibre laissée par un mouvement rapide',
              'Un niveau de résistance',
              'Une moyenne mobile',
            ],
            correctAnswer: 1,
            explanation: 'Un FVG est une zone de déséquilibre (gap) créée quand le prix bouge très rapidement, laissant un vide.',
          ),
          QuizQuestion(
            question: 'Comment identifier un FVG sur 3 bougies ?',
            options: [
              'Les 3 bougies sont identiques',
              'La mèche de la bougie 1 ne touche pas la mèche de la bougie 3',
              'Les 3 bougies sont vertes',
              'Les 3 bougies sont en Doji',
            ],
            correctAnswer: 1,
            explanation: 'Un FVG se forme quand il y a un espace (gap) entre la mèche de la 1ère et de la 3ème bougie, avec une bougie impulsive au milieu.',
          ),
          QuizQuestion(
            question: 'Que fait généralement le prix avec un FVG ?',
            options: [
              'L\'ignore complètement',
              'Revient le combler partiellement ou totalement',
              'Ne le touche jamais',
              'Le casse toujours',
            ],
            correctAnswer: 1,
            explanation: 'Le prix a tendance à revenir "combler" le FVG (au moins 50%) avant de continuer sa direction.',
          ),
          QuizQuestion(
            question: 'Un FVG haussier se forme :',
            options: [
              'Lors d\'une forte baisse',
              'Lors d\'une forte hausse',
              'En range seulement',
              'Jamais',
            ],
            correctAnswer: 1,
            explanation: 'Un FVG haussier se crée lors d\'un mouvement haussier impulsif et rapide.',
          ),
          QuizQuestion(
            question: 'Quelle est la meilleure façon de trader un FVG ?',
            options: [
              'Entrer immédiatement à sa formation',
              'Attendre le retest du FVG puis chercher une confirmation',
              'Ignorer les FVG',
              'Trader contre le FVG',
            ],
            correctAnswer: 1,
            explanation: 'La meilleure approche est d\'attendre que le prix reteste le FVG, puis chercher une confirmation (rejet, bougie de retournement) avant d\'entrer.',
          ),
          QuizQuestion(
            question: 'Qu\'est-ce qu\'un FVG "inversé" ?',
            options: [
              'Un FVG qui disparaît',
              'Un FVG haussier qui devient baissier ou vice-versa',
              'Un faux FVG',
              'Un FVG horizontal',
            ],
            correctAnswer: 1,
            explanation: 'Un FVG inversé est un ancien FVG qui change de polarité après avoir été comblé et cassé.',
          ),
          QuizQuestion(
            question: 'Quel timeframe est le plus fiable pour les FVG ?',
            options: [
              'M1 uniquement',
              'Tous les timeframes sont égaux',
              'H1, H4, D1 sont plus fiables',
              'Les FVG ne fonctionnent pas',
            ],
            correctAnswer: 2,
            explanation: 'Les FVG sur des timeframes plus élevés (H1, H4, D1) sont généralement plus fiables et respectés par le marché.',
          ),
        ],
      ),

      // ============ QUIZ ORDER BLOCKS ============
      QuizData(
        id: 'orderblock_expert',
        title: 'Order Blocks - Expert',
        category: 'Order Block',
        difficulty: 'hard',
        description: 'Devenez expert en identification et trading des Order Blocks',
        xpReward: 100,
        questions: [
          QuizQuestion(
            question: 'Qu\'est-ce qu\'un Order Block ?',
            options: [
              'Un ordre en attente',
              'La dernière bougie avant un mouvement impulsif',
              'Une moyenne mobile',
              'Un indicateur technique',
            ],
            correctAnswer: 1,
            explanation: 'Un Order Block est la dernière bougie (ou zone) avant qu\'un mouvement impulsif fort se produise.',
          ),
          QuizQuestion(
            question: 'Un Bullish Order Block est :',
            options: [
              'La dernière bougie verte avant une baisse',
              'La dernière bougie rouge avant une hausse',
              'N\'importe quelle bougie verte',
              'Un support horizontal',
            ],
            correctAnswer: 1,
            explanation: 'Un Bullish OB est la dernière bougie baissière (rouge) avant qu\'un fort mouvement haussier se produise.',
          ),
          QuizQuestion(
            question: 'Pourquoi les Order Blocks sont-ils importants ?',
            options: [
              'Ils sont jolis sur le graphique',
              'Ils montrent où les institutions ont placé leurs ordres',
              'Ils prédisent l\'avenir avec certitude',
              'Ils n\'ont aucune importance',
            ],
            correctAnswer: 1,
            explanation: 'Les OB représentent des zones où le Smart Money (institutions) a accumulé ou distribué des positions massives.',
          ),
          QuizQuestion(
            question: 'Comment valider la qualité d\'un Order Block ?',
            options: [
              'Il doit être petit',
              'Le mouvement après doit être impulsif et fort',
              'Il doit être en M1',
              'Tous les OB sont identiques',
            ],
            correctAnswer: 1,
            explanation: 'Un OB de qualité est suivi d\'un mouvement impulsif fort, montrant l\'intervention institutionnelle.',
          ),
          QuizQuestion(
            question: 'Un OB non retesté est :',
            options: [
              'Invalide',
              'Plus puissant qu\'un OB retesté',
              'Identique aux autres',
              'À ignorer',
            ],
            correctAnswer: 1,
            explanation: 'Un OB qui n\'a jamais été retesté (fresh OB) est généralement plus puissant car la liquidité institutionnelle y est toujours présente.',
          ),
          QuizQuestion(
            question: 'Quelle confluence rend un OB encore plus puissant ?',
            options: [
              'OB seul suffit',
              'OB + FVG dans la même zone',
              'OB + Doji',
              'OB + couleur verte',
            ],
            correctAnswer: 1,
            explanation: 'Un OB combiné avec un FVG dans la même zone crée une confluence très puissante, augmentant les probabilités de succès.',
          ),
          QuizQuestion(
            question: 'Quand un OB est-il considéré comme "invalidé" ?',
            options: [
              'Après 1 jour',
              'Quand le prix le traverse complètement sans réaction',
              'Jamais',
              'Après un retest',
            ],
            correctAnswer: 1,
            explanation: 'Un OB est invalidé si le prix le traverse entièrement sans montrer de réaction (rejet, support/résistance).',
          ),
          QuizQuestion(
            question: 'Les meilleurs OB se forment après :',
            options: [
              'Un range tranquille',
              'Un liquidity grab (stop hunt)',
              'Une nouvelle économique',
              'N\'importe quand',
            ],
            correctAnswer: 1,
            explanation: 'Les OB les plus puissants se forment souvent après un liquidity grab, car les institutions ont "nettoyé" les stop loss avant de placer leurs ordres.',
          ),
        ],
      ),

      // ============ QUIZ LIQUIDITÉ ============
      QuizData(
        id: 'liquidity_master',
        title: 'Liquidité & Smart Money - Master',
        category: 'Liquidity',
        difficulty: 'hard',
        description: 'Comprenez en profondeur la manipulation de liquidité',
        xpReward: 125,
        questions: [
          QuizQuestion(
            question: 'Qu\'est-ce que la liquidité en trading ?',
            options: [
              'L\'argent sur votre compte',
              'Les ordres en attente (stop loss, take profit, limit orders)',
              'Le volume de la bougie',
              'Le nombre de traders',
            ],
            correctAnswer: 1,
            explanation: 'La liquidité représente tous les ordres en attente dans le marché : stop loss, limit orders, take profit, etc.',
          ),
          QuizQuestion(
            question: 'Où trouve-t-on généralement de la liquidité ?',
            options: [
              'Au milieu du range',
              'Au-dessus des highs et en-dessous des lows',
              'Dans les moyennes mobiles',
              'Nulle part',
            ],
            correctAnswer: 1,
            explanation: 'La liquidité s\'accumule au-dessus des sommets (stop loss des vendeurs) et en-dessous des creux (stop loss des acheteurs).',
          ),
          QuizQuestion(
            question: 'Qu\'est-ce qu\'un "liquidity grab" ?',
            options: [
              'Acheter beaucoup d\'actifs',
              'Un mouvement rapide pour déclencher les stop loss',
              'Vendre tout son portefeuille',
              'Une stratégie de scalping',
            ],
            correctAnswer: 1,
            explanation: 'Un liquidity grab (stop hunt) est quand le prix va rapidement chercher la liquidité en déclenchant les stop loss, avant de revenir.',
          ),
          QuizQuestion(
            question: 'Les niveaux ronds (100.00, 1.2000) sont importants car :',
            options: [
              'Ils sont beaux',
              'Les traders y placent souvent des ordres psychologiques',
              'Ils n\'ont aucune importance',
              'Ils sont magiques',
            ],
            correctAnswer: 1,
            explanation: 'Les niveaux ronds sont des zones psychologiques où beaucoup de traders placent leurs ordres, créant de la liquidité.',
          ),
          QuizQuestion(
            question: 'Le Smart Money cherche la liquidité pour :',
            options: [
              'S\'amuser',
              'Remplir leurs gros ordres sans impacter trop le prix',
              'Aider les traders retail',
              'Aucune raison',
            ],
            correctAnswer: 1,
            explanation: 'Les institutions cherchent la liquidité pour exécuter leurs ordres massifs sans faire bouger le prix de manière défavorable.',
          ),
          QuizQuestion(
            question: 'Un "sweep of liquidity" désigne :',
            options: [
              'Un nettoyage de bureau',
              'Le balayage rapide de plusieurs zones de liquidité',
              'Une analyse technique',
              'Un type d\'ordre',
            ],
            correctAnswer: 1,
            explanation: 'Un sweep of liquidity est un mouvement rapide qui balaye plusieurs zones de liquidité en déclenchant de nombreux stop loss.',
          ),
          QuizQuestion(
            question: 'Après un liquidity grab, le prix :',
            options: [
              'Continue dans la même direction toujours',
              'Revient souvent dans la direction opposée',
              'S\'arrête complètement',
              'Devient imprévisible',
            ],
            correctAnswer: 1,
            explanation: 'Après un liquidity grab, le prix revient généralement dans la direction opposée - c\'est le vrai mouvement intentionnel.',
          ),
          QuizQuestion(
            question: 'Comment trader avec la liquidité ?',
            options: [
              'Entrer au moment du liquidity grab',
              'Attendre le grab, puis entrer au retour dans la zone d\'intérêt',
              'Ignorer la liquidité',
              'Trader contre la liquidité',
            ],
            correctAnswer: 1,
            explanation: 'La stratégie ICT consiste à attendre le liquidity grab (faux mouvement), puis entrer quand le prix revient dans la zone d\'intérêt (OB/FVG).',
          ),
        ],
      ),

      // ============ QUIZ KILL ZONES ============
      QuizData(
        id: 'kill_zones_timing',
        title: 'Kill Zones & Timing - Pro',
        category: 'Kill Zones',
        difficulty: 'medium',
        description: 'Maîtrisez les meilleures fenêtres de trading',
        xpReward: 75,
        questions: [
          QuizQuestion(
            question: 'Qu\'est-ce qu\'une Kill Zone en trading ICT ?',
            options: [
              'Une zone dangereuse',
              'Une fenêtre de temps où le Smart Money est actif',
              'Un niveau de prix',
              'Une stratégie d\'options',
            ],
            correctAnswer: 1,
            explanation: 'Les Kill Zones sont des périodes spécifiques où le Smart Money (institutions) est le plus actif, créant les meilleurs setups.',
          ),
          QuizQuestion(
            question: 'La London Kill Zone se situe à (heure de Paris) :',
            options: [
              '02h00 - 05h00',
              '08h00 - 11h00',
              '14h00 - 17h00',
              '20h00 - 23h00',
            ],
            correctAnswer: 1,
            explanation: 'La London Kill Zone est de 08h00 à 11h00 (heure de Paris), période la plus volatile avec l\'ouverture européenne.',
          ),
          QuizQuestion(
            question: 'La New York Kill Zone se situe à (heure de Paris) :',
            options: [
              '08h00 - 11h00',
              '13h00 - 16h00',
              '18h00 - 21h00',
              '22h00 - 01h00',
            ],
            correctAnswer: 1,
            explanation: 'La New York Kill Zone est de 13h00 à 16h00 (Paris), période d\'overlap Londres-New York avec maximum de liquidité.',
          ),
          QuizQuestion(
            question: 'Quel est le concept du "Power of 3" ?',
            options: [
              '3 indicateurs techniques',
              'Accumulation, Manipulation, Distribution',
              '3 timeframes',
              '3 paires de devises',
            ],
            correctAnswer: 1,
            explanation: 'Le Power of 3 décrit le cycle : Accumulation (consolidation) → Manipulation (liquidity grab) → Distribution (vrai mouvement).',
          ),
          QuizQuestion(
            question: 'Quelle session est généralement la moins volatile ?',
            options: [
              'Session de Londres',
              'Session de New York',
              'Session Asiatique',
              'Toutes sont égales',
            ],
            correctAnswer: 2,
            explanation: 'La session Asiatique est généralement la moins volatile, avec des mouvements plus restreints et du ranging.',
          ),
          QuizQuestion(
            question: 'Pourquoi trader pendant les Kill Zones ?',
            options: [
              'Par habitude',
              'C\'est quand le Smart Money crée les meilleurs setups',
              'Parce que c\'est cool',
              'Aucune raison particulière',
            ],
            correctAnswer: 1,
            explanation: 'Les Kill Zones offrent la meilleure liquidité et volatilité, c\'est quand les institutions créent les setups les plus clairs.',
          ),
        ],
      ),

      // ============ QUIZ SILVER BULLET ============
      QuizData(
        id: 'silver_bullet_setup',
        title: 'Silver Bullet - Setup Complet',
        category: 'Silver Bullet',
        difficulty: 'hard',
        description: 'Maîtrisez la stratégie signature d\'ICT',
        xpReward: 150,
        questions: [
          QuizQuestion(
            question: 'Qu\'est-ce que la stratégie Silver Bullet ?',
            options: [
              'Une moyenne mobile',
              'Une fenêtre de temps spécifique avec un setup haute probabilité',
              'Un indicateur technique',
              'Un type d\'ordre',
            ],
            correctAnswer: 1,
            explanation: 'La Silver Bullet est une fenêtre de temps spécifique (généralement 1h) où un setup haute probabilité se forme selon le Power of 3.',
          ),
          QuizQuestion(
            question: 'Quelles sont les fenêtres Silver Bullet principales ?',
            options: [
              'Toute la journée',
              'London (09h-10h Paris) et NY (16h-17h Paris)',
              'Uniquement la nuit',
              'Pendant les news',
            ],
            correctAnswer: 1,
            explanation: 'Les fenêtres Silver Bullet sont : London 09h00-10h00 et New York 16h00-17h00 (heure de Paris).',
          ),
          QuizQuestion(
            question: 'Le setup Silver Bullet suit quelle séquence ?',
            options: [
              'Achat direct',
              'Liquidity grab → FVG/OB → Entrée',
              'Vente sur résistance',
              'Range trading',
            ],
            correctAnswer: 1,
            explanation: 'Le Silver Bullet suit : Liquidity grab (manipulation) → Formation FVG/OB → Entrée au retest avec confirmation.',
          ),
          QuizQuestion(
            question: 'Avant la Kill Zone, il faut :',
            options: [
              'Entrer immédiatement',
              'Analyser la structure H4/D1 et identifier les zones clés',
              'Dormir',
              'Ignorer l\'analyse',
            ],
            correctAnswer: 1,
            explanation: 'Avant la Kill Zone, on doit analyser la structure sur timeframes élevés (H4/D1) et marquer OB, FVG, zones de liquidité.',
          ),
          QuizQuestion(
            question: 'Dans un Silver Bullet haussier, on cherche :',
            options: [
              'Une cassure baissière',
              'Liquidity grab sous un low → Retour rapide créant FVG',
              'Un Doji',
              'N\'importe quel achat',
            ],
            correctAnswer: 1,
            explanation: 'Silver Bullet haussier : Prix grab liquidité sous un low → Retour explosif créant FVG → Entrée au retest.',
          ),
          QuizQuestion(
            question: 'Quel est le win rate typique d\'un Silver Bullet bien exécuté ?',
            options: [
              '30-40%',
              '60-70%',
              '90-100%',
              '10-20%',
            ],
            correctAnswer: 1,
            explanation: 'Selon ICT, un Silver Bullet bien exécuté a un win rate de 60-70%, avec des RR de 1:3 à 1:5.',
          ),
          QuizQuestion(
            question: 'Quand NE PAS trader le Silver Bullet ?',
            options: [
              'Tous les jours',
              'Pendant news importantes (NFP, FOMC), en range, vendredi PM',
              'Le lundi',
              'Jamais',
            ],
            correctAnswer: 1,
            explanation: 'Éviter : news importantes, absence de FVG, mouvement lent, range sans tendance, vendredi après-midi.',
          ),
        ],
      ),

      // ============ QUIZ RISK MANAGEMENT ============
      QuizData(
        id: 'risk_management_essential',
        title: 'Gestion du Risque - Essentiel',
        category: 'Risk Management',
        difficulty: 'medium',
        description: 'Protégez votre capital comme un professionnel',
        xpReward: 75,
        questions: [
          QuizQuestion(
            question: 'Quel pourcentage maximum devriez-vous risquer par trade ?',
            options: [
              '10-20%',
              '5-10%',
              '1-2%',
              '50%',
            ],
            correctAnswer: 2,
            explanation: 'La règle d\'or est de ne JAMAIS risquer plus de 1-2% de votre capital par trade pour protéger votre compte.',
          ),
          QuizQuestion(
            question: 'Qu\'est-ce que le ratio Risk/Reward (RR) ?',
            options: [
              'Le risque total du compte',
              'Le rapport entre ce que vous risquez et ce que vous visez',
              'Le nombre de trades',
              'Le levier utilisé',
            ],
            correctAnswer: 1,
            explanation: 'Le RR compare ce que vous risquez (SL) à ce que vous visez (TP). Exemple : RR 1:3 = risque 100€ pour viser 300€.',
          ),
          QuizQuestion(
            question: 'Quel est le RR minimum recommandé par ICT ?',
            options: [
              '1:1',
              '1:2',
              '1:5',
              '1:10',
            ],
            correctAnswer: 1,
            explanation: 'ICT recommande minimum un RR de 1:2, mais les setups ICT offrent souvent 1:3 à 1:5 voire plus.',
          ),
          QuizQuestion(
            question: 'Qu\'est-ce que le "revenge trading" ?',
            options: [
              'Une stratégie gagnante',
              'Re-trader immédiatement après une perte pour "se refaire"',
              'Un type d\'ordre',
              'Une analyse technique',
            ],
            correctAnswer: 1,
            explanation: 'Le revenge trading (trader par vengeance après une perte) est une erreur émotionnelle très coûteuse à éviter absolument.',
          ),
          QuizQuestion(
            question: 'Où placer le Stop Loss sur un Bullish Order Block ?',
            options: [
              'Au-dessus de l\'OB',
              'En-dessous de l\'OB',
              'Au milieu',
              'Pas de SL',
            ],
            correctAnswer: 1,
            explanation: 'Le Stop Loss sur un Bullish OB se place en-dessous de la zone de l\'Order Block.',
          ),
          QuizQuestion(
            question: 'Si vous perdez 50% de votre capital, quel gain faut-il pour revenir à l\'équilibre ?',
            options: [
              '50%',
              '75%',
              '100%',
              '25%',
            ],
            correctAnswer: 2,
            explanation: 'Si vous perdez 50%, il faut gagner 100% pour revenir ! C\'est pourquoi protéger son capital est crucial.',
          ),
        ],
      ),
    ];
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}
