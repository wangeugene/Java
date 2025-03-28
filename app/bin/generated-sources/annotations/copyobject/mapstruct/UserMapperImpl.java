package copyobject.mapstruct;

import copyobject.pojo.User;
import copyobject.pojo.UserView;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.processing.Generated;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2025-03-28T15:28:27+0800",
    comments = "version: 1.5.5.Final, compiler: Eclipse JDT (IDE) 3.42.0.v20250325-2231, environment: Java 21.0.6 (Eclipse Adoptium)"
)
public class UserMapperImpl implements UserMapper {

    @Override
    public UserView userToUserView(User user) {
        if ( user == null ) {
            return null;
        }

        UserView userView = new UserView();

        userView.setIncome( user.getSalary() );
        userView.setAge( user.getAge() );
        List<String> list = user.getExperiences();
        if ( list != null ) {
            userView.setExperiences( new ArrayList<String>( list ) );
        }
        userView.setName( user.getName() );

        return userView;
    }
}
