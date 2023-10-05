import tester.*;

/*
 * Class diagram 

                                +------------------------------------+
                                | +--------------------------------+ |
                                | |                                | |
                                v v                                | |
                   +---------------------------+                   | |
                   │           IAT             │                   | |
                   +---------------------------+                   | |
                   +---------------------------+                   | |
                   | int count()               |                   | |
                   | int femaleAncOver40()     |                   | |
                   | int numTotalGens()        |                   | |
                   | int numPartialGens()      |                   | |
                   | boolean wellFormed()      |                   | |
                   | ILoSting ancNames()       |                   | |
                   | IAT youngestGrandParent() |                   | |
                   +---------------------------+                   | |
                                |                                  | |
                               / \                                 | |
                               ---                                 | |
                                |                                  | |
             +-----------------------------------+                 | |
             |                                   |                 | |
 +---------------------------+     +---------------------------+   | |
 │         Unknown           │     |          Person           |   | |
 +---------------------------+     +---------------------------+   | |
 +---------------------------+     | String name               |   | |
 | int count()               |     | int yob                   |   | |
 | int femaleAncOver40()     |     | boolean isMale            |   | |
 | int numTotalGens()        |     | IAT mom                   +---+ |
 | int numPartialGens()      |     | IAT dad                   +-----+
 | boolean wellFormed()      |     +---------------------------+
 | ILoSting ancNames()       |     | int count()               |
 | IAT youngestGrandParent() |     | int femaleAncOver40()     |
 +---------------------------+     | int numTotalGens()        |
                                   | int numPartialGens()      |
                                   | boolean wellFormed()      |
                                   | ILoSting ancNames()       |
                                   | IAT youngestGrandParent() |
                                   +---------------------------+


 */

interface IAT { 
    // To compute the number of known ancestors of this ancestor tree
    // (excluding this ancestor tree itself)
    int count();
    // To compute the number of known ancestors of this ancestor tree
    // (including this ancestor tree itself)
    int countHelper();
    
    // To compute how many ancestors of this ancestor tree (excluding this
    // ancestor tree itself) are women older than 40 (in the current year)?
    int femaleAncOver40();
    // Produces the number of female ancestors over 40 in this tree 
    //(excluding this ancestor tree itself)
    int femaleOver40Helper();

    // To compute the number of generations that are completely known
    // (including this AT)
    int numTotalGens();
    // To compute the number of generations that are at least partialy known
    // (including this AT)
    int numPartialGens();
    
    // To compute whether this ancestor tree is well-formed: are all known
    // people younger than their parents?
    boolean wellFormed();
    // produces true if this yob is less than thatYob
    boolean bornBefore(int thatYob);
    // produces true if this AT parents are well formed and if it is older than its given child yob 
    boolean wellFormedHelper(int childYob);

    // To compute the names of all the known ancestors in this ancestor tree
    // (including this ancestor tree itself)
    ILoString ancNames();
    
    // To compute this ancestor tree's youngest grandparent
    IAT youngestGrandparent();
    // produces the this youngest parent
    IAT youngestParent();
    // produces the youngest ancestor tree between this and that
    IAT youngest(IAT that);
    // To determine if this ancestry tree is younger than the given year
    boolean isYoungerThan(int yob);
}

class Unknown implements IAT {
    // To compute the number of known ancestors of this ancestor tree
    // (excluding this ancestor tree itself)
    public int count() { return 0; }
    // To compute the number of known ancestors of this ancestor tree
    // (including this ancestor tree itself)
    public int countHelper() { return 0; }

    // To compute how many ancestors of this ancestor tree (excluding this
    // ancestor tree itself) are women older than 40 (in the current year)?
    public int femaleAncOver40() { return 0; }
    // Produces the number of female ancestors over 40 in this tree 
    //(excluding this ancestor tree itself)
    public int femaleOver40Helper() { return 0; }

    // To compute the number of generations that are completely known
    // (including this AT)
    public int numTotalGens() { return 0; }

    // To compute the number of generations that are at least partialy known
    // (including this AT)
    public int numPartialGens() { return 0; }

