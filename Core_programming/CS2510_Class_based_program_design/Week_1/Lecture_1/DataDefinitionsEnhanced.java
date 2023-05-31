import tester.Tester;
/**
 * HtDC Lectures
 * Lecture 2: Designing Simple Classes: Books and Authors
 * 
 * Copyright 2013 Viera K. Proulx
 * This program is distributed under the terms of the 
 * GNU Lesser General Public License (LGPL)
 * 
 * @since 29 August 2013
 */

// Exercise:
// Enhance the definitions of Book and Author above to include Publisher information. 
// A Publisher should have fields representing their name (that is a String), 
//                                             their country of operation (that is also a String),
//                                             and the year they opened for business (that is an int). 
// Should Books or Authors have Publishers? 
// Enhance the class diagram above to include your new inforamation.
// Define the new class. And enhance the ExamplesBooks class to include examples of the new data.

//*******************************************************************
// Enhancements
/*


            +---------------------+
            | Book                | 
            +---------------------+
            | String title        |
            | Author author       |--+
            | int price           |  |
         +--| Publisher publisher |  |
         |  +---------------------+  |
         v                           v
 +----------------+           +-------------+
 | Publisher      |           | Author      |
 +----------------+           +-------------+
 | String name    |           | String name |
 | String country |           | int yob     |
 | int yob        |           +-------------+
 +----------------+            

*/





// to represent a book in a bookstore
class Book{
  String title;
  Author author;
  int price;
  Publisher publisher;

  // the constructor
  Book(String title, Author author, int price, Publisher publisher){
    this.title = title;
    this.author = author;
    this.price = price;
    this.publisher = publisher;
  }
}

// to represent a author of a book in a bookstore
class Author{
  String name;
  int yob;

  // the constructor
  Author(String name, int yob){
    this.name = name;
    this.yob = yob;
  }
}

// to represent a Publisher 
class Publisher {
  String name;
  String country;
  int yob;

  //the constructor
  Publisher(String name, String country, int year) {
    this.name = name;
    this.country = country;
    this.yob = year;
  }
}

// examples and tests for the class hierarchy that represents 
// books and authors
class ExamplesBooks{
  ExamplesBooks(){}
  
  Author pat = new Author("Pat Conroy", 1948);
  Publisher doubleDay = new Publisher("Doubleday", "USA", 1897);
  Book beaches = new Book("Beaches", this.pat, 20, this.doubleDay);
}
