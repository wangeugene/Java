package copyobjects.mapstruct;


import copyobjects.User;
import copyobjects.UserView;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

@Mapper
public interface UserMapper {
    UserMapper userMapper = Mappers.getMapper(UserMapper.class);

    @Mapping(source = "salary", target = "income")
    UserView userToUserView(User user);
}
