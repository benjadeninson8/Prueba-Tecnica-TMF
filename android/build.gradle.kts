allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    afterEvaluate {
        (project.extensions.findByName("android") as? com.android.build.gradle.BaseExtension)?.let { android ->
            if (android.namespace == null) {
                val pkg = if (project.group.toString().isNotEmpty()) project.group.toString() else "dev.isar.${project.name.replace("-", "_")}"
                android.namespace = pkg
            }
            android.compileSdkVersion(36)
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
