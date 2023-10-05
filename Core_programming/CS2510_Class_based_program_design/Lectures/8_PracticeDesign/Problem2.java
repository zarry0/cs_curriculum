import tester.Tester;
/*
 * Variant A
 * 
 * Suppose you are given a list of integers. Your task is to determine if this list contains:
 *      - A number that is even
 *      - A number that is positive and odd
 *      - A number between 5 and 10, inclusive
 * The order in which you find numbers in the list satisfying these requirements does not matter. 
 * The list could have many more numbers than you need. Any number in the list may satisfy multiple requirements. 
 * For example, the list (in Racket notation) (list 6 5) satisfies all three requirements, while the list (list 4 3) does not.
 * 
 * 
 * Variant B
 * 
 * Again, the list must contain numbers satisfying the three requirements above. 
 * Again, order does not matter. This time, a given number in the list may only be used to satisfy a single requirement;
 * however, duplicate numbers are permitted to satisfy multiple requirements. 
 * So, (list 6 5) does not meet all the criteria for this variant, but (list 6 5 6) does.
 * 
 * 
 * Variant C 
 * 
 * Again, the list must contain numbers satisfying the three requirements above. 
 * Again, order does not matter. Again, a given number in the list may only be used to satisfy a single requirement.
 * This time, however, the list may not contain any extraneous numbers. 
 * So, (list 6 5 6) satisfies all our criteria for this variant, but (list 6 5 42 6) does not.
 * 
 * Variant Z
 * (Very open-ended) 
 * 
 * There is something distinctly unsatisfying about designing these solutions to work for precisely three requirements:
 * why not four, or five, or an arbitrary number? Design functions in DrRacket to solve the preceding three problems again, 
 * this time supporting an arbitrary number of requirements to be checked on the elements of the list. 
 * What essential features of Racket are you using, that we do not yet have in Java?
 * 
 * Answer:
 * In Racket, we can abstract the process of checking each number for requirements by designing a generic function that 
 * goes through the list and returns an answer based on several requirements (flags) and a function that evaluates 
 * a single number for those requirements.
 * We achieve this thanks to the use of higher-order functions.
 */

interface ILoInt {
    // produces true if this contains an even number, 
    //                                an odd and positive number and 
    //                                a number between 5 and 10 inclusive
    boolean checkVariantA();
    boolean checkVariantAHelper(boolean isEven, boolean isOddPositive, boolean isInRange);

    // produces true if this contains an even number, 
    //                                an odd and positive number and 
    //                                a number between 5 and 10 inclusive
    // Note: a single number can only satisfy a single requirement, 
    //       but duplicates are allowed to satisfy different requirements
    boolean checkVariantB();
    boolean checkVariantBHelper(boolean isEven, boolean isOddPositive, boolean isInRange);  

    // produces true if this contains an even number, 
    //                                an odd and positive number and 
    //                                a number between 5 and 10 inclusive
    //          also the list must not contain any extraneous numbers
    // ASSUME: a extraneous number is one that is outside of the range [5, 10]
    // Note: a single number can only satisfy a single requirement, 
    //       but duplicates are allowed to satisfy different requirements
    boolean checkVariantC();
    boolean checkVariantCHelper(boolean isEven, boolean isOddPositive, boolean isInRange);
}
class MtLoInt implements ILoInt {
    // produces true if this contains an even number, 
    //                                an odd and positive number and 
    //                                a number between 5 and 10 inclusive
    public boolean checkVariantA() {
        return false;
    }
    public boolean checkVariantAHelper(boolean isEven, boolean isOddPositive, boolean isInRange) {
        return isEven && isOddPositive && isInRange;
    }

    // produces true if this contains an even number, 
    //                                an odd and positive number and 
    //                                a number between 5 and 10 inclusive
    // Note: a single number can only satisfy a single requirement, 
    //       but duplicates are allowed to satisfy different requirements
    public boolean checkVariantB() {
        return false;
    }
    public boolean checkVariantBHelper(boolean isEven, boolean isOddPositive, boolean isInRange) {
        return isEven && isOddPositive && isInRange;
    }

    // produces true if this contains an even number, 
    //                                an odd and positive number and 
    //                                a number between 5 and 10 inclusive
    //          also the list must not contain any extraneous numbers
    // ASSUME: a extraneous number is one that is outside of the range [5, 10]
    // Note: a single number can only satisfy a single requirement, 
    //       but duplicates are allowed to satisfy different requirements
    public boolean checkVariantC() {
        return false;
    }
    public boolean checkVariantCHelper(boolean isEven, boolean isOddPositive, boolean isInRange) {
        return isEven && isOddPositive && isInRange;
    }
}
class ConsLoInt implements ILoInt {
    int first;
    ILoInt rest;
    public ConsLoInt(int first, ILoInt rest) {
        this.first = first;
        this.rest = rest;
    }
    // produces true if this contains an even number, 
    //                                an odd and positive number and 
    //                                a number between 5 and 10 inclusive
    public boolean checkVariantA() {
        return this.checkVariantAHelper(false, false, false);
    }
    public boolean checkVariantAHelper(boolean isEven, boolean isOddPositive, boolean isInRange) {
        // This method was written in such a way that resembles the structure of the variant B & C structure
        // not necessarily the better way
        
        boolean hasNumEven = isEven;
        boolean hasNumOddPositive = isOddPositive;
        boolean hasNumInRange = isInRange;
        
        if (this.first % 2 == 0)                          hasNumEven |= true;
        if (this.first % 2 != 0 && this.first > 0) hasNumOddPositive |= true;
        if (this.first >= 5 && this.first <= 10)       hasNumInRange |= true;
        
        return this.rest.checkVariantAHelper(hasNumEven, hasNumOddPositive, hasNumInRange);  
    }
    /* Alt version for checkVariantAHelper()
    public boolean checkVariantAHelper(boolean isEven, boolean isOddPositive, boolean isInRange) {
        boolean hasNumEven = (this.first % 2 == 0) || isEven;
        boolean hasNumOddPositive = (this.first % 2 != 0 && this.first > 0) || isOddPositive;
        boolean hasNumInRange = (this.first >= 5 && this.first <= 10) || isInRange;
        if (hasNumEven && hasNumOddPositive && hasNumInRange) return true;
        return this.rest.checkVariantAHelper(hasNumEven, hasNumOddPositive, hasNumInRange);
    }*/

