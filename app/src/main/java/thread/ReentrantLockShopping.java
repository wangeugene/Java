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
     */
    @Override
    public void run() {
        for (int i = 0; i < 10_000; i++) {
            addPotato();
            addGarlic();
        }
    }

    private void addGarlic() {
        reentrantLock.lock();
        out.println(reentrantLock.getHoldCount());
        garlicCount++;
        reentrantLock.unlock();
    }

    private void addPotato() {
        reentrantLock.lock();
        potatoCount++;
        addGarlic();
        reentrantLock.unlock();
    }
}

public class ReentrantLockShopping {
    public static void main(String[] args) throws InterruptedException {
        Thread bran = new Shopper();
        Thread olivia = new Shopper();
        bran.start();
        olivia.start();
        bran.join();
        olivia.join();
        out.printf("The final garlic count is: %d %nThe final potato count is: %d", Shopper.garlicCount, Shopper.potatoCount);
    }
}
