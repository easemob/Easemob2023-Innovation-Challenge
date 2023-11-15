pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "kangaroo_demo_for_kotlin"
include(":app")
include(":ktlib")
include(":ktui")
include(":basecommonlib")
project(":ktlib").projectDir = File(settingsDir, "/kangaroo_lib_for_kotlin/ktlib")
project(":ktui").projectDir = File(settingsDir, "/kangaroo_lib_for_kotlin/ktui")
project(":basecommonlib").projectDir = File(settingsDir, "/kangaroo_lib_for_kotlin/basecommonlib")
