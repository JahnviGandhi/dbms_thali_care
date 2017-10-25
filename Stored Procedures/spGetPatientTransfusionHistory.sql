USE Thali_Care_Database
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spGetPatientTransfusionHistory'))
BEGIN
    DROP PROCEDURE spGetPatientTransfusionHistory
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spGetPatientTransfusionHistory
	@patientId int,
	@startDate date = NULL,
	@endDate date = NULL
AS
BEGIN
	SELECT [Patient Name], [Transfusion Cycle Id], [Date of Transfusion], Doctor, Nurse, [Ward Person], [Transfusion Level] FROM viewPatientTransfusionHistory
	WHERE [Patient ID] = @patientId
	AND ([Date of Transfusion] >= @startDate AND [Date of Transfusion] <= @endDate);
END
GO

-- EXECUTE spGetPatientTransfusionHistory 3, '10-26-2015', '12-14-2015'
