import tester.*;

/* Class diagram
 *             +--------------------------------+
               | ILoBook                        |<----------------------+
               +--------------------------------+                       |
               +--------------------------------+                       |
               | int count()                    |                       |
               | double salePrice(int discount) |                       |
               | ILoBook allBefore(int y)       |                       |
               | ILoBook sortByPrice()          |                       |
               +--------------------------------+                       |
                                |                                       |
                               / \                                      |
                               ---                                      |
                                |                                       |
                  -----------------------------                         |
                  |                           |                         |
+--------------------------------+   +--------------------------------+ |
| MtLoBook                       |   | ConsLoBook                     | |
+--------------------------------+   +--------------------------------+ |
+--------------------------------+ +-| Book first                     | |
| int count()                    | | | ILoBook rest                   |-+
| double salePrice(int discount) | | +--------------------------------+
| ILoBook allBefore(int y)       | | | int count()                    |
| ILoBook sortByPrice()          | | | double salePrice(int discount) |
+--------------------------------+ | | ILoBook allBefore(int y)       |
                                   | | ILoBook sortByPrice()          |
                                   | +--------------------------------+
                                   v
                   +--------------------------------+
                   | Book                           |
                   +--------------------------------+
                   | String title                   |
                   | String author                  |
                   | int year                       |
                   | double price                   |
                   +--------------------------------+
                   | double salePrice(int discount) |
                   +--------------------------------+
 */
class Book {
    String title;
    String author;
    int year;
    double price;

    Book(String title, String author, int year, double price) {
        this.title = title;
        this.author = author;
        this.year = year;
        this.price = price;
    }

    // calculate the sale price for a given discount
    double salePrice(int discount) {
        return this.price - (this.price * discount) / 100;
    }

    // produces true if the book was published before the given year
    boolean publishedBefore(int year) {
        return this.year < year;
    }

    boolean isCheaperThan(Book that) {
        return this.price < that.price;
    }

    // produces true if this.title <= that title, false otherwise
    boolean titleBefore(Book that) {
        return this.title.compareTo(that.title) <= 0;
    }
}

interface ILoBook {
    // count the books in this list
    int count();
 
    // produce a list of all books published before the given date
    // from this list of books 
    ILoBook allBefore(int year);
 
    // calculate the total sale price of all books in this list for a given discount
    double salePrice(int discount);
 
    // produce a list of all books in this list, sorted by their price
    ILoBook sortByPrice();

    // inserts a book into a sorted list of Books in the rigth position
    ILoBook insert(Book book);
    
    // produce a list of all books in this list, sorted by their title
    ILoBook sortByTitle();

    // inserts a book into a sorted list of Books by their title in the rigth position
    ILoBook insertByTitle(Book book);
}

class MtLoBook implements ILoBook {
    // count the books in this list
    public int count() { return 0; }
 
    // produce a list of all books published before the given date
    // from this list of books 
    public ILoBook allBefore(int year) { return this; }
 
    // calculate the total sale price of all books in this list for a given discount
    public double salePrice(int discount) { return 0; }
 
    // produce a list of all books in this list, sorted by their price
    public ILoBook sortByPrice() { return this; }

    public ILoBook insert(Book book) { return new ConsLoBook(book, this); }

    public ILoBook sortByTitle() { return this; }

    public ILoBook insertByTitle(Book book) { return new ConsLoBook(book, this); }

}
class ConsLoBook implements ILoBook {
    Book first;
    ILoBook rest;

    ConsLoBook(Book first, ILoBook rest) {
        this.first = first;
        this.rest = rest;
    }

    // count the books in this list
    public int count() {
        return 1 + this.rest.count(); 
    }
 
    // produce a list of all books published before the given date
    // from this list of books 
    public ILoBook allBefore(int year) { 
        if (this.first.publishedBefore(year)) return new ConsLoBook(first, rest.allBefore(year));
        else return rest.allBefore(year);
    }
 
    // calculate the total sale price of all books in this list for a given discount
    public double salePrice(int discount) { 
        return this.first.salePrice(discount) + this.rest.salePrice(discount); 
    }
 
    // produce a list of all books in this list, sorted by their price
    public ILoBook sortByPrice() { 
        return this.rest.sortByPrice().insert(this.first); 
    }

    public ILoBook insert(Book book) {
        if (this.first.isCheaperThan(book)) 
            return new ConsLoBook(this.first, rest.insert(book));
        else 
            return new ConsLoBook(book, this);
    }

    public ILoBook sortByTitle() {
        return this.rest.sortByTitle().insertByTitle(this.first);
    }

