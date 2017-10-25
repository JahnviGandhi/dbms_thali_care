USE Thali_Care_Database
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spGetPatientMedicationHistory'))
BEGIN
    DROP PROCEDURE spGetPatientMedicationHistory
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spGetPatientMedicationHistory
	@patientId int,
	@startDate date = NULL,
	@endDate date = NULL
AS
BEGIN
	SELECT [Medication Cycle ID], [Medication Date], [Patient Name], Doctor, Prescription FROM viewMedicationCycleHistory
	WHERE [Patient ID] = @patientId
	AND ([Medication Date] >= @startDate AND [Medication Date] <= @endDate);
END
GO

-- EXECUTE spGetPatientMedicationHistory 3, '10-26-2015', '12-14-2015'
