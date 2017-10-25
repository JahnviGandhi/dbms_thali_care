USE Thali_Care_Database
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spDetermineResultsAfterTransfusion'))
BEGIN
    DROP PROCEDURE spDetermineResultsAfterTransfusion
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spDetermineResultsAfterTransfusion
	@patientId int,
	@resultedHb decimal(4,2) OUTPUT,
	@resultedMcv decimal(4,2) OUTPUT,
	@resultedMch decimal(4,2) OUTPUT,
	@resultedHbf decimal(4,2) OUTPUT,
	@resultedHbA2 decimal(4,2) OUTPUT
AS
BEGIN
	BEGIN TRANSACTION;
	BEGIN TRY
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

		DECLARE @bloodSupplyDetails TABLE (bloodSupplyId int,
										   requiredHb decimal(4,2),
										   requiredMcv decimal(4,2),
										   requiredMch decimal(4,2),
										   requiredHbf decimal(4,2),
										   requiredHbA2 decimal(4,2),
										   levelId int);

		INSERT INTO @bloodSupplyDetails (bloodSupplyId, requiredHb, requiredMcv, requiredMch, requiredHbf, requiredHbA2, levelId)
		SELECT TOP 1 Blood_Transfusion_Level_ID, HB_Required, MCV_Required, MCH_Required, Hbf_Required, HbA2_Required, Transfusion_Level_Id
		FROM Blood_Transfusion_Level
		WHERE Patient_ID = @patientId
		ORDER BY Blood_Transfusion_Level_ID DESC;										   

		SET @resultedHb = ((SELECT requiredHb FROM @bloodSupplyDetails) + (SELECT hb FROM @getPatientTestData))/2;
		SET @resultedMcv = ((SELECT requiredMcv FROM @bloodSupplyDetails) + (SELECT mcv FROM @getPatientTestData))/2;
		SET @resultedMch = ((SELECT requiredMch FROM @bloodSupplyDetails) + (SELECT mch FROM @getPatientTestData))/2;

		IF (SELECT hbf FROM @getPatientTestData) IS NOT NULL
		BEGIN
			SET @resultedHbf = ((SELECT requiredHbf FROM @bloodSupplyDetails) + (SELECT hbf FROM @getPatientTestData))/2;
		END

		IF (SELECT hba2 FROM @getPatientTestData) IS NOT NULL
		BEGIN
			SET @resultedHbA2 = ((SELECT requiredHbA2 FROM @bloodSupplyDetails) + (SELECT hba2 FROM @getPatientTestData))/2;
		END

		PRINT 'Patient Report After Transfusion:';
		PRINT 'Resulted HB: ';
		PRINT @resultedHb;
		PRINT 'Resulted MCV: ';
		PRINT @resultedMcv;
		PRINT 'Resulted MCH: ';
		PRINT @resultedMch;
		PRINT 'Resulted Hbf: ';
		PRINT @resultedHbf;
		PRINT 'Resulted HbA2: ';
		PRINT @resultedHbA2;

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