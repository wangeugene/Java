package io;

import java.io.BufferedInputStream;
import java.io.IOException;

public class StandardInputBufferedInputStream {
    public static void main(String[] args) throws IOException {
        BufferedInputStream bufferedInputStream = new BufferedInputStream(System.in);
        System.out.println("Enter some text: ");
        byte[] bytes = new byte[1024];
        int bytesRead = bufferedInputStream.read(bytes);
        String input = new String(bytes, 0, bytesRead);
        System.out.println("You entered: " + input);
    }
}
