CREATE TABLE dbo.CUSTOMER
WITH 
(   
    CLUSTERED COLUMNSTORE INDEX,
    DISTRIBUTION = ROUND_ROBIN
)
AS
SELECT * FROM ext.CUSTOMER
GO;