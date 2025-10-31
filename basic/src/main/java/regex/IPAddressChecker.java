package regex;

public class IPAddressChecker {
    private static final String IP_REGEX = "((25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.){3}(25[0-5]|2[0-4]\\d|[01]?\\d\\d?)";

    public static boolean isValidIPAddress(String ip) {
        return ip.matches(IP_REGEX);
    }
}
