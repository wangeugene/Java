package json.jackson;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.stream.Collectors;

public class JSONStringJacksonDeserializer {
    private final static ObjectMapper objectMapper = new ObjectMapper();

    public static void main(String[] args) {
        try (BufferedReader bufferedReader = new BufferedReader(new FileReader("/Users/eugene/IdeaProjects/Java/app/src/main/resources/valid.json"))) {
            String jsonString = bufferedReader.lines().collect(Collectors.joining());
            Object object = objectMapper.readValue(jsonString, Object.class);
            System.out.println(object);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
