-- RE INSERT
IF NOT EXISTS (SELECT * FROM MTitle WHERE [Description] = N'คุณ')
BEGIN
    INSERT INTO MTitle ([Description], GenderId) VALUES (N'คุณ', 0)
END

GO