    // produces a list with the given book in the right position based on it lexicographic order
    // ASSUME: the list is already sorted
    public ILoBook insertByTitle(Book book) {
        if (this.first.titleBefore(book)) 
            return new ConsLoBook(this.first, new ConsLoBook(book, this.rest));
        else
            return new ConsLoBook(book, this);
    }

}

class ExamplesBooks {
    //Books
    Book htdp = new Book("HtDP", "MF", 2001, 60);
    Book lpp = new Book("LPP", "STX", 1942, 25);
    Book ll = new Book("LL", "FF", 1986, 10);

    // lists of Books
    ILoBook mtlist = new MtLoBook();
    ILoBook lista = new ConsLoBook(this.lpp, this.mtlist);
    ILoBook listb = new ConsLoBook(this.htdp, this.mtlist);
    ILoBook listc = new ConsLoBook(this.lpp,
                    new ConsLoBook(this.ll, this.listb));
    ILoBook listd = new ConsLoBook(this.ll,
                      new ConsLoBook(this.lpp,
                        new ConsLoBook(this.htdp, this.mtlist)));
    ILoBook liste = new ConsLoBook(ll, mtlist);
    
    ILoBook listdUnsorted = new ConsLoBook(this.lpp, new ConsLoBook(this.htdp, new ConsLoBook(this.ll, this.mtlist)));

    ILoBook listdLexSort = new ConsLoBook(htdp, new ConsLoBook(ll, lista));

    boolean testPublishedBefore(Tester t) {
        return t.checkExpect(htdp.publishedBefore(2010), true) &&
               t.checkExpect(lpp.publishedBefore(1800), false);
    }

    // tests for the method count
    boolean testCount(Tester t) {
        return
        t.checkExpect(this.mtlist.count(), 0) &&
        t.checkExpect(this.lista.count(), 1) &&
        t.checkExpect(this.listd.count(), 3);
    }
   
    // tests for the method salePrice
    boolean testSalePrice(Tester t) {
        return
        // no discount -- full price
        t.checkInexact(this.mtlist.salePrice(0), 0.0, 0.001) &&
        t.checkInexact(this.lista.salePrice(0), 25.0, 0.001) &&
        t.checkInexact(this.listc.salePrice(0), 95.0, 0.001) &&
        t.checkInexact(this.listd.salePrice(0), 95.0, 0.001) &&
        // 50% off sale -- half price
        t.checkInexact(this.mtlist.salePrice(50), 0.0, 0.001) &&
        t.checkInexact(this.lista.salePrice(50), 12.5, 0.001) &&
        t.checkInexact(this.listc.salePrice(50), 47.5, 0.001) &&
        t.checkInexact(this.listd.salePrice(50), 47.5, 0.001);
    }
   
    // tests for the method allBefore
    boolean testAllBefore(Tester t) {
      return
      t.checkExpect(this.mtlist.allBefore(2001), this.mtlist) &&
      t.checkExpect(this.lista.allBefore(2001), this.lista) &&
      t.checkExpect(this.listb.allBefore(2001), this.mtlist) &&
      t.checkExpect(this.listc.allBefore(2001),
         new ConsLoBook(this.lpp, new ConsLoBook(this.ll, this.mtlist))) &&
      t.checkExpect(this.listd.allBefore(2001),
         new ConsLoBook(this.ll, new ConsLoBook(this.lpp, this.mtlist)));
    }
  
    // test the method sort for the lists of books
    boolean testSort(Tester t) {
        return
        t.checkExpect(this.listc.sortByPrice(), this.listd) &&
        t.checkExpect(this.listdUnsorted.sortByPrice(), this.listd);
    }

    boolean testSortByTitle(Tester t) {
        return t.checkExpect(mtlist.sortByTitle(), mtlist) &&
               t.checkExpect(lista.sortByTitle(), lista) &&
               t.checkExpect(listd.sortByTitle(), listdLexSort);
    }

    boolean testInsertByTitle(Tester t) {
        return t.checkExpect(mtlist.insertByTitle(htdp), new ConsLoBook(htdp, mtlist)) &&
               t.checkExpect(lista.insertByTitle(ll), new ConsLoBook(ll, lista)) &&
               t.checkExpect(lista.insertByTitle(htdp), new ConsLoBook(htdp, lista)) &&
               t.checkExpect(liste.insertByTitle(lpp), new ConsLoBook(ll, lista));
    }

    boolean testTitleBefore(Tester t) {
        return t.checkExpect(ll.titleBefore(lpp), true) &&
               t.checkExpect(ll.titleBefore(htdp), false);
    }
}