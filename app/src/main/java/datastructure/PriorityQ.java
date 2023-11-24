package datastructure;

public class PriorityQ {
    private final int maxSize;
    private final long[] queArray;
    private int nItems;

    public PriorityQ(int s) {
        maxSize = s;
        queArray = new long[maxSize];
        nItems = 0;
    }

    public void insert(long item) {
        int j;
        if (nItems == 0) {
            queArray[nItems++] = item;
        } else {
            for (j = nItems - 1; j >= 0; j--) {
                if (item > queArray[j]) {
                    queArray[j + 1] = queArray[j]; // shift upward
                } else {
                    break;
                }
            }
            queArray[j + 1] = item; // insert it
            nItems++;
        }
    }

    public long remove() {
        return queArray[--nItems];
    }

    public long peekMin() {
        return queArray[nItems - 1];
    }

    public boolean isEmpty() {
        return nItems == 0;
    }

    public boolean isFull() {
        return nItems == maxSize;
    }

    /*
        test the PriorityQ
     */
    public static void main(String[] args) {
        PriorityQ priorityQ = new PriorityQ(7);
        System.out.println(priorityQ.isEmpty());
        priorityQ.insert(30);
        priorityQ.insert(50);
        priorityQ.insert(120);
        priorityQ.insert(10);
        System.out.println(priorityQ.peekMin());
        priorityQ.insert(40);
        priorityQ.insert(20);
        priorityQ.insert(2200);
        System.out.println(priorityQ.isFull());


        while (!priorityQ.isEmpty()) {
            long item = priorityQ.remove();
            System.out.println("item = " + item);
        }
    }
}
