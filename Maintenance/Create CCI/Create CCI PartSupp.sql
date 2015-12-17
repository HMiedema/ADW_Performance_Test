CREATE TABLE dbo.PARTSUPP
WITH 
(   
    CLUSTERED COLUMNSTORE INDEX,
    DISTRIBUTION = ROUND_ROBIN
)
AS
SELECT * FROM ext.PARTSUPP
GO;