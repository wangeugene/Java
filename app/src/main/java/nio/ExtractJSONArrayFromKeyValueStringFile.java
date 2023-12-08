package nio;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;


/**
 * convert from (each JSON alike string):
 * "json_str": "{"time": 1701014820, "4x40296": 0.796}"
 * to real JSON
 * [ {"time": 1701014820,"4x40296": 0.796} ]
 */
public class ExtractJSONArrayFromKeyValueStringFile {

    public static void main(String[] args) {
        Path path = Path.of("/Users/eugene/IdeaProjects/Java/app/src/main/resources/jsonAlikeInput.response");
        Path pathOut = Path.of("/Users/eugene/IdeaProjects/Java/app/src/main/resources/nioWrite.json");
        try {
            List<String> lines = Files.readAllLines(path);
            List<String> outLines = new ArrayList<>();
            for (String line : lines) {
                if (line.contains("\"json_str\"")) {
                    line = line.substring(20);
                    line = "{" + line.substring(0, line.length() - 2) + "},";
                    System.out.println(line);
                    outLines.add(line);
                }
            }
            String lastLine = outLines.get(outLines.size() - 1);
            lastLine = lastLine.substring(0, lastLine.length() - 1);
            outLines.remove(outLines.size() - 1);
            outLines.add(lastLine);
            outLines.add(0, "[");
            outLines.add(outLines.size(), "]");
            Files.write(pathOut, outLines);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
