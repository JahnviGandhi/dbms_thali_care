USE Thali_Care_Database
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spPerformFirstDiagnosis'))
BEGIN
    DROP PROCEDURE spPerformFirstDiagnosis
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spPerformFirstDiagnosis
	@patientId int
AS
BEGIN
	BEGIN TRANSACTION;
	BEGIN TRY

		DECLARE @isThalassemiac char(1);
		DECLARE @possibleThalassemiac char(1);
		DECLARE @symptomsTable TABLE (id int,
								  symptom varchar(80));
		DECLARE @symptomId int;
		DECLARE @present char(1) = 'N';

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

		DECLARE @ageParameter TABLE (min_age int,
		  						     max_age int,
								     min_hb decimal(4,2),
								     max_hb decimal(4,2),
								     min_mcv decimal(4,2),
								     max_mcv decimal(4,2),
								     min_mch decimal(4,2),
								     max_mch decimal(4,2),
								     min_hbf decimal(4,2),
								     max_hbf decimal(4,2),
								     min_hba2 decimal(4,2),
								     max_hba2 decimal(4,2));
	

		INSERT INTO @ageParameter 
		SELECT Min_Age, Max_Age, Min_HB, Max_HB, Min_MCV, Max_MCV, Min_MCH, Max_MCH, Min_Hbf, Max_Hbf, Min_HbA2, Max_HbA2 FROM Age_Gender_Parameter_Mapping
									WHERE ((SELECT age FROM @getPatientData) > Min_Age AND (SELECT age FROM @getPatientData) < Max_Age)
									AND Gender = (SELECT gender FROM @getPatientData) 
									AND isDeleted = 'N';
	
		IF (SELECT hb FROM @getPatientTestData) < (SELECT min_hb FROM @ageParameter)
		BEGIN
			IF (SELECT mcv FROM @getPatientTestData) < (SELECT min_mcv FROM @ageParameter)
			BEGIN
				IF (SELECT mch FROM @getPatientTestData) < (SELECT min_mch FROM @ageParameter)
				BEGIN
					IF (SELECT hbf FROM @getPatientTestData) IS NOT NULL AND (SELECT hba2 FROM @getPatientTestData) IS NOT NULL
					BEGIN
						IF (SELECT hbf FROM @getPatientTestData) > (SELECT max_hbf FROM @ageParameter) AND (SELECT hba2 FROM @getPatientTestData) > (SELECT max_hba2 FROM @ageParameter)
						BEGIN
							SET @possibleThalassemiac = 'Y';
						END
						ELSE
						BEGIN
							SET @possibleThalassemiac = 'N';
						END
					END
					ELSE
					BEGIN
						SET @possibleThalassemiac = 'Y';
					END
				END
				ELSE 
				BEGIN
					SET @possibleThalassemiac = 'N';
				END
			END
			ELSE 
			BEGIN
				SET @possibleThalassemiac = 'N';
			END
		END
		ELSE 
		BEGIN
			SET @possibleThalassemiac = 'N';
		END

		INSERT INTO @symptomsTable (id, symptom)
		SELECT s.Symptoms_ID,f.* FROM funGetCommaSeperatedData((SELECT sysmptoms FROM @getPatientData)) f 
			JOIN Symptoms_Details s ON s.Symptoms = f.Data
			WHERE s.isDeleted = 'N';

			DECLARE symptomCursor CURSOR FOR
			SELECT id FROM @symptomsTable;

		OPEN symptomCursor

		FETCH NEXT FROM symptomCursor
		INTO @symptomId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (SELECT COUNT(*) 
				FROM Thala_Category_Symptoms_Mapping 
				WHERE Symptoms_ID = @symptomId
				AND isDeleted = 'N') > 0
			BEGIN
				IF @present = 'N'	
					SET @present = 'Y';
			END		
			FETCH NEXT FROM symptomCursor INTO @symptomId
		END

		CLOSE symptomCursor


		IF @present = 'Y' AND @possibleThalassemiac = 'Y'
		BEGIN
			SET @isThalassemiac = 'Y'
		END

		UPDATE Patient_Details 
		SET IsThalassemiac = @isThalassemiac
		WHERE Patient_ID = @patientId
		AND isDeleted = 'N';

		PRINT 'First Diagnosis Completed. Is patient thalassemiac? : ' + @isThalassemiac;
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