package multithreading;

import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class ThreadPoolClient {
    public static void main(String[] args) {
        ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(8, 16, 100, TimeUnit.SECONDS, new LinkedBlockingQueue<>());
        threadPoolExecutor.execute(() -> System.out.println("Hello"));
    }

}
