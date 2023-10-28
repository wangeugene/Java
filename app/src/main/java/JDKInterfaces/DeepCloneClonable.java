package JDKInterfaces;

import java.util.ArrayList;
import java.util.List;

public class DeepCloneClonable {
    public static void main(String[] args) {
        User user = new User();
        user.setAge(31);
        user.setName("WangWangWangWangWangWangWangWangWangWangWangWangWangWangWangWangWangWangWangWangWangWangWangWangWangWangWangWangWangWangWang");
        ArrayList<String> experiences = new ArrayList<>();
        experiences.add("PingAn");
        experiences.add("LeShua");
        experiences.add("EPAM");
        user.setExperiences(experiences);

        User cloned = user.clone();

        System.out.println(user.getName());
        System.out.println(user.getAge());
        System.out.println(cloned.getName());
        System.out.println(cloned.getAge());
        System.out.println(cloned.getExperiences());

        cloned.setAge(33);
        cloned.setName("Li");
        cloned.getExperiences().set(1, "LeShuaFake");

        System.out.println(user.getName());
        System.out.println(user.getAge());
        System.out.println(cloned.getName());
        System.out.println(cloned.getAge());
        System.out.println(user.hashCode());
        System.out.println(cloned.hashCode());
        System.out.println(user.getExperiences());
        System.out.println(cloned.getExperiences());
    }
}

@lombok.Getter
class User implements Cloneable{
    private String name;
    private int age;
    private List<String> experiences;

    public void setName(String name) {
        this.name = name;
    }

    public void setAge(int age) {
        this.age = age;
    }

    @Override
    public User clone() {
        try {
            // TODO: copy mutable state here, so the clone can't change the internals of the original
            User cloned = (User) super.clone();
            cloned.experiences = new ArrayList<>(experiences);
            return cloned;

        } catch (CloneNotSupportedException e) {
            throw new AssertionError();
        }
    }

    public void setExperiences(List<String> experiences) {
        this.experiences = experiences;
    }
}
