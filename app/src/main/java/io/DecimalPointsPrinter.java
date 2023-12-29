package io;

public class DecimalPointsPrinter {
    public static void main(String[] args) {
        final double d = 5.0;
        System.out.printf("%f%n", d);
        System.out.printf("%s%n", d);
        System.out.printf("%.1f%n", d);
        System.out.printf("%.2f%n", d);
        System.out.printf("%.3f%n", d);
    }
}
