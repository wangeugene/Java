package thread;

import lombok.Setter;

class UpdateThread extends Thread {
    private static int sharedCount = 0;
    private String name;
    @Setter
    private boolean on;

    public UpdateThread(String name, boolean on) {
        this.on = on;
        this.name = name;
    }

    @Override
    public void run() {
        while (on) {
            System.out.println("Thread name: " + name + " updated: " + sharedCount);
            sharedCount++;
        }
    }
}

public class ThreadRacing {
    public static void main(String[] args) throws InterruptedException {
        boolean on = true;
        UpdateThread bony = new UpdateThread("Bony", on);
        UpdateThread jane = new UpdateThread("Jane", on);
        bony.start();
        jane.start();
        Thread.sleep(1000);
        bony.setOn(false);
        jane.setOn(false);
    }
}
