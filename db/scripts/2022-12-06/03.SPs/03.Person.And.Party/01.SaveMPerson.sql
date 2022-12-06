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
ALTER PROCEDURE [dbo].[SaveMPerson] (
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
DECLARE @matchPersonId int
DECLARE @matchGenderId int
	BEGIN TRY
        -- FIND ID
        IF (@PersonId IS NULL OR @PersonId <= 0)
        BEGIN
            SELECT @matchPersonId = PersonId 
                 , @matchGenderId = GenderId
              FROM MPerson 
             WHERE UPPER(LTRIM(RTRIM(FirstName))) = UPPER(LTRIM(RTRIM(@FirstName)))
               AND UPPER(LTRIM(RTRIM(LastName))) = UPPER(LTRIM(RTRIM(@LastName)))
            -- REPLACE ID IN CASE PartyName is EXISTS but not specificed Id when call this SP
            SET @PersonId = @matchPersonId
        END
        
        IF (@GenderId IS NULL OR @GenderId = 0) -- NULL OR NOT SPECIFICED GENDER
        BEGIN
            SELECT @matchGenderId = GenderId
              FROM MPerson 
             WHERE PersonId = @PersonId
                -- REPLACE ID IN CASE No GenderId but the EXISTS person already assign GenderId
                -- so need to preserve last GenderId
               SET @GenderId = @matchPersonId
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
               SET Prefix = LTRIM(RTRIM(COALESCE(@Prefix, Prefix)))
                 , FirstName = LTRIM(RTRIM(COALESCE(@FirstName, FirstName)))
                 , LastName = LTRIM(RTRIM(COALESCE(@LastName, LastName)))
                 , DOB = COALESCE(@DOB, DOB)
                 , GenderId = COALESCE(@GenderId, GenderId)
                 , EducationId = COALESCE(@EducationId, EducationId)
                 , OccupationId = COALESCE(@OccupationId, OccupationId)
                 , [Remark] = LTRIM(RTRIM(COALESCE(@Remark, Remark)))
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
