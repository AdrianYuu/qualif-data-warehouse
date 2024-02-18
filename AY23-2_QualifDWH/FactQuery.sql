-- SalesFact
IF EXISTS 
(
	SELECT * FROM HospitalIE_OLAP.dbo.FilterTimeStamp
	WHERE TableName = 'SalesFact'
)
BEGIN
	SELECT 
		TimeCode,
		MedicineCode,
		StaffCode,
		CustomerCode,
		[Total Sales Earning] = SUM(Quantity * MedicineSellingPrice),
		[Total Medicine Sold] = SUM(Quantity)
	FROM OLTP_HospitalIE.dbo.TrSalesHeader tsh
	JOIN OLTP_HospitalIE.dbo.TrSalesDetail tsd ON tsh.SalesID = tsd.SalesID
	JOIN HospitalIE_OLAP.dbo.TimeDimension td ON tsh.SalesDate = td.Date
	JOIN HospitalIE_OLAP.dbo.MedicineDimension md ON tsd.MedicineID = md.MedicineID
	JOIN HospitalIE_OLAP.dbo.StaffDimension sd ON tsh.StaffID = sd.StaffID
	JOIN HospitalIE_OLAP.dbo.CustomerDimension cd ON tsh.CustomerID = cd.CustomerID
	WHERE
		tsh.SalesDate > (
							SELECT LastETL
							FROM HospitalIE_OLAP.dbo.FilterTimeStamp
							WHERE TableName = 'SalesFact'
						 )
	GROUP BY TimeCode, MedicineCode, StaffCode, CustomerCode
END
ELSE
BEGIN
	SELECT 
		TimeCode,
		MedicineCode,
		StaffCode,
		CustomerCode,
		[Total Sales Earning] = SUM(Quantity * MedicineSellingPrice),
		[Total Medicine Sold] = SUM(Quantity)
	FROM OLTP_HospitalIE.dbo.TrSalesHeader tsh
	JOIN OLTP_HospitalIE.dbo.TrSalesDetail tsd ON tsh.SalesID = tsd.SalesID
	JOIN HospitalIE_OLAP.dbo.TimeDimension td ON tsh.SalesDate = td.Date
	JOIN HospitalIE_OLAP.dbo.MedicineDimension md ON tsd.MedicineID = md.MedicineID
	JOIN HospitalIE_OLAP.dbo.StaffDimension sd ON tsh.StaffID = sd.StaffID
	JOIN HospitalIE_OLAP.dbo.CustomerDimension cd ON tsh.CustomerID = cd.CustomerID
	GROUP BY TimeCode, MedicineCode, StaffCode, CustomerCode
END

IF EXISTS 
(
	SELECT * FROM HospitalIE_OLAP.dbo.FilterTimeStamp
	WHERE TableName = 'SalesFact'
)
BEGIN
	UPDATE HospitalIE_OLAP.dbo.FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName = 'SalesFact'
END
ELSE
BEGIN
	INSERT INTO HospitalIE_OLAP.dbo.FilterTimeStamp VALUES('SalesFact', GETDATE())
END


-- PurchaseFact
IF EXISTS 
(
	SELECT * FROM HospitalIE_OLAP.dbo.FilterTimeStamp
	WHERE TableName = 'PurchaseFact'
)
BEGIN
	SELECT 
		TimeCode,
		MedicineCode,
		StaffCode,
		DistributorCode,
		[Total Purchase Cost] = SUM(Quantity * MedicineBuyingPrice),
		[Total Medicine Purchased] = SUM(Quantity)
	FROM OLTP_HospitalIE.dbo.TrPurchaseHeader tph
	JOIN OLTP_HospitalIE.dbo.TrPurchaseDetail tpd ON tph.PurchaseID = tpd.PurchaseID
	JOIN HospitalIE_OLAP.dbo.TimeDimension td ON tph.PurchaseDate = td.Date
	JOIN HospitalIE_OLAP.dbo.MedicineDimension md ON tpd.MedicineID = md.MedicineID
	JOIN HospitalIE_OLAP.dbo.StaffDimension sd ON tph.StaffID = sd.StaffID
	JOIN HospitalIE_OLAP.dbo.DistributorDimension dd ON tph.DistributorID = dd.DistributorID
	WHERE
		tph.PurchaseDate > (
							SELECT LastETL
							FROM HospitalIE_OLAP.dbo.FilterTimeStamp
							WHERE TableName = 'PurchaseFact'
						 )
	GROUP BY TimeCode, MedicineCode, StaffCode, DistributorCode
