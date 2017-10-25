USE Thali_Care_Database
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spDetermineBloodSupply'))
BEGIN
    DROP PROCEDURE spDetermineBloodSupply
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spDetermineBloodSupply
	@patientId int,
	@bloodTransfusionLevelId int OUTPUT,
	@testId int OUTPUT,
	@transfusionLevel int OUTPUT
AS
BEGIN
	BEGIN TRANSACTION;
	BEGIN TRY
		DECLARE @transfusionLevelId int;
		DECLARE @requiredHB decimal(4,2),
				@requiredMCV decimal(4,2),
				@requiredMCH decimal(4,2),
				@requiredHbf decimal(4,2),
				@requiredHba2 decimal(4,2),
				@requiredBloodPints decimal(4,2);
		
		
		
		DECLARE @getPatientTestData TABLE (testId int,
		    							   dateTaken date,
									       hb decimal(4,2),
										   mcv decimal(4,2),
									       mch decimal(4,2),
									       hbf decimal(4,2),
									       hba2 decimal(4,2));

		INSERT INTO @getPatientTestData (testId, dateTaken, hb, mcv, mch, hbf, hba2)
		SELECT Test_Id, DateTaken, HB, MCV, MCH, Hbf, HbA2
		FROM Patient_Blood_Test_Details
		WHERE Patient_ID = @patientId
		AND DateTaken = (SELECT MAX(DateTaken) 
						 FROM Patient_Blood_Test_Details 
			   		     WHERE Patient_ID = @patientId
						 AND isDeleted = 'N')
		AND isDeleted = 'N';
		
		EXECUTE spDetermineTranfusionLevel @patientId, @transfusionLevelId

		PRINT @transfusionLevelId;

		DECLARE @transfusionLevelDetails TABLE (tlevel int,
												maxHb decimal(4,2),
												maxMcv decimal(4,2),
												maxMch decimal(4,2),
												maxHbf decimal(4,2),
												maxHba2 decimal(4,2));

		INSERT INTO @transfusionLevelDetails (tlevel, maxHb, maxMcv, maxMch, maxHbf, maxHba2)
		SELECT Transfusion_Level, Max_HB, Max_MCV, Max_MCH, Max_Hbf, Max_HbA2 
		FROM Standard_Transfusion_Level
		WHERE Transfusion_Level_ID = @transfusionLevelId
		AND isDeleted = 'N';

		IF (SELECT tlevel FROM @transfusionLevelDetails) = 1
		BEGIN
			SET @requiredBloodPints = 3;
		END
		
		IF (SELECT tlevel FROM @transfusionLevelDetails) = 2
		BEGIN
			SET @requiredBloodPints = 2;
		END

		IF (SELECT tlevel FROM @transfusionLevelDetails) = 3
		BEGIN
			SET @requiredBloodPints = 1;
		END
										
		SET @requiredHB = (SELECT maxHb FROM @transfusionLevelDetails) - (SELECT hb FROM @getPatientTestData);
		SET @requiredMCV = (SELECT maxMcv FROM @transfusionLevelDetails) - (SELECT mcv FROM @getPatientTestData);
		SET @requiredMCH = (SELECT maxMch FROM @transfusionLevelDetails) - (SELECT mch FROM @getPatientTestData);

		IF (SELECT hbf FROM @getPatientTestData) IS NOT NULL 
		BEGIN
			SET @requiredHbf = (SELECT maxHbf FROM @transfusionLevelDetails) - (SELECT hbf FROM @getPatientTestData);
		END

		IF (SELECT hba2 FROM @getPatientTestData) IS NOT NULL 
		BEGIN
			SET @requiredHba2 = (SELECT maxHba2 FROM @transfusionLevelDetails) - (SELECT hba2 FROM @getPatientTestData);
		END
			
		INSERT INTO Blood_Transfusion_Level (Transfusion_Level_Id, Patient_ID, HB_Required, MCV_Required, MCH_Required, Hbf_Required, HbA2_Required, Blood_Pints_Required)
		VALUES (@transfusionLevelId, @patientId, @requiredHB, @requiredMCV, @requiredMCH, @requiredHbf, @requiredHba2, @requiredBloodPints);

		SET @bloodTransfusionLevelId = (SELECT TOP 1 Blood_Transfusion_Level_ID 
									  FROM Blood_Transfusion_Level
									  WHERE Patient_ID = @patientId
									  ORDER BY Blood_Transfusion_Level_ID DESC);

		SET @testId = (SELECT @testId FROM @getPatientTestData);
		SET @transfusionLevel = @transfusionLevelId;
		
		PRINT 'Blood supply details determined.';	
						
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