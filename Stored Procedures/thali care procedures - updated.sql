use Thali_Care_Database;
/*
select * from Person_Details;
select * from doctor_Details;	
select * from Dietician_Details;
select * from Nurse_Details;
select * from Ward_Person_Details;
select * from Prescription_Details
select * from Admin_Details
select * from Patient_Details
select * from Age_Gender_Parameter_Mapping
select * from Hospital_Details
select * from Admin_Details

*/


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateUserType'))
BEGIN
   DROP PROCEDURE spCreateUserType
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spCreateUserType 

 @Type varchar(10)
as
Begin
insert into User_Type(User_Type_Name) 
values( @Type);
end;



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreatePerson'))
BEGIN
   DROP PROCEDURE spCreatePerson
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spCreatePerson
@firstName varchar(50), @lastName varchar(50), @middleName varchar(50), @gender char(1), @contactDetails int, @streetName varchar(20), @city varchar(20), @zip int
as
Begin
Insert into Person_Details(First_Name,Last_Name,Middle_Name,Gender,Contact_Details,Street_Name,City,Zip)
values(@firstName,@lastName,@middleName,@gender,@contactDetails,@streetName,@city,@zip);
PRINT N'Entry successfully added to Person_Details table.';
End




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreatePatient'))
BEGIN
   DROP PROCEDURE spCreatePatient
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spCreatePatient
@Allergies varchar(200) , @Details varchar(200),@Symptoms varchar(200),@HB decimal(4,2),@PersonId int
as
Begin
Insert into Patient_Details(Allergies,Details,Symptoms,HB,Person_ID)
values(@Allergies,@Details,@Symptoms,@HB,@PersonId);
PRINT N'Entry successfully added to Patient_Details table.';
End



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateDoctor'))
BEGIN
   DROP PROCEDURE spCreateDoctor
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spCreateDoctor
@firstName varchar(50), @lastName varchar(50), @middleName varchar(50), @gender char(1), @contactDetails int, @streetName varchar(20), @city varchar(20), @zip int,@hospitalId int,@fees decimal(8,2),@type varchar(50)
as
Begin
Insert into Doctor_Details(First_Name,Last_Name,Middle_Name,Gender,Contact_Details,Street_Name,City,Zip,Hospital_Id,Fees,Type)
values(@firstName,@lastName,@middleName,@gender,@contactDetails,@streetName,@city,@zip,@hospitalId,@fees,@type);
PRINT N'Entry successfully added to Doctor table.';	
end




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateDietician'))
BEGIN
   DROP PROCEDURE spCreateDietician
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spCreateDietician
@firstName varchar(50), @lastName varchar(50), @middleName varchar(50), @gender char(1), @contactDetails int, @streetName varchar(20), @city varchar(20), @zip int,@hospitalId int,@fees decimal(8,2)
as
Begin
Insert into Dietician_Details(First_Name,Last_Name,Middle_Name,Gender,Contact_Details,Street_Name,City,Zip,Hospital_Id,Fees)
values(@firstName,@lastName,@middleName,@gender,@contactDetails,@streetName,@city,@zip,@hospitalId,@fees);
PRINT N'Entry successfully added to Dietician table.';	
end




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateNurse'))
BEGIN
   DROP PROCEDURE spCreateNurse
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spCreateNurse
@firstName varchar(50), @lastName varchar(50), @middleName varchar(50), @gender char(1), @contactDetails int, @streetName varchar(20), @city varchar(20), @zip int,@hospitalId int,@shifts varchar(50)
as
Begin
Insert into Nurse_Details(First_Name,Last_Name,Middle_Name,Gender,Contact_Details,Street_Name,City,Zip,Hospital_Id,Shifts)
values(@firstName,@lastName,@middleName,@gender,@contactDetails,@streetName,@city,@zip,@hospitalId,@shifts);
PRINT N'Entry successfully added to Nurse table.';	
end



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateWardPerson'))
BEGIN
   DROP PROCEDURE spCreateWardPerson
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spCreateWardPerson
@firstName varchar(50), @lastName varchar(50), @middleName varchar(50), @gender char(1), @contactDetails int, @streetName varchar(20), @city varchar(20), @zip int,@hospitalId int,@shifts varchar(50)
as
Begin
Insert into Ward_Person_Details(First_Name,Last_Name,Middle_Name,Gender,Contact_Details,Street_Name,City,Zip,Hospital_Id,Shifts)
values(@firstName,@lastName,@middleName,@gender,@contactDetails,@streetName,@city,@zip,@hospitalId,@shifts);
PRINT N'Entry successfully added to Nurse table.';	
end



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateHospital'))
BEGIN
   DROP PROCEDURE spCreateHospital
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spCreateHospital
@Name varchar(50), @contactDetails int, @streetName varchar(20), @city varchar(20), @zip int
as
Begin
Insert into Hospital_Details(Name,Contact_Details,Street_Name,City,Zip)
values(@Name,@contactDetails,@streetName,@city,@zip);
PRINT N'Entry successfully added to Hospital table.';	
end



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateAdmin'))
BEGIN
   DROP PROCEDURE spCreateAdmin
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spCreateAdmin
@firstName varchar(50), @lastName varchar(50), @middleName varchar(50), @gender char(1), @contactDetails int, @streetName varchar(20), @city varchar(20), @zip int
as
Begin
Insert into Admin_Details(First_Name,Last_Name,Middle_Name,Gender,Contact_Details,Street_Name,City,Zip)
values(@firstName,@lastName,@middleName,@gender,@contactDetails,@streetName,@city,@zip);
PRINT N'Entry successfully added to Admin_Details table.';
End



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateAgeGenderMapping'))
BEGIN
   DROP PROCEDURE spCreateAgeGenderMapping
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure spCreateAgeGenderMapping
@minAge int, @maxAge int, @gender  varchar(1)
as
Begin
If @minAge>0 and @maxAge<100 and @maxAge>@minAge

