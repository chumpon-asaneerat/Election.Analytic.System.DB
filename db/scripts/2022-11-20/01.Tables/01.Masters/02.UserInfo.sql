/****** UserInfo ******/ 
CREATE TABLE UserInfo(
	UserId int IDENTITY(1,1) NOT NULL,
	RoleId int NOT NULL,
	FullName nvarchar(200) NOT NULL,
	UserName nvarchar(100) NOT NULL,
	[Password] nvarchar(100) NOT NULL,
	Active int NOT NULL DEFAULT 1,
	LastUpdated datetime NOT NULL DEFAULT getdate(),
	CONSTRAINT PK_UserInfo PRIMARY KEY (UserId ASC)
)
GO

CREATE INDEX IX_UserInfo ON UserInfo(UserId ASC)
GO

CREATE UNIQUE INDEX IX_UserInfo_FullName ON UserInfo(FullName ASC)
GO

CREATE UNIQUE INDEX IX_UserInfo_UserName ON UserInfo(UserName ASC)
GO

ALTER TABLE UserInfo WITH CHECK
	ADD CONSTRAINT FK_UserInfo_UserRole FOREIGN KEY (RoleId) REFERENCES UserRole(RoleId)
GO

ALTER TABLE UserInfo CHECK CONSTRAINT FK_UserInfo_UserRole
GO
