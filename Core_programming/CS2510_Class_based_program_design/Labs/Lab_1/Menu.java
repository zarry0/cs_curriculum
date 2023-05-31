import java.net.SocketPermission;

import tester.*;

/* Problem 4
 * A deli menu includes soups, salads, and sandwiches. 
 * Every item has a name and a price (in cents - so we have whole numbers only).
 * 
 * For each soup and salad we note whether it is vegetarian or not.
 * 
 * Salads also specify the name of any dressing being used.
 * 
 * For a sandwich we note the kind of bread, and two fillings (e.g peanut butter and jelly; or ham and cheese). 
 * Assume that every sandwich will have two fillings, and ignore extras (mayo, mustard, tomatoes, lettuce, etc.)
 * 
 * Define classes to represent each of these kinds of menu items. 
 * Think carefully about what type each field of each class should be. Do you need to define any interfaces?
 * Construct at least two examples each of soups, salads, and sandwiches.
 */

/* Class diagram
 *
                              +---------+
                              |  IMenu  |
                              +---------+
                                   |
                                  / \
                                  ---
                                   |
                                   |
             +---------------------+-----------------------+
             |                     |                       |
             v                     v                       v
 +--------------------+  +---------------------+  +-------------------+
 | Soup               |  | Salad               |  | Sandwich          |
 +--------------------+  +---------------------+  +-------------------+
 | String name        |  | String name         |  | String name       |
 | int price          |  | int price           |  | int price         |
 | boolean vegetarian |  | String dressing     |  | String bread      |
 +--------------------+  | boolean vegetarian  |  | Fillings fillings |+---+
                         +---------------------+  +-------------------+    |
                                                                           |
                                                                           |
                                                                           |
                                                             +-------------+
                                                             |
                                                             v
                                                     +--------------------+
                                                     | Fillings           |
                                                     +--------------------+
                                                     | String ingredient1 |
                                                     | String ingredient2 |
                                                     +--------------------+
*/

// to represent a deli menu
interface IMenu { }

// to represent a soup
class Soup implements IMenu {
    String name;
    int price;
    boolean vegetarian;

    Soup(String name, int price, boolean vegetarian) {
        this.name = name;
        this.price = price;
        this.vegetarian = vegetarian;
    }

}

//to represent a salad
class Salad implements IMenu {
    String name;
    int price;
    String dressing;
    boolean vegetarian;

    Salad(String name, int price, String dressing, boolean vegetarian) {
        this.name = name;
        this.price = price;
        this.dressing = dressing;
        this.vegetarian = vegetarian;
    }
}

// to represent a Sandwich
class Sandwich implements IMenu {
    String name;
    int price;
    String bread;
    Fillings fillings;

    Sandwich(String name, int price, String bread, Fillings fillings) {
        this.name = name;
        this.price = price;
        this.bread = bread;
        this.fillings = fillings;
    }
}

// to represent a combination of two ingredients
class Fillings {
    String ingredient1;
    String ingredient2;

    Fillings(String i1, String i2) {
        this.ingredient1 = i1;
        this.ingredient2 = i2;
    }
}

// to add examples for the menu
class ExamplesMenu {
    IMenu potatoSoup = new Soup("Potato Soup", 40, true);
    IMenu chickenSoup = new Soup("Chicken Soup", 55, false);

    IMenu caesarSalad = new Salad("Caesar Salad", 80, "ranch",true);
    IMenu fruitSalad = new Salad("Fruit Salad", 69, "honney", true);

    Fillings pbAndJ = new Fillings("Peanut Butter", "Jelly");
    Fillings hamAndCheese = new Fillings("Ham", "Cheese");

    IMenu pbAndJSandwich = new Sandwich("PB & J sandwich", 150, "white bread", pbAndJ);
    IMenu hamAndCheeseSandwich = new Sandwich("Ham & Cheese sandwich", 200, "garlic bread", hamAndCheese);
}
