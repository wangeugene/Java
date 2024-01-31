package properties;

/**
 * java.home equals to
 * executing the following command in the terminal:
 * `/usr/libexec/java_home`
 */
public class SystemPropertiesPrinter {
    public static void main(String[] args) {
        System.out.println(System.getProperty("java.version"));
        System.out.println(System.getProperty("java.home"));
    }
}
