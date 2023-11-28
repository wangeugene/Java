package functional;

import java.util.Random;
import java.util.function.Supplier;
import java.util.stream.IntStream;

public class SupplierRandom {
    public static void main(String[] args) {
        Supplier<Integer> randomSupplier = () -> new Random().nextInt(15);
        IntStream.range(0, 5).forEach(v -> System.out.println(randomSupplier.get()));
    }
}
