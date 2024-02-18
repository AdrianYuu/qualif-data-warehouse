USE HospitalIE_OLAP

-- Medicine Dimension
SELECT
	MedicineID,
	MedicineName,
	MedicineSellingPrice,
	MedicineBuyingPrice,
	MedicineExpiredDate
FROM OLTP_HospitalIE.dbo.MsMedicine

-- Doctor Dimension
SELECT 
	DoctorID,
	DoctorName,
	DoctorDOB,
	DoctorSalary,
	DoctorAddress
FROM OLTP_HospitalIE.dbo.MsDoctor

-- StaffDimension
SELECT
	StaffID,
	StaffName,
	StaffDOB,
	StaffSalary,
	StaffAddress
FROM OLTP_HospitalIE.dbo.MsStaff

-- CustomerDimension
SELECT
	CustomerID,
	CustomerName,
	CustomerAddress,
	CustomerGender
FROM OLTP_HospitalIE.dbo.MsCustomer
	
-- BenefitDimension
SELECT
	BenefitID,
	BenefitName,
	BenefitPrice
FROM OLTP_HospitalIE.dbo.MsBenefit

-- TreatmentDimension
SELECT
	TreatmentID,
	TreatmentName,
	TreatmentPrice
FROM OLTP_HospitalIE.dbo.MsTreatment

-- DistributorDimension
SELECT
	DistributorID,
	DistributorName,
	DistributorAddress,
	DistributorPhone
FROM OLTP_HospitalIE.dbo.MsDistributor

-- TimeDimension
IF EXISTS 
(
	SELECT * 
	FROM HospitalIE_OLAP.dbo.FilterTimeStamp
	WHERE TableName = 'TimeDimension'
)
BEGIN
	SELECT
		[Date] = X.[Date],
		[Month] = MONTH(X.[Date]),
		[Quarter] = DATEPART(QUARTER, X.[Date]),
		[Year] = YEAR(X.[Date])
	FROM(
		SELECT
			[Date] = ServiceDate
		FROM OLTP_HospitalIE.dbo.TrServiceHeader
		UNION
		SELECT
			[Date] = SubscriptionStartDate
		FROM OLTP_HospitalIE.dbo.TrSubscriptionHeader
		UNION
		SELECT
			[Date] = SalesDate
		FROM OLTP_HospitalIE.dbo.TrSalesHeader
		UNION
		SELECT
			[Date] = PurchaseDate
		FROM OLTP_HospitalIE.dbo.TrPurchaseHeader
	) AS X, HospitalIE_OLAP.dbo.FilterTimeStamp
	WHERE [Date] > LastETL AND TableName = 'TimeDimension'
END
ELSE
BEGIN
	SELECT
		[Date] = X.[Date],
		[Month] = MONTH(X.[Date]),
		[Quarter] = DATEPART(QUARTER, X.[Date]),
		[Year] = YEAR(X.[Date])
	FROM (
		SELECT
			[Date] = ServiceDate
		FROM OLTP_HospitalIE.dbo.TrServiceHeader
		UNION
		SELECT
			[Date] = SubscriptionStartDate
		FROM OLTP_HospitalIE.dbo.TrSubscriptionHeader
		UNION
		SELECT
			[Date] = SalesDate
		FROM OLTP_HospitalIE.dbo.TrSalesHeader
		UNION
		SELECT
			[Date] = PurchaseDate
		FROM OLTP_HospitalIE.dbo.TrPurchaseHeader
	) AS X
END

IF EXISTS 
(
	SELECT * FROM HospitalIE_OLAP.dbo.FilterTimeStamp
	WHERE TableName = 'TimeDimension'
)
BEGIN
	UPDATE HospitalIE_OLAP.dbo.FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName = 'TimeDimension'
END
ELSE
BEGIN
	INSERT INTO HospitalIE_OLAP.dbo.FilterTimeStamp VALUES('TimeDimension', GETDATE())
END

SELECT * FROM HospitalIE_OLAP.dbo.MedicineDimension
SELECT * FROM HospitalIE_OLAP.dbo.DoctorDimension
SELECT * FROM HospitalIE_OLAP.dbo.StaffDimension
SELECT * FROM HospitalIE_OLAP.dbo.CustomerDimension
SELECT * FROM HospitalIE_OLAP.dbo.BenefitDimension
SELECT * FROM HospitalIE_OLAP.dbo.TreatmentDimension
SELECT * FROM HospitalIE_OLAP.dbo.DistributorDimension
SELECT * FROM HospitalIE_OLAP.dbo.TimeDimension

SELECT * FROM HospitalIE_OLAP.dbo.FilterTimeStamp
