import tester.*;

interface IAT {
    // To compute the number of known ancestors of this ancestor tree
    // (excluding this ancestor tree itself)
    int count();

    // To compute the number of known ancestors of this ancestor tree 
    // (including this ancestor tree itself)
    int countHelp();

    // To compute how many ancestors of this ancestor tree (excluding this
    // ancestor tree itself) are women older than 40 (in the current year)?
    int femaleAncOver40();
  
    // To compute how many ancestors of this ancestor tree (including this
    // ancestor tree itself) are women older than 40 (in the current year)?
    int femaleAncOver40Helper();

    // produces how many generations (inclusive) are completely known
    int numTotalGens();

    // produces how many generations (inclusive) are at least partially known
    int numPartialGens();

    // To compute whether this ancestor tree is well-formed: are all known
    // people older than their parents?
    boolean wellFormed();

    // To determine if this ancestry tree is older than the given year of birth,
    // and its parents are well-formed
    boolean wellFormedHelper(int childYob);

    // To determine if this ancestry tree is born in or before the given year
    boolean bornInOrBefore(int yob);
    
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
    // To compute the number of known ancestors of this Unknown (excluding this Unknown itself)
    public int count() { return 0; }

    // To compute the number of known ancestors of this Unknown (including this Unknown itself)
    public int countHelp() { return 0; }

    // To compute how many ancestors of this Unknown (excluding this
    // Unknown itself) are women older than 40 (in the current year)?
    public int femaleAncOver40() { return 0; }

    // To compute how many ancestors of this Unknown (including this
    // Unknown itself) are women older than 40 (in the current year)?
    public int femaleAncOver40Helper() { return 0; }

    // produces how many generations (inclusive) are completely known
    public int numTotalGens() { return 0; }

    // produces how many generations (inclusive) are at least partially known
    public int numPartialGens() { return 0; }

    // To compute whether this Unknown is well-formed
    public boolean wellFormed() { return true; }

    // To determine if this Unknown is older than the given year of birth,
    // and its parents are well-formed
    public boolean wellFormedHelper(int childYob) { return true; }

    // To determine if this Unknown is born in or before the given year
    public boolean bornInOrBefore(int yob) { return true; }

    // To compute the names of all the known ancestors in this Unknown
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
    
    // To compute the number of known ancestors of this Person (excluding this Person itself)
    public int count() {
        return this.countHelp() - 1;
    }

    // To compute the number of known ancestors of this Person (including this Person itself)
    public int countHelp() {
        return 1 + this.mom.countHelp() + this.dad.countHelp();
    }

    // To compute how many ancestors of this Person (excluding this
    // Person itself) are women older than 40 (in 2023)
    public int femaleAncOver40() {
        return this.femaleAncOver40Helper() - 1;
    }
  
    // To compute how many ancestors of this Person (including this
    // Person itself) are women older than 40 (in 2023)
    public int femaleAncOver40Helper() {
        int count = (!this.isMale && (2023-40) >= this.yob) ? 1 : 0;
        return count + this.mom.femaleAncOver40Helper() + this.dad.femaleAncOver40Helper();
    }

    // produces how many generations (inclusive) are completely known
    public int numTotalGens() {
        // ASSUME: the current person is in a complete generation 
        //         (since I cant Know anything about sibiling nodes)
        // Count the complete generations of the parents, and take the minimun 
        // since that number represents the last complete generation
        return 1 + Math.min(this.mom.numTotalGens(),this.dad.numTotalGens());
    }

    // produces how many generations (inclusive) are at least partially known
    public int numPartialGens() {
        // Similar to numTotalGens
        return 1 + Math.max(this.mom.numPartialGens(),this.dad.numPartialGens());
    }

    /******         Version1 of well formed       *******/
        // To determine if this Person is well-formed
        public boolean wellFormed_v1() { 
            return this.mom.bornInOrBefore(this.yob) 
            && this.dad.bornInOrBefore(this.yob) 
            && this.mom.wellFormed() 
            && this.dad.wellFormed();
        }
        
        // produces true if this is older than its parents
        public boolean bornInOrBefore(int yob) {
            return this.yob <= yob;
        }
    /******        End of Version 1 of well formed       *******/
    
