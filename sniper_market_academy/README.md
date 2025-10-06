# Sniper Market Academy 🎯

**Application mobile éducative ICT/SMC pour traders - 100% Offline**

## 📱 Description

Sniper Market Academy est une application Flutter complète pour apprendre les concepts Inner Circle Trader (ICT) et Smart Money Concepts (SMC). L'application fonctionne entièrement hors ligne avec stockage local.

## ✨ Fonctionnalités

### 🎓 Modules Théoriques
- **Market Structure** : Structure de marché (HH, HL, LH, LL)
- **Break of Structure (BOS)** : Cassures de structure
- **Fair Value Gap (FVG)** : Déséquilibres de prix
- **Optimal Trade Entry (OTE)** : Zones d'entrée optimales
- **Liquidité** : Pools de liquidité et manipulation
- **Displacement** : Mouvements impulsifs
- **Order Blocks (OB)** : Zones institutionnelles
- **Kill Zones** : Sessions de trading optimales
- **Silver Bullet** : Stratégie signature ICT

### 🧠 Exercices Interactifs
- Identification de BOS/CHoCH
- Marquage des FVG
- Repérage des Order Blocks
- Setup complets ICT
- Quiz de validation

### 📊 Simulateur de Trading
- Paper trading avec graphiques réels
- Pratique des setups ICT/SMC
- Suivi des performances

### 📈 Progression
- Système de niveaux et XP
- Suivi des modules complétés
- Statistiques détaillées
- Badges de réussite

### 📚 Glossaire Complet
- Tous les termes ICT/SMC
- Définitions claires
- Exemples visuels

### ⚙️ Paramètres
- Thème sombre/clair
- Notifications
- Gestion du profil
- Réinitialisation des données

## 🛠️ Technologies

- **Flutter** : 3.32.2
- **Dart** : 3.8.1
- **Stockage** : Hive + SharedPreferences
- **Charts** : Candlesticks, FL Chart, Syncfusion
- **State Management** : Provider
- **Audio** : Audioplayers

## 📦 Installation

### Prérequis

```bash
# Installer Flutter 3.32.2
flutter --version
# Flutter 3.32.2 • channel stable
# Dart 3.8.1

# Vérifier l'installation
flutter doctor
```

### Cloner le projet

```bash
git clone <votre-repo>
cd sniper_market_academy
```

### Installer les dépendances

```bash
flutter pub get
```

### Générer les adaptateurs Hive

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🚀 Build

### Android (APK)

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split par ABI (taille optimisée)
flutter build apk --split-per-abi --release

# App Bundle (pour Play Store)
flutter build appbundle --release
```

Les fichiers générés seront dans :
- APK : `build/app/outputs/flutter-apk/`
- App Bundle : `build/app/outputs/bundle/release/`

### iOS (IPA)

```bash
# Ouvrir Xcode
open ios/Runner.xcworkspace

# Ou via ligne de commande
flutter build ios --release

# Pour archive et export
flutter build ipa --release
```

Le fichier `.ipa` sera dans : `build/ios/ipa/`

### Configuration de signature

#### Android

**IMPORTANT** : Aucune clé de signature n'est incluse dans ce projet pour des raisons de sécurité.

Pour signer l'application :

1. Créez votre keystore :
```bash
keytool -genkey -v -keystore ~/sniper-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias sniper
```

2. Créez `android/key.properties` :
```properties
storePassword=<votre-password>
keyPassword=<votre-password>
keyAlias=sniper
storeFile=<chemin-vers-votre-keystore>
```

3. Le fichier `android/app/build.gradle` est déjà configuré pour utiliser ces clés.

#### iOS

1. Ouvrez `ios/Runner.xcworkspace` dans Xcode
2. Sélectionnez votre équipe de développement
3. Configurez le Bundle Identifier unique
4. Xcode gérera automatiquement les profils de provisioning

## 🎮 Lancer l'application

### Mode développement

```bash
# Lister les devices disponibles
flutter devices

# Lancer sur device connecté
flutter run

# Lancer avec hot reload
flutter run --hot

# Lancer en mode release
flutter run --release
```

### Émulateurs

```bash
# Android
flutter emulators
flutter emulators --launch <emulator_id>

