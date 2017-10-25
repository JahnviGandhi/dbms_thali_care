USE Thali_Care_Database
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spGetPatientBloodTestHistory'))
BEGIN
    DROP PROCEDURE spGetPatientBloodTestHistory
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spGetPatientBloodTestHistory
	@patientId int,
	@startDate date = NULL,
	@endDate date = NULL
AS
BEGIN
	SELECT [Test ID], [Patient Name], Date, Age, HB, MCV, MCH, Hbf, HbA2  FROM viewPatientBloodTestHistory
	WHERE [Patient ID] = @patientId
	AND (Date >= @startDate AND Date <= @endDate);
END
GO

-- EXECUTE spGetPatientBloodTestHistory 3, '10-26-2015', '12-14-2015'
