package copyobjects;

import java.util.ArrayList;

public class Copy {
    protected static User user;

    static {
        user = new User();
        user.setAge(31);
        user.setName("Wang");
        ArrayList<String> experiences = new ArrayList<>();
        experiences.add("PingAn");
        experiences.add("LeShua");
        experiences.add("EPAM");
        user.setExperiences(experiences);
    }
}
