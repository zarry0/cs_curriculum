import tester.Tester;
/*
 * Design a data representation for this problem:
 *  Develop a “real estate assistant” program. 
 *  The “assistant” helps real estate agents locate available houses for clients. 
 *  The information about a house includes its kind, the number of rooms, its address, and the asking price.
 *  An address consists of a street number, a street name, and a city. . . .
 * 
 * Represent the following examples using your classes:
 *  1.  Ranch, 7 rooms, $375,000, 23 Maple Street, Brookline; 
 *  2.  Colonial, 9 rooms, $450,000, 5 Joye Road, Newton; and
 *  3.  Cape, 6 rooms, $235,000, 83 Winslow Road, Waltham.
 */


 /*
  * Class diagram
               +-----------------+
               | House           |
               +-----------------+
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

  class ExamplesHouses {
    Address address1 = new Address(23, "Mapple Street", "Brookline");
    Address address2 = new Address(5, "Joye Road", "Newton");
    Address address3 = new Address(83, "Winslow Road", "Waltham");

    House ranch = new House("Ranch", 7, 3575000, address1);
    House colonial = new House("Ranch", 9, 450000, address2);
    House cape = new House("Ranch", 6, 235000, address3);
  }