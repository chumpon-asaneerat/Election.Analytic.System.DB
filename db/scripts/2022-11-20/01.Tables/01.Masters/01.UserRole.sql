/****** UserRole ******/ 
CREATE TABLE UserRole (
	RoleId int NOT NULL,
	RoleName nvarchar(100) NOT NULL,
	CONSTRAINT PK_UserRole PRIMARY KEY (RoleId ASC)
)
GO

CREATE UNIQUE INDEX IX_UserRole_RoleName ON UserRole(RoleName ASC)
GO
