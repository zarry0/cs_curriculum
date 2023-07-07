import tester.Tester;

/*
 * Modify the Coffee class from figure 38 so that cost takes into account bulk discounts:
 * 
 *      Develop a program that computes the cost of selling bulk 
 *      coffee at a specialty coffee seller from a receipt that includes the kind of coffee, 
 *      the unit price, and the total amount (weight) sold. 
 *      If the sale is for less than 5,000 pounds, there is no discount. 
 *      For sales of 5,000 pounds to 20,000 pounds, the seller grants a discount of 10%. 
 *      For sales of 20,000 pounds or more, the discount is 25%. 
 * 
 * Don’t forget to adapt the examples, too.
 * 
 * Figure 38:
 * 
     +-----------------------------+
     | Coffee                      |
     |-----------------------------|
     | String kind                 |
     | int price (cents per pound) |
     | int weight (pounds)         |
     |-----------------------------|
     | int cost()                  |
     | int costWithDiscount()      |   (Modification to add the discount)
     +-----------------------------+
 * Examples:
 *      Coffee type Kona,      at 2095 cents per pound, 100  pounds;   expected cost 209500
 *      Coffee type Ethiopian, at 800  cents per pound, 1000 pounds;   expected cost 800000
 *      Coffee type Colombian, at 950  cents per pound, 20   pounds;   expected cost 19000
 */

 // to represent a coffee sale
 // at which price, how much coffee was sold
 class Coffee {
    String kind;
    int price;
    int weight;

    Coffee(String kind, int price, int weight) {
        this.kind = kind;
        this.price = price;
        this.weight = weight;
    }

    int cost() {
        return this.price * this.weight;
    }

    int costWithDiscount() {
        double subTotal = this.cost();
        if (subTotal >= 5000 && subTotal < 20000) subTotal *= .9;
        else if (subTotal >= 20000) subTotal *= 0.75;

        return (int) subTotal;
    }
 }

 class ExamplesCoffee {
    Coffee kona = new Coffee("Kona", 2095, 100);
    Coffee ethi = new Coffee("Ethiopian", 800, 1000);
    Coffee colo = new Coffee("Colombian", 950, 20);

    boolean testCost(Tester t) {
        return  t.checkExpect(this.kona.cost(), 209500) &&
                t.checkExpect(this.ethi.cost(), 800000) &&
                t.checkExpect(this.colo.cost(), 19000);
    }

    boolean testCostWithDiscount(Tester t) {
        return  t.checkExpect(this.kona.costWithDiscount(), 157125) && 
                t.checkExpect(this.ethi.costWithDiscount(), 600000) &&
                t.checkExpect(this.colo.costWithDiscount(), 17100);
    }
 }