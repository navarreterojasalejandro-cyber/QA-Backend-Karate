package report;

import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.stream.Stream;

public final class CucumberReportGenerator {

    private CucumberReportGenerator() {
    }

    public static void main(String[] args) throws IOException {
        if (args.length != 2) {
            throw new IllegalArgumentException("Uso: CucumberReportGenerator <carpeta-json> <carpeta-salida>");
        }

        Path inputDirectory = Path.of(args[0]);
        File outputDirectory = Path.of(args[1]).toFile();
        List<String> jsonFiles = findCucumberJsonFiles(inputDirectory);

        if (jsonFiles.isEmpty()) {
            throw new IllegalStateException("No se encontraron archivos JSON de Cucumber en: " + inputDirectory);
        }

        Configuration configuration = new Configuration(outputDirectory, "Platzi Fake Store API");
        configuration.setBuildNumber("local");
        configuration.addClassifications("Framework", "Karate 1.5.2");
        configuration.addClassifications("Runtime", "Java 21");

        new ReportBuilder(jsonFiles, configuration).generateReports();
        System.out.println("Reporte Cucumber creado en: " + outputDirectory.getAbsolutePath());
    }

    private static List<String> findCucumberJsonFiles(Path root) throws IOException {
        if (!Files.isDirectory(root)) {
            return List.of();
        }

        try (Stream<Path> paths = Files.walk(root)) {
            return paths
                    .filter(Files::isRegularFile)
                    .filter(path -> path.toString().endsWith(".json"))
                    .filter(CucumberReportGenerator::isCucumberJson)
                    .map(Path::toString)
                    .toList();
        }
    }

    private static boolean isCucumberJson(Path path) {
        try {
            String content = Files.readString(path).stripLeading();
            return content.startsWith("[") && content.contains("\"elements\"");
        } catch (IOException exception) {
            return false;
        }
    }
}