Insert into Age_Gender_Parameter_Mapping (Min_Age,Max_Age,Gender ) 
Values(@minAge, @maxAge, @gender );
PRINT N'Entry successfully added to Age_Gender_Mapping table.';

end;



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateStandardNutritionLevel'))
BEGIN
   DROP PROCEDURE spCreateStandardNutritionLevel
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spCreateStandardNutritionLevel
@Age_Gender_Parameter_Mapping_ID int, @Calcium decimal(6,2), @Vitamin_D decimal(6,2), @Vitamin_C decimal(6,2), @Vitamin_E decimal(6,2), @Iron decimal(6,2), @Glucose decimal(6,2)
as
Begin
INSERT INTO Standard_Nutrition_Level (Age_Gender_Parameter_Mapping_ID, Calcium, VitaminD, VitaminC, VitaminE, Iron, Glucose)
Values(@Age_Gender_Parameter_Mapping_ID, @Calcium, @Vitamin_D, @Vitamin_C, @Vitamin_E, @Iron, @Glucose);
PRINT N'Entry successfully added to Standard_Nutrition_Level table.';
END




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spStandardTransfusionLevel'))
BEGIN
   DROP PROCEDURE spStandardTransfusionLevel
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spStandardTransfusionLevel
@Min_HB decimal (4,2),
@Min_MCV decimal(4,2),
@Min_MCH decimal(4,2),
@Max_HB decimal(4,2),
@Max_MCV decimal(4,2),
@Max_MCH decimal(4,2)

