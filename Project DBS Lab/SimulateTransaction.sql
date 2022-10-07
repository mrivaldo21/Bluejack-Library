USE BluejackLibrary

--1. Donator mendonasikan buku "Naruto" sejumlah 50 buku
BEGIN TRAN
INSERT INTO DonationTransaction VALUES
('DT016', 'SF003', 'DR002', '2021-06-05')

INSERT INTO DonationTransactionDetail VALUES
('DT016', 'BK001', 50)

UPDATE Book
SET BookStock = BookStock + 50
WHERE BookID = 'BK001'

--2 Murid meminjam buku "Laskar Pelangi" dan "Interstellar"
BEGIN TRAN
INSERT INTO BorrowTransaction VALUES
('BT016', 'ST005', 'SF002', '2021-06-06')

INSERT INTO BorrowTransactionDetail VALUES
('BT016', 'BK003', '2021-06-13'),
('BT016', 'BK006', '2021-06-13')

UPDATE Book
SET BookStock = BookStock - 1
WHERE BookID IN ('BK003', 'BK006')

--3 Murid meminjam buku "Jujutsu Kaisen"
BEGIN TRAN
INSERT INTO BorrowTransaction VALUES
('BT017', 'ST007', 'SF009', '2021-06-12')

INSERT INTO BorrowTransactionDetail VALUES
('BT017', 'BK005', '2021-06-19')

UPDATE Book
SET BookStock = BookStock - 1
WHERE BookID IN ('BK005')

--4 Donator mendonasikan buku "Your Lie in April"
BEGIN TRAN
INSERT INTO DonationTransaction VALUES
('DT017', 'SF009', 'DR003', '2021-06-12')

INSERT INTO DonationTransactionDetail VALUES
('DT017', 'BK002', 35)

UPDATE Book
SET BookStock = BookStock + 35
WHERE BookID = 'BK002'