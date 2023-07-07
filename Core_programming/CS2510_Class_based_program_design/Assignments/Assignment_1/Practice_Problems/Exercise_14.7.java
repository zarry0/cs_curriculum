import tester.Tester;

/*
 * Recall exercise 4.5:
 *      Develop a program that creates an on-line gallery from three different kinds of records: 
 *          - images (gif), 
 *          - texts (txt), and 
 *          - sounds (mp3). 
 *      All have names for source files and sizes (number of bytes). 
 *      Images also include information about the height, the width, and the quality of the image. 
 *      Texts specify the number of lines needed for visual representation.
 *      Sounds include information about the playing time of the recording, given in seconds. 
 * 
 * Develop the following methods for this program:
 *      1.  timeToDownload, which computes how long it takes to download a file at some given network connection speed (in bytes per second);
 *      2.  smallerThan, which determines whether the file is smaller than some given maximum size;
 *      3.  sameName, which determines whether the name of a file is the same as some given name.
 * 
 * Examples given in exercise 4.5:
 *      1.  an image, stored in flower.gif; size: 57,234 bytes; width: 100 pixels; height: 50 pixels; quality: medium;
 *      2.  a text, stored in welcome.txt; size: 5,312 bytes; 830 lines;
 *      3.  a music piece, stored in theme.mp3; size: 40,960 bytes, playing time 3 minutes and 20 seconds.
 */

 /*
  * Class diagram



                                      +--------------------------+
                                      | IRecord                  |
                                      |--------------------------|
                                      | int timeToDownload(int)  |
                                      | boolean smallerThan(int) |
                                      | boolean sameName(String) |
                                      +--------------------------+
                                                  |
                                                 / \
                                                 ---
                                                  |
                                                  |
                   +------------------------------+--------------------------------+
                   |                              |                                |
                   |                              |                                |
                   |                              |                                |
      +--------------------------+    +--------------------------+    +--------------------------+
      | Image                    |    | Text                     |    | Sound                    |
      |--------------------------|    |--------------------------|    |--------------------------|
      | File source              |--+ | File source              |--+ | File source              |--+
      | int height               |  | | int numOfLines           |  | | int playingTime          |  |
      | int width                |  | |--------------------------|  | |--------------------------|  |
      | String quality           |  | | int timeToDownload(int)  |  | | int timeToDownload(int)  |  |
      |--------------------------|  | | boolean smallerThan(int) |  | | boolean smallerThan(int) |  |
      | int timeToDownload(int)  |  | | boolean sameName(String) |  | | boolean sameName(String) |  |
      | boolean smallerThan(int) |  | +--------------------------+  | +--------------------------+  |
      | boolean sameName(String) |  |                               |                               |
      +--------------------------+  |                               |                               |
                                    |              +----------------+                               |
                                    +-----------+  |  +---------------------------------------------+
                                                |  |  |
                                                v  v  v
                                      +--------------------------+
                                      | File                     |
                                      |--------------------------|
                                      | String fileName          |
                                      | int fileSize             |
                                      |--------------------------|
                                      | int timeToDownload(int)  |
                                      | boolean smallerThan(int) |
                                      | boolean sameName(String) |
                                      +--------------------------+


  */

class File {
    String fileName;
    int fileSize;

    File(String fileName, int fileSize) {
        this.fileName = fileName;
        this.fileSize = fileSize;
    }
    
    // computes how long it takes to download a file at the given network speed (in bytes per second)
    int timeToDownload(int networkSpeed) {
        float result = this.fileSize / (float) networkSpeed;
        return Math.round(result);
    }

    // produces true if the file is smaller than the given maximum size
    boolean smallerThan(int maxSize) {
        return this.fileSize < maxSize;
    }

    // produces true if the name of this file is the same as the given name
    boolean sameName(String otherName) {
        return this.fileName.equals(otherName);
    }
}