As
Begin
Insert into Standard_Transfusion_Level( Min_HB, Min_MCV, Min_MCH, Max_HB,Max_MCV,Max_MCH) values (@Min_HB, @Min_MCV, @Min_MCH, @Max_HB, @Max_MCV, @Max_MCH)
PRINT N'Entry successfully added to Standard_Transfusion_Level table.';
END


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateThalaCategorySymptomMapping'))
BEGIN
   DROP PROCEDURE spCreateThalaCategorySymptomMapping
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spCreateThalaCategorySymptomMapping
@ThalassemiaCategoryId int,
@Symptom int
As
Begin
Insert into Thala_Category_Symptoms_Mapping(thalassemia_category_id,symptoms_id) values (@ThalassemiaCategoryId, @Symptom);
PRINT N'Entry successfully added to Thala_Category_Symptoms_Mapping table.';
END


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateSymptoms'))
BEGIN
   DROP PROCEDURE spCreateSymptoms
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure spCreateSymptoms
      @Symptoms_ID                     INT       , 
      @Symptoms           VARCHAR(200)  
                       
AS 
BEGIN 

    INSERT INTO Symptoms_Details
         ( 
           Symptoms_ID                  ,
           Symptoms                     
         ) 
    VALUES 
         ( 
           @Symptoms_ID                    ,
           @Symptoms                       
         ) 
		 PRINT N'Entry successfully added to Symptoms_Details table.';
END 



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateMedicine'))
BEGIN
   DROP PROCEDURE spCreateMedicine
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure spCreateMedicine
      @Name           VARCHAR(50),
     @Components  VARCHAR(100),
     @Side_Effects  VARCHAR(100)  
                       
AS 
BEGIN 

     INSERT INTO Medicine_Details
         (
           Name,
            Components,
             Side_Effects                   
         ) 
    VALUES 
         ( 
           @Name,
           @Components,
           @Side_Effects                       
         ) 
		 PRINT N'Entry successfully added to Medicine_Details table.';
END 

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


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateBloodGroupParameter'))
BEGIN
 DROP PROCEDURE spCreateBloodGroupParameter
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spCreateBloodGroupParameter
@Blood_Group_Id INT,
    @Blood_Group VARCHAR(5),
     @Min_HB decimal(4,2),
     @Min_MCV decimal(4,2),
     @Min_MCH decimal(4,2),
     @Max_HB decimal(4,2),
  @Max_MCV decimal(4,2),
  @Max_MCH decimal(4,2)  
                     
AS 
BEGIN

   INSERT INTO Blood_Group_Parameter_Details
       (
         Blood_Group,
         Min_HB,
          Min_MCV,
          Min_MCH,
          Max_HB,
          Max_MCV,
          Max_MCH                
       ) 
  VALUES 
       ( 
         @Blood_Group,
         @Min_HB,
          @Min_MCV,
          @Min_MCH,
           @Max_HB,
           @Max_MCV,
            @Max_MCH                     
       )
        PRINT N'Entry successfully added to Blood_Group_Parameter_Details table.';
END


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateBloodTransfusionLevel'))
BEGIN
 DROP PROCEDURE spCreateBloodTransfusionLevel
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spCreateBloodTransfusionLevel

     @Min_HB decimal(4,2),
     @Min_MCV decimal(4,2),
     @Min_MCH decimal(4,2),
     @Max_HB decimal(4,2),
  @Max_MCV decimal(4,2),
  @Max_MCH decimal(4,2),
  @Blood_Pints_Required decimal(4,2),
  @HB_Required decimal(4,2),
  @MCV_Required decimal(4,2),
  @MCH_Required decimal(4,2),
  @Age_Gender_Parameter_Mapping_ID int  
                     
AS 
BEGIN

   INSERT INTO Blood_Transfusion_Level
       (
         
         Min_HB,
          Min_MCV,
          Min_MCH,
          Max_HB,
          Max_MCV,
          Max_MCH,
          Blood_Pints_Required,
           HB_Required,
           MCV_Required,
            MCH_Required,
            Age_Gender_Parameter_Mapping_ID              
       ) 
  VALUES 
       ( 
         
          @Min_HB,
     @Min_MCV,
     @Min_MCH,
     @Max_HB,
  @Max_MCV,
  @Max_MCH,
  @Blood_Pints_Required,
  @HB_Required,
  @MCV_Required,
  @MCH_Required,
  @Age_Gender_Parameter_Mapping_ID                    
       ) 
        PRINT N'Entry successfully added to Blood_Transfusion_Level table.';