END
ELSE
BEGIN
	SELECT 
		TimeCode,
		MedicineCode,
		StaffCode,
		DistributorCode,
		[Total Purchase Cost] = SUM(Quantity * MedicineBuyingPrice),
		[Total Medicine Purchased] = SUM(Quantity)
	FROM OLTP_HospitalIE.dbo.TrPurchaseHeader tph
	JOIN OLTP_HospitalIE.dbo.TrPurchaseDetail tpd ON tph.PurchaseID = tpd.PurchaseID
	JOIN HospitalIE_OLAP.dbo.TimeDimension td ON tph.PurchaseDate = td.Date
	JOIN HospitalIE_OLAP.dbo.MedicineDimension md ON tpd.MedicineID = md.MedicineID
	JOIN HospitalIE_OLAP.dbo.StaffDimension sd ON tph.StaffID = sd.StaffID
	JOIN HospitalIE_OLAP.dbo.DistributorDimension dd ON tph.DistributorID = dd.DistributorID
	GROUP BY TimeCode, MedicineCode, StaffCode, DistributorCode
END

IF EXISTS 
(
	SELECT * FROM HospitalIE_OLAP.dbo.FilterTimeStamp
	WHERE TableName = 'PurchaseFact'
)
BEGIN
	UPDATE HospitalIE_OLAP.dbo.FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName = 'PurchaseFact'
END
ELSE
BEGIN
	INSERT INTO HospitalIE_OLAP.dbo.FilterTimeStamp VALUES('PurchaseFact', GETDATE())
END


-- SubscriptionFact
IF EXISTS 
(
	SELECT * FROM HospitalIE_OLAP.dbo.FilterTimeStamp
	WHERE TableName = 'SubscriptionFact'
)
BEGIN
	SELECT 
		TimeCode,
		CustomerCode,
		StaffCode,
		BenefitCode,
		[Total Subscription Earning] = SUM(BenefitPrice),
		[Subscriber Count] = SUM(tsh.SubscriptionID)
	FROM OLTP_HospitalIE.dbo.TrSubscriptionHeader tsh
	JOIN OLTP_HospitalIE.dbo.TrSubscriptionDetail tsd ON tsh.SubscriptionID = tsd.SubscriptionID 
	JOIN HospitalIE_OLAP.dbo.TimeDimension td ON tsh.SubscriptionStartDate = td.Date
	JOIN HospitalIE_OLAP.dbo.CustomerDimension cd ON tsh.CustomerID = cd.CustomerID
	JOIN HospitalIE_OLAP.dbo.StaffDimension sd ON tsh.StaffID = sd.StaffID
	JOIN HospitalIE_OLAP.dbo.BenefitDimension bd ON tsd.BenefitID = bd.BenefitID
	WHERE
		tsh.SubscriptionStartDate > (
							SELECT LastETL
							FROM HospitalIE_OLAP.dbo.FilterTimeStamp
							WHERE TableName = 'SubscriptionFact'
						 )
	GROUP BY TimeCode, CustomerCode, StaffCode, BenefitCode
END
ELSE
BEGIN
	SELECT 
		TimeCode,
		CustomerCode,
		StaffCode,
		BenefitCode,
		[Total Subscription Earning] = SUM(BenefitPrice),
		[Subscriber Count] = SUM(tsh.SubscriptionID)
	FROM OLTP_HospitalIE.dbo.TrSubscriptionHeader tsh
	JOIN OLTP_HospitalIE.dbo.TrSubscriptionDetail tsd ON tsh.SubscriptionID = tsd.SubscriptionID 
	JOIN HospitalIE_OLAP.dbo.TimeDimension td ON tsh.SubscriptionStartDate = td.Date
	JOIN HospitalIE_OLAP.dbo.CustomerDimension cd ON tsh.CustomerID = cd.CustomerID
	JOIN HospitalIE_OLAP.dbo.StaffDimension sd ON tsh.StaffID = sd.StaffID
	JOIN HospitalIE_OLAP.dbo.BenefitDimension bd ON tsd.BenefitID = bd.BenefitID
	GROUP BY TimeCode, CustomerCode, StaffCode, BenefitCode
