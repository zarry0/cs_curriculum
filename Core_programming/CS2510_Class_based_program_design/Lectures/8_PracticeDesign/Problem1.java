import tester.Tester;

/* Problem 1
 * Suppose you are working on a research paper, and you have gathered a set of documents together
 * for your bibliography: books and Wikipedia articles. 
 * Every document has an author, a title, and a bibliography of documents; 
 * additionally, books have publishers, and wiki articles have URLs.
 * 
 *     -  Since you know that wiki articles are not necessarily authoritative sources[citation needed], 
 *        you want to produce a bibliography containing just the authors and titles of the books you’ve found, 
 *        either directly or transitively through the bibliographies of other documents.
 *        Format the entries as “Last name, First name. "Title".”
 * 
 *     -  Since bibliographies must be alphabetized, sort the bibliography by the authors’ last names.
 * 
 *     -  Documents may be referenced more than once, but should only appear in the bibliography once. 
 *        Remove any duplicates (defined as the same author name and the same title)
 * 
 */

/* Class diagram
 * 
                      +--------+
                      |  IBib  |<-----------------------+
                      +--------+                        |
                      +--------+                        |
                          |                             |
                         / \                            |
                         ---                            |
                          |                             |
            +----------------------------+              |
            |                            |              |
   +-------------------+       +-------------------+    |
   |       Book        |       |       Wiki        |    |
   +-------------------+       +-------------------+    |
   | Author author     +--+ +--+ Author author     |    |
   | String title      |  | |  | String title      |    |
 +-+ ILoBib references |  | |  | ILoBib references +-+  |
 | | String publisher  |  | |  | String url        | |  |
 | +-------------------+  | |  +-------------------+ |  |
 | +-------------------+  | |  +-------------------+ |  |
 |                        v v                        |  |
 |                +------------------+               |  |
 |                |     Author       |               |  |
 |                +------------------+               |  |
 |                | String firstName |               |  |
 |                | String lastName  |               |  |
 |                +------------------+               |  |
 |                +------------------+               |  |
 |                                                   |  |
 +-------------------------+  +----------------------+  |
                           |  |                         |
                           v  v                         |
                        +--------+                      |
                        | ILoBib |                      |
                        +--------+                      |
                        +--------+                      |
                            |                           |
                           / \                          |
                           ---                          |
                            |                           |
                     +-------------+                    |
                     |             |                    |
                +---------+  +-------------+            |
                | MtLoBib |  |  ConsLoBib  |            |
                +---------+  +-------------+            |
                +---------+  | IBib first  +------------+
                             | ILoBib rest |
                             +-------------+
                             +-------------+

 */

interface IBib {
    // produces a bibliography with just the info from books either directly or transitively
    // sorted by the authors last name, where each entry has the format: "Last name, First name, 'Title'"
    ILoString getBibliography();

    // produces a list of all the book references (either directly or transitively)
    ILoBib getBookReferences();

    // produces true if this is bigger than that
    // bigger means that this comes after that alphabetically based on the authors last name
    boolean isBiggerThan(IBib that);
    // produces true if this last name is smaller than or equal to that last name
    public boolean isSmallerThanOrEq(Author that);

    // produces true if this is equal than that
    // two docs are equal if they're the same type, their author names are equal and their name is equal
    boolean isEqual(IBib that);
    // produces true if this and that are both books with the same title and author
    boolean compareBooks(Book that);
    // produces true if this and that are both wikis with the same title and author
    boolean compareWikis(Wiki that);

    // produces a String with the contents of this IBib with the format "Last name, First name. 'Title'"
    String format();
}

class Book implements IBib {
    Author author;
    String title;
    ILoBib references;
    String publisher;

    public Book(Author author, String title, ILoBib references, String publisher) {
        this.author = author;
        this.title = title;
        this.references = references;
        this.publisher = publisher;
    }

    // produces a bibliography with just the info from books either directly or transitively
    // sorted by the authors last name, where each entry has the format: "Last name, First name, Title"
    public ILoString getBibliography() {
        return this.getBookReferences().sortByLastName().filterDuplicates().format();
    }
    // produces a list of all the book references (either directly or transitively)
    public ILoBib getBookReferences() {
        return new ConsLoBib(this, this.references.getBookReferences());
    }

    // produces true if this is bigger than that
    // bigger means that this comes after that alphabetically based on the authors last name
    public boolean isBiggerThan(IBib that) {
        return that.isSmallerThanOrEq(this.author);
    }
    // produces true if this last name is smaller than or equal to that last name
    public boolean isSmallerThanOrEq(Author that) {
        return this.author.lastNameIsSmallerThanOrEqual(that);
    }

