package thread;

import java.util.concurrent.locks.ReentrantLock;

import static java.lang.System.*;

class Shopper extends Thread {
    static int garlicCount = 0;
    static int potatoCount = 0;
    private static ReentrantLock reentrantLock = new ReentrantLock();

    /**
     * to guard the critic section, we can use one of these:
     * 1. reentrant lock
     * 2. atomic integer in this case
     * 3. synchronized keyword
     * The final garlic count is: 40000000
     * The final potato count is: 20000000
     * Elapsed time: 4242 ms
     */
    @Override
    public void run() {
        for (int i = 0; i < 10_000_000; i++) {
            addPotato();
            addGarlic();
        }
    }

    private void addGarlic() {
        reentrantLock.lock();
        garlicCount++;
        reentrantLock.unlock();
    }

    private void addPotato() {
        reentrantLock.lock();
        potatoCount++;
        addGarlic(); // reentrant lock allows to re-enter the lock
        reentrantLock.unlock();
    }
}

public class ReentrantLockShopping {
    public static void main(String[] args) throws InterruptedException {
        Thread bran = new Shopper();
        Thread olivia = new Shopper();
        long start = System.currentTimeMillis();
        bran.start();
        olivia.start();
        bran.join();
        olivia.join();
        long end = System.currentTimeMillis();
        out.printf("The final garlic count is: %d %nThe final potato count is: %d%n", Shopper.garlicCount, Shopper.potatoCount);
        out.println("Elapsed time: " + (end - start) + " ms");
    }
}
