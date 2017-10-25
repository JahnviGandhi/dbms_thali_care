IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateMedicationCycleDetail'))
BEGIN
    DROP PROCEDURE spCreateMedicationCycleDetail
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spCreateMedicationCycleDetail 
	@patientId int,
	@doctorId int,
	@prescriptionId int,
	@isPrescriptionUpdated char(1),
	@med1 int,
	@newDosage1 int,
	@med2 int,
	@newDosage2 int,
	@med3 int,
	@newDosage3 int,
	@med4 int,
	@newDosage4 int,
	@med5 int,
	@newDosage5 int
AS
BEGIN
	DECLARE @count int;
	DECLARE @oldPresId int;
	DECLARE @oldDosage int;

	SET @count = (SELECT COUNT(*) FROM Medication_Cycle_Details 
				  WHERE Patient_ID = @patientId);

	IF @count > 0 
	BEGIN
		SET @oldPresId = (SELECT TOP 1 Prescription_Details_ID
						  FROM Medication_Cycle_Details
						  WHERE Patient_ID = @patientId
						  ORDER BY Medication_Date DESC);

		IF @oldPresId = @prescriptionId
		BEGIN
			-- add new record in medication cycle detail table
			INSERT INTO Medication_Cycle_Details (Medication_Date, Follow_Up_Date, Is_Pres_Changed, Is_Pres_Updated, Patient_Id, Doctor_Id, Prescription_Details_Id)
			VALUES (GETDATE(), DATEADD(day, 15, GETDATE()), 'N', @isPrescriptionUpdated, @patientid, @doctorId, @prescriptionId);
			
				IF @isPrescriptionUpdated = 'Y'
				BEGIN
				-- add new record in prescription update table
					IF @med1 IS NOT NULL AND @newDosage1 IS NOT NULL
					BEGIN
						SET @oldDosage = (SELECT TOP 1 New_dosage
						FROM Prescription_Update_Details
						WHERE Patient_Id = @patientId 
						AND Medicine_ID = @med1
						ORDER BY Updated_Date DESC);

						IF @oldDosage IS NULL 
						BEGIN
							SET @oldDosage = (SELECT Dosages 
											  FROM Prescribed_Medicine_Details 
											  WHERE Prescription_Details_Id = @prescriptionId
											  AND Medicine_Id = @med1);
						END

						EXECUTE spCreatePrescriptionUpdateDetail @patientId, @doctorId, @prescriptionId, @med1, @oldDosage, @newDosage1
					END
					IF @med2 IS NOT NULL AND @newDosage2 IS NOT NULL
					BEGIN
						SET @oldDosage = (SELECT TOP 1 New_dosage
						FROM Prescription_Update_Details
						WHERE Patient_Id = @patientId 
						AND Medicine_ID = @med2
						ORDER BY Updated_Date DESC);

						IF @oldDosage IS NULL 
						BEGIN
							SET @oldDosage = (SELECT Dosages 
											  FROM Prescribed_Medicine_Details 
											  WHERE Prescription_Details_Id = @prescriptionId
											  AND Medicine_Id = @med2);
						END

						EXECUTE spCreatePrescriptionUpdateDetail @patientId, @doctorId, @prescriptionId, @med2, @oldDosage, @newDosage2
					END
					IF @med3 IS NOT NULL AND @newDosage3 IS NOT NULL
					BEGIN
						SET @oldDosage = (SELECT TOP 1 New_dosage
						FROM Prescription_Update_Details
						WHERE Patient_Id = @patientId 
						AND Medicine_ID = @med3
						ORDER BY Updated_Date DESC);

						IF @oldDosage IS NULL 
						BEGIN
							SET @oldDosage = (SELECT Dosages 
											  FROM Prescribed_Medicine_Details 
											  WHERE Prescription_Details_Id = @prescriptionId
											  AND Medicine_Id = @med3);
						END

						EXECUTE spCreatePrescriptionUpdateDetail @patientId, @doctorId, @prescriptionId, @med3, @oldDosage, @newDosage3
					END
					IF @med4 IS NOT NULL AND @newDosage4 IS NOT NULL
					BEGIN
						SET @oldDosage = (SELECT TOP 1 New_dosage
						FROM Prescription_Update_Details
						WHERE Patient_Id = @patientId 
						AND Medicine_ID = @med4
						ORDER BY Updated_Date DESC);

						IF @oldDosage IS NULL 
						BEGIN
							SET @oldDosage = (SELECT Dosages 
											  FROM Prescribed_Medicine_Details 
											  WHERE Prescription_Details_Id = @prescriptionId
											  AND Medicine_Id = @med4);
						END

						EXECUTE spCreatePrescriptionUpdateDetail @patientId, @doctorId, @prescriptionId, @med4, @oldDosage, @newDosage4
					END
					IF @med5 IS NOT NULL AND @newDosage5 IS NOT NULL
					BEGIN
						SET @oldDosage = (SELECT TOP 1 New_dosage
						FROM Prescription_Update_Details
						WHERE Patient_Id = @patientId 
						AND Medicine_ID = @med5
						ORDER BY Updated_Date DESC);

						IF @oldDosage IS NULL 
						BEGIN
							SET @oldDosage = (SELECT Dosages 
											  FROM Prescribed_Medicine_Details 
											  WHERE Prescription_Details_Id = @prescriptionId
											  AND Medicine_Id = @med5);
						END

						EXECUTE spCreatePrescriptionUpdateDetail @patientId, @doctorId, @prescriptionId, @med5, @oldDosage, @newDosage5
					END
				END
			END
		ELSE
		BEGIN
			INSERT INTO Medication_Cycle_Details (Medication_Date, Follow_Up_Date, Is_Pres_Changed, Is_Pres_Updated, Patient_Id, Doctor_Id, Prescription_Details_Id)
			VALUES (GETDATE(), DATEADD(day, 15, GETDATE()), 'Y', @isPrescriptionUpdated, @patientid, @doctorId, @prescriptionId);	
		END
	END
END
GO
