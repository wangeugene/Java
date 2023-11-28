package datastructure;

import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicReference;

class ListTest {
    @Test
    void removeFromFirst() {
        AtomicReference<List<Integer>> list = new AtomicReference<>(new ArrayList<>());
        list.get().add(1);
        list.get().add(2);
        list.get().add(3);
        list.get().add(4);
        list.get().remove(1);
        System.out.println(list);
    }
}
