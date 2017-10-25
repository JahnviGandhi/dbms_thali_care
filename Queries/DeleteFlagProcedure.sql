
Use Thali_Care_Database
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spDeleteUserType'))
BEGIN
  DROP PROCEDURE spDeleteUserType
END
GO

CREATE PROCEDURE spDeleteUserType
@User_Type_ID int
AS
BEGIN
UPDATE User_Type SET isDeleted = 'Y' 
WHERE User_Type_Id = @User_Type_ID;

PRINT N'Updated successfully.';

END;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spDeletePersonDetail'))
BEGIN
  DROP PROCEDURE spDeletePersonDetail
END
GO

CREATE PROCEDURE spDeletePersonDetail
@Person_ID int
AS
BEGIN
UPDATE Person_Details SET isDeleted = 'Y' 
WHERE Person_ID = @Person_ID;

PRINT N'Updated successfully.';

END;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spDeletePatientDetail'))
BEGIN
  DROP PROCEDURE spDeletePatientDetail
END
GO

create procedure spDeletePatientDetail
@Patient_ID int
as
Begin
Update Patient_Details set isDeleted = 'Y' 
Where Patient_ID = @Patient_ID;

PRINT N'Updated successfully.';

end;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spDeleteDoctorDetail'))
BEGIN
  DROP PROCEDURE spDeleteDoctorDetail
END
GO

create procedure spDeleteDoctorDetail
@Doctor_ID int
as
Begin
Update Doctor_Details set isDeleted = 'Y' 
Where Doctor_ID = @Doctor_ID;

PRINT N'Updated successfully.';

end;


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spDeleteDieticianDetail'))
BEGIN
  DROP PROCEDURE spDeleteDieticianDetail
END
GO

create procedure spDeleteDieticianDetail
@Dietician_ID int
as
Begin
Update Dietician_Details set isDeleted = 'Y' 
Where Dietician_ID = @Dietician_ID;

PRINT N'Updated successfully.';

end;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spDeleteHospital'))
BEGIN
  DROP PROCEDURE spDeleteHospital
END
GO

create procedure spDeleteHospital
@Hospital_ID int
as
Begin
Update Hospital_Details set isDeleted = 'Y' 
Where Hospital_ID = @Hospital_ID;

PRINT N'Updated successfully.';

end;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spDeleteNurseDetails'))
BEGIN
  DROP PROCEDURE spDeleteNurseDetails
END
GO

create procedure spDeleteNurseDetails
@Nurse_ID int
as
Begin
Update Nurse_Details set isDeleted = 'Y' 
Where Nurse_ID = @Nurse_ID;

PRINT N'Updated successfully.';

end;

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spDeleteWardPersonDetails'))
BEGIN
  DROP PROCEDURE spDeleteWardPersonDetails
END
GO

create procedure spDeleteWardPersonDetails
@Ward_Person_ID int
as
Begin
Update Ward_Person_Details set isDeleted = 'Y' 
Where Ward_Person_ID = @Ward_Person_ID;

PRINT N'Updated successfully.';

end;


------------------ new--------------------------


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spDeleteMedicine'))
BEGIN
 DROP PROCEDURE spDeleteMedicine
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spDeleteMedicine
    @Medicine_ID     int
                     
AS
BEGIN
   Update Medicine_Details
       SET isDeleted='Y'
        WHERE Medicine_ID=@Medicine_ID
        PRINT N'Entry successfully updated to Medicine_Details table.';
END

-------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spDeleteAdmin'))
BEGIN
 DROP PROCEDURE spDeleteAdmin
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spDeleteAdmin
    @Admin_ID     int
                     
AS
BEGIN
   Update Admin_Details
       SET isDeleted='Y'
        WHERE Admin_ID=@Admin_ID
        PRINT N'Entry successfully updated to Admin_Details table.';
END

-------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spDeletePrescription'))
BEGIN
 DROP PROCEDURE spDeletePrescription
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spDeletePrescription
    @Prescription_Details_ID     int
                     
AS
BEGIN
   Update Prescription_Details
       SET isDeleted='Y'
        WHERE Prescription_Details_ID=@Prescription_Details_ID
        PRINT N'Entry successfully updated to Prescription_Details_ID table.';
END