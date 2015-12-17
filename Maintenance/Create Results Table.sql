IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Results]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Results](
    [Run] [varchar](256) NULL,
    [Run_Number] [int] NULL,
	[Step] [varchar](256) NULL,
	[Step_Action] [varchar](10) NULL,
	[Action_Time] [datetime] NULL,
	[Error_Flag] char(1) NULL,
	[Error_Message] varchar(4000) NULL
)
END