/****** Object:  StoredProcedure [dbo].[SaveMPerson]    Script Date: 11/26/2022 1:17:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMPerson
-- [== History ==]
-- <2022-08-20> :
--	- Stored Procedure Created.
--
-- [== Example ==]
-- 
-- =============================================
CREATE PROCEDURE [dbo].[SaveMPerson] (
  @Prefix nvarchar(100)
, @FirstName nvarchar(200)
, @LastName nvarchar(200)
, @DOB datetime = NULL
, @GenderId int = NULL
, @EducationId int = NULL
, @OccupationId int = NULL
, @Remark nvarchar(MAX) = NULL
, @PersonId int = NULL out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @matchId int
	BEGIN TRY
        -- FIND ID
        IF (@PersonId IS NULL OR @PersonId <= 0)
        BEGIN
            SELECT @matchId = PersonId 
              FROM MPerson 
             WHERE UPPER(LTRIM(RTRIM(FirstName))) = UPPER(LTRIM(RTRIM(@FirstName)))
               AND UPPER(LTRIM(RTRIM(LastName))) = UPPER(LTRIM(RTRIM(@LastName)))
            -- REPLACE ID IN CASE PartyName is EXISTS but not specificed Id when call this SP
            SET @PersonId = @matchId
        END

		IF (@PersonId IS NULL)
		BEGIN
			INSERT INTO MPerson
			(
				  Prefix 
                , FirstName 
                , LastName 
                , DOB
                , GenderId
                , EducationId
                , OccupationId
                , [Remark]
			)
			VALUES
			(
				  LTRIM(RTRIM(@Prefix))
                , LTRIM(RTRIM(@FirstName))
                , LTRIM(RTRIM(@LastName))
                , @DOB
                , @GenderId
                , @EducationId
                , @OccupationId
                , LTRIM(RTRIM(@Remark))
			);

			SET @PersonId = @@IDENTITY;
		END
        ELSE
        BEGIN
            UPDATE MPerson
               SET Prefix = LTRIM(RTRIM(@Prefix))
                 , FirstName = LTRIM(RTRIM(@FirstName))
                 , LastName = LTRIM(RTRIM(@LastName))
                 , DOB = @DOB
                 , GenderId = @GenderId
                 , EducationId = @EducationId
                 , OccupationId = @OccupationId
                 , [Remark] = LTRIM(RTRIM(@Remark))
             WHERE PersonId = @PersonId;
        END

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
