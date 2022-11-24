-- CREATE DEFAULT USER ROLES
INSERT INTO UserRole(RoleId, RoleName) VALUES(1, N'Admistrator');
INSERT INTO UserRole(RoleId, RoleName) VALUES(10, N'Supervisor');
INSERT INTO UserRole(RoleId, RoleName) VALUES(20, N'User');
GO

-- CREATE DEFAULT USERS
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(1, N'Administrator', N'admin', N'admin');

INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(10, N'Supervisor 1', N'sup1', N'123');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(10, N'Supervisor 2', N'sup2', N'123');

INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(20, N'User 1', N'user1', N'123');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(20, N'User 2', N'user2', N'123');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(20, N'User 3', N'user3', N'123');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(20, N'User 4', N'user4', N'123');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(20, N'User 5', N'user5', N'123');
GO
