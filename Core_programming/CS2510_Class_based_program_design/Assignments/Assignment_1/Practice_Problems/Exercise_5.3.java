import tester.Tester;

/*
 * Consider a revision of the problem in exercise 3.1:
 *       Develop a program that assists real estate agents. 
 *       The program deals with listings of available houses.
 * Make examples of listings. 
 * Develop a data definition for listings of houses. 
 * Implement the definition with classes. Translate the examples into objects.
 */

 /*
  * Class diagram

            +----------+
            | IListing |
            +----------+
                 |
                / \
                ---
                 |
                 |
        +-----------------+
        |                 |
  +-----------+     +-------------+
  | MtListing |     | ConsListing |
  +-----------+     |-------------|        +-----------------+
                    | House house +------->| House           |
                    +-------------+        +-----------------+
                                           | String kind     |
                                           | int rooms       |
                                   +-------+ Address address |
                                   |       | double price    |
                                   |       +-----------------+
                                   |
                                   |
                                   v
                               +----------------+
                               | Address        |
                               +----------------+
                               | int stNumber   |
                               | String stName  |
                               | String city    |
                               +----------------+

  */

class House {
    String kind;
    int rooms;
    double price;
    Address address;

    House(String kind, int rooms, double price, Address address) {
        this.kind = kind;
        this.rooms = rooms;
        this.price = price;
        this.address = address;
    }
}

class Address {
    int stNumber;
    String stName;
    String city;

    Address(int stNumber, String stName, String city) {
        this.stNumber = stNumber;
        this.stName = stName;
        this.city = city;
    }
}

interface IListing {}

class MtListing implements IListing {}

class ConsListing implements IListing {
    House house;
    IListing rest;

    ConsListing(House house, IListing rest) {
        this.house = house;
        this.rest = rest;
    }
}

class ExamplesIListing {
    Address address1 = new Address(23, "Mapple Street", "Brookline");
    Address address2 = new Address(5, "Joye Road", "Newton");
    Address address3 = new Address(83, "Winslow Road", "Waltham");

    House ranch = new House("Ranch", 7, 3575000, address1);
    House colonial = new House("Ranch", 9, 450000, address2);
    House cape = new House("Ranch", 6, 235000, address3);

    IListing empty = new MtListing();
    IListing listing1 = new ConsListing(this.ranch, this.empty);
    IListing listing2 = new ConsListing(this.colonial, new ConsListing(this.ranch, this.empty));
    IListing listing3 = new ConsListing(this.cape, new ConsListing(colonial, new ConsListing(this.ranch, this.empty)));
}