import tester.*;

// How to run with tester lib
//  1. Compile the file: 
//           javac -d bin -cp [path to testerlib.jar] Person.jar
//  2. Run tester.Main with ExamplesClass as an argument: 
//           java -cp [path to tester.jar:path to ExamplesClass (./bin)] tester.Main ExamplesClass

/* Problem 1
   Here is a data definition in DrRacket:

        ;; to represent a person
        ;; A Person is (make-person String Number String)
        (define-struct person [name age gender])
 
        (define tim (make-person "Tim" 23 "Male"))
        (define kate (make-person "Kate" 22 "Female"))
        (define rebecca (make-person "Rebecca" 31 "Non-binary"))
  
   Draw the class diagram that represents this data.

   Define the class Person that implements this data definition and the class ExamplesPerson that contains the examples defined above. You should do this in a new Person.java file. Right click the default package under Lab1 and select New > File. Name it Person.java.

   Run your program to make sure it works.
 */

/*
    Class Diagram
   +---------------+
   | Person        |
   +---------------+
   | String name   |
   | int age       |
   | String gender |
   +---------------+
 */

 // to represent a person
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

 // to represent examples and tests for person
 class ExamplesPerson {
    Person tim = new Person("Tim", 23, "Male");
    Person kate = new Person("Kate", 22, "Female");
    Person rebecca = new Person("Rebecca", 31, "Non-binary");
 }


/* Problem 2
 * Modify your data definitions so that for each person we also record the person’s address. For each person’s 
 * address we only record the city and the state; each of these should be its own field. Create an Address class to 
 * contain the address information, then modify the Person data definition to include an Address.
 * 
 *   - Draw the class diagram for this data definition
 *   - Define Java classes that represent this data definition.
 *   - Tim lives in Boston, MA, Kate lives in Warwick, RI, and Rebecca lives in Nashua, NH.
 * 
 * Make examples of these data and add two more people.
 */

 /* Class diagram
  * 
 +-----------------+
 | Person          |
 +-----------------+
 | String name     |
 | int age         |
 | String gender   |         +--------------+
 | Address address |+------->| Address      |
 +-----------------+         +--------------+
                             | String city  |
                             | String state |
                             +--------------+
  */

// to represent a person
class Person2 {
    String name;
    int age;
    String gender;
    Address address;

    Person2(String name, int age, String gender, Address address) {
        this.name = name;
        this.age = age;
        this.gender = gender;
        this.address = address;
    } 
}

// to represent an address
class Address {
    String city;
    String state;

    Address(String city, String state) {
        this.city = city;
        this.state = state;
    }
}

class ExamplesPerson2 {
    Address boston = new Address("Boston", "MA");
    Address warwick = new Address("Warwick", "RI");
    Address nashua = new Address("Nashua", "NH");
    Address sf = new Address("San Francisco", "CA");

    Person2 tim = new Person2("Tim", 23, "Male", boston);
    Person2 kate = new Person2("Kate", 22, "Female", warwick);
    Person2 rebecca = new Person2("Rebecca", 31, "Non-binary", nashua);
    Person2 john = new Person2("John", 24, "Male", sf);
    Person2 tania = new Person2("Tania", 23, "Female", boston);
}