# iOS (macOS seulement)
open -a Simulator
```

## 📁 Structure du Projet

```
sniper_market_academy/
├── lib/
│   ├── main.dart                 # Point d'entrée
│   ├── models/                   # Modèles de données (Hive)
│   │   ├── user_progress.dart
│   │   ├── module.dart
│   │   ├── exercise.dart
│   │   └── trade.dart
│   ├── services/                 # Services (stockage, logique)
│   │   ├── hive_service.dart
│   │   ├── progress_service.dart
│   │   └── audio_service.dart
│   ├── providers/                # State management
│   │   ├── theme_provider.dart
│   │   └── user_provider.dart
│   ├── screens/                  # Écrans principaux
│   │   ├── home/
│   │   ├── modules/
│   │   ├── exercises/
│   │   ├── simulator/
│   │   ├── progression/
│   │   ├── glossary/
│   │   └── settings/
│   ├── widgets/                  # Composants réutilisables
│   │   ├── candlestick_chart.dart
│   │   ├── progress_card.dart
│   │   └── module_card.dart
│   ├── theme/                    # Thème et styles
│   │   ├── app_theme.dart
│   │   └── colors.dart
│   └── utils/                    # Utilitaires
│       ├── constants.dart
│       └── helpers.dart
├── assets/
│   ├── images/
│   ├── animations/
│   ├── audio/
│   └── data/
├── android/                      # Configuration Android
├── ios/                          # Configuration iOS
├── test/                         # Tests unitaires
├── pubspec.yaml                  # Dépendances
└── README.md
```

## 🎨 Assets

Tous les assets doivent être placés dans les dossiers appropriés :

- **Images** : `assets/images/`
- **Modules** : `assets/images/modules/`
- **Exercices** : `assets/images/exercises/`
- **Charts** : `assets/images/charts/`
- **Animations** : `assets/animations/`
- **Audio** : `assets/audio/`
- **Données** : `assets/data/`

## 🔧 Configuration

### Modifier le nom de l'app

**Android** : `android/app/src/main/AndroidManifest.xml`
```xml
<application android:label="Sniper Market Academy">
```

**iOS** : `ios/Runner/Info.plist`
```xml
<key>CFBundleName</key>
<string>Sniper Market Academy</string>
```

### Changer l'icône

1. Placez votre icône 1024x1024 dans `assets/images/icon.png`
2. Exécutez :
```bash
flutter pub run flutter_launcher_icons
```

## 🐛 Débogage

```bash
# Logs en temps réel
flutter logs

# Analyser l'app
flutter analyze

# Nettoyer le build
flutter clean
flutter pub get
```

## 📊 Performance

```bash
# Profile mode
flutter run --profile

# DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

## 📝 Notes Importantes

### Stockage Local

- **Hive** : Pour les données structurées (progression, trades)
- **SharedPreferences** : Pour les préférences simples
- Toutes les données sont stockées localement
- Pas besoin de connexion Internet

### Pas de Backend

- Cette application fonctionne 100% offline
- Aucun serveur Python ou autre backend requis
- Tous les contenus sont embarqués dans l'app

### Ajout de Backend (Optionnel)

Si vous souhaitez ajouter un backend plus tard :

```dart
// lib/services/api_service.dart (OPTIONNEL)
// 
// import 'package:http/http.dart' as http;
// 
// class ApiService {
//   static const String baseUrl = 'https://votre-api.com';
//   
//   Future<void> syncProgress() async {
//     // Synchroniser la progression avec le serveur
//   }
//   
//   Future<void> fetchLeaderboard() async {
//     // Récupérer le classement global
//   }
// }
```

## 🤝 Contribution

1. Fork le projet
2. Créez votre branche (`git checkout -b feature/amazing-feature`)
3. Commit vos changements (`git commit -m 'Add amazing feature'`)
4. Push vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrez une Pull Request

## 📄 Licence

Ce projet est sous licence MIT.

## 📧 Contact

Pour toute question ou support : contact@snipermarketacademy.com

## 🙏 Remerciements

- Inner Circle Trader (ICT) pour les concepts
- Communauté SMC
- Tous les contributeurs

---

**Fait avec ❤️ pour les traders qui veulent apprendre le Smart Money**
