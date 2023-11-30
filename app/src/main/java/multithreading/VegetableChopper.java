package multithreading;

class ChopperThread extends Thread {
    private int countChopped;
    private String chopper;
    private boolean started;

    public ChopperThread(String chopper, boolean started) {
        this.started = started;
        this.chopper = chopper;
    }

    public void setStarted(boolean started) {
        this.started = started;
    }

    @Override
    public void run() {
        while (started) {
            System.out.println("Chopper:" + chopper + " Chopped " + countChopped);
            countChopped++;
        }
    }
}

public class VegetableChopper {
    public static void main(String[] args) throws InterruptedException {
        boolean started = true;
        ChopperThread bony = new ChopperThread("Bony", started);
        ChopperThread jane = new ChopperThread("Jane", started);
        bony.start();
        jane.start();
        Thread.sleep(1000);
        bony.setStarted(false);
        jane.setStarted(false);
    }
}
