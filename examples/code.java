import java.io.*;


public class AddNum {
   
   public int addNum(int numA, int numB) {
      return numA + numB;
   }

   

   public static void main(String args[]) throws IOException {
      AddNum obj = new AddNum();
      int sum = obj.addNum(10, 20);

      System.out.println("Sum of 10 and 20 is :" + sum);
   }
} 


package com.brianway.learning.java.nio;



import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.charset.Charset;

public class BufferToText {
    private static final int BSIZE = 1024;

    public static void main(String[] args) throws Exception {
        String parent = BufferToText.class.getResource("/").getPath();
        String file = parent + "/buffer2text.txt";

        FileChannel fc =
                new FileOutputStream(file).getChannel();
        fc.write(ByteBuffer.wrap("Some text".getBytes()));
        fc.close();
        fc = new FileInputStream(file).getChannel();
        ByteBuffer buff = ByteBuffer.allocate(BSIZE);
        fc.read(buff);
        buff.flip();
        
        System.out.println(buff.asCharBuffer());

        
        buff.rewind();
        String encoding = System.getProperty("file.encoding");
        System.out.println("Decoded using " + encoding + ": "
                + Charset.forName(encoding).decode(buff));

        
        fc = new FileOutputStream(file).getChannel();
        fc.write(ByteBuffer.wrap(
                "Some text".getBytes("UTF-16BE")));
        fc.close();
        
        fc = new FileInputStream(file).getChannel();
        buff.clear();
        fc.read(buff);
        buff.flip();
        System.out.println(buff.asCharBuffer());

        
        fc = new FileOutputStream(file).getChannel();
        buff = ByteBuffer.allocate(24); 
        buff.asCharBuffer().put("Some text");
        fc.write(buff);
        fc.close();
        
        fc = new FileInputStream(file).getChannel();
        buff.clear();
        fc.read(buff);
        buff.flip();
        System.out.println(buff.asCharBuffer());
    }
}
