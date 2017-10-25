IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('spCreateUserAccount'))
BEGIN
    DROP PROCEDURE spCreateUserAccount
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spCreateUserAccount 
	@id int, 
	@userTypeId int, 
	@userName nvarchar(50), 
	@password nvarchar(50)
AS
BEGIN
	-- Declare variables to fetch userAccountId and userTypeName
	DECLARE @userAccountId int;
	DECLARE @userTypeName varchar(20);
	
	INSERT INTO User_Account (Username, Password, User_Type_Id) 
	VALUES (@userName, @password, @userTypeId); 

	SET @userAccountId = (SELECT TOP 1 User_Account_Id FROM User_Account ORDER BY User_Account_Id DESC);
	SET @userTypeName = (SELECT User_Type_Name FROM User_Type WHERE User_Type_Id = @userTypeId);

	IF @userTypeName = 'Admin'
		UPDATE Admin_Details SET User_Account_Id = @userAccountId
		WHERE Admin_Id = @id;
	ELSE
	BEGIN
		IF @userTypeName = 'Person'
				UPDATE Person_Details SET User_Account_Id = @userAccountId
				WHERE Person_ID = @id;
		ELSE 
		BEGIN
			IF @userTypeName = 'Doctor'
				UPDATE Doctor_Details SET User_Account_Id = @userAccountId 
				WHERE Doctor_ID = @id;
			ELSE
			BEGIN
				IF @userTypeName = 'Dietician'
					UPDATE Dietician_Details SET User_Account_Id = @userAccountId
					WHERE Dietician_ID = @id;
				ELSE 
				BEGIN 
					IF @userTypeName = 'Nurse' 
						UPDATE Nurse_Details SET User_Account_Id = @userAccountId
						WHERE Nurse_ID = @id;
					ELSE 
					BEGIN 
						IF @userTypeId = 'Ward Person'
							UPDATE Ward_Person_Details SET User_Account_Id = @userAccountId
							WHERE Ward_Person_ID = @id;
					END
				END
			END
		END
	END
END
GO