interface IRecord {
    // computes how long it takes to download a file at the given network speed (in bytes per second)
    int timeToDownload(int networkSpeed);

    // produces true if the file is smaller than the given maximum size
    boolean smallerThan(int maxSize);

    // produces true if the name of this file is the same as the given name
    boolean sameName(String otherName);
}

class Image implements IRecord {
    File source;
    int height;
    int width;
    String quality;

    Image(String fileName, int fileSize, int height, int width, String quality) {
        this.source = new File(fileName, fileSize);
        this.height = height;
        this.width = width;
        this.quality = quality;
    }

    // computes how long it takes to download an image at the given network speed (in bytes per second)
    public int timeToDownload(int networkSpeed) {
        return this.source.timeToDownload(networkSpeed);
    }

    // produces true if the image is smaller than the given maximum size
    public boolean smallerThan(int maxSize) {
        return this.source.smallerThan(maxSize);
    }

    // produces true if the name of this image is the same as the given name
    public boolean sameName(String otherName) {
        return this.source.sameName(otherName);
    }

}

class Text implements IRecord {
    File source;
    int numOfLines;

    Text(String fileName, int fileSize, int numOfLines) {
        this.source = new File(fileName, fileSize);
        this.numOfLines = numOfLines;
    }

    // computes how long it takes to download a text file at the given network speed (in bytes per second)
    public int timeToDownload(int networkSpeed) {
        return this.source.timeToDownload(networkSpeed);
    }

    // produces true if the text file is smaller than the given maximum size
    public boolean smallerThan(int maxSize) {
        return this.source.smallerThan(maxSize);
    }

    // produces true if the name of this text file is the same as the given name
    public boolean sameName(String otherName) {
        return this.source.sameName(otherName);
    }
}

class Sound implements IRecord {
    File source;
    int playingTime;

    Sound(String fileName, int fileSize, int playingTime) {
        this.source = new File(fileName, fileSize);
        this.playingTime = playingTime;
    }

    // computes how long it takes to download a sound file at the given network speed (in bytes per second)
    public int timeToDownload(int networkSpeed) {
        return this.source.timeToDownload(networkSpeed);
    }

    // produces true if the sound file is smaller than the given maximum size
    public boolean smallerThan(int maxSize) {
        return this.source.smallerThan(maxSize);
    }

    // produces true if the name of this sound file is the same as the given name
    public boolean sameName(String otherName) {
        return this.source.sameName(otherName);
    }
}

class ExamplesRecords {
    IRecord image = new Image("flower.gif", 57234, 50, 100, "medium");
    IRecord text = new Text("welcome.txt", 5312, 830);
    IRecord sound = new Sound("theme.mp3", 40960, 200);

    boolean testTimeToDownload(Tester t) {
        return  t.checkExpect(this.image.timeToDownload(100), 572) &&
                t.checkExpect(this.text.timeToDownload(145), 37) &&
                t.checkExpect(this.sound.timeToDownload(2500), 16);
    }

    boolean testSmallerThan(Tester t) {
        return  t.checkExpect(this.image.smallerThan(70000), true) &&
                t.checkExpect(this.image.smallerThan(50000), false) &&
                t.checkExpect(this.text.smallerThan(50000), true) &&
                t.checkExpect(this.text.smallerThan(1000), false) &&
                t.checkExpect(this.sound.smallerThan(1000), false) &&
                t.checkExpect(this.sound.smallerThan(65000), true);           
    }

    boolean testSameName(Tester t) {
        return  t.checkExpect(this.image.sameName("flower"), false) &&
                t.checkExpect(this.image.sameName("flower.gif"), true) &&
                t.checkExpect(this.text.sameName("welcome.gif"), false) &&
                t.checkExpect(this.text.sameName("welcome.txt"), true) &&
                t.checkExpect(this.sound.sameName("theme"), false) &&
                t.checkExpect(this.sound.sameName("theme.mp3"), true);
    }
}