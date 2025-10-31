package math;

import java.util.Arrays;

public class PrimeNumberValidator {
    public static void main(String[] args) {
        Arrays.asList(2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30)
                .forEach(PrimeNumberValidator::isPrime);
    }

    private static void isPrime(Integer integer) {
        boolean isPrime = true;
        for (int i = 2; i < integer; i++) {
            if (integer % i == 0) {
                isPrime = false;
                break;
            }
        }
        System.out.println(integer + " is prime: " + isPrime);
    }
}
