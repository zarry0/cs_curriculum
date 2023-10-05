import tester.*;

// How to run with tester lib
//  1. Compile the file: 
//           javac -d bin -cp [path to testerlib.jar] Event.jar
//  2. Run tester.Main with ExamplesClass as an argument: 
//           java -cp [path to tester.jar:path to ExamplesClass (./bin)] tester.Main ExamplesClass

/* Problem 3
 * We want to define events which have a title, date, location and host. 
 * What types of data should you use for each of these fields? A date should have a day, month and year. 
 * A host should be a Person.
 * 
 *   - Draw the class diagrams for an event data definition.
 *   - Define the class Event that implements this data definition.
 *   - Define the class ExamplesEvent and create some examples of events.
 */

 /* Class Diagram
  * 
                         +--------------+
                         | Event        |
                         +--------------+
                         | String title |       +--------------+
 +---------------+       | Date date    |+----->| Date         |
 | Person        |<-----+| Person host  |       +--------------+
 +---------------+       +--------------+       | int day      |
 | String name   |                              | int month    |
 | int age       |                              | int year     |
 | String gender |                              +--------------+
 +---------------+

*/

// to represent an Event
class Event {
    String title;
    Date date;
    Person host;

    Event(String title, Date date, Person host) {
        this.title = title;
        this.date = date;
        this.host = host;
    }
}

// to represent a Date
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

// to represent a Person
class Person {
    String name;
    int age;
    String gender;

    Person(String name, int age, String gender) {
        this.name = name;
        this.age = age;
        this.gender = gender;
    } 
}

// to represent examples of events
class ExamplesEvents {
    Person tim = new Person("Tim", 23, "Male");
    Person kate = new Person("Kate", 22, "Female");
    Person rebecca = new Person("Rebecca", 31, "Non-binary");

    Date fourthOfJuly = new Date(4,7,2023);
    Date dec31st = new Date(31,12,2022);
    Date cincoDeMayo = new Date(5,5,1862);
    Date may4th = new Date(5,5,2023);

    Event independenceDay = new Event("US independence day", forthOfJuly, kate);
    Event newYearsEve = new Event("New Year's Eve", dec31st, rebecca);
    Event notAMexicanHolliday = new Event("Cinco de Mayo", cincoDeMayo, tim);
    Event starWarsDay = new Event("May the fourth be with you", may4th, tim);
}