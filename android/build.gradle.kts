allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    val buildDirFile = newSubprojectBuildDir.asFile
    val projectDirMarker = File(buildDirFile, ".project_dir")
    val currentProjectPath = project.projectDir.absolutePath
    if (buildDirFile.exists()) {
        val previousProjectPath =
            if (projectDirMarker.exists()) projectDirMarker.readText() else null
        if (previousProjectPath != currentProjectPath) {
            File(buildDirFile, "kotlin").deleteRecursively()
            File(buildDirFile, "tmp/kotlin-classes").deleteRecursively()
            projectDirMarker.writeText(currentProjectPath)
        }
    }
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    val builtInKotlin =
        project.providers.gradleProperty("android.builtInKotlin").orNull?.toBoolean() ?: true
    if (!builtInKotlin) {
        project.pluginManager.withPlugin("com.android.library") {
            if (!project.plugins.hasPlugin("kotlin-android")) {
                project.pluginManager.apply("kotlin-android")
            }
        }
    }
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
