package multithreading;

import java.math.BigInteger;
import java.util.*;
import java.util.concurrent.*;

public class CalculateFactorial {
    public static void main(String[] args) {
        List<Integer> numbers = Arrays.asList(3, 7, 10, 14, 20);
        Map<Integer, BigInteger> answers = findAnswer(numbers);
        System.out.println(answers);
    }

    public static Map<Integer, BigInteger> findAnswer(List<Integer> numbers) {
        ExecutorService executorService = Executors.newFixedThreadPool(5);
        List<Future<Map.Entry<Integer, BigInteger>>> futures = new ArrayList<>();
        for (Integer number : numbers) {
            futures.add(executorService.submit(new FactorialTask(number)));
        }

        Map<Integer, BigInteger> results = new HashMap<>();
        for (Future<Map.Entry<Integer, BigInteger>> future : futures) {
            try {
                Map.Entry<Integer, BigInteger> result = future.get();
                results.put(result.getKey(), result.getValue());
            } catch (InterruptedException | ExecutionException e) {
                throw new RuntimeException(e);
            }
        }
        executorService.shutdown();
        return results;
    }

}

class FactorialTask implements Callable<Map.Entry<Integer, BigInteger>> {
    private final Integer number;

    public FactorialTask(Integer number) {
        this.number = number;
    }

    @Override
    public Map.Entry<Integer, BigInteger> call() {
        BigInteger factorial = BigInteger.ONE;
        for (int i = 2; i <= number; i++) {
            factorial = factorial.multiply(BigInteger.valueOf(i));
        }
        return new AbstractMap.SimpleEntry<>(number, factorial);
    }
}
