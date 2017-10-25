USE Thali_Care_Database
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('viewPatientBloodTestHistory'))
BEGIN
    DROP VIEW viewPatientBloodTestHistory
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW viewPatientBloodTestHistory
AS
	SELECT pbt.Test_ID 'Test ID',
		   pbt.Patient_ID 'Patient ID',
		   p.First_Name + ' ' + p.Last_Name 'Patient Name',
		   pbt.DateTaken 'Date',
		   pd.Age,
		   pbt.HB,
		   pbt.MCV,
		   pbt.MCH,
		   pbt.Hbf,
		   pbt.HbA2
	FROM Patient_Blood_Test_Details pbt
	JOIN Patient_Details pd ON pbt.Patient_ID = pd.Patient_ID
	JOIN Person_Details p ON pd.Person_ID = p.Person_ID
	WHERE pbt.isDeleted = 'N';
GO