    // To determine if this Person is well-formed
    public boolean wellFormed() {
        return this.mom.wellFormedHelper(yob)
            && this.dad.wellFormedHelper(yob);
    }
    
    // To determine if this Person is well-formed: is it younger than its parents,
    // and are its parents are well-formed
    public boolean wellFormedHelper(int childYob) {
        // childYob is a context preserving accumulator
        return this.yob <= childYob && 
               this.mom.wellFormedHelper(this.yob) &&
               this.dad.wellFormedHelper(this.yob);
    }

    // To compute the names of all the known ancestors in this Person
    // (including this Person itself)
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
 
    boolean testCount(Tester t) {
        return
            t.checkExpect(this.andrew.count(), 16) &&
            t.checkExpect(this.david.count(), 1) &&
            t.checkExpect(this.enid.count(), 0) &&
            t.checkExpect(new Unknown().count(), 0);
    }
    boolean testFemaleAncOver40(Tester t) {
        return
            t.checkExpect(this.andrew.femaleAncOver40(), 7) &&
            t.checkExpect(this.bree.femaleAncOver40(), 3) &&
            t.checkExpect(this.darcy.femaleAncOver40(), 1) &&
            t.checkExpect(this.enid.femaleAncOver40(), 0) &&
            t.checkExpect(new Unknown().femaleAncOver40(), 0);
    }
    boolean testNumGens(Tester t) {
        return
            t.checkExpect(this.andrew.numTotalGens(), 3) &&
            t.checkExpect(this.candace.numTotalGens(), 2) &&
            t.checkExpect(this.david.numTotalGens(), 1) &&
            t.checkExpect(this.enid.numTotalGens(), 1) &&
            t.checkExpect(new Unknown().numTotalGens(), 0) &&
            t.checkExpect(this.andrew.numPartialGens(), 5) &&
            t.checkExpect(this.enid.numPartialGens(), 1) &&
            t.checkExpect(new Unknown().numPartialGens(), 0);
    }
    boolean testWellFormed(Tester t) {
        return
            t.checkExpect(this.andrew.wellFormed(), true) &&
            t.checkExpect(new Unknown().wellFormed(), true) &&
            t.checkExpect(
                new Person("Zane", 2000, true, this.andrew, this.bree).wellFormed(),
                false);
    }
    boolean testAncNames(Tester t) {
        return
            t.checkExpect(this.darcy.ancNames(),
                new ConsLoString("Darcy",
                    new ConsLoString("Emma", 
                        new ConsLoString("Eustace", new MtLoString())))) &&
            t.checkExpect(this.david.ancNames(),
                new ConsLoString("David",
                    new ConsLoString("Edward", new MtLoString()))) &&
            t.checkExpect(this.eustace.ancNames(),
                new ConsLoString("Eustace", new MtLoString())) &&
            t.checkExpect(new Unknown().ancNames(), new MtLoString());
    }
    boolean testYoungestGrandparent(Tester t) {
        return
            t.checkExpect(new Unknown().youngestGrandparent(), new Unknown()) &&
            t.checkExpect(this.emma.youngestGrandparent(), new Unknown()) &&
            t.checkExpect(this.david.youngestGrandparent(), new Unknown()) &&
            t.checkExpect(this.claire.youngestGrandparent(), this.eustace) &&
            t.checkExpect(this.bree.youngestGrandparent(), this.dixon) &&
            t.checkExpect(this.andrew.youngestGrandparent(), this.candace);
    }
}

// Listof String
interface ILoString {
    // produces a new list by appending the given list onto this
    ILoString append(ILoString that);
}

class ConsLoString implements ILoString {
    String first;
    ILoString rest;
    ConsLoString(String first, ILoString rest) {
        this.first = first;
        this.rest = rest;
    }

    // produces a new list by appending the given list onto this
    public ILoString append(ILoString that) {
        return new ConsLoString(this.first, this.rest.append(that));
    }
}

class MtLoString implements ILoString {
    // produces a new list by appending the given list onto this
    public ILoString append(ILoString that) { return that; }
}