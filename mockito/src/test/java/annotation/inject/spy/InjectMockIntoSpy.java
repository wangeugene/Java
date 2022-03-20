package annotation.inject.spy;

import annotation.inject.MyDictionary;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Created by IntelliJ IDEA.<br/>
 *
 * @author: Eugene_Wang<br />
 * Date: 3/20/2022<br/>
 * Time: 8:33 PM<br/>
 * To change this template use File | Settings | File Templates.
 */
public class InjectMockIntoSpy {
    @Mock
    Map<String, String> wordMap;

    MyDictionaryDI spyDic;

    @BeforeEach
    public void init() {
        MockitoAnnotations.openMocks(this);
        spyDic = Mockito.spy(new MyDictionaryDI(wordMap));
    }

    @Test
    public void whenUseInjectMocksAnnotationThenCorrect() {
        Mockito.when(wordMap.get("aWord")).thenReturn("aMeaning");

        assertEquals("aMeaning", spyDic.getMeaning("aWord"));
    }
}
