package thread;

import static java.lang.System.out;

class SynchronizedBlockShopper extends Thread {
    static int garlicCount = 0;
    static int potatoCount = 0;

    private static final Object garlicLock = new Object();

    /**
     * The final garlic count is: 40000000
     * The final potato count is: 20000000
     * Elapsed time: 605 ms
     */
    @Override
    public void run() {
        for (int i = 0; i < 10_000_000; i++) {
            addPotato();
            addGarlic();
        }
    }

    private void addGarlic() {
        synchronized (garlicLock) {
            garlicCount++;
        }
    }

    private void addPotato() {
        synchronized (garlicLock) {
            potatoCount++;
            addGarlic();
        }
    }
}

public class SynchronizedBlockShopping {
    public static void main(String[] args) throws InterruptedException {
        Thread bran = new SynchronizedBlockShopper();
        Thread olivia = new SynchronizedBlockShopper();
        long start = System.currentTimeMillis();
        bran.start();
        olivia.start();
        bran.join();
        olivia.join();
        long end = System.currentTimeMillis();
        out.printf("The final garlic count is: %d %nThe final potato count is: %d%n", SynchronizedBlockShopper.garlicCount, SynchronizedBlockShopper.potatoCount);
        out.println("Elapsed time: " + (end - start) + " ms");
    }
}