    // To compute whether this ancestor tree is well-formed: are all known
    // people younger than their parents?
    public boolean wellFormed() { return true; }
    // produces true if this yob is less than thatYob
    public boolean bornBefore(int thatYob) { return true; }
    // produces true if this AT parents are well formed and if it is older than its given child yob 
    public boolean wellFormedHelper(int childYob) { return true; }

    // To compute the names of all the known ancestors in this ancestor tree
    // (including this ancestor tree itself)
    public ILoString ancNames() { return new MtLoString(); }

    // To compute this Unknown's youngest grandparent
    public IAT youngestGrandparent() { return this; }
    // produces the this youngest parent
    public IAT youngestParent() { return this; }
    // produces the youngest Unknown between this and that
    public IAT youngest(IAT that) { return that; }
    // To determine if this Unknown is younger than the given year
    public boolean isYoungerThan(int yob) { return false; }
}

class Person implements IAT {
    String name;
    int yob;
    boolean isMale;
    IAT mom;
    IAT dad;
    Person(String name, int yob, boolean isMale, IAT mom, IAT dad) {
        this.name = name;
        this.yob = yob;
        this.isMale = isMale;
        this.mom = mom;
        this.dad = dad;
    }

    // To compute the number of known ancestors of this ancestor tree
    // (excluding this ancestor tree itself)
    public int count() { 
        return this.countHelper() - 1; 
    }
    // To compute the number of known ancestors of this ancestor tree
    // (including this ancestor tree itself)
    public int countHelper() {
        return 1 + this.mom.countHelper() + this.dad.countHelper();
    }

    // To compute how many ancestors of this ancestor tree (excluding this
    // ancestor tree itself) are women older than 40 (in the current year)?
    public int femaleAncOver40() { 
        return this.mom.femaleOver40Helper() + this.dad.femaleOver40Helper();
    }
    // Produces the number of female ancestors over 40 in this tree 
    //(excluding this ancestor tree itself)
    public int femaleOver40Helper() {
        int nodeCount = ((2022 - 40) > this.yob && !this.isMale) ? 1 : 0;
        return nodeCount + this.mom.femaleOver40Helper() 
                         + this.dad.femaleOver40Helper();
    }

    // To compute the number of generations that are completely known
    // (including this AT)
    public int numTotalGens() {
        return 1 + Math.min(this.mom.numTotalGens(), this.dad.numTotalGens());
    }

    // To compute the number of generations that are at least partialy known
    // (including this AT)
    public int numPartialGens() {
        return 1 + Math.max(this.mom.numPartialGens(), this.dad.numPartialGens());
    }

    /******         Version1 of well formed       *******/
    // To compute whether this ancestor tree is well-formed: are all known
    // people younger than their parents?
    /* 
    public boolean wellFormed() {
        return  this.mom.bornBefore(this.yob) && 
                this.dad.bornBefore(this.yob) && 
                this.mom.wellFormed() && 
                this.dad.wellFormed();
    } */
     // produces true if this yob is less than thatYob
    public boolean bornBefore(int thatYob) { 
        return this.yob < thatYob; 
    }
    /******         End of version1 of well formed       *******/

    public boolean wellFormed() {
        return  this.mom.wellFormedHelper(this.yob) && 
                this.dad.wellFormedHelper(this.yob);
    }
    // produces true if this AT parents are well formed and if it is older than its given child yob 
    public boolean wellFormedHelper(int childYob) {
        return  (this.yob < childYob) && 
                this.mom.wellFormedHelper(this.yob) &&
                this.dad.wellFormedHelper(this.yob);
    }

    // To compute the names of all the known ancestors in this ancestor tree
    // (including this ancestor tree itself)
    public ILoString ancNames() {
        return new ConsLoString(this.name, this.mom.ancNames().append(this.dad.ancNames()));
    }

    // To compute this Person's youngest known grandparent
    public IAT youngestGrandparent() {
        return  this.mom.youngestParent().youngest(this.dad.youngestParent());
    }
    // produces the this youngest parent
    public IAT youngestParent() {
        return this.mom.youngest(this.dad);
    }
    // produces the youngest Person between this and that
    public IAT youngest(IAT that) {
        return (that.isYoungerThan(this.yob)) ? that : this;
    }
    // To determine if this ancestry tree is younger than the given year
    public boolean isYoungerThan(int yob) {
        return this.yob > yob;
    }
}

