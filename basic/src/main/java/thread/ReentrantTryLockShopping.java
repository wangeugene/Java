package thread;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@SuppressWarnings("ALL")
class TryLockShopper extends Thread {
    private int itemsToAdd = 0;
    private static int itemsOnNotepad = 0;
    private static Lock pencil = new ReentrantLock();

    TryLockShopper(String name) {
        this.setName(name);
    }

    /**
     * tryLock() improve performance by not blocking the thread
     * if the lock is not available. lock() will block the thread
     */
    @Override
    public void run() {
        while (itemsOnNotepad <= 20) {
            if (itemsToAdd > 0 && pencil.tryLock()) {
                try {
                    itemsOnNotepad += itemsToAdd;
                    System.out.println(this.getName() + " added " + itemsToAdd + " items to notepad.");
                    itemsToAdd = 0;
                    Thread.sleep(300);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                } finally {
                    pencil.unlock();
                }
            } else {
                try {
                    Thread.sleep(100);
                    itemsToAdd++;
                    System.out.println(this.getName() + " found something to buy.");
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}

public class ReentrantTryLockShopping {
    public static void main(String[] args) throws InterruptedException {
        Thread olivia = new TryLockShopper("Olivia");
        Thread bran = new TryLockShopper("Bran");
        long start = System.currentTimeMillis();
        olivia.start();
        bran.start();
        bran.join();
        olivia.join();
        long end = System.currentTimeMillis();
        System.out.println("Elapsed time: " + (end - start) + " ms");
    }
}
