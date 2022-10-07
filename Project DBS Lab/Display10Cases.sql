USE BluejackLibrary

--1
SELECT [Student Name] = StudentName, 
[Student Address] = StudentAddress, 
[Borrow Transaction ID] = BorrowTransID, 
[Borrow Transaction Date] = BorrowDate, 
[Number of Book Borrowed] = BorrowQuantity
FROM Student ST
JOIN BorrowTransaction BT
ON ST.StudentID = BT.StudentID
WHERE YEAR(BorrowDate) = '2020' AND StudentAddress LIKE '%Street'

--2
SELECT 
[Book Title] = BK.BookTitle, 
[Publish Month]= MONTH(PublishDate), 
BookCategoryName,
[Total Donation Quantity] = SUM(DonationQuantity)
FROM DonationTransactionDetail DTD
JOIN Book BK 
ON BK.BookID = DTD.BookID
JOIN BookCategory BC
ON BC.BookCategoryID = BK.BookCategoryID
WHERE BookCategoryName LIKE '%y%' AND MONTH(PublishDate)%2 != 0
GROUP BY BK.BookTitle, BK.PublishDate, BC.BookCategoryName

--3.
SELECT [Borrow Transaction ID] = BT.BorrowTransID, 
[Borrow Transaction Date] = CONVERT(VARCHAR, BorrowDate, 106),
[Student Name] = StudentName,
[Book Borrowed Quantity] = BorrowQuantity,
[Average Book Rating] = AVG(BookRating)
FROM Book BK
JOIN BorrowTransactionDetail BTD
ON BTD.BookID = BK.BookID
JOIN BorrowTransaction BT
ON BT.BorrowTransID = BTD.BorrowTransID
JOIN Student ST
ON ST.StudentID = BT.StudentID
WHERE ST.StudentEmail LIKE '%gmail%'
GROUP BY BT.BorrowTransID, BT.BorrowDate, ST.StudentName, BT.BorrowQuantity
HAVING AVG(BookRating) > 4.0

--4.
SELECT [Donator Name] = 'Ms. ' + DonatorName,
[Donation Date] = CONVERT(VARCHAR, DonationDate, 107),
[Books Donated] = SUM(DonationQuantity),
[Average Rating] = AVG(BookRating)
FROM Book BK
JOIN DonationTransactionDetail DTD
ON BK.BookID = DTD.BookID
JOIN DonationTransaction DT
ON DT.DonationTransID = DTD.DonationTransID
JOIN Donator DN
ON DN.DonatorID = DT.DonatorID
WHERE DonatorGender = 'Female' AND DAY(DonationDate) BETWEEN 1 AND 14
GROUP BY DN.DonatorName, DT.DonationDate

--5
SELECT [Donator Name] = DonatorName, 
[Donation Date] = DonationDate,
[Staff Name] = StaffName, 
[Staff Gender] = StaffGender,
[Staff Salary] = 'Rp. ' + CAST(StaffSalary AS VARCHAR(255))
FROM Donator DN
JOIN DonationTransaction DT
ON DN.DonatorID = DT.DonatorID
JOIN Staff SF
ON DT.StaffID = SF.StaffID,
(SELECT AVG(StaffSalary) AS average FROM Staff) AS x
WHERE SF.StaffSalary > x.average AND DN.DonatorName LIKE '% %'
ORDER BY DonationDate DESC

--6
SELECT [Donation ID] = DT.DonationTransID,
[Book Title] = REPLACE(BookTitle, ' ', ''),
[Rating Percentage] = CAST(BookRating * 20 AS VARCHAR(255)) + '%',
[Quantity] = DonationQuantity,
[Donator Phone] = DonatorPhoneNumber
FROM Donator DN
JOIN DonationTransaction DT
ON DN.DonatorID = DT.DonatorID
JOIN DonationTransactionDetail DTD
ON DT.DonationTransID = DTD.DonationTransID
JOIN Book BK
ON DTD.BookID = BK.BookID,
(SELECT AVG(BookRating) AS average FROM Book) AS x
WHERE BK.BookRating > x.average AND LEN(DN.DonatorAddress) > 15 