// Auxiliary data definition for List of String
interface ILoString { 
    // produces a list with the elements of lst appended at the end of this
    ILoString append(ILoString lst);
}

class MtLoString implements ILoString { 
    // produces a list with the elements of lst appended at the end of this
    public ILoString append(ILoString lst) { return lst; }
}
class ConsLoString implements ILoString {
    String first;
    ILoString rest;
    ConsLoString(String first, ILoString rest) {
        this.first = first;
        this.rest = rest;
    }

    // produces a list with the elements of lst appended at the end of this
    public ILoString append(ILoString lst) {
        return new ConsLoString(this.first, this.rest.append(lst));
    }
}


class ExamplesIAT {
    IAT enid = new Person("Enid", 1904, false, new Unknown(), new Unknown());
    IAT edward = new Person("Edward", 1902, true, new Unknown(), new Unknown());
    IAT emma = new Person("Emma", 1906, false, new Unknown(), new Unknown());
    IAT eustace = new Person("Eustace", 1907, true, new Unknown(), new Unknown());
 
    IAT david = new Person("David", 1925, true, new Unknown(), this.edward);
    IAT daisy = new Person("Daisy", 1927, false, new Unknown(), new Unknown());
    IAT dana = new Person("Dana", 1933, false, new Unknown(), new Unknown());
    IAT darcy = new Person("Darcy", 1930, false, this.emma, this.eustace);
    IAT darren = new Person("Darren", 1935, true, this.enid, new Unknown());
    IAT dixon = new Person("Dixon", 1936, true, new Unknown(), new Unknown());
 
    IAT clyde = new Person("Clyde", 1955, true, this.daisy, this.david);
    IAT candace = new Person("Candace", 1960, false, this.dana, this.darren);
    IAT cameron = new Person("Cameron", 1959, true, new Unknown(), this.dixon);
    IAT claire = new Person("Claire", 1956, false, this.darcy, new Unknown());
 
    IAT bill = new Person("Bill", 1980, true, this.candace, this.clyde);
    IAT bree = new Person("Bree", 1981, false, this.claire, this.cameron);
 
    IAT andrew = new Person("Andrew", 2001, true, this.bree, this.bill);

    IAT badlyFormed1 = new Person("Jon", 1974, true, new Unknown(), this.bree);
    IAT badlyFormed2 = new Person("Jon", 1974, true, this.clyde, this.bree);
    IAT badlyFormed3 = new Person("Jon", 1910, true, this.david, this.darcy);

    boolean testCount(Tester t) {
        return  t.checkExpect(new Unknown().count(), 0) &&
                t.checkExpect(this.enid.count(),     0) &&
                t.checkExpect(this.david.count(),    1) &&
                t.checkExpect(this.darcy.count(),    2) &&
                t.checkExpect(this.andrew.count(),  16);
    }

    boolean testFemaleAncOver40(Tester t) {
        return  t.checkExpect(new Unknown().femaleAncOver40(), 0) &&
                t.checkExpect(this.enid.femaleAncOver40(),     0) &&
                t.checkExpect(this.darcy.femaleAncOver40(),    1) &&
                t.checkExpect(this.bree.femaleAncOver40(),     3) &&
                t.checkExpect(this.andrew.femaleAncOver40(),   8);
    }

    boolean testNumTotalGens(Tester t) {
        return  t.checkExpect(new Unknown().numTotalGens(), 0) &&
                t.checkExpect(this.enid.numTotalGens(),     1) &&
                t.checkExpect(this.clyde.numTotalGens(),    2) &&
                t.checkExpect(this.bill.numTotalGens(),     3) &&
                t.checkExpect(this.andrew.numTotalGens(),   3);
    }
    
    boolean testNumPartialGens(Tester t) {
        return  t.checkExpect(new Unknown().numPartialGens(), 0) &&
                t.checkExpect(this.enid.numPartialGens(),     1) &&
                t.checkExpect(this.clyde.numPartialGens(),    3) &&
                t.checkExpect(this.bill.numPartialGens(),     4) &&
                t.checkExpect(this.andrew.numPartialGens(),   5);
    }
    
