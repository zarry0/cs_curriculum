import tester.Tester;
 
/*
 * Exercise 3.2 provides the data definition for a weather recording program.
 * Design the following methods for the WeatherRecord class: 
 *      1. withinRange, which determines whether today’s high and low were within the normal range;
 *      2. rainyDay, which determines whether the precipitation is higher than some given value;
 *      3. recordDay, which determines whether the temperature broke either the high or the low record. 
 * 
 * Exercise 3.2 class diagram:
 * 
           +-------------------------+
           | WeatherRecord           |
           |-------------------------|
       +---+ Date d                  |
       |   | TemperatureRange today  +------+
       |   | TemperatureRange normal +----+ |
       |   | TemperatureRange record +--+ | |
       |   +-------------------------+  | | |
       |                                | | |
       v                                v v v
  +--------------+                +------------------+
  | Date         |                | TemperatureRange |
  |--------------|                |------------------|
  | int day      |                | int high         |
  | String month |                | int low          |
  | int year     |                +------------------+
  +--------------+

 */


 /*
  * Updated class definition to accomodate the new methods

            +------------------------- +
            | WeatherRecord            |
            |------------------------- |
        +---+ Date d                   |
        |   | TemperatureRange today   +------+
        |   | TemperatureRange normal  +----+ |
        |   | TemperatureRange record  +--+ | |
        |   | double precipitation     |  | | |
        |   +------------------------- +  | | |
        |   | boolean withinRange()    |  | | |
        |   | boolean rainyDay(double) |  | | |
        |   | boolean recordDay()      |  | | |
        |   +------------------------- +  | | |
        v                                 v v v
   +--------------+       +---------------------------------------+
   | Date         |       | TemperatureRange                      |
   |--------------|       |---------------------------------------|
   | int day      |       | int high                              |
   | String month |       | int low                               |
   | int year     |       +---------------------------------------+
   +--------------+       | boolean withinRange(TemperatureRange) |
                          | boolean withinRangeHelper(int, int)   |
                          +---------------------------------------+

  */

  class Date {
    int day;
    int month;
    int year;

    Date(int day, int month, int year) {
        this.day = day;
        this.month = month;
        this.year = year;
    }
  }

  class TemperatureRange {
    int low;
    int high;

    TemperatureRange(int low, int high) {
        this.low = low;
        this.high = high;
    }

    // produces true if that is within this
    boolean withinRange(TemperatureRange that) {
        // this.low... this.high...
        return that.withinRangeHelper(this.low, this.high);
    }

    // produces true if this range is within the given limits
    boolean withinRangeHelper(int thatLow, int thatHigh) {
        return this.low >= thatLow && this.high <= thatHigh;
    }
  }

  class WeatherRecord {
    Date d;
    TemperatureRange today;
    TemperatureRange normal;
    TemperatureRange record;
    double precipitation;

    WeatherRecord(Date d, TemperatureRange today, TemperatureRange normal, TemperatureRange record, double precipitation) {
        this.d = d;
        this.today = today;
        this.normal = normal;
        this.record = record;
        this.precipitation = precipitation;
    }

    // produces true if today's range is within the normal range
    boolean withinRange() {
        return this.normal.withinRange(this.today);
    }

    // produces true if this.precipitation is higher than the given reference
    boolean rainyDay(double reference) {
        return this.precipitation > reference;
    }

    // produces true if todays range broke either the low or high record
    boolean recordDay() {
        return !this.record.withinRange(this.today);
    }
  }

  class ExamplesWeatherRecord {
    Date d1 = new Date(2,9,1959);
    Date d2 = new Date(8,8,2004);
    Date d3 = new Date(12,12,1999);
    Date d4 = new Date(26,10,2011);

    TemperatureRange t1 = new TemperatureRange(66,88);
    TemperatureRange t2 = new TemperatureRange(29,31);
    TemperatureRange t3 = new TemperatureRange(70,80);

    WeatherRecord r1 = new WeatherRecord(d1, t1, t2, t3, 0);
    WeatherRecord r2 = new WeatherRecord(d2, t2, t3, t1, 10);
    WeatherRecord r3 = new WeatherRecord(d3, t3, t1, t2, 9);
    WeatherRecord r4 = new WeatherRecord(d4, t3, t2, t1, 9);

    boolean testWithinRange(Tester t) {
        return  t.checkExpect(this.t1.withinRange(t2), false) &&
                t.checkExpect(this.t1.withinRange(t3), true) &&
                t.checkExpect(this.r1.withinRange(), false) &&
                t.checkExpect(this.r2.withinRange(), false) &&
                t.checkExpect(this.r3.withinRange(), true);
    }

    boolean testRainyDay(Tester t) {
        return  t.checkExpect(this.r1.rainyDay(0), false) &&
                t.checkExpect(this.r1.rainyDay(10), false) &&
                t.checkExpect(this.r2.rainyDay(5), true) &&
                t.checkExpect(this.r3.rainyDay(8), true) &&
                t.checkExpect(this.r3.rainyDay(10), false);
    }

    boolean testRecordDay(Tester t) {
        return  t.checkExpect(this.r1.recordDay(), true) &&
                t.checkExpect(this.r2.recordDay(), true) &&
                t.checkExpect(this.r3.recordDay(), true) &&
                t.checkExpect(this.r4.recordDay(), false);
    }
  }