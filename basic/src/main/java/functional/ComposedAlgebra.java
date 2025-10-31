package functional;

import java.util.function.Function;

public class ComposedAlgebra {
    public static void main(String[] args) {
        Function<Integer, Integer> times3 = x -> x * 3;
        Function<Integer, Integer> plus1 = x -> x + 1;
        // y = 3x + 1 = 16;
        Integer y = times3.andThen(plus1).apply(5);
        System.out.println("y = " + y);
        /// y = ( x + 1 ) * 3 = 18
        Integer z = plus1.andThen(times3).apply(5);
        System.out.println("z = " + z);
    }
}
