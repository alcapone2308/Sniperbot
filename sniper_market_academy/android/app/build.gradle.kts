import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ✅ Firebase plugin
}

// 🔐 Chargement de la configuration de signature
val keystoreProperties = Properties().apply {
    load(FileInputStream(rootProject.file("key.properties")))
}

android {
    namespace = "com.snipermarketacademy.app"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.snipermarketacademy.app"
        minSdk = 21
        targetSdk = 35
        versionCode = 14
        versionName = "1.0.1"
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
        getByName("debug") {
            signingConfig = signingConfigs.getByName("release")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Desugar pour compatibilité Java 11+
    add("coreLibraryDesugaring", "com.android.tools:desugar_jdk_libs:2.0.4")

    // ✅ Firebase BOM (gère toutes les versions ensemble)
    implementation(platform("com.google.firebase:firebase-bom:33.4.0"))

    // ✅ Firestore (classement global)
    implementation("com.google.firebase:firebase-firestore-ktx")

    // ✅ Analytics (optionnel mais conseillé)
    implementation("com.google.firebase:firebase-analytics-ktx")
}
