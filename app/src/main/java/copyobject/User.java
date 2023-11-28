package copyobject;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class User implements Cloneable {

    private String name;
    private int age;
    private double salary;
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