END

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreatePrescription'))
BEGIN
 DROP PROCEDURE spCreatePrescription
END
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spCreatePrescription

     @Min_HB decimal(4,2),
     @Min_MCV decimal(4,2),
     @Min_MCH decimal(4,2),
     @Max_HB decimal(4,2),
  @Max_MCV decimal(4,2),
  @Max_MCH decimal(4,2),
  @Age_Gender_Parameter_Mapping_ID int  
                     
AS 
BEGIN

   INSERT INTO Prescription_Details
       (
         
         Min_HB,
          Min_MCV,
          Min_MCH,
          Max_HB,
          Max_MCV,
          Max_MCH,
            Age_Gender_Parameter_Mapping_ID              
       ) 
  VALUES 
       ( 
         
          @Min_HB,
     @Min_MCV,
     @Min_MCH,
     @Max_HB,
  @Max_MCV,
  @Max_MCH,
  @Age_Gender_Parameter_Mapping_ID                    
       ) 
        PRINT N'Entry successfully added to Prescription_Details table.';
END



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateTransfusionGroup'))
BEGIN
 DROP PROCEDURE spCreateTransfusionGroup
END
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spCreateTransfusionGroup

@DoctorId int,@NurseId int,@WardPersonId int 
                     
AS 
BEGIN

   INSERT INTO Transfusion_Group_Details
       (
         doctor_id,
		 nurse_id,
		 Ward_Person_ID            
       ) 
  VALUES 
       ( 
        @doctorID,
		@NurseId,
		@WardPersonId  
       ) ;
        PRINT N'Entry successfully added to Transfusion_Group_Details table.';
END



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreatePrescribedMedicine'))
BEGIN
 DROP PROCEDURE spCreatePrescribedMedicine
END
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spCreatePrescribedMedicine

@Dosages varchar(50),@PrescriptionID int ,@MedicineId int 
                     
AS 
BEGIN

   INSERT INTO Prescribed_Medicine_Details
       (
         Dosages,
		 Prescription_Details_ID,
		 Medicine_ID            
       ) 
  VALUES 
       ( 
        @Dosages,
		@PrescriptionID,
		@MedicineId  
       ) ;
        PRINT N'Entry successfully added to Prescribed_Medicine_Details table.';
END



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreatePatientBloodTest'))
BEGIN
 DROP PROCEDURE spCreatePatientBloodTest
END
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spCreatePatientBloodTest

@HB decimal(4,2),@DateTaken date ,@MCH decimal(4,2), @MCV decimal(4,2), @Hbf decimal(4,2), @HbA2 decimal(4,2), @PatientId int
                     
AS 
BEGIN

   INSERT INTO Patient_Blood_Test_Details
       (
         HB,
		 DateTaken,
		 MCH,
		 MCV,
		 Hbf,
		 HbA2,
		 Patient_ID            
       ) 
  VALUES 
       ( 
        @HB,
		@DateTaken,
		@MCH,
		@MCV,
		@Hbf,
		@HbA2,
		@PatientId  
       ) ;
        PRINT N'Entry successfully added to Patient_Blood_Test_Details table.';
END





IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateTransfusionCycle'))
BEGIN
 DROP PROCEDURE spCreateTransfusionCycle
END
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spCreateTransfusionCycle

@PatientId int, @BloodTransfusionId int, @TestId int,@TransfusionLevelId int, @TransfusionGroupId int 
                     
AS 
BEGIN

   INSERT INTO Transfusion_Cycle_Details
       (
         Patient_ID,
		 Blood_Transfusion_Level_ID,
		 Test_ID,
		 Transfusion_Level_ID,
		 Transfusion_Group_Details_ID           
       ) 
  VALUES 
       ( 
        @PatientId,
		@BloodTransfusionId,
		@TestId,
		@TransfusionLevelId,
		@TransfusionGroupId
       ) ;
        PRINT N'Entry successfully added to Transfusion_Cycle_Details table.';
END



