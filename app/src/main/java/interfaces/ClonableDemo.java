package interfaces;

public class ClonableDemo {
    public static void main(String[] args) {
        User user = new User();
        user.setAge(31);
        user.setName("Wang");
    }
}

class User implements Cloneable{
    private String name;
    private int age;

    public void setName(String name) {
        this.name = name;
    }

    public void setAge(int age) {
        this.age = age;
    }
}
