-- CREATE DEFAULT USER ROLES
INSERT INTO UserRole(RoleId, RoleName) VALUES(1, N'Admistrator');
INSERT INTO UserRole(RoleId, RoleName) VALUES(10, N'User');

-- CREATE DEFAULT USERS
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(1, N'Administrator', N'admin', N'admin');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(10, N'User 1', N'user1', N'123');
INSERT INTO UserInfo(RoleId, FullName, UserName, [Password]) VALUES(10, N'User 2', N'user2', N'123');
