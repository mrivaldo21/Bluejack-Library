CREATE DATABASE BluejackLibrary 

USE BluejackLibrary

CREATE TABLE [Staff](
    StaffID CHAR(5) PRIMARY KEY CHECK (StaffID LIKE 'SF[0-9][0-9][0-9]'),
    StaffName VARCHAR(50) NOT NULL, 
    StaffGender VARCHAR(8) NOT NULL CHECK (StaffGender IN ('Female','Male')),
    StaffAddress VARCHAR(50) NOT NULL, 
    StaffPhone VARCHAR(15) NOT NULL CHECK (StaffPhone LIKE '+62%'), 
    StaffSalary INT NOT NULL
)

CREATE TABLE [BookCategory](
    BookCategoryID CHAR(5) PRIMARY KEY CHECK (BookCategoryID LIKE 'BC[0-9][0-9][0-9]'),
    BookCategoryName VARCHAR(255) NOT NULL CHECK (BookCategoryName IN ('Fantasy','Mystery','Education','Romance','Sci-fi'))
)

CREATE TABLE [Student](
    StudentID CHAR(5) PRIMARY KEY CHECK (StudentID LIKE 'ST[0-9][0-9][0-9]'), 
    StudentName VARCHAR(255) NOT NULL, 
    StudentGender VARCHAR(10) NOT NULL CHECK (StudentGender IN ('Female','Male')),
    StudentAddress VARCHAR(255) NOT NULL, 
    StudentEmail VARCHAR(255) NOT NULL CHECK(StudentEmail LIKE '%@%')
)

CREATE TABLE [Donator](
    DonatorID CHAR(5) PRIMARY KEY CHECK (DonatorID LIKE 'DR[0-9][0-9][0-9]'),
    DonatorName VARCHAR(255) NOT NULL CHECK (len (DonatorName) > 1),
    DonatorGender VARCHAR(10) NOT NULL CHECK (DonatorGender IN ('Female','Male')),
    DonatorAddress VARCHAR(255) NOT NULL, 
    DonatorPhoneNumber VARCHAR(15) NOT NULL CHECK (DonatorPhoneNumber LIKE '+62%'),
)

CREATE TABLE [Book](
    BookID CHAR(5) PRIMARY KEY CHECK (BookID LIKE 'BK[0-9][0-9][0-9]'),
    BookCategoryID CHAR(5) FOREIGN KEY REFERENCES BookCategory(BookCategoryID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL, 
    BookTitle VARCHAR(255) NOT NULL, 
    PublishDate DATE NOT NULL CHECK (YEAR(PublishDate) > 2011),
    BookStock INT NOT NULL, 
    BookRating NUMERIC (2,1)
)

CREATE TABLE [DonationTransaction](
    DonationTransID CHAR(5) PRIMARY KEY CHECK (DonationTransID LIKE 'DT[0-9][0-9][0-9]'),
    StaffID CHAR(5) FOREIGN KEY REFERENCES Staff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    DonatorID CHAR(5) FOREIGN KEY REFERENCES Donator(DonatorID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    DonationDate DATE NOT NULL
)

CREATE TABLE [DonationTransactionDetail](
    DonationTransID CHAR(5) FOREIGN KEY REFERENCES DonationTransaction(DonationTransID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    BookID CHAR(5) FOREIGN KEY REFERENCES Book(BookID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    DonationQuantity INT NOT NULL CHECK (DonationQuantity BETWEEN 10 AND 500),

    PRIMARY KEY(DonationTransID,BookID)
)

CREATE TABLE [BorrowTransaction](
    BorrowTransID CHAR(5) PRIMARY KEY CHECK (BorrowTransID LIKE 'BT[0-9][0-9][0-9]'),
    StudentID CHAR(5) FOREIGN KEY REFERENCES Student(StudentID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    StaffID CHAR(5) FOREIGN KEY REFERENCES Staff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    BorrowDate DATE NOT NULL, 
	BorrowQuantity INT NOT NULL
)

CREATE TABLE [BorrowTransactionDetail](
    BorrowTransID CHAR(5) FOREIGN KEY REFERENCES BorrowTransaction(BorrowTransID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    BookID CHAR(5) FOREIGN KEY REFERENCES Book(BookID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    ReturnDate DATE NOT NULL,

    PRIMARY KEY(BorrowTransID,BookID)
)