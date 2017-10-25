USE Thali_Care_Database
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spDetermineTranfusionLevel'))
BEGIN
    DROP PROCEDURE spDetermineTranfusionLevel
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spDetermineTranfusionLevel
	@patientId int,
	@transfusionLevelId int OUTPUT
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
		DECLARE @transfusionLevel int;

		DECLARE @getPatientData TABLE (sysmptoms VARCHAR(200),
				    				   hb INT,
							           age INT,
							           blood_group_id INT,
							           gender char(1));
	
		INSERT INTO @getPatientData (sysmptoms, hb, age, blood_group_id, gender)
		SELECT Symptoms, HB, Age, Blood_Group_ID, (SELECT Gender FROM Person_Details 
												   WHERE Person_ID = (SELECT Person_ID 
																	  FROM Patient_Details 
																	  WHERE Patient_ID = @patientId
																	  AND isDeleted = 'N')
													AND isDeleted = 'N') 
		FROM Patient_Details
		WHERE Patient_ID = @patientId
		AND isDeleted = 'N';
		
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

		DECLARE @ageParameterId int;

		SET @ageParameterId = (SELECT Age_Gender_Parameter_Mapping_ID FROM Age_Gender_Parameter_Mapping
							 WHERE ((SELECT age FROM @getPatientData) > Min_Age AND (SELECT age FROM @getPatientData) < Max_Age)
							 AND Gender = (SELECT gender FROM @getPatientData) 
							 AND isDeleted = 'N');
		


		IF ((SELECT hb FROM @getPatientTestData) > (SELECT Min_HB FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 1
												   AND isDeleted = 'N')
			AND (SELECT hb FROM @getPatientTestData) < (SELECT Max_HB FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 1
												   AND isDeleted = 'N'))
			AND ((SELECT mcv FROM @getPatientTestData) > (SELECT Min_MCV FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 1
												   AND isDeleted = 'N')
			AND (SELECT mcv FROM @getPatientTestData) < (SELECT Max_MCV FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 1
												   AND isDeleted = 'N'))
			AND ((SELECT mch FROM @getPatientTestData) > (SELECT Min_MCH FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 1
												   AND isDeleted = 'N')
			AND (SELECT mch FROM @getPatientTestData) < (SELECT Max_MCH FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 1
												   AND isDeleted = 'N'))
		BEGIN
				SET @transfusionLevel = 1;
		END

		IF ((SELECT hb FROM @getPatientTestData) > (SELECT Min_HB FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 2
												   AND isDeleted = 'N')
			AND (SELECT hb FROM @getPatientTestData) < (SELECT Max_HB FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 2
												   AND isDeleted = 'N'))
			AND ((SELECT mcv FROM @getPatientTestData) > (SELECT Min_MCV FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 2
												   AND isDeleted = 'N')
			AND (SELECT mcv FROM @getPatientTestData) < (SELECT Max_MCV FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 2
												   AND isDeleted = 'N'))
			AND ((SELECT mch FROM @getPatientTestData) > (SELECT Min_MCH FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 2
												   AND isDeleted = 'N')
			AND (SELECT mch FROM @getPatientTestData) < (SELECT Max_MCH FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 2
												   AND isDeleted = 'N'))
		BEGIN
				SET @transfusionLevel = 2;
		END
		
		IF ((SELECT hb FROM @getPatientTestData) > (SELECT Min_HB FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 3
												   AND isDeleted = 'N')
			AND (SELECT hb FROM @getPatientTestData) < (SELECT Max_HB FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 3
												   AND isDeleted = 'N'))
			AND ((SELECT mcv FROM @getPatientTestData) > (SELECT Min_MCV FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 3
												   AND isDeleted = 'N')
			AND (SELECT mcv FROM @getPatientTestData) < (SELECT Max_MCV FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 3
												   AND isDeleted = 'N'))
			AND ((SELECT mch FROM @getPatientTestData) > (SELECT Min_MCH FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 3
												   AND isDeleted = 'N')
			AND (SELECT mch FROM @getPatientTestData) < (SELECT Max_MCH FROM Standard_Transfusion_Level
												   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
												   AND  Transfusion_Level = 3
												   AND isDeleted = 'N'))
		BEGIN
				SET @transfusionLevel = 3;
		END
		 
		SET @transfusionLevelId = (SELECT Transfusion_Level_ID 
								   FROM Standard_Transfusion_Level
								   WHERE Age_Gender_Parameter_Mapping_ID = @ageParameterId
								   AND Transfusion_Level = @transfusionLevel
								   AND isDeleted = 'N');

		PRINT 'Transfusion level determined.';
		PRINT @transfusionLevelId;

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