END

IF EXISTS 
(
	SELECT * FROM HospitalIE_OLAP.dbo.FilterTimeStamp
	WHERE TableName = 'SubscriptionFact'
)
BEGIN
	UPDATE HospitalIE_OLAP.dbo.FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName = 'SubscriptionFact'
END
ELSE
BEGIN
	INSERT INTO HospitalIE_OLAP.dbo.FilterTimeStamp VALUES('SubscriptionFact', GETDATE())
END


-- ServiceFact
IF EXISTS 
(
	SELECT * FROM HospitalIE_OLAP.dbo.FilterTimeStamp
	WHERE TableName = 'ServiceFact'
)
BEGIN
	SELECT 
		TimeCode,
		CustomerCode,
		TreatmentCode,
		DoctorCode,
		[Total Service Earning] = SUM(Quantity * TreatmentPrice),
		[Number Of Doctor] = COUNT(tsh.DoctorID)
	FROM OLTP_HospitalIE.dbo.TrServiceHeader tsh
	JOIN OLTP_HospitalIE.dbo.TrServiceDetail tsd ON tsh.ServiceID = tsd.ServiceID 
	JOIN HospitalIE_OLAP.dbo.TimeDimension td ON tsh.ServiceDate = td.Date
	JOIN HospitalIE_OLAP.dbo.CustomerDimension cd ON tsh.CustomerID = cd.CustomerID
	JOIN HospitalIE_OLAP.dbo.TreatmentDimension ttd ON tsd.TreatmentID = ttd.TreatmentID
	JOIN HospitalIE_OLAP.dbo.DoctorDimension bd ON tsh.DoctorID = bd.DoctorID
	WHERE
		tsh.ServiceDate > (
							SELECT LastETL
							FROM HospitalIE_OLAP.dbo.FilterTimeStamp
							WHERE TableName = 'ServiceFact'
						 )
	GROUP BY TimeCode, CustomerCode, TreatmentCode, DoctorCode
END
ELSE
BEGIN
	SELECT 
		TimeCode,
		CustomerCode,
		TreatmentCode,
		DoctorCode,
		[Total Service Earning] = SUM(Quantity * TreatmentPrice),
		[Number Of Doctor] = COUNT(tsh.DoctorID)
	FROM OLTP_HospitalIE.dbo.TrServiceHeader tsh
	JOIN OLTP_HospitalIE.dbo.TrServiceDetail tsd ON tsh.ServiceID = tsd.ServiceID 
	JOIN HospitalIE_OLAP.dbo.TimeDimension td ON tsh.ServiceDate = td.Date
	JOIN HospitalIE_OLAP.dbo.CustomerDimension cd ON tsh.CustomerID = cd.CustomerID
	JOIN HospitalIE_OLAP.dbo.TreatmentDimension ttd ON tsd.TreatmentID = ttd.TreatmentID
	JOIN HospitalIE_OLAP.dbo.DoctorDimension bd ON tsh.DoctorID = bd.DoctorID
	GROUP BY TimeCode, CustomerCode, TreatmentCode, DoctorCode
END

IF EXISTS 
(
	SELECT * FROM HospitalIE_OLAP.dbo.FilterTimeStamp
	WHERE TableName = 'ServiceFact'
)
BEGIN
	UPDATE HospitalIE_OLAP.dbo.FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName = 'ServiceFact'
END
ELSE
BEGIN
	INSERT INTO HospitalIE_OLAP.dbo.FilterTimeStamp VALUES('ServiceFact', GETDATE())
END

SELECT * FROM HospitalIE_OLAP.dbo.SalesFact
SELECT * FROM HospitalIE_OLAP.dbo.PurchaseFact
SELECT * FROM HospitalIE_OLAP.dbo.SubscriptionFact
SELECT * FROM HospitalIE_OLAP.dbo.ServiceFact


