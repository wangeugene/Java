package json.gson;


import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.stream.Collectors;

public class JSONStringGsonDeserializer {
    private final static Gson gson = new Gson();

    public static void main(String[] args) {
        try (BufferedReader bufferedReader = new BufferedReader(new FileReader("/Users/eugene/IdeaProjects/Java/app/src/main/resources/valid.json"))) {
            String jsonString = bufferedReader.lines().collect(Collectors.joining());
            JsonObject jsonObject = gson.fromJson(jsonString, JsonObject.class);
            System.out.println(jsonObject);
            JsonArray jsonArray = jsonObject.get("result").getAsJsonArray();
            for (JsonElement jsonElement : jsonArray) {
                System.out.println(jsonElement);
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