    // produces true if this is equal than that
    // two docs are equal if they're the same type, their author names are equal and their name is equal
    public boolean isEqual(IBib that) {
        return that.compareBooks(this);
    }
    //produces true if this and that are books with the same title and author
    public boolean compareBooks(Book thatBook) {
        return thatBook.isSameBook(this.title, this.author);
    }
    // produces true if this.author and this.title is the same as the given values
    private boolean isSameBook(String title, Author author) {
        return this.title.compareTo(title) == 0 && this.author.isSameAuthor(author);
    }
    // produces true if this and that are both wikis with the same title and author
    public boolean compareWikis(Wiki that) {
        return false;
    }

    // produces a String with the contents of this IBib with the format  "Last name, First name. 'Title'"
    public String format() {
        return String.format("%s. '%s'", this.author.getNameString(), this.title);
    }
}

class Wiki implements IBib {
    Author author;
    String title;
    ILoBib references;
    String url;

    public Wiki(Author author, String title, ILoBib references, String url) {
        this.author = author;
        this.title = title;
        this.references = references;
        this.url = url;
    }

    // produces a bibliography with just the info from books either directly or transitively
    // sorted by the authors last name, where each entry has the format: "Last name, First name, Title"
    public ILoString getBibliography() {
        return this.getBookReferences().sortByLastName().filterDuplicates().format();
    }
    // produces a list of all the book references (either directly or transitively)
    public ILoBib getBookReferences() {
        return this.references.getBookReferences();
    }

    // produces true if this is bigger than that
    // bigger means that this comes after that alphabetically based on the authors last name
    public boolean isBiggerThan(IBib that) {
        return that.isSmallerThanOrEq(this.author);
    }
    // produces true if this last name is smaller than or equal to that last name
    public boolean isSmallerThanOrEq(Author that) {
        return this.author.lastNameIsSmallerThanOrEqual(that);
    }

    // produces true if this is equal than that
    // two docs are equal if they're the same type, their author names are equal and their name is equal
    public boolean isEqual(IBib that) {
        return that.compareWikis(this);
    }
    //produces false because this is a wiki and that a  book
    public boolean compareBooks(Book thatBook) {
        return false;
    }
    // produces true if this and that are both wikis with the same title and author
    public boolean compareWikis(Wiki that) {
        return that.isSameWiki(this.title, this.author);
    }
    // produces true if this.author and this.title is the same as the given values
    private boolean isSameWiki(String title, Author author) {
        return this.title.compareTo(title) == 0 && this.author.isSameAuthor(author);
    }

    // produces a String with the contents of this IBib with the format  "Last name, First name. 'Title'"
    public String format() {
        return String.format("%s. '%s'", this.author.getNameString(), this.title);
    }
}

class ExamplesIBib {

    ExamplesAuthor authors = new ExamplesAuthor();

    ILoBib mtlist = new MtLoBib();
    IBib htdp     = new Book(authors.matt,"HtDP", this.mtlist, "NEU");
    ILoBib mdRef = new ConsLoBib(this.htdp, this.mtlist);
    IBib mobyDick = new Book(authors.herman, "Moby Dick",this.mdRef,  "MIT");
    ILoBib sapRef = new ConsLoBib(this.htdp, new ConsLoBib(this.mobyDick, this.mtlist));
    IBib sapiens  = new Book(authors.yuval, "Sapiens", this.sapRef, "MIT");
    IBib sherlock = new Book(authors.doyle, "Sherlock Holmes", this.mtlist, "MIT");

    ILoBib w1Ref = new ConsLoBib(this.mobyDick, new ConsLoBib(this.sherlock, this.mtlist));
    IBib wiki1 = new Wiki(authors.appleseed, "Clasic Books", this.w1Ref,  "http://...");
    ILoBib w2Ref = new ConsLoBib(this.sapiens, this.mtlist);
    IBib wiki2 = new Wiki(authors.janeDoe,   "Evolution",    this.w2Ref,  "http://...");
    ILoBib w3Ref = new ConsLoBib(this.sapiens, new ConsLoBib(this.sapiens, new ConsLoBib(this.wiki2, this.mtlist)));
    IBib wiki3 = new Wiki(authors.zill, "Science", this.w3Ref,  "http://...");
    IBib wiki4 = new Wiki(authors.zill, "Some article", this.mtlist, "http://...");

