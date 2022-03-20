package annotation;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Created by IntelliJ IDEA.<br/>
 *
 * @author: Eugene_Wang<br />
 * Date: 3/20/2022<br/>
 * Time: 7:35 PM<br/>
 * To change this template use File | Settings | File Templates.
 */
class WithMockAnnotation {
    @Mock
    List<String> mockedList;

    @BeforeEach
    void init() {
        // to use @Mock this is a must
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void whenUseMockAnnotationThenMockIsInjected() {
        mockedList.add("one");
        Mockito.verify(mockedList).add("one");
        assertEquals(0, mockedList.size());

        Mockito.when(mockedList.size()).thenReturn(100);
        assertEquals(100, mockedList.size());
    }
}
