-- INSERT File Types
INSERT INTO MFileType(FileTypeId, [Description]) VALUES(1, N'Image');
INSERT INTO MFileType(FileTypeId, [Description]) VALUES(2, N'Data');
GO

-- INSERT File Sub Types
INSERT INTO MFileSubType(FileTypeId, FileSubTypeId, [Description]) VALUES(1, 1, N'Person');
INSERT INTO MFileSubType(FileTypeId, FileSubTypeId, [Description]) VALUES(1, 2, N'Logo');
INSERT INTO MFileSubType(FileTypeId, FileSubTypeId, [Description]) VALUES(2, 1, N'Json');
GO
