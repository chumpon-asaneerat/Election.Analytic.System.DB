/****** Object:  StoredProcedure [dbo].[GetMPerson]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPerson
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- 
-- =============================================
CREATE PROCEDURE [dbo].[GetMPerson] (
  @PersonId int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
        SELECT A.PersonId
             , A.Prefix
             , A.FirstName
             , A.LastName
             , LTRIM(RTRIM(
                LTRIM(RTRIM(A.Prefix)) + ' ' + 
                LTRIM(RTRIM(A.FirstName)) + ' ' + 
                LTRIM(RTRIM(A.LastName))
               )) AS FullName
             , A.DOB
             , A.GenderId
             , B.[Description] AS GenderDescription
             , A.EducationId
             , C.[Description] AS EducationDescription
             , A.OccupationId
             , D.[Description] AS OccupationDescription
             , A.[Remark]
          FROM MPerson A 
            LEFT OUTER JOIN MGender B ON B.GenderId = A.GenderId
            LEFT OUTER JOIN MEducation C ON C.EducationId = A.EducationId
            LEFT OUTER JOIN MOccupation D ON D.OccupationId = A.OccupationId
         WHERE A.PersonId = @PersonId
        -- Update Error Status/Message
        SET @errNum = 0;
        SET @errMsg = 'Success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
