CREATE DATABASE HospitalIE_OLAP
GO

USE HospitalIE_OLAP

-- DIMENSION
CREATE TABLE MedicineDimension(
	MedicineCode INT PRIMARY KEY IDENTITY(1, 1),
	MedicineID INT,
	MedicineName VARCHAR(255),
	MedicineSellingPrice BIGINT,
	MedicineBuyingPrice BIGINT,
	MedicineExpiredDate DATE,
	ValidFrom DATE,
	ValidTo DATE
)

CREATE TABLE DoctorDimension(
	DoctorCode INT PRIMARY KEY IDENTITY(1, 1),
	DoctorID INT,
	DoctorName VARCHAR(255),
	DoctorDOB DATE,
	DoctorSalary BIGINT,
	DoctorAddress VARCHAR(255),
	ValidFrom DATE,
	ValidTo DATE
)

CREATE TABLE StaffDimension(
	StaffCode INT PRIMARY KEY IDENTITY(1, 1),
	StaffID INT,
	StaffName VARCHAR(255),
	StaffDOB DATE,
	StaffSalary BIGINT,
	StaffAddress VARCHAR(255),
	ValidFrom DATE,
	ValidTo DATE
)

CREATE TABLE CustomerDimension(
	CustomerCode INT PRIMARY KEY IDENTITY(1, 1),
	CustomerID INT,
	CustomerName VARCHAR(255),
	CustomerAddress VARCHAR(255),
	CustomerGender CHAR(1)
)

CREATE TABLE BenefitDimension(
	BenefitCode INT PRIMARY KEY IDENTITY(1, 1),
	BenefitID INT,
	BenefitName VARCHAR(255),
	BenefitPrice BIGINT,
	ValidFrom DATE,
	ValidTo DATE
)

CREATE TABLE TreatmentDimension(
	TreatmentCode INT PRIMARY KEY IDENTITY(1, 1),
	TreatmentID INT,
	TreatmentName VARCHAR(255),
	TreatmentPrice BIGINT,
	ValidFrom DATE,
	ValidTo DATE
)

CREATE TABLE DistributorDimension(
	DistributorCode INT PRIMARY KEY IDENTITY(1, 1),
	DistributorID INT,
	DistributorName VARCHAR(255),
	DistributorAddress VARCHAR(255),
	DistributorPhone VARCHAR(13)
)

CREATE TABLE TimeDimension(
	TimeCode INT PRIMARY KEY IDENTITY(1, 1),
	[Date] DATE,
	[Month] INT,
	[Quarter] INT,
	[Year] INT
)

-- FACT
CREATE TABLE SalesFact(
	TimeCode INT,
	MedicineCode INT,
	StaffCode INT,
	CustomerCode INT,
	[Total Sales Earning] BIGINT,
	[Total Medicine Sold] BIGINT
)

CREATE TABLE PurchaseFact(
	TimeCode INT,
	MedicineCode INT,
	StaffCode INT,
	DistributorCode INT,
	[Total Purchase Cost] BIGINT,
	[Total Medicine Purchased] BIGINT
)

CREATE TABLE SubscriptionFact(
	TimeCode INT,
	CustomerCode INT,
	StaffCode INT,
	BenefitCode INT,
	[Total Subscription Earning] BIGINT,
	[Subscriber Count] BIGINT
)

CREATE TABLE ServiceFact(
	TimeCode INT,
	CustomerCode INT,
	TreatmentCode INT,
	DoctorCode INT,
	[Total Service Earning] BIGINT,
	[Number Of Doctor] BIGINT
)

CREATE TABLE FilterTimeStamp(
	TableName VARCHAR(255),
	LastETL DATE
)

