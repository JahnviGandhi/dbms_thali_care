IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreatePrescriptionUpdateDetail'))
BEGIN
    DROP PROCEDURE spCreatePrescriptionUpdateDetail
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spCreatePrescriptionUpdateDetail 
	@patientId int,
	@doctorId int,
	@prescriptionId int,
	@medicineId int,
	@oldDosage int,
	@newDosage int	
AS
BEGIN
	INSERT INTO Prescription_Update_Details (Patient_ID, Doctor_ID, Prescription_Details_ID, Medicine_ID, Old_dosage, New_dosage, Updated_Date)
	VALUES (@patientId, @doctorId, @prescriptionId, @medicineId, @oldDosage, @newDosage, GETDATE());
END
GO
