package loading;

public class LoadingOrder {
    public LoadingOrder() {
        System.out.println("I am constructor of LoadingOrder");
    }
    static {
        System.out.println("I am static block of LoadingOrder");
    }
    {
        System.out.println("I am instance block of LoadingOrder");
    }

    public static void main(String[] args) {
        new LoadingOrder();
        new LoadingOrder();
    }
}

class BeingLoad extends LoadingOrder{
    public BeingLoad() {
        System.out.println("I am constructor of BeingLoad");
    }
    static {
        System.out.println("I am static block of BeingLoad");
    }
    {
        System.out.println("I am instance block of BeingLoad");
    }
}
