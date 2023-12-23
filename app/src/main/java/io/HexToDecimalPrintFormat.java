package io;

public class HexToDecimalPrintFormat {
    public static void main(String[] args) {
        String hex = "AA";
        System.out.println(Integer.parseInt(hex, 16));
        System.out.printf("15%s", hex);
    }
}
