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
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

allprojects {
    val currentProject = this
    currentProject.plugins.withId("com.android.library") {
        val androidExt = currentProject.extensions.findByName("android")
        if (androidExt != null) {
            val dsl = androidExt as Object
            try {
                val getNamespace = dsl.javaClass.getMethod("getNamespace")
                if (getNamespace.invoke(dsl) == null) {
                    val setNamespace = dsl.javaClass.getMethod("setNamespace", String::class.java)
                    if (currentProject.name == "isar_flutter_libs") {
                        setNamespace.invoke(dsl, "dev.isar.isar_flutter_libs")
                    } else if (currentProject.name == "path_provider_android") {
                        setNamespace.invoke(dsl, "io.flutter.plugins.pathprovider")
                    }
                }
            } catch (e: Exception) {
                // Ignore if properties are already finalized
            }
        }
    }
}