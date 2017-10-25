USE Thali_Care_Database
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spGetPrescription'))
BEGIN
    DROP PROCEDURE spGetPrescription
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spGetPrescription
	@patientId int,
	@prescriptionId int OUTPUT
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
		DECLARE @resultedHb decimal(4,2),
				@resultedMcv decimal(4,2),
				@resultedMch decimal(4,2),
				@resultedHbf decimal(4,2),
				@resultedHbA2 decimal(4,2);
				
		EXECUTE spDetermineResultsAfterTransfusion @patientId, @resultedHb, @resultedMcv, @resultedMch, @resultedHbf, @resultedHbA2

		DECLARE @getPatientData TABLE (sysmptoms VARCHAR(200),
				  					   hb INT,
									   age INT,
									   blood_group_id INT,
									   isThalassemiac char(1),
									   gender char(1));
	
		INSERT INTO @getPatientData (sysmptoms, hb, age, blood_group_id, isThalassemiac, gender)
		SELECT Symptoms, HB, Age, Blood_Group_ID, IsThalassemiac, (SELECT Gender FROM Person_Details 
																   WHERE Person_ID = (SELECT Person_ID 
							 														  FROM Patient_Details 
																					WHERE Patient_ID = @patientId
																AND isDeleted = 'N')
													 AND isDeleted = 'N') 
		FROM Patient_Details
		WHERE Patient_ID = @patientId
		AND isDeleted = 'N';
		
		DECLARE @ageParameterId int;

		SET @ageParameterId = (SELECT Age_Gender_Parameter_Mapping_ID FROM Age_Gender_Parameter_Mapping
							 WHERE ((SELECT age FROM @getPatientData) > Min_Age AND (SELECT age FROM @getPatientData) < Max_Age)
							 AND Gender = (SELECT gender FROM @getPatientData) 
							 AND isDeleted = 'N');
		
		SET @prescriptionId = (SELECT Prescription_Details_ID 
							   FROM Prescription_Details
							   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
							   AND isDeleted = 'N');

		PRINT 'Prescription retreived.'
		PRINT 'Presctiption ID: ';
		PRINT @prescriptionId;
									  
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		DECLARE @ErrorNumber INT = ERROR_NUMBER();
		DECLARE @ErrorLine INT = ERROR_LINE();
		DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
		DECLARE @ErrorState INT = ERROR_STATE();

		PRINT 'Actual error number: ' + CAST(@ErrorNumber AS VARCHAR(10));
		PRINT 'Actual line number: ' + CAST(@ErrorLine AS VARCHAR(10));

		RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);

		PRINT 'Error Has Occurred. Cannot Process Further.';
	END CATCH

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
GO