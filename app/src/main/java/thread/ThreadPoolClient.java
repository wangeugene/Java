package thread;

import java.util.Date;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class ThreadPoolClient {
    public static void main(String[] args) {
        ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(8, 16, 100, TimeUnit.SECONDS, new LinkedBlockingQueue<>());
        threadPoolExecutor.execute(ThreadPoolClient::run);
    }

    private static void run() {
        System.out.println("I am thread at: " + new Date());
    }
}
