package copyobjects.mapstruct;

import copyobject.ShallowCopy;
import copyobject.pojo.User;
import copyobject.pojo.UserView;
import copyobject.mapstruct.UserMapper;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

final class UserMapperTest {
    @Test
    void testMappingUserView() {
        User user = ShallowCopy.getShallowCopy();
        UserView userView = UserMapper.userMapper.userToUserView(user);
        Assertions.assertNotNull(userView);
        Assertions.assertEquals(user.getName(), userView.getName());
        Assertions.assertEquals(user.getAge(), userView.getAge());
        Assertions.assertEquals(user.getSalary(), userView.getIncome());
        Assertions.assertEquals(user.getExperiences(), userView.getExperiences());
    }
}