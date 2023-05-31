import tester.*;

/* Problem 5
 * The HtDP book includes the data definition for Ancestor Trees:
 * 
 *      ;; An Ancestor Tree (AT) is one of
 *      ;; -- 'unknown
 *      ;; -- (make-tree Person AT AT)
 *      ;; A Person is defined as above
 * 
 * Convert this data definition into Java classes and interfaces. 
 * What options do you have for how to translate this into Java? 
 * Make examples of ancestor trees that in at least one branch cover at least three generations.
 */

 /* Class diagram
  * 
 +------------------+
 |+--------------+  |
 ||              |  |
 ||              v  v
 ||            +-------+
 ||            |  IAT  |
 ||            +-------+
 ||                |
 ||               / \
 ||               ---
 ||                |
 ||        +---------------+
 ||        |               |
 ||        v               v
 ||  +-----------+  +---------------+
 ||  |  Unknown  |  | Tree Node     |
 ||  +-----------+  +---------------+
 ||                 | Person person |+------+
 |+----------------+| IAT mom       |       |
 +-----------------+| IAT dad       |       |
                    +---------------+       |
                                            v
                                    +---------------+
                                    | Person        |
                                    +---------------+
                                    | String name   |
                                    | int age       |
                                    | String gender |
                                    +---------------+
  */

// to represent an ancestor tree
interface IAT { }

// to represent an empty tree node
class Unknown implements IAT { }

// to represent a tree node
class TreeNode implements IAT {
    Person person;
    IAT mom;
    IAT dad;
    TreeNode(Person person, IAT mom, IAT dad) {
        this.person = person;
        this.mom = mom;
        this.dad = dad;
    }
}

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

// to represent examples of ancestor trees
class ExamplesAT {
    IAT unknown = new Unknown();

    IAT allison = new TreeNode(new Person("Allison", 20, "Female"), unknown, unknown);
    IAT tim = new TreeNode(new Person("Tim", 23, "Male"), unknown, unknown);
    IAT jon= new TreeNode(new Person("Jon", 40, "Male"), allison, tim);
    IAT rebecca = new TreeNode(new Person("Rebecca", 31, "Female"), unknown, unknown);
    IAT kate = new TreeNode(new Person("Kate", 22, "Female"), rebecca, jon);
}