    // produces true if this contains an even number, 
    //                                an odd and positive number and 
    //                                a number between 5 and 10 inclusive
    // Note: a single number can only satisfy a single requirement, 
    //       but duplicates are allowed to satisfy different requirements
    public boolean checkVariantB() {
        return this.checkVariantBHelper(false, false, false);
    }
    public boolean checkVariantBHelper(boolean isEven, boolean isOddPositive, boolean isInRange) {

        boolean hasNumEven = isEven;
        boolean hasNumOddPositive = isOddPositive;
        boolean hasNumInRange = isInRange;

        if      (!isEven && this.first % 2 == 0)                          hasNumEven |= true;
        else if (!isOddPositive && this.first % 2 != 0 && this.first > 0) hasNumOddPositive |= true;
        else if (!isInRange && this.first >= 5 && this.first <= 10)       hasNumInRange |= true;
        
        return this.rest.checkVariantBHelper(hasNumEven, hasNumOddPositive, hasNumInRange);    
    }

    // produces true if this contains an even number, 
    //                                an odd and positive number and 
    //                                a number between 5 and 10 inclusive
    //          also the list must not contain any extraneous numbers
    // ASSUME: a extraneous number is one that is outside of the range [5, 10]
    // Note: a single number can only satisfy a single requirement, 
    //       but duplicates are allowed to satisfy different requirements
    public boolean checkVariantC() {
        return this.checkVariantCHelper(false, false, false);
    }
    public boolean checkVariantCHelper(boolean isEven, boolean isOddPositive, boolean isInRange) {
        if (this.first < 5  || this.first > 10) return false;

        boolean hasNumEven = isEven;
        boolean hasNumOddPositive = isOddPositive;
        boolean hasNumInRange = isInRange;

        if      (!isEven && this.first % 2 == 0)                          hasNumEven |= true;
        else if (!isOddPositive && this.first % 2 != 0 && this.first > 0) hasNumOddPositive |= true;
        else if (!isInRange && this.first >= 5 && this.first <= 10)       hasNumInRange |= true;
        
        return this.rest.checkVariantCHelper(hasNumEven, hasNumOddPositive, hasNumInRange);    
    }
}
class ExamplesILoInt {
    ILoInt l0 = new MtLoInt();
    ILoInt l1 = new ConsLoInt(4, new ConsLoInt(3, l0));
    ILoInt l2 = new ConsLoInt(6, new ConsLoInt(5, l0));
    ILoInt l3 = new ConsLoInt(-1, new ConsLoInt(4, l0));
    ILoInt l4 = new ConsLoInt(6, new ConsLoInt(5, new ConsLoInt(6, l0)));
    ILoInt l5 = new ConsLoInt(4, new ConsLoInt(3, new ConsLoInt(6, l0)));
    ILoInt l6 = new ConsLoInt(6, new ConsLoInt(5, new ConsLoInt(42, new ConsLoInt(6, l0))));

    boolean testCheckVariantA(Tester t) {
        return  t.checkExpect(this.l0.checkVariantA(), false) &&
                t.checkExpect(this.l1.checkVariantA(), false) &&
                t.checkExpect(this.l2.checkVariantA(), true) &&
                t.checkExpect(this.l3.checkVariantA(), false) &&
                t.checkExpect(this.l4.checkVariantA(), true) &&
                t.checkExpect(this.l5.checkVariantA(), true) &&
                t.checkExpect(this.l6.checkVariantA(), true);
    }

    boolean testCheckVariantB(Tester t) {
        return  t.checkExpect(this.l0.checkVariantB(), false) &&
                t.checkExpect(this.l1.checkVariantB(), false) &&
                t.checkExpect(this.l2.checkVariantB(), false) &&
                t.checkExpect(this.l3.checkVariantB(), false) &&
                t.checkExpect(this.l4.checkVariantB(), true) &&
                t.checkExpect(this.l5.checkVariantB(), true) &&
                t.checkExpect(this.l6.checkVariantB(), true);
    }

    boolean testCheckVariantC(Tester t) {
        return  t.checkExpect(this.l0.checkVariantC(), false) &&
                t.checkExpect(this.l1.checkVariantC(), false) &&
                t.checkExpect(this.l2.checkVariantC(), false) &&
                t.checkExpect(this.l3.checkVariantC(), false) &&
                t.checkExpect(this.l4.checkVariantC(), true) &&
                t.checkExpect(this.l5.checkVariantC(), false) &&
                t.checkExpect(this.l6.checkVariantC(), false);
    }

}

