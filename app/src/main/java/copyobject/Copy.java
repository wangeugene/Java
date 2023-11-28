package copyobject;

import copyobject.pojo.User;

import java.util.ArrayList;

public class Copy {
    public static User user;

    static {
        user = new User();
        user.setAge(31);
        user.setName("Wang");
        user.setSalary(25000.0);
        ArrayList<String> experiences = new ArrayList<>();
        experiences.add("PingAn");
        experiences.add("LeShua");
        experiences.add("EPAM");
        user.setExperiences(experiences);
    }
}