--7
SELECT [Borrow Transaction ID] = BT.BorrowTransID,
[Borrow Date] = CONVERT(VARCHAR, BorrowDate, 105),
[Return Day] = DATENAME(WEEKDAY, ReturnDate),
[Book Title] = BookTitle,
[Book Rating] = CAST(BookRating AS VARCHAR(255)) + ' star(s)',
[Book Category Name] = BookCategoryName
FROM BorrowTransaction BT
JOIN BorrowTransactionDetail BTD
ON BT.BorrowTransID = BTD.BorrowTransID
JOIN Book BK
ON BTD.BookID = BK.BookID
JOIN BookCategory BC
ON BK.BookCategoryID = BC.BookCategoryID,
(SELECT MIN(BookRating) AS minimum, MAX(BookRating) AS maximum FROM Book) x
WHERE BK.BookRating IN (x.minimum, x.maximum) AND BK.BookStock > 10
ORDER BY BT.BorrowTransID DESC

--8
SELECT
CASE 
        WHEN StudentGender = 'Male' THEN 'Mr. ' + StudentName
END AS StudentName,
[Student Email] = REPLACE(StudentEmail, '.com', ''),
BooksBorrowed = SUM(BorrowQuantity)
FROM Student ST
JOIN BorrowTransaction BT
ON ST.StudentID = BT.StudentID
JOIN STAFF SF
ON BT.StaffID = SF.StaffID,
(SELECT AVG(StaffSalary) AS average FROM Staff) AS x
WHERE SF.StaffSalary > x.average AND ST.StudentGender = 'Male' 
GROUP BY StudentName, StudentGender, StudentEmail
UNION
SELECT
CASE 
        WHEN StudentGender = 'Female' THEN 'Ms. ' + StudentName
END AS StudentName,
[Student Email] = REPLACE(StudentEmail, '.com', ''),
BooksBorrowed = SUM(BorrowQuantity)
FROM Student ST
JOIN BorrowTransaction BT
ON ST.StudentID = BT.StudentID
JOIN STAFF SF
ON BT.StaffID = SF.StaffID,
(SELECT AVG(StaffSalary) AS average FROM Staff) AS x
WHERE SF.StaffSalary < x.average AND ST.StudentGender = 'Female'
GROUP BY StudentName, StudentGender, StudentEmail

--9
GO
CREATE VIEW ViewDonationDetail 
AS
SELECT DISTINCT
 [Donator Name] = DonatorName, 
 [Donator Transaction] = COUNT(dt.DonationTransID),
 [Average Quantity] = AVG(dtd.DonationQuantity)
FROM Donator DN
JOIN DonationTransaction DT
ON DN.DonatorID = DT.DonatorID
JOIN DonationTransactionDetail DTD
ON DTD.DonationTransID = DT.DonationTransID
WHERE DonatorAddress LIKE ('%Avenue') OR DonatorAddress LIKE('%Street')
GROUP BY DN.DonatorName, DN.DonatorAddress
HAVING COUNT(DT.DonationTransId) > 1

--10
CREATE VIEW ViewStudentBorrowingData 
AS
SELECT DISTINCT
 [Student Name] = st.StudentName, 
 [Borrow Transaction] = COUNT(DISTINCT(bt.BorrowTransID)),
 [Average Duration] = AVG(DISTINCT(DATEDIFF(DAY, bt.BorrowDate, btd.ReturnDate)))
FROM Student st
JOIN BorrowTransaction bt ON st.StudentID = bt.StudentID
JOIN BorrowTransactionDetail btd ON bt.BorrowTransID = btd.BorrowTransID
WHERE st.StudentGender LIKE ('Male') AND st.StudentEmail LIKE ('%yahoo%')
GROUP BY st.StudentName

SELECT * 
FROM ViewStudentBorrowingData