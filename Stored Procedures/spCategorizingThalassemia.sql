USE Thali_Care_Database
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCategorizingThalassemia'))
BEGIN
    DROP PROCEDURE spCategorizingThalassemia
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spCategorizingThalassemia
	@patientId int
AS
BEGIN
	BEGIN TRANSACTION;
	BEGIN TRY
		DECLARE @isThalassemiac char(1);
		DECLARE @thalCategory int;
		DECLARE @rowCount int;

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

		SET @isThalassemiac = (SELECT isThalassemiac FROM @getPatientData);

		IF @isThalassemiac = 'Y'
		BEGIN
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
			AND isDeleted =	'N';

			SET @rowCount = (SELECT COUNT(*) FROM @getPatientTestData);

			IF @rowCount <= 0
			BEGIN
				DECLARE @Error varchar(100);

				SET @Error = 'Patient blood test report needed. Cannot proceed further.';

				RAISERROR (@Error, 16, 1);
			END	

			IF (SELECT hbf FROM @getPatientTestData) IS NULL AND (SELECT hba2 FROM @getPatientTestData) IS NULL
			BEGIN
				IF (SELECT hb FROM @getPatientTestData) > 0 AND (SELECT hb FROM @getPatientTestData) < 7
				BEGIN 
					IF (SELECT mch FROM @getPatientTestData) < 15 AND (SELECT mcv FROM @getPatientTestData) < 60
					BEGIN
						SET @thalCategory = (SELECT tc.Thalassemia_Category_ID 
											 FROM Thalassemia_Category tc
											 WHERE tc.Type = 'Alpha Major'
											 AND tc.isDeleted = 'N');
					END
				END	 
				ELSE 
				BEGIN
					IF (SELECT hb FROM @getPatientTestData) > 7 AND (SELECT hb FROM @getPatientTestData) <= 11
					BEGIN
						IF (SELECT mch FROM @getPatientTestData) < 25 AND (SELECT mcv FROM @getPatientTestData) < 80
						BEGIN
							SET @thalCategory = (SELECT tc.Thalassemia_Category_ID 
												 FROM Thalassemia_Category tc
												 WHERE tc.Type = 'Alpha Minor'
												 AND tc.isDeleted = 'N');
						END		
					END
				END
			END
			ELSE 
			BEGIN
				IF (SELECT hbf FROM @getPatientTestData) > 4.5 AND (SELECT hba2 FROM @getPatientTestData) > 4.5
				BEGIN
					IF (SELECT hb FROM @getPatientTestData) > 0 AND (SELECT hb FROM @getPatientTestData) < 7
					BEGIN 
						IF (SELECT mch FROM @getPatientTestData) < 15 AND (SELECT mcv FROM @getPatientTestData) < 60
						BEGIN
							SET @thalCategory = (SELECT tc.Thalassemia_Category_ID 
												 FROM Thalassemia_Category tc
												 WHERE tc.Type = 'Beta Major'
												 AND tc.isDeleted = 'N');
						END
					END	 
					ELSE 
					BEGIN
						IF (SELECT hb FROM @getPatientTestData) > 7 AND (SELECT hb FROM @getPatientTestData) <= 11
						BEGIN
							IF (SELECT mch FROM @getPatientTestData) < 25 AND (SELECT mcv FROM @getPatientTestData) < 80
							BEGIN
								SET @thalCategory = (SELECT tc.Thalassemia_Category_ID 
													 FROM Thalassemia_Category tc
													 WHERE tc.Type = 'Beta Minor'
													 AND tc.isDeleted = 'N');
							END		
						END
					END
				END	
			END
	
			UPDATE Patient_Details
			SET Thalassemia_Category_ID = @thalCategory
			WHERE Patient_ID = @patientId
			AND isDeleted = 'N'; 
		
			PRINT 'Thalassemia Category identified for the patient.';
		END
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