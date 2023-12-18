package multithreading;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

class Shopper extends Thread {
    static int garlicCount = 0;
    private static Lock lock = new ReentrantLock();

    @Override
    public void run() {
        for (int i = 0; i < 100_00; i++) {
            lock.lock();
            garlicCount++;
            lock.unlock();
        }
    }
}

public class MutualExclusionShopping {
    public static void main(String[] args) throws InterruptedException {
        Thread bran = new Shopper();
        Thread olivia = new Shopper();
        bran.start();
        olivia.start();
        bran.join();
        olivia.join();
        System.out.println(Shopper.garlicCount);
    }
}
