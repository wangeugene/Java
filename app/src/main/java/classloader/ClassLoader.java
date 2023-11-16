package classloader;

class SuperClassLoader {
    public SuperClassLoader() {
        System.out.println("SuperClass Constructor 5");
    }

    static {
        System.out.println("SuperClass Static Initialize Block 1");
    }

    {
        System.out.println("SuperClass Initialize Block 4");
    }
}

public class ClassLoader extends SuperClassLoader {
    private static int[] staticInts = {9, 8, 7};
    private int[] ints = {1, 2, 3};

    {
        System.out.println(ints[1]);
        System.out.println("Initialize Block 6");
    }

    public ClassLoader() {
        System.out.println(staticInts[1]);
        System.out.println(ints[1]);
        System.out.println("Constructor 7");
    }

    static {
        System.out.println("Static Initialize Block 2");
    }
}

class SubClassLoader extends ClassLoader {
    public static void main(String[] args) {
        new SubClassLoader();
    }

    public SubClassLoader() {
        System.out.println("SubClass Constructor 9");
    }

    static {
        System.out.println("SubClass Static Initialize Block 3");
    }

    {
        System.out.println("SubClass Initialize Block 8");
    }
}

