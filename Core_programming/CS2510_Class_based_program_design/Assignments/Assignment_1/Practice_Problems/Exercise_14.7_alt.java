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
                  | File                     |
                  |--------------------------|
                  | String fileName          |
                  | int fileSize             |
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
            +------------------+-------------------+
            |                  |                   |
            |                  |                   |
    +----------------+  +----------------+  +-----------------+
    | ImageFile      |  | TextFile       |  | SoundFile       |
    |----------------|  |----------------|  |-----------------|
    | int height     |  | int numOfLines |  | int playingTime |
    | int width      |  +----------------+  +-----------------+
    | String quality |
    +----------------+


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

class Image extends File {
    int height;
    int width;
    String quality;

    Image(String fileName, int fileSize, int height, int width, String quality) {
        super(fileName, fileSize);
        this.height = height;
        this.width = width;
        this.quality = quality;
    }
}

class Text extends File {
    int numOfLines;

    Text(String fileName, int fileSize, int numOfLines) {
        super(fileName, fileSize);
        this.numOfLines = numOfLines;
    }
}

class Sound extends File{
    File source;
    int playingTime;

    Sound(String fileName, int fileSize, int playingTime) {
        super(fileName, fileSize);
        this.playingTime = playingTime;
    }
}

class ExamplesRecordsAlt {
    File image = new Image("flower.gif", 57234, 50, 100, "medium");
    File text = new Text("welcome.txt", 5312, 830);
    File sound = new Sound("theme.mp3", 40960, 200);

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