    ILoBib csRef = new ConsLoBib(this.htdp, new ConsLoBib(this.wiki3, new ConsLoBib(this.wiki1, this.mtlist)));
    IBib cs = new Book(authors.johnDoe, "CS Fundamentals", this.csRef, "Harvard");

    boolean testGetBibliography(Tester t) {
        return  t.checkExpect(this.htdp.getBibliography(), new ConsLoString("Felleisen, Matthias. 'HtDP'", new MtLoString())) &&
                t.checkExpect(this.mobyDick.getBibliography(), new ConsLoString("Felleisen, Matthias. 'HtDP'", 
                                                                    new ConsLoString("Melville, Herman. 'Moby Dick'", new MtLoString()))) &&
                t.checkExpect(this.wiki1.getBibliography(), new ConsLoString("Doyle, Arthur. 'Sherlock Holmes'", 
                                                                new ConsLoString("Felleisen, Matthias. 'HtDP'", 
                                                                    new ConsLoString("Melville, Herman. 'Moby Dick'", new MtLoString())))) &&
                t.checkExpect(this.cs.getBibliography(), new ConsLoString("Doe, John. 'CS Fundamentals'",
                                                            new ConsLoString("Doyle, Arthur. 'Sherlock Holmes'", 
                                                                new ConsLoString("Felleisen, Matthias. 'HtDP'", 
                                                                    new ConsLoString("Harari, Yuval. 'Sapiens'",
                                                                        new ConsLoString("Melville, Herman. 'Moby Dick'",
                                                                            new MtLoString())))))) &&
                t.checkExpect(this.wiki4.getBibliography(), new MtLoString());

    }

    boolean testGetBookReferences(Tester t) {
        return  t.checkExpect(this.htdp.getBookReferences(), new ConsLoBib(this.htdp, new MtLoBib())) && 
                t.checkExpect(this.mobyDick.getBookReferences(), new ConsLoBib(this.mobyDick, new ConsLoBib(this.htdp, new MtLoBib()))) &&
                t.checkExpect(this.sapiens.getBookReferences(), new ConsLoBib(this.sapiens, 
                                                                new ConsLoBib(this.htdp,
                                                                    new ConsLoBib(this.mobyDick,
                                                                        new ConsLoBib(this.htdp, new MtLoBib()))))) &&
                t.checkExpect(this.wiki1.getBookReferences(), new ConsLoBib(this.mobyDick,
                                                                new ConsLoBib(this.htdp, 
                                                                    new ConsLoBib(this.sherlock, new MtLoBib())))) &&
                t.checkExpect(this.wiki3.getBookReferences(), new ConsLoBib(this.sapiens,
                                                                new ConsLoBib(this.htdp, 
                                                                    new ConsLoBib(this.mobyDick, 
                                                                        new ConsLoBib(this.htdp, 
                                                              new ConsLoBib(this.sapiens,
                                                                new ConsLoBib(this.htdp, 
                                                                    new ConsLoBib(this.mobyDick, 
                                                                        new ConsLoBib(this.htdp,
                                                              new ConsLoBib(this.sapiens,
                                                                new ConsLoBib(this.htdp, 
                                                                    new ConsLoBib(this.mobyDick, 
                                                                        new ConsLoBib(this.htdp, new MtLoBib()))))))))))))) &&
                t.checkExpect(this.wiki4.getBookReferences(), new MtLoBib());
    }

    boolean testIsBiggerThan(Tester t) {
        return  t.checkExpect(this.htdp.isBiggerThan(this.htdp), false) &&
                t.checkExpect(this.htdp.isBiggerThan(this.sherlock), true) &&
                t.checkExpect(this.htdp.isBiggerThan(this.sapiens), false) &&

                t.checkExpect(this.htdp.isBiggerThan(this.wiki1), true) &&
                t.checkExpect(this.htdp.isBiggerThan(this.wiki3), false) &&
                t.checkExpect(this.cs.isBiggerThan(this.wiki2), false) &&

                t.checkExpect(this.wiki1.isBiggerThan(this.wiki3), false) &&
                t.checkExpect(this.wiki3.isBiggerThan(this.wiki1), true) &&
                t.checkExpect(this.wiki2.isBiggerThan(this.wiki2), false);
    }

    boolean testisEqual(Tester t) {
        return  t.checkExpect(this.htdp.isEqual(this.htdp), true) &&
                t.checkExpect(this.htdp.isEqual(this.sapiens), false) &&
                t.checkExpect(this.wiki1.isEqual(this.wiki1), true) &&
                t.checkExpect(this.wiki1.isEqual(this.wiki2), false) &&
                t.checkExpect(this.htdp.isEqual(this.wiki2), false) &&
                t.checkExpect(this.wiki1.isEqual(this.sherlock), false);
    }
}

