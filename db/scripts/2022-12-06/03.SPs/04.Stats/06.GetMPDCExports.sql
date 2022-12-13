/****** Object:  StoredProcedure [dbo].[GetMPDCExports]    Script Date: 12/13/2022 8:35:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDCExports
-- [== History ==]
-- <2022-09-29> :
--	- Stored Procedure Created.
-- <2022-10-07> :
--	- Supports Paging.
-- <2022-10-09> :
--	- Add FullNamne parameter.
-- <2022-10-30> :
--	- Change logic.
--	- Remove Paging.
--
-- [== Example ==]
--
-- =============================================
CREATE PROCEDURE [dbo].[GetMPDCExports]
(
  @ThaiYear int
, @ProvinceNameTH nvarchar(200) = NULL
, @PollingUnitNo as int = NULL
, @FullName nvarchar(MAX) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @sFullName nvarchar(MAX)
	BEGIN TRY
	    IF (@FullName IS NULL)
		BEGIN
			SET @sFullName = N'';
		END
		ELSE 
		BEGIN
			SET @sFullName = @FullName;
		END

		SELECT ThaiYear
             , ProvinceNameTH
			 , ADM1Code
			 , PollingUnitNo
			 , CandidateNo
             , PersonId
			 , FullName
             , PrevPartyId
			 , PartyName AS PrevPartyName
			 , EducationName
			 , CandidateRemark
			 , CandidateSubGroup
		  FROM MPDCView 
		 WHERE ThaiYear = @ThaiYear
           AND UPPER(LTRIM(RTRIM(ProvinceNameTH))) = UPPER(LTRIM(RTRIM(COALESCE(@ProvinceNameTH, ProvinceNameTH))))
		   AND PollingUnitNo = COALESCE(@PollingUnitNo, PollingUnitNo)
		   AND UPPER(LTRIM(RTRIM(FullName))) LIKE '%' + UPPER(LTRIM(RTRIM(@sFullName))) + '%'

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
