USE Thali_Care_Database
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID('funGetCommaSeperatedData'))
BEGIN
    DROP FUNCTION funGetCommaSeperatedData
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION funGetCommaSeperatedData (@commaDeliminatedString varchar(1000))
RETURNS
	@commaSeperatedData TABLE (Data varchar(80))
AS 
BEGIN
	DECLARE @IntLocation INT
    
	WHILE (CHARINDEX(',',    @commaDeliminatedString, 0) > 0)
    BEGIN
		SET @IntLocation =   CHARINDEX(',',    @commaDeliminatedString, 0)      
        INSERT INTO   @commaSeperatedData (Data)
        --LTRIM and RTRIM to ensure blank spaces are   removed
        SELECT RTRIM(LTRIM(SUBSTRING(@commaDeliminatedString,   0, @IntLocation)))   
        SET @commaDeliminatedString = STUFF(@commaDeliminatedString,   1, @IntLocation,   '') 
    END
    INSERT INTO @commaSeperatedData (Data)
    SELECT RTRIM(LTRIM(@commaDeliminatedString))--LTRIM and RTRIM to ensure blank spaces are removed
    RETURN 
END 
GO