class Author {
    String firstName;
    String lastName;

    public Author(String firstName, String lastName) {
        this.firstName = firstName;
        this.lastName = lastName;
    }

    // produces true if this last name is smaller than or equal to that last name
    public boolean lastNameIsSmallerThanOrEqual(Author that) {
        return that.lastNameIsBiggerThan(this.lastName);
    }

    // produces true if this last name is bigger than the given string
    private boolean lastNameIsBiggerThan(String str) {
        return this.lastName.compareTo(str) > 0;
    }

    // produces true if this is equal to that
    // equals means that have the same name and last name
    public boolean isSameAuthor(Author that) {
        return that.isSamePerson(this.firstName, this.lastName); 
    }
    // produces true if this.firstName and this.lastName are the same as the given values
    private boolean isSamePerson(String thatFirst, String thatLast) {
        return thatFirst.compareTo(this.firstName) == 0 && thatLast.compareTo(this.lastName) == 0;
    }

    // produces a string with the name of this in the format: lasName, firstName
    public String getNameString() {
        return String.format("%s, %s", this.lastName, this.firstName);
    }
 }

 class ExamplesAuthor {
    Author matt = new Author("Matthias", "Felleisen");
    Author herman = new Author("Herman", "Melville");
    Author yuval = new Author("Yuval", "Harari");
    Author doyle = new Author("Arthur", "Doyle");

    Author johnDoe = new Author("John", "Doe");
    Author janeDoe = new Author("Jane", "Doe");
    Author zill = new Author("William", "Zill");
    Author appleseed = new Author("John", "Appleseed");
}

interface ILoBib {
    // produces a new list with the given list appended to the end of this
    ILoBib appendILoBib(ILoBib lst);

    // produces a list of all the book references (directly or trasitively) in this list
    ILoBib getBookReferences();

    // sorts this by each author's last name
    ILoBib sortByLastName();
    // inserts the given IBib into this in the right position
    // ASSUME: this is already sorted
    ILoBib insert(IBib prev);

    // produces a new ILoBib with only the unique elements in this
    ILoBib filterDuplicates();
    // produces true if this.first is the same as thatFirst
    boolean hasSameFirst(IBib thatFirst);

    // produces a ListOfString in which each element is a strign with the title and authors information
    ILoString format();
 }
class MtLoBib implements ILoBib {
    // produces a new list with the given list appended to the end of this
    public ILoBib appendILoBib(ILoBib lst) {
        return lst;
    }

    // produces a list of all the book references (directly or trasitively) in this list
    public ILoBib getBookReferences() {
        return new MtLoBib();
    }

    // sorts this by each author's last name
    public ILoBib sortByLastName() {
        return new MtLoBib();
    }
    // inserts the given IBib into this in the right position
    // ASSUME: this is already sorted
    public ILoBib insert(IBib prev) {
        return new ConsLoBib(prev, new MtLoBib());
    }

    // produces a new ILoBib with only the unique elements in this
    public ILoBib filterDuplicates() {
        return new MtLoBib();
    }
    // produces true if this.first is the same as thatFirst
    public boolean hasSameFirst(IBib thatFirst) {
        return false;
    }

    // produces a ListOfString in which each element is a strign with the title and authors information
    public ILoString format() {
        return new MtLoString();
    }
}
class ConsLoBib implements ILoBib { 
    IBib first;
    ILoBib rest;
    
    public ConsLoBib(IBib first, ILoBib rest) {
        this.first = first;
        this.rest = rest;
    }

    // produces a new list with the given list appended to the end of this
    public ILoBib appendILoBib(ILoBib lst) {
        return new ConsLoBib(this.first, this.rest.appendILoBib(lst));
    }

    // produces a list of all the book references (directly or trasitively) in this list
    public ILoBib getBookReferences() {
        return this.first.getBookReferences().appendILoBib(this.rest.getBookReferences());
    }
    // sorts this by each author's last name
    public ILoBib sortByLastName() {
        return this.rest.sortByLastName().insert(this.first);
    }
    // inserts the given IBib into this in the right position
    // ASSUME: this is already sorted
    public ILoBib insert(IBib prev) {
        // if the second is bigger than the first
        if (this.first.isBiggerThan(prev)) return new ConsLoBib(prev, this);
        return new ConsLoBib(this.first, this.rest.insert(prev));
    }

