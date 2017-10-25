USE Thali_Care_Database
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('viewPatientTransfusionHistory'))
BEGIN
    DROP VIEW viewPatientTransfusionHistory
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW viewPatientTransfusionHistory
AS
	SELECT pd.Patient_ID 'Patient ID',
		   p.First_Name + ' ' + p.Last_Name 'Patient Name',
		   tcd.Transfusion_Cycle_ID 'Transfusion Cycle Id',
		   tcd.Date_Of_Transfusion 'Date of Transfusion',		   
		   d.First_Name + ' ' + d.Last_Name 'Doctor', 
		   n.First_Name + ' ' + n.Last_Name 'Nurse', 
		   w.First_Name + ' ' + w.Last_Name 'Ward Person',
		   stl.Transfusion_Level 'Transfusion Level'
	FROM Transfusion_Cycle_Details tcd
	JOIN Transfusion_Group_Details tgd ON tcd.Transfusion_Group_Details_ID = tgd.Transfusion_Group_Details_ID
	JOIN Doctor_Details d ON tgd.Doctor_ID = d.Doctor_ID
	JOIN Nurse_Details n ON tgd.Nurse_ID = n.Nurse_ID
	JOIN Ward_Person_Details w ON tgd.Ward_Person_ID = w.Ward_Person_ID
	JOIN Standard_Transfusion_Level stl ON tcd.Transfusion_Level_ID = stl.Transfusion_Level_ID
	JOIN Patient_Details pd ON tcd.Patient_ID = pd.Patient_ID
	JOIN Person_Details p ON pd.Person_ID = p.Person_ID
	WHERE tcd.isDeleted = 'N';
GO