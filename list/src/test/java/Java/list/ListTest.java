package Java.list;

import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

class ListTest {
    @Test
    void removeFromFirst() {
        List<Integer> list = new ArrayList<>();
        list.add(1);
        list.add(2);
        list.add(3);
        list.add(4);
        for (int i = 0, length = list.size(); i < length; i++) {
            list.remove(i);
            System.out.println(list.get(i));
        }
    }
}
