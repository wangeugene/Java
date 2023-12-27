package access;

public class InnerClassPrivateStaticMethodCaller {
    public static void main(String[] args) {
        Inner.Private p = new Inner.Private();
        p.powerOfTwo(4);
        p.powerOfTwo(17);
    }

    static class Inner {
        private static class Private {
            private void powerOfTwo(int num) {
                System.out.println(((num & num - 1) == 0) ? num + " is power of 2" : num + " is not a power of 2");
            }
        }
    }
}
