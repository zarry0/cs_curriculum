import tester.Tester;

/*
 * Problem 2:
 * Here is a data definition in DrRacket:
 * 
 *      ;; An IceCream is one of:
 *      ;; -- EmptyServing
 *      ;; -- Scooped
 * 
 *      ;;An EmptyServing is a (make-empty-serving Boolean)
 *      (define-struct empty-serving (cone))
 * 
 *      ;;A Scooped is a (make-scooped IceCream String)
 *      (define-struct scooped (more flavor))
 * 
 *  -  Draw the class diagram that represents this data definition.
 *  -  Convert this data definition into Java. 
 *  -  Create examples in a class ExamplesIceCream. 
 *     Include in your examples the following two ice cream orders:
 *          +  a cup of ice cream with scoops of "mint chip", "coffee", "black raspberry", and "caramel swirl"
 *          +  a cone with scoops of "chocolate", "vanilla", and "strawberry"
 * 
 * Make sure the two sample orders given above are named order1 and order2.
 * Note: the descriptions above are listed in the order that you would order this in real life. 
 *       Think carefully how this should be represented as data.
 */

 /*
  * Class diagram:

              +-----------+
              | IIceCream |
              |-----------|
              +-----------+
                    |
                   / \
                   ---
                    |
                    |
         +--------------------+
         |                    |
  +--------------+    +----------------+
  | EmptyServing |    | Scooped        |
  |--------------|    |----------------|
  | boolean cone |    | IIceCream more |
  +--------------+    | String flavor  |
                      +----------------+
*/

interface IIceCream { }

class EmptyServing implements IIceCream {
    boolean cone;

    EmptyServing(boolean cone) {
        this.cone = cone;
    }
}

class Scooped implements IIceCream {
    IIceCream more;
    String flavor;

    Scooped(IIceCream more, String flavor) {
        this.more = more;
        this.flavor = flavor;
    }
}

class ExamplesIceCream {
    IIceCream order1 = new Scooped(new Scooped(new Scooped(new Scooped(new EmptyServing(false), "mint chip"), 
                                                                                                "coffee"), 
                                                                                                "black raspberry"), 
                                                                                                "caramel swirl");
    IIceCream order2 = new Scooped(new Scooped(new Scooped(new EmptyServing(true), "chocolate"),
                                                                                        "vanilla"), 
                                                                                        "strawberry");
    IIceCream order3 = new Scooped(new Scooped(new EmptyServing(true), "pineapple"), "coconut");
}