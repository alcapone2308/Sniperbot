import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ✅ Firebase plugin
}

// 🔐 Chargement des propriétés de signature
val keystoreProperties = Properties().apply {
    load(FileInputStream(rootProject.file("key.properties")))
}

android {
    namespace = "com.snipermarketacademy.app"
    compileSdk = 36 // ✅ mise à jour pour compatibilité avec plugins Android récents

    defaultConfig {
        applicationId = "com.snipermarketacademy.app"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = 17
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
        sourceCompatibility = JavaVersion.VERSION_17 // ✅ Java 17 requis par Gradle 8+
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17" // ✅ cohérent avec compileOptions
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Desugar pour compatibilité Java 17+
    add("coreLibraryDesugaring", "com.android.tools:desugar_jdk_libs:2.0.4")

    // ✅ Firebase BOM (gère toutes les versions ensemble)
    implementation(platform("com.google.firebase:firebase-bom:33.4.0"))

    // ✅ Firestore
    implementation("com.google.firebase:firebase-firestore-ktx")

    // ✅ Analytics
    implementation("com.google.firebase:firebase-analytics-ktx")
}
