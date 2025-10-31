package copyobject;

import copyobject.pojo.User;

public class DeepCopy extends Copy {

    public static User getDeepCopy() {
        return user.clone();
    }
}
