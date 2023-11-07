package copyobjects;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class User implements Cloneable {

    private String name;
    private int age;
    private List<String> experiences;

    @Override
    public User clone() {
        try {
            User cloned = (User) super.clone();
            cloned.experiences = new ArrayList<>(experiences);
            return cloned;

        } catch (CloneNotSupportedException e) {
            throw new AssertionError();
        }
    }
}
