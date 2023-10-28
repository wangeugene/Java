package decorator;

public class DecoratorImpl implements Decorator {
    private Decorator decorated = new Decorated();
    @Override
    public String enhance() {
        return "enhanced " + decorated.enhance();
    }
}
