package classloader;

class SuperClassLoader {
    public SuperClassLoader() {
        System.out.println("SuperClass Constructor 5");
    }

    static {
        System.out.println("SuperClass Static Initialize Block 1");
    }

}

public class ClassLoadOrder extends SuperClassLoader {
    private final static int[] staticInts = {9, 8, 7};
    private final int[] ints = {1, 2, 3};

    {
        System.out.println(ints[1]);
        System.out.println("Initialize Block 6");
    }

    public ClassLoadOrder() {
        System.out.println(staticInts[1]);
        System.out.println(ints[1]);
        System.out.println("Constructor 7");
    }

    static {
        System.out.println("Static Initialize Block 2");
    }
}

class SubClassLoadOrder extends ClassLoadOrder {
    public static void main(String[] args) {
        new SubClassLoadOrder();
    }

    public SubClassLoadOrder() {
        System.out.println("SubClass Constructor 9");
    }

    static {
        System.out.println("SubClass Static Initialize Block 3");
    }

}

