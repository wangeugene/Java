package copyobject;

import lombok.Data;

import java.util.List;

@Data
public class UserView {
    private String name;
    private int age;
    private Double income;
    private List<String> experiences;
}
