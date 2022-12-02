/****** Object:  StoredProcedure [dbo].[GetMProvinces]    Script Date: 12/2/2022 6:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMProvinces
-- [== History ==]
-- <2022-08-17> :
--	- Stored Procedure Created.
-- <2022-09-11> :
--	- Get more fields from view.
--
-- [== Example ==]
--
-- EXEC GetMProvinces NULL, NULL
-- =============================================
CREATE PROCEDURE [dbo].[GetMProvinces]
(
  @RegionId nvarchar(20) = NULL
, @ADM1Code nvarchar(20) = NULL
)
AS
BEGIN
	SELECT ProvinceId
	     , ProvinceNameTH
	     , ProvinceNameEN
	     , ADM1Code
	     , RegionId
		 , RegionName
		 , GeoGroup
		 , GeoSubGroup
		 , ProvinceAreaM2
	  FROM MProvinceView
	 WHERE UPPER(LTRIM(RTRIM(ADM1Code))) = UPPER(LTRIM(RTRIM(COALESCE(@ADM1Code, ADM1Code))))
	   AND (   UPPER(LTRIM(RTRIM(RegionId))) LIKE '%' + UPPER(LTRIM(RTRIM(COALESCE(@RegionId, RegionId)))) + '%'
            OR (RegionId IS NULL AND @RegionId IS NULL)
           )
	 ORDER BY ProvinceNameTH

END

GO
