IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('trgCheckExistingUserAccount'))
BEGIN
    DROP TRIGGER trgCheckExistingUserAccount
END

GO

CREATE TRIGGER trgCheckExistingUserAccount
ON User_Account
INSTEAD OF INSERT
AS
BEGIN
	PRINT 'User Account already exists!';
END

