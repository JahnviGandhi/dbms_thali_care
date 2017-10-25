USE Thali_Care_Database
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('trgNotifyMedicationAppointment'))
BEGIN
    DROP TRIGGER trgNotifyMedicationAppointment
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER trgNotifyMedicationAppointment
ON Medication_Cycle_Details
AFTER INSERT 
AS
BEGIN
	BEGIN TRANSACTION;
	BEGIN TRY
		DECLARE @MedicationDetails TABLE (Medication_Date date,
										   Follow_Up_Date date,
										   Patient_ID int,
										   Patient_Name varchar(200),
										   Patient_Email varchar(200),
										   Doctor_ID int,
										   Doctor_Name varchar(200),
										   Doctor_Email varchar(200));

		INSERT INTO @MedicationDetails (Medication_Date, Follow_Up_Date, Patient_ID, Patient_Name, Patient_Email, Doctor_ID, Doctor_Name, Doctor_Email)
		SELECT TOP 1 mcd.Medication_Date, 
					 mcd.Follow_Up_Date, 
					 mcd.Patient_ID, 
					 (SELECT First_Name + ' ' + Last_Name
					 FROM Person_Details p
					 JOIN Patient_Details pd
					 ON p.Person_ID = pd.Person_ID
					 WHERE pd.Patient_ID = mcd.Patient_ID),
					 (SELECT Email_Address 
					 FROM Person_Details p
					 JOIN Patient_Details pd
					 ON p.Person_ID = pd.Patient_ID
					 WHERE pd.Patient_ID = mcd.Patient_ID),
   					 mcd.Doctor_ID,
					 (SELECT First_Name + ' ' +Last_Name
					 FROM Doctor_Details d
					 WHERE d.Doctor_ID = mcd.Doctor_ID),
					 (SELECT Email_Address
					 FROM Doctor_Details d
					 WHERE d.Doctor_ID = mcd.Doctor_ID)  
		FROM Medication_Cycle_Details mcd
		ORDER BY mcd.Medication_Cycle_ID DESC;

		DECLARE @patient_email varchar(200);
		SET @patient_email = (SELECT Patient_Email FROM @MedicationDetails);
	    
		DECLARE @doctor_email varchar(200);
		SET @doctor_email = (SELECT Doctor_Email FROM @MedicationDetails);

		PRINT @doctor_email;

		DECLARE @patientMailBody varchar(1000);
		SET @patientMailBody = 'Hello ' + (SELECT Patient_Name FROM @MedicationDetails) + ' ,';
		SET @patientMailBody = '\n';
		SET @patientMailBody = 'Your next medication appointment is on ' + CONVERT(VARCHAR,(SELECT Follow_Up_Date FROM @MedicationDetails), 121);
		SET @patientMailBody = '\n';
		SET @patientMailBody = 'Regards, Thali Care Team!';

		EXEC msdb.dbo.sp_send_dbmail
		    @profile_name = 'Thali Care Administrator Profile 1',
			@recipients = @patient_email,
			@body = @patientMailBody,
			@subject = 'Appointment Notification!';


		DECLARE @doctorMailBody varchar(1000);
		SET @doctorMailBody = 'Hello ' + (SELECT Doctor_Name FROM @MedicationDetails) + ' ,';
		SET @doctorMailBody = '\n';
		SET @doctorMailBody = (SELECT Patient_Name FROM @MedicationDetails) + ' has next transfusion appointment with you on ' + CONVERT(VARCHAR,(SELECT Follow_Up_Date FROM @MedicationDetails), 121);
		SET @doctorMailBody = '\n';
		SET @doctorMailBody = 'Regards, Thali Care Team!';

		EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'Thali Care Administrator Profile 1',
			@recipients = @doctor_email,
			@body = @doctorMailBody,
			@subject = 'Appointment Notification!';
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

	IF @@TRANCOUNT < 0
		COMMIT TRANSACTION;
END 

