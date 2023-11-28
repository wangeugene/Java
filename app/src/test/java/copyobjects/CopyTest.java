package copyobjects;

import copyobject.DeepCopy;
import copyobject.ShallowCopy;
import copyobject.pojo.User;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.util.List;

import static copyobject.Copy.user;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

final class CopyTest {

    private static User shallowCopy;
    private static User deepCopy;

    @BeforeAll
    static void setUp() {
        shallowCopy = ShallowCopy.getShallowCopy();
        deepCopy = DeepCopy.getDeepCopy();
        mutateExperiencesListInOriginalUser();
    }

    private static void mutateExperiencesListInOriginalUser() {
        List<String> experiences = user.getExperiences();
        experiences.set(0, "PingAnChanged");
        user.setExperiences(experiences);
    }

    @Test
    void getShallowCopy() {
        commonAssertions(shallowCopy);
        assertEquals("PingAnChanged", shallowCopy.getExperiences().get(0));
    }

    @Test
    void getDeepCopy() {
        commonAssertions(deepCopy);
        assertEquals("PingAn", deepCopy.getExperiences().get(0));
    }

    private static void commonAssertions(User shallowCopy) {
        assertEquals("Wang", shallowCopy.getName());
        assertEquals(31, shallowCopy.getAge());
        assertNotNull(shallowCopy.getExperiences());
    }
}