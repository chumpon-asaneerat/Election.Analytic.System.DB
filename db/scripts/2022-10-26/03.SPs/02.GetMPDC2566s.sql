/****** Object:  StoredProcedure [dbo].[GetMPDC2566s]    Script Date: 10/26/2022 1:44:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMPDC2566s
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
ALTER PROCEDURE [dbo].[GetMPDC2566s]
(
  @ProvinceName nvarchar(100)
, @PollingUnitNo as int
, @FullName nvarchar(200) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
	BEGIN TRY
		SELECT A.ProvinceName
			 , A.PollingUnitNo
			 , A.CandidateNo
			 , A.FullName
			 , A.PrevPartyName
			 , A.EducationLevel
			 , A.Remark
			 , A.SubGroup
			 , IMG.FullName AS ImageFullName
			 , IMG.Data
             , A.ProvinceName AS ProvinceNameOri
             , A.PollingUnitNo AS PollingUnitNoOri
             , A.CandidateNo AS CandidateNoOri
             , A.FullName AS FullNameOri
		  FROM MPDC2566 A 
			   LEFT OUTER JOIN PersonImage IMG
               ON 
               (   
                   (IMG.FullName = A.FullName)
                OR (IMG.FullName LIKE '%' + A.FullName + '%')
                OR (A.FullName LIKE '%' + IMG.FullName + '%')
               )
		 WHERE A.ProvinceName = @ProvinceName
		   AND A.PollingUnitNo = @PollingUnitNo
		   AND A.FullName LIKE '%' + @FullName + '%'

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
