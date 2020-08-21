---
layout: post
title:  "Work in Progress: Peas in a Book Pod"
date:   2020-08-04 11:16:59 -0700
categories: Projects
---

![a free sketch of my brainstorming process](../../../../img/landing_page.png)


## Background

Quarantine got me chasing after habbits, such as picking up reading again!

I found myself to be a small subset of people fortunate to be surrounded by books gathered over the years. But not so fortunate enough that I wanted to throw the so called "classics" out of my window. With the libraries closed during quarantine, I weigh between buying a new book or reading one on Overdrive (a library ebook app). I was faced with a dilemma:

I was raised to be conscious of subtle actions, such as physical book trading, that contribute to carbon footprint. Therefore, I didn't buy a new book. Since libraries are closed, I didn't find another physical book to read.

On the other hand, I like disconnecting for a quiet afternoon with a book I can carry in my hands, with no WiFi or blue light. Therefore, neither did I read an/ebook/audiobook.

Not only was I faced with this problem, I was distracted with a thought about joining a book club to make some new friends. It was around that time I saw some people started getting books for each other on instagram within my friend groups: 

> Buy me a book, share on social media as I did, and more people will buy you books!

This gave me idea to **utilize our existing network and  circulate our own books in an unconventional book club**.

![a free sketch of my brainstorming process](../../../../img/whiteboard_brainstorm.png)


## Problem Space

There're no shortage of readers who are happy to lend books to their friends and borrow from others to build a literate, tight-knit community. The challenges are that they are not only

> ...passionate about sharing - but also getting back - beloved books.

Many encountered hateful, inconsiderate, forgetful friends:
> In a few months, I could no longer find my books and then discovered in their families donation pile. How disrespectful!

Some people resort to the following solutions:

> Jean Jacobs wrote a curse to those who don't return her books. All books were returned.

To ensure that all parties are commited to respectful rules, maybe we should get all parties invested in **a giant book exchange**.

## Technical Problem: Design a system to circulate owned books between a collection of readers in a pod.

I decided to build a web app because a website has a wider reach than mobile apps, especially at its beginning with a small audience. I got inspiration from simply-designed web apps such as Kahoot, Tinder, and Uber. I kept in mind to implement only **one robust** main feature that characrizes this project before distracting myself with strectch goals. It also helps to keep the user interface clean and easy-to-follow.

### Front End
[prototype in progress](https://www.figma.com/proto/y1203BjQzYBTxTdXYUfkvM/Peas-in-a-Book-Pod?node-id=22%3A0&scaling=scale-down)

[figma wireframe](https://www.figma.com/file/y1203BjQzYBTxTdXYUfkvM/Peas-in-a-Book-Pod?node-id=0%3A1)

### Backend
I decided to use the Angular Framework because I recently learned it at a hackathon and look forward to exploring it further in building a web app. 
```
class Reader {
    String uid;
    String name;
    ArrayList<Book> book;
    int pagesReadPerDay;
    boolean reading;

    void createBook(title, author, ...);
    void read(Book book); // or finish a book
    void update(Book book);

    void joinPod();
    void leavePod();
    // stretch goal: adminPod()
}

class Book {
    String bookId;
    String ownerUid;
    boolean availability;

    String title;
    String Author;
    int pageCount;
    String Description;
    String genre;
    String purchaseLink;
}

class Pod {
    String podId; // join code
    HashMap<Person, Book> assignments;
    
    //keeping track of timeline? 

    /* 
    Brute Force: recursive backtracking to find best combination to reduce total wait time of everybody in the cycle of a pod. Stretch goal: once somebody finishes, somebody else can submit new book into the cycle.
    */

}

```
What I am working on right now is solving the problem of keeping track of the book assignments in a pod. In other words, I'm thinking about how I can design a pod class to circulate the books most efficiently.

#### For database design
Currently, I am looking into using Firestore to keep a database of the information outlined in the classes above. I 