package mockito;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class StubbingAndVerifyTest {
    @Mock
    private List<String> mockList;

    @Test
    void testStubbing() {
        when(mockList.size()).thenReturn(100);
        assertEquals(100, mockList.size());
    }

    @Test
    void testVerify() {
        mockList.add("one");
        verify(mockList).add("one");
        assertEquals(0, mockList.size());
    }
}
