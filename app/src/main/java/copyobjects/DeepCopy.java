package copyobjects;

public class DeepCopy extends Copy {

    public static User getDeepCopy() {
        return user.clone();
    }
}
