use Thali_Care_Database

ALTER TABLE Admin_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));

ALTER TABLE Age_Gender_Parameter_Mapping
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));

ALTER TABLE Blood_Group_Parameter_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));

ALTER TABLE Blood_Transfusion_Level
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));

ALTER TABLE Dietician_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));

ALTER TABLE Doctor_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));

ALTER TABLE Hospital_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));

ALTER TABLE Medication_Cycle_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));

ALTER TABLE Medicine_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));

ALTER TABLE Nurse_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));

ALTER TABLE Patient_Blood_Test_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));

ALTER TABLE Patient_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));

ALTER TABLE Patient_Dietary_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));

ALTER TABLE Person_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));

ALTER TABLE Prescribed_Medicine_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));

ALTER TABLE Prescription_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));


ALTER TABLE Prescription_Update_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));


ALTER TABLE Standard_Nutrition_Level
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));


ALTER TABLE Standard_Transfusion_Level
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));


ALTER TABLE Strandard_Diet_Plan_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));


ALTER TABLE Symptoms_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));


ALTER TABLE Thala_Category_Symptoms_Mapping
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));


ALTER TABLE Thalassemia_Category
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));


ALTER TABLE Transfusion_Cycle_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));


ALTER TABLE Transfusion_Group_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));


ALTER TABLE User_Account
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));


ALTER TABLE User_Type
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));


ALTER TABLE Ward_Person_Details
ADD isDeleted char(1) not null Default 'N'
CHECK (isDeleted IN ('Y','N'));

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateThalassemiaCategory'))
BEGIN
  DROP PROCEDURE spCreateThalassemiaCategory
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spCreateThalassemiaCategory
@thalassemiaCategoryID int, @type varchar(30), @mch decimal (4,2), @mcv decimal (4,2), @hbf decimal (4,2), @hba2 decimal (4,2), @hb decimal (4,2) 
as
Begin
Insert into Thalassemia_Category(Thalassemia_Category_ID, Type, MCH, MCV, Hbf, HbA2, HB)
values(@thalassemiaCategoryID, @type, @mch, @mcv, @hbf, @hba2, @hb);
PRINT N'Entry successfully added to Person_Details table.';
End

select * from Nurse_Details

insert into Nurse_Details
values(12,'aba','aba',12,'aba',null,null,'aba','aba','aba','F',)

