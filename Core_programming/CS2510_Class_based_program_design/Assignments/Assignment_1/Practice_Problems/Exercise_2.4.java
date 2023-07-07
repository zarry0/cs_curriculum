import tester.Tester;

/*
* Translate the class diagram in figure 6 into a class definition. 
* Also create instances of the class.
*
  +---------------+
  | Automobile    |
  |---------------|
  | String model  |
  | int price     |
  | double mileage|
  | boolean used  |
  +---------------+
 * Figure 6: A class diagram for automobiles
 */

 class Automobile {
    String model;
    int price;
    double mileage;
    boolean used;

    Automobile(String model, int price, double mileage, boolean used) {
        this.model = model;
        this.price = price;
        this.mileage = mileage;
        this.used = used;
    }
 }

 class ExamplesAutomobile {
    Automobile rav4 = new Automobile("Toyota Rav4", 25000, 1500, true);
    Automobile impala = new Automobile("Chevy Impala", 45000, 2000, true);
    Automobile model_3 = new Automobile("Tesla Model 3", 35000, 0, false);
    Automobile cavalier = new Automobile("Chevrolet Cavalier", 20000, 0, true);
 }