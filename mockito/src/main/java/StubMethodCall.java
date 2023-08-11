import java.util.LinkedList;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class StubMethodCall {
    public static void main(String[] args) {
        var mockedList = mock(LinkedList.class);
        when(mockedList.get(0)).thenReturn("First");
        System.out.println(mockedList.get(0));
        System.out.println(mockedList.get(999));
    }
}
