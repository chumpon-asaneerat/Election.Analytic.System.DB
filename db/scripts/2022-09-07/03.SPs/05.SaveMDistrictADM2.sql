/****** Object:  StoredProcedure [dbo].[SaveMDistrictADM2]    Script Date: 9/11/2022 8:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveMDistrictADM2
-- [== History ==]
-- <2022-09-11> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- SaveMDistrictADM2 N'สกลนคร', N'Sakon Nakhon', N'อากาศอำนวย', N'Akat Amnuai', N'TH4711', 661338974.564
-- =============================================
CREATE PROCEDURE [dbo].[SaveMDistrictADM2] (
  @ProvinceNameTH nvarchar(100)
, @ProvinceNameEN nvarchar(100)
, @DistrictNameTH nvarchar(100)
, @DistrictNameEN nvarchar(100)
, @ADM2Code nvarchar(20)
, @AreaM2 decimal(16, 3) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		IF (   @ProvinceNameTH IS NULL 
		    OR @ProvinceNameEN IS NULL 
			OR @DistrictNameTH IS NULL 
			OR @DistrictNameEN IS NULL
			OR @ADM2Code IS NULL)
		BEGIN
			SET @errNum = 100;
			SET @errMsg = 'Parameter some parameter(s) is null';
			RETURN
		END

		IF ((@DistrictNameEN IS NOT NULL)
		    AND 
			(@ADM2Code IS NOT NULL)
		   )
		BEGIN
			UPDATE MM
			   SET MM.DistrictNameEN = UPPER(LTRIM(RTRIM(@DistrictNameEN)))
				 , MM.ADM2Code = UPPER(LTRIM(RTRIM(@ADM2Code)))
				 , MM.AreaM2 = @AreaM2
			  FROM MDistrict MM 
			  JOIN MDistrictView MV ON 
			       (    
					    MM.DistrictId = MV.DistrictId 
				    AND MM.ProvinceId = MV.ProvinceId
				   )
			 WHERE UPPER(LTRIM(RTRIM(MV.ProvinceNameTH))) = UPPER(LTRIM(RTRIM(@ProvinceNameTH)))
			   AND UPPER(LTRIM(RTRIM(MV.DistrictNameTH))) = UPPER(LTRIM(RTRIM(@DistrictNameTH)))
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