    boolean testWellFormed(Tester t) {
        return  t.checkExpect(new Unknown().wellFormed(), true) &&
                t.checkExpect(this.andrew.wellFormed(), true) &&
                t.checkExpect(this.badlyFormed1.wellFormed(), false) &&
                t.checkExpect(this.badlyFormed2.wellFormed(), false) &&
                t.checkExpect(this.badlyFormed3.wellFormed(), false);
    }

    boolean testAncNames(Tester t) {
        return  t.checkExpect(new Unknown().ancNames(), new MtLoString()) &&
                t.checkExpect(this.enid.ancNames(), new ConsLoString("Enid", new MtLoString())) &&
                t.checkExpect(this.darcy.ancNames(), new ConsLoString("Darcy", 
                                                        new ConsLoString("Emma", 
                                                            new ConsLoString("Eustace", 
                                                            new MtLoString()))));
    }

    boolean testYoungestGrandparent(Tester t) {
        return  t.checkExpect(new Unknown().youngestGrandparent(), new Unknown()) &&
                t.checkExpect(this.enid.youngestGrandparent(), new Unknown()) &&
                t.checkExpect(this.darcy.youngestGrandparent(), new Unknown()) &&
                t.checkExpect(this.bree.youngestGrandparent(), this.dixon) &&
                t.checkExpect(this.bill.youngestGrandparent(), this.darren) &&
                t.checkExpect(this.andrew.youngestGrandparent(), this.candace);
    }
}

/* Example tree
 * 
 *                                              ┌─────────┐
                                                │Andrew(M)│
                                                │(2001)   │
                                                └────┬────┘
                                                     │
                             ┌───────────────────────┴──────────────────────────┐
                             │                                                  │
                         ┌───┴───┐                                          ┌───┴───┐
                         │Bree(F)│                                          │Bill(M)│
                         │(1981) │                                          │(1980) │
                         └───┬───┘                                          └───┬───┘
                             │                                                  │
                    ┌────────┴─────────┐                          ┌─────────────┴───────────────┐
                    │                  │                          │                             │
               ┌────┴────┐        ┌────┴─────┐               ┌────┴─────┐                   ┌───┴────┐
               │Claire(F)│        │Cameron(M)│               │Candace(F)│                   │Clide(M)│
               │(1956)   │        │(1959)    │               │(1960)    │                   │(1955)  │
               └────┬────┘        └────┬─────┘               └────┬─────┘                   └───┬────┘
                    │                  │                          │                             │
            ┌───────┴───────┐    ┌─────┴─────┐            ┌───────┴────────┐             ┌──────┴───────┐
            │               │    │           │            │                │             │              │
        ┌───┴────┐         ┌┴┐  ┌┴┐      ┌───┴────┐   ┌───┴───┐       ┌────┴────┐    ┌───┴────┐    ┌────┴───┐
        │Darcy(F)│         │x│  │x│      │Dixon(M)│   │Dana(F)│       │Darren(M)│    │Daisy(F)│    │David(M)│
        │(1930)  │         └─┘  └─┘      │(1936)  │   │(1933) │       │(1935)   │    │(1927)  │    │(1925)  │
        └───┬────┘                       └────────┘   └───┬───┘       └────┬────┘    └───┬────┘    └───┬────┘
            │                                             │                │             │             │
     ┌──────┴──────┐                                  ┌───┴───┐       ┌────┴────┐    ┌───┴────┐    ┌───┴────┐
     │             │                                  │       │       │         │    │        │    │        │
 ┌───┴───┐    ┌────┴─────┐                           ┌┴┐     ┌┴┐  ┌───┴───┐    ┌┴┐  ┌┴┐      ┌┴┐  ┌┴┐  ┌────┴────┐
 │Emma(F)│    │Eustace(M)│                           │x│     │x│  │Enid(F)│    │x│  │x│      │x│  │x│  │Edward(M)│
 │(1906) │    │(1907)    │                           └─┘     └─┘  │(1904) │    └─┘  └─┘      └─┘  └─┘  │(1902)   │
 └───────┘    └──────────┘                                        └───────┘                            └─────────┘

 */