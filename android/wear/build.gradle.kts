import java.util.regex.Pattern

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

val pubspecVersion: String = file("../../pubspec.yaml").readText()
val versionMatch = Pattern.compile("version:\\s*(\\S+)").matcher(pubspecVersion)
check(versionMatch.find()) { "version not found in pubspec.yaml" }
val versionParts = versionMatch.group(1)!!.split("+")
val flutterVersionName = versionParts[0]
val flutterVersionCode = versionParts.getOrElse(1) { "1" }.toInt()

android {
    namespace = "com.nomad.alarm.wear"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.nomad.alarm.wear"
        minSdk = 26
        targetSdk = 36
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    buildTypes {
        release {
            isMinifyEnabled = false
        }
    }
}

dependencies {
    implementation("com.google.android.gms:play-services-wearable:18.2.0")
    implementation("androidx.core:core-ktx:1.15.0")
    implementation("androidx.wear.watchface:watchface-complications-data-source-ktx:1.2.1")
}
