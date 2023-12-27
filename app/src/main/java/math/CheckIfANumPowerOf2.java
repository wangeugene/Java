package math;

import java.util.Arrays;

public class CheckIfANumPowerOf2 {
    public static void main(String[] args) {
        Arrays.asList(2, 7, 8, 9, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384)
                .forEach(CheckIfANumPowerOf2::checkIfANumPowerOf2);
    }

    private static void checkIfANumPowerOf2(Integer integer) {
        boolean isPowerOf2 = (integer & (integer - 1)) == 0;
        System.out.println(integer + " is power of 2: " + isPowerOf2);
    }
}
