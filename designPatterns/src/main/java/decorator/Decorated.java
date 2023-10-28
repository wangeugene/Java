package decorator;

public class Decorated implements Decorator {
    @Override
    public String enhance() {
        return "I am plain decorate impl";
    }
}
