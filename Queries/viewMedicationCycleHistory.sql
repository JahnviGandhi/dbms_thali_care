USE Thali_Care_Database
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('viewMedicationCycleHistory'))
BEGIN
    DROP VIEW viewMedicationCycleHistory
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW viewMedicationCycleHistory
AS
	SELECT mcd.Medication_Cycle_ID 'Medication Cycle ID',
		   mcd.Medication_Date 'Medication Date',
		   pd.Patient_ID 'Patient ID',
		   p.First_Name + ' ' + p.Last_Name 'Patient Name',
		   d.First_Name + ' ' + d.Last_Name 'Doctor',
		   mcd.Prescription_Details_ID 'Prescription'	
	FROM Medication_Cycle_Details mcd 
	JOIN Patient_Details pd ON mcd.Patient_ID = pd.Patient_ID
	JOIN Person_Details p ON pd.Person_ID = p.Person_ID
	JOIN Doctor_Details d ON mcd.Doctor_ID = d.Doctor_ID
	WHERE mcd.isDeleted = 'N';
GO