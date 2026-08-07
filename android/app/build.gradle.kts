import java.util.Properties
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "de.vito0912.yaabsa"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "29.0.14206865"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "de.vito0912.yaabsa"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val envKeyAlias = System.getenv("KEY_ALIAS")
            val envKeyPassword = System.getenv("KEY_PASSWORD")
            val envStoreFile = System.getenv("STORE_FILE")
            val envStorePassword = System.getenv("STORE_PASSWORD")

            val keyAliasValue = envKeyAlias ?: keystoreProperties.getProperty("keyAlias")
            val keyPasswordValue = envKeyPassword ?: keystoreProperties.getProperty("keyPassword")
            val storeFilePath = envStoreFile ?: keystoreProperties.getProperty("storeFile")
            val storePasswordValue = envStorePassword ?: keystoreProperties.getProperty("storePassword")

            if (!keyAliasValue.isNullOrBlank()) {
                keyAlias = keyAliasValue
            }
            if (!keyPasswordValue.isNullOrBlank()) {
                keyPassword = keyPasswordValue
            }
            if (!storeFilePath.isNullOrBlank()) {
                storeFile = file(storeFilePath)
            }
            if (!storePasswordValue.isNullOrBlank()) {
                storePassword = storePasswordValue
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
        debug {
            applicationIdSuffix = ".dev"
            isDebuggable = true
        }
    }

    flavorDimensions += "carPlatform"
    productFlavors {
        create("auto") {
            dimension = "carPlatform"
        }
        create("automotive") {
            dimension = "carPlatform"
            versionCode = flutter.versionCode + 1
            versionName = flutter.versionName
        }
        create("wear") {
            dimension = "carPlatform"
            minSdk = flutter.minSdkVersion
            versionCode = flutter.versionCode + 2
            versionName = flutter.versionName
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.documentfile:documentfile:1.0.1")
    implementation("androidx.media:media:1.7.0")
    implementation("com.google.android.gms:play-services-wearable:19.0.0")
    implementation("com.google.android.material:material:1.12.0")
}