    // produces a new ILoBib with only the unique elements in this
    // ASSUME: the list is sorted by the authors last name
    public ILoBib filterDuplicates() {
        if (this.rest.hasSameFirst(this.first)) return this.rest.filterDuplicates();
        return new ConsLoBib(this.first, this.rest.filterDuplicates());
    }
    // produces true if this.first is the same as thatFirst
    public boolean hasSameFirst(IBib thatFirst) {
        return this.first.isEqual(thatFirst);
    }

    // produces a ListOfString in which each element is a string with the title and authors information
    public ILoString format() {
        return new ConsLoString(this.first.format(), this.rest.format());
    }
}

class ExamplesILoBib {
    public ExamplesILoBib() {}

    ExamplesIBib docs = new ExamplesIBib();

    boolean testGetBookReferences(Tester t) {
        return  t.checkExpect(docs.mtlist.getBookReferences(), docs.mtlist) &&
                t.checkExpect(docs.mdRef.getBookReferences(), docs.mdRef) &&
                t.checkExpect(docs.sapRef.getBookReferences(), new ConsLoBib(docs.htdp, new ConsLoBib(docs.mobyDick, docs.mdRef))) &&
                t.checkExpect(docs.w1Ref.getBookReferences(), new ConsLoBib(docs.mobyDick, 
                                                                new ConsLoBib(docs.htdp, 
                                                                    new ConsLoBib(docs.sherlock, docs.mtlist)))) &&
                t.checkExpect(docs.w2Ref.getBookReferences(), new ConsLoBib(docs.sapiens, 
                                                                new ConsLoBib(docs.htdp, 
                                                                    new ConsLoBib(docs.mobyDick,
                                                                        new ConsLoBib(docs.htdp, docs.mtlist))))) &&
                t.checkExpect(docs.w3Ref.getBookReferences(), new ConsLoBib(docs.sapiens, 
                                                                new ConsLoBib(docs.htdp, 
                                                                    new ConsLoBib(docs.mobyDick, 
                                                                        new ConsLoBib(docs.htdp,
                                                             new ConsLoBib(docs.sapiens, 
                                                                new ConsLoBib(docs.htdp, 
                                                                    new ConsLoBib(docs.mobyDick, 
                                                                        new ConsLoBib(docs.htdp,
                                                             new ConsLoBib(docs.sapiens, 
                                                                new ConsLoBib(docs.htdp, 
                                                                    new ConsLoBib(docs.mobyDick, 
                                                                        new ConsLoBib(docs.htdp, docs.mtlist)))))))))))));
    }

    boolean testSortByLastName(Tester t) {
        return  t.checkExpect(docs.mtlist.sortByLastName(), docs.mtlist) &&
                t.checkExpect(docs.mdRef.sortByLastName(), docs.mdRef) &&
                t.checkExpect(docs.sapRef.sortByLastName(), docs.sapRef) &&
                t.checkExpect(docs.w1Ref.sortByLastName(), new ConsLoBib(docs.sherlock, new ConsLoBib(docs.mobyDick, docs.mtlist))) &&
                t.checkExpect(docs.w3Ref.sortByLastName(), new ConsLoBib(docs.wiki2, new ConsLoBib(docs.sapiens, new ConsLoBib(docs.sapiens, docs.mtlist))));
    }

    boolean testFilterDuplicates(Tester t) {
        return  t.checkExpect(docs.mtlist.filterDuplicates(), new MtLoBib()) &&
                t.checkExpect(docs.mdRef.filterDuplicates(), docs.mdRef) &&
                t.checkExpect(docs.sapRef.filterDuplicates(), docs.sapRef) &&
                t.checkExpect(docs.w3Ref.sortByLastName().filterDuplicates(),  new ConsLoBib(docs.wiki2, new ConsLoBib(docs.sapiens, docs.mtlist)));
    }

    boolean testFormat(Tester t) {
        return  t.checkExpect(docs.mtlist.format(), new MtLoString()) &&
                t.checkExpect(docs.mdRef.format(), new ConsLoString("Felleisen, Matthias. 'HtDP'", new MtLoString())) &&
                t.checkExpect(docs.sapRef.format(), new ConsLoString("Felleisen, Matthias. 'HtDP'", 
                                                        new ConsLoString( "Melville, Herman. 'Moby Dick'",new MtLoString())));
    }
}

// Auxiliary definition
interface ILoString { }
class MtLoString implements ILoString { }
class ConsLoString implements ILoString { 
    String first;
    ILoString rest;

    public ConsLoString(String first, ILoString rest) {
        this.first = first;
        this.rest = rest;
    }
}






