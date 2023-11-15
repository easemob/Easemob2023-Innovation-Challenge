import com.google.protobuf.gradle.id
import com.google.protobuf.gradle.proto
import org.jetbrains.kotlin.cli.jvm.main

plugins {
    alias(libs.plugins.android.library)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kapt)
    alias(libs.plugins.hilt)
    alias(libs.plugins.protobuf)
}
android {
    namespace = "com.kangaroo.ktlib"
    compileSdk = libs.versions.compileSdk.get().toInt()

    defaultConfig {
        minSdk = libs.versions.minSdk.get().toInt()

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        consumerProguardFiles("consumer-rules.pro")
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
    protobuf{
        protoc{
            artifact = "com.google.protobuf:protoc:3.8.0"
        }

        generateProtoTasks {
            all().forEach {
                it.builtins {
                    id("java"){
                        option("lite")
                    }
                }
            }
        }
    }


    sourceSets["main"].let {
        it.proto {
            srcDir("src/main/proto")
        }
        it.java {
            srcDir("src/main/java")
        }
    }
}

dependencies {

    implementation(libs.androidx.appcompat)
    implementation(libs.androidx.core.ktx)
    testImplementation(libs.junit4)
    androidTestImplementation(libs.androidx.test.ext.junit)
    androidTestImplementation(libs.androidx.test.espresso.core)

    implementation(libs.androidx.lifecycle.process)
    implementation(libs.androidx.lifecycle.common.java8)
    implementation(libs.orhanobut.logger)
    implementation(libs.squareup.moshi)

    api(libs.androidx.dataStore.preferences)
    api(libs.androidx.dataStore.core)

    implementation(libs.google.protobuf.javalite)
    implementation(libs.jakewharton.disklrucache)

    implementation(platform(libs.squareup.okhttp3.bom))
    implementation(libs.squareup.okhttp3)
    api(libs.squareup.retrofit2)
    implementation(libs.squareup.retrofit2.converter.moshi)

    // Hilt
    implementation(libs.hilt.android.core)
    kapt(libs.hilt.compiler)


}