import tester.Tester;

/*
 * Design a data representation for this problem:
 * 
 *  Develop a “bank account” program. 
 *  The program keeps track of the balances in a person’s bank accounts. 
 *  Each account has an id number and a customer’s name. 
 *  There are three kinds of accounts: 
 *      - a checking account, 
 *      - a savings account, and 
 *      - a certificate of deposit (CD). 
 *  Checking account information also includes the minimum balance. 
 *  Savings account includes the interest rate. 
 *  A CD specifies the interest rate and the maturity date. 
 *  Naturally, all three types come with a current balance. 
 * 
 *  Represent the following examples using your classes:
 *      1. Earl Gray, id# 1729, has $1,250 in a checking account with minimum balance of $500;
 *      2. Ima Flatt, id# 4104, has $10,123 in a certificate of deposit whose interest rate is 4% and whose maturity date is June 1, 2005;
 *      3. Annie Proulx, id# 2992, has $800 in a savings account; the account yields interest at the rate of 3.5%.
 */


 /*
  * Class diagram

                                      +----------+
                                      | IAccount |
                                      +----------+
                                           |
                                          / \
                                          ---
                                           |
                                           |
               +---------------------------+-------------------------+
               |                           |                         |
               |                           |                         |
               |                           |                         |
     +--------------------+     +---------------------+     +---------------------+
     | Checkings          |     | Savings             |     | CD                  |
     |--------------------|     |---------------------|     |---------------------|
  +--+ Customer customer  |  +--+ Customer customer   |  +--+ Customer customer   |
  |  | double currBalance |  |  | double currBalance  |  |  | double currBalance  |
  |  | double minBalance  |  |  | double interestRate |  |  | double interestRate |
  |  +--------------------+  |  +---------------------+  |  | Date maturityDate   +--+
  |                          |                           |  +---------------------+  |
  |                          +-------------+             |                           |
  +-------------------------------------+  |  +----------+          +----------------+
                                        |  |  |                     |
                                        v  v  v                     v
                                    +-------------+          +--------------+
                                    | Customer    |          | Date         |
                                    |-------------|          |--------------|
                                    | String name |          | int day      |
                                    | int id      |          | String month |
                                    +-------------+          | int year     |
                                                             +--------------+
 */
 
class Customer {
    String name;
    int id;

    Customer(String name, int id) {
        this.name = name;
        this.id = id;
    }
}

interface IAccount {}

class Checkings implements IAccount {
    Customer customer;
    double currBalance;
    double minBalance;

    Checkings(Customer customer, double currBalance, double minBalance) {
        this.customer = customer;
        this.currBalance = currBalance;
        this.minBalance = minBalance;
    }
}

class Savings implements IAccount {
    Customer customer;
    double currBalance;
    double interestRate;

    Savings(Customer customer, double currBalance, double interestRate) {
        this.customer = customer;
        this.currBalance = currBalance;
        this.interestRate = interestRate;
    }
}

class CD implements IAccount {
    Customer customer;
    double currBalance;
    double interestRate;
    Date maturityDate;

    CD(Customer customer, double currBalance, double interestRate, Date maturityDate) {
        this.customer = customer;
        this.currBalance = currBalance;
        this.interestRate = interestRate;
        this.maturityDate = maturityDate;
    }
}

class Date {
    int day;
    String month;
    int year;

    Date(int day, String month, int year) {
        this.day = day;
        this.month = month;
        this.year = year;
    }
}

class ExamplesIAccount {
    Customer earlGray = new Customer("Earl Gray", 1729);
    Customer imaFlatt = new Customer("Ima Flatt", 4104);
    Customer annieProulx = new Customer("Annie Proulx", 2992);

    IAccount earlAccount = new Checkings(earlGray, 1250, 500);
    IAccount imaAccount = new CD(imaFlatt, 10123, 4, new Date(1, "June", 2005));
    IAccount annieAccount = new Savings(annieProulx, 800, 3.5);
}