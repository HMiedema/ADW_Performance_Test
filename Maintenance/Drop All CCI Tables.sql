IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NATION]') AND type in (N'U'))
BEGIN
DROP TABLE [dbo].[NATION]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.REGION') AND type in (N'U'))
BEGIN
DROP TABLE dbo.REGION
END


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.PART') AND type in (N'U'))
BEGIN
DROP TABLE dbo.PART
END


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.PARTSUPP') AND type in (N'U'))
BEGIN
DROP TABLE dbo.PARTSUPP
END


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.CUSTOMER') AND type in (N'U'))
BEGIN
DROP TABLE dbo.CUSTOMER
END


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.ORDERS') AND type in (N'U'))
BEGIN
DROP TABLE dbo.ORDERS
END


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.LINEITEM') AND type in (N'U'))
BEGIN
DROP TABLE dbo.LINEITEM
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.SUPPLIER') AND type in (N'U'))
BEGIN
DROP TABLE dbo.SUPPLIER
END



