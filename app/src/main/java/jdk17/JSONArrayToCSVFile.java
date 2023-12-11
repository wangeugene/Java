package jdk17;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class JSONArrayToCSVFile {
    private static final Gson gson = new Gson();

    public static void main(String[] args) {
        Path filePath = Path.of("/Users/eugene/IdeaProjects/Java/app/src/main/resources/nioWrite.json");
        Path outPath = Path.of("/Users/eugene/IdeaProjects/Java/app/src/main/resources/output.csv");
        try {
            String content = Files.readString(filePath, StandardCharsets.UTF_8);

            JsonArray jsonArray = gson.fromJson(content, JsonArray.class);
            JsonObject firstJsonObject = jsonArray.get(0).getAsJsonObject();
            String[] header = firstJsonObject.keySet().toArray(new String[0]);

            System.out.println(jsonArray.size());
            List<String[]> outs = new ArrayList<>();
            outs.add(header);
            for (JsonElement jsonElement : jsonArray) {
                if (jsonElement.isJsonObject()) {
                    JsonObject jsonObject = jsonElement.getAsJsonObject();
                    String[] rowData = new String[header.length];
                    for (int i = 0; i < header.length; i++) {
                        rowData[i] = jsonObject.get(header[i]).getAsString();
                    }
                    outs.add(rowData);
                } else {
                    System.err.println("Not a JSON Object!");
                }
            }
            System.out.println(outs.size());
            System.out.println(Arrays.toString(outs.get(outs.size() - 1)));

            List<String> outlines = outs.stream()
                    .map(line -> String.join(",", line))
                    .toList();
            Files.write(outPath, outlines, StandardOpenOption.CREATE);

        } catch (IOException e) {
            System.err.println(e.getMessage());
        }
    }
}
