import tester.Tester;

/*
 * Problem 1:
 * We are designing the data collection for the American Kennel Club. 
 * For each dog we need to collect the following information:
 *      - name: to be represented as a String
 *      - breed: of dog
 *      - yob: the year of birth given as a four digit number
 *      - state: of residence – given as the standard two letter abbreviation
 *      - hypoallergenic: a boolean value, true, if the dog is hypoallergenic
 * 
 * Design the class Dog that represents the information about each dog for the census.
 * Make at least three examples of instances of this class, in the class ExamplesDog. 
 * 
 * Two of the examples should be objects named huffle and pearl and should represent the following two dogs:
 *      1. Hufflepuff, a Wheaten Terrier, born in 2012, resides in TX, and is hypoallergenic
 *      2. Pearl, a Labrador Retriever, born in 2016, resides in MA, and is not hypoallergenic
 */

 /*
  * Class Diagram

   +------------------------+
   | Dog                    |
   |------------------------|
   | String name            |
   | String breed           |
   | int yob                |
   | String state           |
   | boolean hypoallergenic |
   +------------------------+

*/

class Dog {
    String name;
    String breed;
    int yob;
    String state;
    boolean hypoallergenic;

    Dog(String name, String breed, int yob, String state, boolean hypoallergenic) {
        this.name = name;
        this.breed = breed;
        this.yob = yob;
        this.state = state;
        this.hypoallergenic = hypoallergenic;
    }
}

class ExamplesDog {
    Dog hufflepuff = new Dog("Hufflepuff", "Wheaten Terrier", 2012, "TX", true);
    Dog pearl = new Dog("Pearl", "Labrador Retriever", 2016, "MA", false);
    Dog lucky = new Dog("Lucky", "Schnauzer", 2011, "VER", true);
    Dog sonny = new Dog("Sonny", "Schnauzer", 2022, "VER", true);
}