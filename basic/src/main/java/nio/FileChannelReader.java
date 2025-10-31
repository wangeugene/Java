package nio;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;

public class FileChannelReader {
    public static void main(String[] args) throws IOException {
        try (RandomAccessFile logConfigFile = new RandomAccessFile("app/src/main/resources/log4j2.xml", "rw")) {
            FileChannel channel = logConfigFile.getChannel();
            ByteBuffer buffer = ByteBuffer.allocate(48);
            int bytesRead = channel.read(buffer);
            while (bytesRead != -1) {
                buffer.flip();
                while (buffer.hasRemaining()) {
                    System.out.print((char) buffer.get());
                }
                buffer.clear();
                bytesRead = channel.read(buffer);
            }
        } catch (IOException ioException) {
            System.out.println("ioException = " + ioException.getMessage());
        }
    }
}
