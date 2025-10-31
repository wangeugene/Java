package io;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * The code snippet below shows how to read a file using BufferedReader.
 * BufferedReader is a class that reads text from a character-input stream.
 * It buffers characters, so as provide for the efficient reading of characters, arrays, and lines.
 * The buffer size may be specified, or the default size may be used.
 * The default is large enough for most purposes.
 * In general,
 * each read request made of a Reader causes a corresponding read request
 * to be made of the underlying character or byte stream.
 * It is therefore advisable to wrap a BufferedReader around any Reader whose read() operations may be costly.
 * For example,
 * BufferedReader in
 * = new BufferedReader(new FileReader("foo.in"));
 * will buffer the input from the specified file.
 * Without buffering,
 * each invocation of read() or readLine() could cause bytes to be read from the file,
 * converted into characters
 * and then returned,
 * which can be very inefficient.
 * Programs that use DataInputStreams for textual input can be localized
 * by replacing each DataInputStream with an appropriate BufferedReader.
 *
 * @see <a href="https://docs.oracle.com/javase/8/docs/api/java/io/BufferedReader.html">BufferedReader</a>
 */
public class BufferedFileReader {
    public static void main(String[] args) {
        try {
            // Notice that the path is relative to the project root directory.
            BufferedReader bufferedReader = new BufferedReader(new FileReader("app/src/main/java/io/BufferedFileReader.java"));
            String line;
            while ((line = bufferedReader.readLine()) != null) {
                System.out.println(line);
            }
            bufferedReader.close();
        } catch (IOException e) {
            System.out.println("Error reading file: " + e.getMessage());
        }
    }
}
