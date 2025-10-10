# 🚀 Guide de Push sur GitHub

## 📋 Prérequis
- Git installé sur votre machine Windows
- Compte GitHub : https://github.com/alcapone2308
- Projet téléchargé et extrait

---

## 🔧 Étape 1 : Créer un nouveau repo sur GitHub

1. **Allez sur** : https://github.com/new
2. **Nom du repo** : `sniper-market-academy` (ou autre nom)
3. **Description** : `Application Flutter d'apprentissage ICT/SMC avec portefeuille virtuel et quiz avancés`
4. **Visibilité** : 
   - ✅ **Public** (recommandé pour portfolio)
   - ou **Private** (si vous préférez)
5. **NE PAS** cocher :
   - ❌ Add a README file
   - ❌ Add .gitignore
   - ❌ Choose a license
6. **Cliquez** : **Create repository**

---

## 💻 Étape 2 : Sur votre machine Windows

### A. Ouvrir le terminal
- Ouvrez **Git Bash** (ou **PowerShell**)
- Naviguez vers le dossier du projet :

```bash
cd chemin/vers/sniper_market_academy
```

### B. Vérifier que Git est initialisé
```bash
git status
```

Vous devriez voir : `On branch master` ou `On branch main`

### C. Ajouter votre repo GitHub comme remote
**IMPORTANT** : Remplacez `VOTRE-NOM-REPO` par le nom que vous avez choisi !

```bash
git remote add origin https://github.com/alcapone2308/VOTRE-NOM-REPO.git
```

**Exemple** :
```bash
git remote add origin https://github.com/alcapone2308/sniper-market-academy.git
```

### D. Vérifier le remote
```bash
git remote -v
```

Vous devriez voir :
```
origin  https://github.com/alcapone2308/VOTRE-NOM-REPO.git (fetch)
origin  https://github.com/alcapone2308/VOTRE-NOM-REPO.git (push)
```

### E. Pousser le code vers GitHub
```bash
git branch -M main
git push -u origin main
```

**Note** : GitHub vous demandera de vous authentifier :
- **Username** : alcapone2308
- **Password** : Utilisez un **Personal Access Token** (voir ci-dessous)

---

## 🔑 Étape 3 : Créer un Personal Access Token (si nécessaire)

Si GitHub refuse votre mot de passe, créez un token :

1. **Allez sur** : https://github.com/settings/tokens
2. **Cliquez** : **Generate new token** → **Generate new token (classic)**
3. **Note** : `Sniper Market Academy Upload`
4. **Expiration** : 90 days (ou autre)
5. **Cochez** : `repo` (Full control of private repositories)
6. **Cliquez** : **Generate token**
7. **COPIEZ LE TOKEN** immédiatement (vous ne pourrez plus le revoir)
8. **Utilisez ce token** comme mot de passe lors du push

---

## ✅ Étape 4 : Vérification

1. **Allez sur** : https://github.com/alcapone2308/VOTRE-NOM-REPO
2. Vous devriez voir tout le code !
3. **Fichiers principaux** :
   - ✅ `lib/` (tout le code Dart)
   - ✅ `pubspec.yaml`
   - ✅ `README.md`
   - ✅ `FEATURES_ADDED.md`
   - ✅ `android/` et `ios/`

---

## 🎯 Structure du Repo GitHub

Votre repo contiendra :

```
sniper-market-academy/
├── .gitignore                    (✅ déjà créé)
├── README.md                     (✅ documentation)
├── FEATURES_ADDED.md             (✅ nouvelles fonctionnalités)
├── GITHUB_SETUP.md               (✅ ce fichier)
├── pubspec.yaml                  (✅ dépendances)
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── quiz_data.dart        (✨ 53 questions)
│   ├── providers/
│   │   ├── wallet_provider.dart  (✨ portefeuille)
│   │   └── quiz_provider.dart    (✨ quiz)
│   ├── screens/
│   │   ├── wallet_page.dart      (✨ nouveau)
│   │   └── quiz_page.dart        (✨ nouveau)
│   └── ...
├── android/                      (✅ config Android)
├── ios/                          (✅ config iOS)
└── assets/                       (✅ images, data)
```

---

## 📱 Cloner sur une autre machine

Plus tard, pour cloner votre projet :

```bash
git clone https://github.com/alcapone2308/VOTRE-NOM-REPO.git
cd VOTRE-NOM-REPO
flutter pub get
flutter run
```

---

## 🔄 Mises à jour futures

Après avoir modifié le code :

```bash
git add .
git commit -m "Description de vos changements"
git push
```

---

## 🆘 Problèmes Courants

### Problème 1 : "Authentication failed"
**Solution** : Utilisez un Personal Access Token au lieu du mot de passe

### Problème 2 : "Remote origin already exists"
**Solution** :
```bash
git remote remove origin
git remote add origin https://github.com/alcapone2308/VOTRE-NOM-REPO.git
```

### Problème 3 : "Permission denied"
**Solution** : Vérifiez que vous êtes bien connecté avec le compte alcapone2308

### Problème 4 : "Repository not found"
**Solution** : Vérifiez l'URL du repo. Elle doit être exactement :
```
https://github.com/alcapone2308/nom-exact-du-repo.git
```

---

## 📧 Support

Si vous rencontrez des problèmes :
1. Vérifiez que Git est installé : `git --version`
2. Vérifiez votre connexion GitHub : `git remote -v`
3. Vérifiez les logs : `git log`

---

## ✨ Contenu du Projet

Une fois poussé, votre repo contiendra :
- ✅ Application Flutter complète
- ✅ Portefeuille virtuel (10,000$)
- ✅ 53 questions quiz ICT/SMC
- ✅ 8 quiz avec explications
- ✅ 0 backend Python
- ✅ 100% offline (Hive)
- ✅ Documentation complète

**Votre code sera visible sur votre profil GitHub ! 🎉**

---

## 🌟 Bonus : Personnaliser le README GitHub

Une fois poussé, vous pouvez éditer le `README.md` directement sur GitHub pour ajouter :
- Screenshots de l'app
- Badges (Flutter, Dart, etc.)
- Instructions détaillées
- Lien vers l'APK/IPA

**Bon push ! 🚀**
