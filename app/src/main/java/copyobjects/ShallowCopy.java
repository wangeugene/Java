package copyobjects;

public class ShallowCopy extends Copy {
    public static User getShallowCopy() {
        User userCopied = new User();
        userCopied.setName(user.getName());
        userCopied.setAge(user.getAge());
        userCopied.setSalary(user.getSalary());
        userCopied.setExperiences(user.getExperiences());
        return userCopied;
    }
}
