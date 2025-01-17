USE [XDPortal]
GO
/****** Object:  User [dexter]    Script Date: 03/23/2012 10:10:02 ******/
CREATE USER [dexter] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  StoredProcedure [dbo].[spSelectEventWeekViewBeginAndEndDate]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectEventWeekViewBeginAndEndDate]

@Year int,
@WeekNumber int

AS
BEGIN

	SET NOCOUNT ON;

    DECLARE @LowDate DATETIME
	DECLARE @HighDate DATETIME
	SET @LowDate = cast(cast('1/1'as varchar) + '/' + cast(@Year as varchar) as datetime)
	SET @HighDate = cast(cast('12/31' as varchar) + '/' + cast(@Year as varchar) as datetime)

	DECLARE @DateTable TABLE (date datetime)
	INSERT INTO @DateTable (date)
	SELECT DISTINCT DATEADD(dd, Days.Row, DATEADD(mm, Months.Row, DATEADD(yy, Years.Row, @LowDate))) AS Date
	FROM
	(SELECT 0 AS Row UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
	 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
	 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14
	 UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19
	 UNION ALL SELECT 20
	) AS Years
	INNER JOIN
	(SELECT 0 AS Row UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
	 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
	 UNION ALL SELECT 10 UNION ALL SELECT 11
	) AS Months
	ON DATEADD(mm, Months.Row,  DATEADD(yy, Years.Row, @LowDate)) <= @HighDate 
	INNER JOIN
	(SELECT 0 AS Row UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
	 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
	 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14
	 UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19
	 UNION ALL SELECT 20 UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24
	 UNION ALL SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29
	 UNION ALL SELECT 30
	) AS Days
	ON DATEADD(dd, Days.Row, DATEADD(mm, Months.Row,  DATEADD(yy, Years.Row, @LowDate))) <= @HighDate
	WHERE DATEADD(yy, Years.Row, @LowDate) <= @HighDate
	ORDER BY 1


	DECLARE @WeekBegindate datetime
	DECLARE @WeekEnddate datetime

	SET @WeekBegindate = (SELECT TOP 1 date FROM @DateTable
	WHERE DATEPART(YY, [date]) = @Year
	AND DATEPART(WK, [date]) = @WeekNumber
	ORDER BY date ASC)

	SET @WeekEnddate = (SELECT TOP 1 date FROM @DateTable
	WHERE DATEPART(YY, [date]) = @Year
	AND DATEPART(WK, [date]) = @WeekNumber
	ORDER BY date DESC)


    SELECT @WeekBegindate as WeekBegindate, @WeekEnddate as WeekEnddate  

END
GO
/****** Object:  Table [dbo].[WhosOnline]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WhosOnline](
	[UserName] [nvarchar](100) NULL,
	[UserIP] [nvarchar](40) NULL,
	[DateCreated] [datetime] NULL,
	[LastDateChecked] [datetime] NULL,
	[CheckedIn] [datetime] NULL,
	[LastChecked] [datetime] NULL,
	[PageBrowse] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[GetLastArticleID]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <6/6/2005>
-- Description:	<Return last submitted article ID>
-- =============================================
CREATE PROCEDURE [dbo].[GetLastArticleID] 

AS
BEGIN

	SET NOCOUNT ON;

    SELECT IDENT_CURRENT('Cooking_Article') As Col

END
GO
/****** Object:  Table [dbo].[UserSuspenionLog]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserSuspenionLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UID] [int] NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[Note] [varchar](500) NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_UserSuspenionLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[usersmain]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[usersmain](
	[UID] [int] IDENTITY(1,1) NOT NULL,
	[UserLevel] [int] NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Country] [varchar](50) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[DOB] [datetime] NULL,
	[AboutMe] [varchar](1000) NULL,
	[FavoriteFoods1] [varchar](50) NULL,
	[FavoriteFoods2] [varchar](50) NULL,
	[FavoriteFoods3] [varchar](50) NULL,
	[NewsLetter] [int] NOT NULL,
	[DateJoined] [datetime] NOT NULL,
	[Photo] [varchar](50) NULL,
	[Website] [varchar](100) NULL,
	[Hits] [int] NOT NULL,
	[LastVisit] [datetime] NULL,
	[LastUpdated] [datetime] NULL,
	[ContactMe] [int] NULL,
	[isActive] [int] NOT NULL,
	[GUID] [varchar](100) NOT NULL,
	[ReceivePM] [int] NULL,
	[PMEmailNotification] [int] NULL,
	[Activation] [int] NOT NULL,
	[ShowFriendsListinProfile] [int] NOT NULL,
	[ShowCookBookinProfile] [int] NOT NULL,
	[NumRecordsCookBookQuickView] [int] NOT NULL,
	[NumRecordsFriendsList] [int] NOT NULL,
	[PreferredLayout] [int] NULL,
	[PreferredPageSize] [int] NULL,
	[IsUserChoosePreferredLayout] [int] NULL,
	[IsFirsTimeLogin] [int] NULL,
 CONSTRAINT [PK_usersmain] PRIMARY KEY CLUSTERED 
(
	[UID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [pass] ON [dbo].[usersmain] 
(
	[Password] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [uname] ON [dbo].[usersmain] 
(
	[UserName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usersadmin]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usersadmin](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[uname] [nvarchar](25) NOT NULL,
	[password] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NULL,
	[Role] [nvarchar](25) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_usersadmin] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ID] ON [dbo].[usersadmin] 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [pass] ON [dbo].[usersadmin] 
(
	[password] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Uname] ON [dbo].[usersadmin] 
(
	[uname] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'17' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'⿍钪穱䯣꒻閄訅' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'users' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'龼쒳馘乡㮼뒩ꆤ�' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'uname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'25' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'uname' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'users' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'uname'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'즅㖅උ䛌ﱫ遁' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'password' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'50' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'password' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'users' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin', @level2type=N'COLUMN',@level2name=N'password'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin'
GO
EXEC sys.sp_addextendedproperty @name=N'DateCreated', @value=N'9/7/2004 3:17:47 AM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin'
GO
EXEC sys.sp_addextendedproperty @name=N'LastUpdated', @value=N'6/19/2005 12:42:08 PM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'users' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin'
GO
EXEC sys.sp_addextendedproperty @name=N'OrderByOn', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin'
GO
EXEC sys.sp_addextendedproperty @name=N'Orientation', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin'
GO
EXEC sys.sp_addextendedproperty @name=N'RecordCount', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin'
GO
EXEC sys.sp_addextendedproperty @name=N'Updatable', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usersadmin'
GO
/****** Object:  Table [dbo].[userCookBook]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[userCookBook](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UID] [int] NOT NULL,
	[RecipeID] [int] NOT NULL,
	[RecipeName] [varchar](100) NOT NULL,
	[Hits] [int] NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_userCookBook] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [UID] ON [dbo].[userCookBook] 
(
	[UID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RecipeUpdateLog]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecipeUpdateLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RID] [int] NOT NULL,
	[UID] [int] NOT NULL,
	[DateUpdated] [datetime] NOT NULL,
 CONSTRAINT [PK_UpdatedRecipeLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Recipes]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Recipes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CAT_ID] [int] NOT NULL,
	[Category] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Author] [nvarchar](50) NOT NULL,
	[Ingredients] [nvarchar](1000) NOT NULL,
	[Instructions] [nvarchar](2000) NOT NULL,
	[Date] [datetime] NOT NULL,
	[HOMEPAGE] [nvarchar](100) NULL,
	[LINK_APPROVED] [int] NOT NULL,
	[HITS] [int] NOT NULL,
	[RATING] [int] NOT NULL,
	[NO_RATES] [int] NOT NULL,
	[TOTAL_COMMENTS] [int] NOT NULL,
	[HIT_DATE] [datetime] NULL,
	[RecipeImage] [varchar](50) NULL,
	[UID] [int] NOT NULL,
	[upsize_ts] [timestamp] NULL,
 CONSTRAINT [PK_Recipes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [ID] ON [dbo].[Recipes] 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'17' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'䓈뽦䓋붜ባ䐁' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Recipes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'DefaultValue', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'촺ῡ䌊亯֕⟄亐㜣' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'CAT_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'CAT_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Recipes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'CAT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'〼䴬띳䂳蚳ఔꁠ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Category' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'50' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Category' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Recipes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'苯�੨么躌Ḟ槟' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'150' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Recipes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Name'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'쵀㖾Ρ䂶邖ҟ쁷穹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Author' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'50' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Author' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Recipes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Author'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'죤�臨䴖⼙쪸অ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Ingredients' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Ingredients' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Recipes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'12' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Ingredients'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'꧝毳糘䅞ಫῧᘄ䐽' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Instructions' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'6' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Instructions' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Recipes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'12' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Instructions'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'DefaultValue', @value=N'Date()' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'�ၙ賓䲈斔뚢稑' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'7' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Recipes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'Date'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'DefaultValue', @value=N'"N/A"' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'ᛑꙝ咙䋵抛砌嶍켜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'HOMEPAGE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'HOMEPAGE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Recipes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HOMEPAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'DefaultValue', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'倠䄺侴䁫⚙퀈㼯Ⲿ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'LINK_APPROVED' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'9' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'LINK_APPROVED' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Recipes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'LINK_APPROVED'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'DefaultValue', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'첼㇢ﶭ䘎ꆔЬ쑼�' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'HITS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'HITS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Recipes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HITS'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'DefaultValue', @value=N'5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'붢ﳇ倀䈧㒦ל�轳' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'RATING' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'11' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'RATING' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Recipes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'RATING'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'DefaultValue', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'삔问ᜧ䷛骢๚�㍟' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'NO_RATES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'12' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'NO_RATES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Recipes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'NO_RATES'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'DefaultValue', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'幒튮䨿膉㜭࠵앎' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'TOTAL_COMMENTS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'13' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'TOTAL_COMMENTS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Recipes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'TOTAL_COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'묽焮텶䛥늝쨇闔瀀' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'HIT_DATE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'14' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'HIT_DATE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Recipes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes', @level2type=N'COLUMN',@level2name=N'HIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes'
GO
EXEC sys.sp_addextendedproperty @name=N'DateCreated', @value=N'7/18/2005 11:33:47 PM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes'
GO
EXEC sys.sp_addextendedproperty @name=N'LastUpdated', @value=N'5/17/2008 8:38:48 AM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Recipes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes'
GO
EXEC sys.sp_addextendedproperty @name=N'OrderByOn', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes'
GO
EXEC sys.sp_addextendedproperty @name=N'Orientation', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes'
GO
EXEC sys.sp_addextendedproperty @name=N'RecordCount', @value=N'1307' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes'
GO
EXEC sys.sp_addextendedproperty @name=N'Updatable', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Recipes'
GO
/****** Object:  Table [dbo].[RECIPE_CAT]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RECIPE_CAT](
	[CAT_ID] [int] IDENTITY(1,1) NOT NULL,
	[CAT_TYPE] [nvarchar](70) NULL,
	[GROUPCAT] [int] NULL,
 CONSTRAINT [PK_RECIPE_CAT] PRIMARY KEY CLUSTERED 
(
	[CAT_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PrivateMessageSentMessages]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PrivateMessageSentMessages](
	[M_ID] [int] IDENTITY(1,1) NOT NULL,
	[M_Subject] [nvarchar](50) NOT NULL,
	[M_From] [int] NOT NULL,
	[M_To] [int] NOT NULL,
	[M_Sent] [datetime] NOT NULL,
	[PM_Message] [varchar](max) NOT NULL,
	[M_Read] [int] NOT NULL,
	[M_OutBox] [int] NOT NULL,
	[M_mail] [int] NOT NULL,
 CONSTRAINT [PK_PrivateMessageSentMessages] PRIMARY KEY CLUSTERED 
(
	[M_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [M_From] ON [dbo].[PrivateMessageSentMessages] 
(
	[M_From] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [M_Read] ON [dbo].[PrivateMessageSentMessages] 
(
	[M_Read] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [M_To] ON [dbo].[PrivateMessageSentMessages] 
(
	[M_To] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PrivateMessageBlockedUsers]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrivateMessageBlockedUsers](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UID] [int] NOT NULL,
	[BlockedUID] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_PrivateMessageBlockedUsers] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PrivateMessage]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PrivateMessage](
	[M_ID] [int] IDENTITY(1,1) NOT NULL,
	[M_Subject] [nvarchar](50) NOT NULL,
	[M_From] [int] NOT NULL,
	[M_To] [int] NOT NULL,
	[M_Sent] [datetime] NOT NULL,
	[PM_Message] [varchar](max) NOT NULL,
	[M_Read] [int] NOT NULL,
	[M_OutBox] [int] NOT NULL,
	[M_mail] [int] NOT NULL,
	[isTrash] [int] NOT NULL,
 CONSTRAINT [PK_PrivateMessage] PRIMARY KEY CLUSTERED 
(
	[M_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [M_From] ON [dbo].[PrivateMessage] 
(
	[M_From] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [M_Read] ON [dbo].[PrivateMessage] 
(
	[M_Read] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [M_To] ON [dbo].[PrivateMessage] 
(
	[M_To] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExceptionLog]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ExceptionLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[URL] [varchar](100) NULL,
	[Exception] [varchar](2000) NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_ExceptionLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Events]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Events](
	[EVENT_ID] [int] IDENTITY(1,1) NOT NULL,
	[DATE_ADDED] [datetime] NOT NULL,
	[START_DATE] [datetime] NOT NULL,
	[CATEGORY] [varchar](50) NULL,
	[END_DATE] [datetime] NOT NULL,
	[EVENT_TITLE] [nvarchar](100) NOT NULL,
	[EVENT_DETAILS] [nvarchar](1000) NULL,
	[APPMEETING_STARTTIME] [varchar](20) NULL,
	[APPMEETING_ENDTIME] [varchar](20) NULL,
	[UID] [int] NOT NULL,
	[PRIVATE] [int] NOT NULL,
 CONSTRAINT [PK_Events] PRIMARY KEY CLUSTERED 
(
	[EVENT_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [Category] ON [dbo].[Events] 
(
	[CATEGORY] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Category2] ON [dbo].[Events] 
(
	[CATEGORY] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Category3] ON [dbo].[Events] 
(
	[START_DATE] ASC,
	[CATEGORY] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [startdate] ON [dbo].[Events] 
(
	[START_DATE] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [startdate2] ON [dbo].[Events] 
(
	[START_DATE] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeletedUserLog]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeletedUserLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UID] [int] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Reason] [nvarchar](250) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_DeletedUserLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cooking_Article_Category]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cooking_Article_Category](
	[CAT_ID] [int] IDENTITY(1,1) NOT NULL,
	[CAT_NAME] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Article_Category] PRIMARY KEY CLUSTERED 
(
	[CAT_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cooking_Article]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cooking_Article](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CAT_ID] [int] NOT NULL,
	[Title] [nvarchar](100) NOT NULL,
	[Post_Date] [datetime] NOT NULL,
	[Content] [varchar](8000) NOT NULL,
	[Hits] [int] NOT NULL,
	[Author] [nvarchar](100) NOT NULL,
	[Keyword] [nvarchar](255) NOT NULL,
	[Show] [int] NOT NULL,
	[No_Rating] [int] NOT NULL,
	[No_Rates] [int] NOT NULL,
	[Summary] [nvarchar](500) NOT NULL,
	[Total_Comments] [int] NOT NULL,
	[UID] [int] NOT NULL,
	[Update_date] [datetime] NOT NULL,
 CONSTRAINT [PK_Article] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [UID] ON [dbo].[Cooking_Article] 
(
	[UID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConfigureLastViewedHours]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConfigureLastViewedHours](
	[Hourspan] [int] NOT NULL
) ON [PRIMARY]
GO
INSERT [dbo].[ConfigureLastViewedHours] ([Hourspan]) VALUES (240)
/****** Object:  Table [dbo].[Configuration]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Configuration](
	[HideShowComment] [int] NOT NULL,
	[HideShowArticleComment] [int] NOT NULL,
	[NumberOfrecipeInCookBook] [int] NOT NULL,
	[NumberOfFriendsInFriendsList] [int] NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[SmtpServer] [varchar](50) NOT NULL,
	[PublicPrivateProfile] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[Configuration] ([HideShowComment], [HideShowArticleComment], [NumberOfrecipeInCookBook], [NumberOfFriendsInFriendsList], [Email], [SmtpServer], [PublicPrivateProfile]) VALUES (1, 1, 50, 50, N'Admin@yahoo.com', N'Webdeveloper@yahoo.com', 1)
/****** Object:  Table [dbo].[COMMENTS_RECIPE]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COMMENTS_RECIPE](
	[COM_ID] [int] IDENTITY(1,1) NOT NULL,
	[ID] [int] NOT NULL,
	[AUTHOR] [nvarchar](60) NOT NULL,
	[EMAIL] [nvarchar](60) NOT NULL,
	[COMMENTS] [nvarchar](350) NOT NULL,
	[DATE] [datetime] NOT NULL,
	[UID] [int] NOT NULL,
	[upsize_ts] [timestamp] NULL,
 CONSTRAINT [PK_COMMENTS_RECIPE] PRIMARY KEY CLUSTERED 
(
	[COM_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ID] ON [dbo].[COMMENTS_RECIPE] 
(
	[COM_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UID] ON [dbo].[COMMENTS_RECIPE] 
(
	[UID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'17' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'轳Ö齀䔙ꮪ㡈뽹熂' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'COM_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'COM_ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'COMMENTS_RECIPE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'DefaultValue', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'냨Ծ�䗟龜⻼㚳줰' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DecimalPlaces', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'COMMENTS_RECIPE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'穼殳�䵁窞贠肐⇰' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'AUTHOR' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'60' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'AUTHOR' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'COMMENTS_RECIPE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'AUTHOR'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'험쏁⋠䇵ꮐ뉕⽁' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'EMAIL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'50' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'EMAIL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'COMMENTS_RECIPE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'믗粧㯘䫪溳깼ʏ쥾' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'COMMENTS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'COMMENTS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'COMMENTS_RECIPE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'12' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'COMMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'DefaultValue', @value=N'Date()' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'GUID', @value=N'Ꙑ撺隇䋨⮡ை湛阞' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'DATE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'6' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'DATE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'COMMENTS_RECIPE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE', @level2type=N'COLUMN',@level2name=N'DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE'
GO
EXEC sys.sp_addextendedproperty @name=N'DateCreated', @value=N'9/7/2004 3:16:05 AM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE'
GO
EXEC sys.sp_addextendedproperty @name=N'LastUpdated', @value=N'7/16/2005 10:37:45 AM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE'
GO
EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'COMMENTS_RECIPE' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE'
GO
EXEC sys.sp_addextendedproperty @name=N'OrderByOn', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE'
GO
EXEC sys.sp_addextendedproperty @name=N'Orientation', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE'
GO
EXEC sys.sp_addextendedproperty @name=N'RecordCount', @value=N'8' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE'
GO
EXEC sys.sp_addextendedproperty @name=N'Updatable', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMMENTS_RECIPE'
GO
/****** Object:  Table [dbo].[COMMENTS_ARTICLE]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COMMENTS_ARTICLE](
	[COM_ID] [int] IDENTITY(1,1) NOT NULL,
	[ID] [int] NOT NULL,
	[Author] [nvarchar](60) NOT NULL,
	[Email] [nvarchar](60) NOT NULL,
	[Comments] [nvarchar](350) NOT NULL,
	[Date] [datetime] NOT NULL,
	[UID] [int] NOT NULL,
 CONSTRAINT [PK_COMMENTS_ARTICLE] PRIMARY KEY CLUSTERED 
(
	[COM_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ID] ON [dbo].[COMMENTS_ARTICLE] 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UID] ON [dbo].[COMMENTS_ARTICLE] 
(
	[UID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ArticleUpdateLog]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArticleUpdateLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AID] [int] NOT NULL,
	[UID] [int] NOT NULL,
	[DateUpdated] [datetime] NULL,
 CONSTRAINT [PK_ArticleUpdateLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FriendsList]    Script Date: 03/23/2012 10:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FriendsList](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UID] [int] NOT NULL,
	[FriendID] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[IsApproved] [int] NOT NULL,
 CONSTRAINT [PK_FriendsList] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [UID] ON [dbo].[FriendsList] 
(
	[UID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[fnValidateRatingValue]    Script Date: 03/23/2012 10:10:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnValidateRatingValue]
(
	@Rating int
)
RETURNS int
AS
BEGIN
	
    DECLARE @RatingValue int

	IF (@Rating = '' OR @Rating <= 0 OR @Rating > 5)
		BEGIN
		 SET @RatingValue = 3
		END
	ELSE
		BEGIN
		 SET @RatingValue = @Rating
		END

	RETURN @RatingValue

END
GO
/****** Object:  UserDefinedFunction [dbo].[fnConvertCSVToINT]    Script Date: 03/23/2012 10:10:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Dexter Zafra
-- Create date: 5/15/2009
-- Description:	Convert a CSV value to INT - This is use when performing batch/multiple delete.
-- =============================================

/***********************************************
* Samplae usage:
* DECLARE @CSV varchar(100)
* SET @CSV = '1,2,3,4,5,6,7,8,9,10'
* SELECT * from dbo.fnConvertCSVToINT(@CSV)
***********************************************/

CREATE FUNCTION [dbo].[fnConvertCSVToINT] 
( 
	@CSVArray varchar(5000)
) 
	RETURNS @Table Table (ID int)
AS

BEGIN

	DECLARE @separator char(1)
	SET @separator = ','

	DECLARE @pos int 
	DECLARE @arrvalue varchar(1000) 
	
	SET @CSVArray = @CSVArray + ','
	
	WHILE PATINDEX('%,%' , @CSVArray) <> 0 
	BEGIN
	  	SELECT @pos =  PATINDEX('%,%' , @CSVArray)
	  	SELECT @arrvalue = LEFT(@CSVArray, @pos - 1)
	
		INSERT @Table
		VALUES (CAST(@arrvalue AS int))

	  	SELECT @CSVArray = STUFF(@CSVArray, 1, @pos, '')
	END

	RETURN

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateNumRecordsFriendsListProfile]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateNumRecordsFriendsListProfile] 

@UserID int,
@NewValue int

AS
BEGIN

	SET NOCOUNT ON;

    UPDATE dbo.usersmain SET NumRecordsFriendsList = @NewValue
    WHERE [UID] = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateNumRecordsCookBookProfile]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateNumRecordsCookBookProfile] 

@UserID int,
@NewValue int

AS
BEGIN

	SET NOCOUNT ON;

    UPDATE dbo.usersmain SET NumRecordsCookBookQuickView = @NewValue
    WHERE [UID] = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateMarkPMUnreadOrRead]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateMarkPMUnreadOrRead]

@UserID int,
@ID int,
@Val int

AS
BEGIN

	SET NOCOUNT ON;

UPDATE dbo.PrivateMessage SET M_Read = @Val 
WHERE M_ID = @ID AND M_To = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateMarkedPMOldMsgViaAJAX]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateMarkedPMOldMsgViaAJAX] 

@PMID int,
@UserID int 

AS
BEGIN

SET NOCOUNT ON;

UPDATE dbo.PrivateMessage SET M_Read = 1 WHERE M_ID = @PMID AND M_To = @UserID;

UPDATE dbo.PrivateMessageSentMessages SET M_Read = 1 WHERE M_ID = @PMID AND M_To = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateLastVisit]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateLastVisit]

@UserID int

AS
BEGIN

UPDATE dbo.usersmain
SET LastVisit = GETDATE()
WHERE [UID] = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateConfigNumberOfRecordsInFriendsListAdmin]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateConfigNumberOfRecordsInFriendsListAdmin]

@NumRecords int

AS
BEGIN

	SET NOCOUNT ON;

	UPDATE dbo.Configuration SET NumberOfFriendsInFriendsList = @NumRecords

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateConfigNumberOfRecordsInCookBookAdmin]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateConfigNumberOfRecordsInCookBookAdmin]

@NumRecords int

AS
BEGIN

	SET NOCOUNT ON;

	UPDATE dbo.Configuration SET NumberOfrecipeInCookBook = @NumRecords

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateArticleCommentConfiguration]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateArticleCommentConfiguration]

@Val int

AS
BEGIN

	SET NOCOUNT ON;

	UPDATE dbo.Configuration SET HideShowArticleComment = @Val

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateArticle]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <6/5/2008>
-- Description:	<Update article>
-- =============================================
CREATE PROCEDURE [dbo].[spUpdateArticle]

@UserID int,
@AID int,
@Title varchar(200),
@Content varchar(8000),
@CAT_ID int,
@Keyword varchar(100),
@Summary varchar(500)

AS

DECLARE @ErrorCode int

BEGIN

--Make sure it belongs to the right owner.
IF Exists (SELECT ID FROM dbo.Cooking_Article WHERE [UID] = @UserID AND ID = @AID)

BEGIN

	IF (@Cat_Id = 0)

		BEGIN

			UPDATE Cooking_Article SET 
								   Title = @Title,
								   [Content] = @Content,
								   Keyword = @Keyword,
								   Summary = @Summary,
								   Update_date = getdate()
								   WHERE [UID] = @UserID AND ID = @AID
		END

	ELSE

		BEGIN

			UPDATE Cooking_Article SET 
								   Title = @Title,
								   [Content] = @Content,
								   CAT_ID = @CAT_ID,
								   Keyword = @Keyword,
								   Summary = @Summary,
								   Update_date = getdate()
								   WHERE [UID] = @UserID AND ID = @AID

		END

--Insert Article Update Log
INSERT INTO dbo.ArticleUpdateLog(AID, [UID], DateUpdated) VALUES(@AID, @UserID, GETDATE())

END

SET @ErrorCode = @@error
		
END

RETURN @ErrorCode
GO
/****** Object:  StoredProcedure [dbo].[spUdateApprovedAFriend]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUdateApprovedAFriend]

@UserID int,
@ID int 

AS
BEGIN

	SET NOCOUNT ON;

	UPDATE dbo.FriendsList SET IsApproved = 1
	WHERE ID = @ID AND FriendID = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSuspendUserWithNote]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSuspendUserWithNote] 

@UserID int,
@Type varchar(50),
@Note varchar(500)

AS
BEGIN

SET NOCOUNT ON;

IF Exists (SELECT [UID] FROM dbo.usersmain WITH (NOLOCK) WHERE [UID] = @UserID)

	BEGIN

		--Update status
		UPDATE dbo.usersmain SET isActive = 0 WHERE [UID] = @UserID;

	   --Insert suspension note
		INSERT INTO dbo.UserSuspenionLog ([UID], [Type], Note, Date)
		VALUES (@UserID, @Type, @Note, GETDATE())

	END

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectWhoAddsMeInFriendsList]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectWhoAddsMeInFriendsList]

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT TOP 5 fl.UID, 
				u.UserName, 
				fl.Date 
	FROM 
		dbo.FriendsList fl WITH (NOLOCK)
	INNER JOIN 
		dbo.usersmain u WITH (NOLOCK)
	ON
		fl.UID = u.UID
	WHERE 
		fl.FriendID = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectViewUsersRecipeSavedPublishedByMe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectViewUsersRecipeSavedPublishedByMe]

@PublisherID int,
@UserIDWhoSaved int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT TOP 25 ucb.RecipeID, 
				ucb.RecipeName, 
				ucb.Date 
	FROM 
		dbo.userCookBook ucb WITH (NOLOCK)
	INNER JOIN
		dbo.Recipes r WITH (NOLOCK)
	ON
		ucb.RecipeID = r.ID
	WHERE 
		r.UID = @PublisherID AND ucb.UID = @UserIDWhoSaved

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectViewSuspenionNoteByuserID]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectViewSuspenionNoteByuserID]

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Type], 
			Note, 
			Date 
	FROM 
		dbo.UserSuspenionLog WITH (NOLOCK) 
	WHERE 
		[UID] = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectViewDeleteduserLog]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectViewDeleteduserLog]

AS
BEGIN

	SET NOCOUNT ON;

	SELECT [UID], 
			UserName, 
			Reason, 
			CreatedDate 
	FROM 
		dbo.DeletedUserLog WITH (NOLOCK)
	ORDER BY CreatedDate DESC

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectUsersWhoSavedThisRecipeInCookBook]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Get top 5 users who saved this recipe in their Cookbook
CREATE PROCEDURE [dbo].[spSelectUsersWhoSavedThisRecipeInCookBook] 

@RecipeID int

AS
BEGIN

SELECT TOP 5 u.UID, 
            u.UserName,
			(
			   SELECT COUNT(Distinct [UID]) 
               FROM 
                  dbo.userCookBook ucb WITH (NOLOCK) 
               WHERE 
                  RecipeID = @RecipeID) TotalCount
		FROM  
			dbo.usersmain u WITH (NOLOCK)
        INNER JOIN 
		(
		   SELECT Distinct [UID] 
           FROM 
              dbo.userCookBook ucb WITH (NOLOCK) 
           WHERE 
           RecipeID = @RecipeID
        ) b
       ON 
		  u.UID = b.UID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectUserStatus]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectUserStatus]

@Username varchar(50),
@UserPassword varchar(50) 

AS
BEGIN

	SELECT isActive 
	FROM 
		dbo.usersmain WITH (NOLOCK) 
	WHERE 
		UserName = @Username AND [Password] = @UserPassword 

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectUsersrecipeInCookBook]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectUsersrecipeInCookBook]

@UserID int,
@NumRecords int

AS
BEGIN

	SET ROWCOUNT @NumRecords

	DECLARE @Counter int
	SELECT @Counter = Count(*) FROM dbo.userCookBook WITH (NOLOCK) WHERE [UID] = @UserID

	SELECT ucb.ID, 
		   ucb.[UID], 
		   ucb.RecipeID, 
		   ucb.RecipeName, 
		   r.Hits, 
		   ucb.Date, 
		   @Counter as TotalCount,
		   r.Author,
		   r.Category,
		   r.TOTAL_COMMENTS,
		   CAST((1.0 * r.RATING/r.NO_RATES) as decimal(2,1)) as Rates,
		   COALESCE(NULLIF(r.RecipeImage, ''), 'noimageavailable.gif') as RecipeImage
	FROM 
	   dbo.userCookBook ucb WITH (NOLOCK) 
	INNER JOIN
	   dbo.Recipes r WITH (NOLOCK)
	ON
	   ucb.RecipeID = r.ID
	WHERE 
		ucb.[UID] = @UserID
	ORDER BY ucb.Date DESC

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectUsersFeaturesConfiguration]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectUsersFeaturesConfiguration]

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT NumRecordsFriendsList, 
		   NumRecordsCookBookQuickView,
		   PreferredLayout, 
		   PreferredPageSize, 
		   IsUserChoosePreferredLayout,
		   ReceivePM,
		   PMEmailNotification
	FROM 
		dbo.usersmain WITH (NOLOCK) 
	WHERE 
		[UID] = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectUsersCookBookMain]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectUsersCookBookMain]

@UserID int,
@OrderBy int = '',
@SortBy int = '',
@PageIndex int = 1,
@PageSize int = 20

AS
BEGIN

DECLARE @StartRow int
DECLARE @EndRow int

SET @StartRow = (@PageSize * (@PageIndex - 1))  + 1  
SET @EndRow = @PageSize * @PageIndex + 1

DECLARE @Counter int
SELECT @Counter = Count(*) FROM dbo.userCookBook WITH (NOLOCK) WHERE [UID] = @UserID

SET NOCOUNT ON;

WITH CookBook AS
	(
		SELECT
		   ROW_NUMBER() OVER 
			 (
       -- Dynamic bidirectional sorting
        ORDER BY 
              CASE WHEN @OrderBy = 1 AND @SortBy = 1 THEN r.Hits END DESC,
              CASE WHEN @OrderBy = 1 AND @SortBy = '' THEN r.Hits END DESC,
              CASE WHEN @OrderBy = 1 AND @SortBy = 2 THEN r.Hits END ASC,
              CASE WHEN @OrderBy = 2 AND @SortBy = 2 THEN r.NO_RATES END ASC,
              CASE WHEN @OrderBy = 2 AND @SortBy = '' THEN r.NO_RATES END ASC,
              CASE WHEN @OrderBy = 2 AND @SortBy = 1 THEN r.NO_RATES END DESC,
              CASE WHEN @OrderBy = 3 AND @SortBy = 2 THEN ucb.RecipeName END ASC,
              CASE WHEN @OrderBy = 3 AND @SortBy = '' THEN ucb.RecipeName END ASC,
              CASE WHEN @OrderBy = 3 AND @SortBy = 1 THEN ucb.RecipeName END DESC,
              CASE WHEN @OrderBy = 4 AND @SortBy = 1 OR @OrderBy = '' THEN ucb.Date END DESC,
              CASE WHEN @OrderBy = 4 AND @SortBy = '' OR @OrderBy = '' THEN ucb.Date END DESC,
              CASE WHEN @OrderBy = 4 AND @SortBy = 2 THEN ucb.Date END ASC
			 ) AS RowNumber, 
				   ucb.ID, 
				   ucb.[UID], 
				   ucb.RecipeID, 
				   ucb.RecipeName, 
				   r.Hits, 
				   ucb.Date, 
				   @Counter as TotalCount,
				   r.Author,
				   r.Category,
				   r.TOTAL_COMMENTS,
				   CAST((1.0 * r.RATING/r.NO_RATES) as decimal(2,1)) as Rates,
				   COALESCE(NULLIF(r.RecipeImage, ''), 'noimageavailable.gif') as RecipeImage
			FROM 
			   dbo.userCookBook ucb WITH (NOLOCK) 
			INNER JOIN
			   dbo.Recipes r WITH (NOLOCK)
			ON
			   ucb.RecipeID = r.ID
			WHERE 
			   ucb.[UID] = @UserID
	)
	-- Statement that executes the CTE
	SELECT a.*
	FROM
		  CookBook a
	WHERE
		  a.RowNumber BETWEEN @StartRow AND @EndRow - 1
	ORDER BY
		  a.RowNumber


END
GO
/****** Object:  StoredProcedure [dbo].[spSelectUsersCookBook]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectUsersCookBook]

@UserID int

AS
BEGIN

	DECLARE @NumRecords int

	SELECT @NumRecords = NumberOfrecipeInCookBook FROM dbo.Configuration WITH (NOLOCK)

	SET ROWCOUNT @NumRecords

	DECLARE @Counter int
	SELECT @Counter = Count(*) FROM dbo.userCookBook WITH (NOLOCK) WHERE [UID] = @UserID

	SELECT ucb.ID, 
		   ucb.[UID], 
		   ucb.RecipeID, 
		   ucb.RecipeName, 
		   r.Hits, 
		   ucb.Date, 
		   @Counter as TotalCount,
		   r.Author,
		   r.Category,
		   r.TOTAL_COMMENTS,
		   CAST((1.0 * r.RATING/r.NO_RATES) as decimal(2,1)) as Rates,
		   COALESCE(NULLIF(r.RecipeImage, ''), 'noimageavailable.gif') as RecipeImage
	FROM 
	   dbo.userCookBook ucb WITH (NOLOCK) 
	INNER JOIN
	   dbo.Recipes r WITH (NOLOCK)
	ON
	   ucb.RecipeID = r.ID
	WHERE 
	   ucb.[UID] = @UserID
	ORDER BY ucb.Date DESC

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectUserPrivateMessage]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectUserPrivateMessage]

@UserID int

AS
BEGIN

SET NOCOUNT ON;

	SELECT	pm.M_ID, 
			pm.M_Subject, 
			pm.M_From, 
			pm.M_To, 
			pm.M_Sent, 
			pm.PM_Message, 
			pm.M_Read, 
			pm.M_OutBox, 
			pm.M_mail,
			u.UserName as FromUserName
	FROM 
		dbo.PrivateMessage pm WITH (NOLOCK)
	INNER JOIN
		dbo.usersmain u WITH (NOLOCK)
	ON
		pm.M_From = u.UID
	WHERE
		pm.M_To = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectUserPhotoByUserID]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectUserPhotoByUserID]

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Photo FROM dbo.usersmain WITH (NOLOCK) WHERE [UID] = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectUserNewPrivateMessage]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectUserNewPrivateMessage] 

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Count(*) CountNewMessage 
	FROM 
		dbo.PrivateMessage WITH (NOLOCK) 
	WHERE 
		M_To = @UserID AND M_Read = 0

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectUserCookBookConfig]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectUserCookBookConfig] 

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

   SELECT ShowCookBookinProfile FROM dbo.usersmain WITH (NOLOCK) WHERE [UID] = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectUser]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectUser] 

@UserID int

AS

SET NOCOUNT ON

DECLARE @PostedRecipeCount int
DECLARE @PostedArticleCount int
DECLARE @SavedRecipeCount int
DECLARE @CommentsRecipeCount int
DECLARE @CommentsArticleCount int
DECLARE @FriendsCount int

SELECT @PostedRecipeCount = Count(*) FROM dbo.Recipes WITH (NOLOCK) WHERE LINK_APPROVED = 1 AND [UID] = @UserID
SELECT @PostedArticleCount = COUNT(*) FROM dbo.Cooking_Article WITH (NOLOCK) WHERE Show = 1 AND [UID] = @UserID
SELECT @SavedRecipeCount = Count(*) FROM dbo.userCookBook WITH (NOLOCK) WHERE [UID] = @UserID
SELECT @CommentsRecipeCount = Count(DISTINCT ID) FROM dbo.COMMENTS_RECIPE WITH (NOLOCK) WHERE [UID] = @UserID
SELECT @CommentsArticleCount = Count(DISTINCT ID) FROM dbo.COMMENTS_ARTICLE WITH (NOLOCK) WHERE [UID] = @UserID
SELECT @FriendsCount = Count(*) FROM dbo.FriendsList WITH (NOLOCK) WHERE IsApproved = 1 AND [UID] = @UserID

	SELECT  [UID], 
		    UserLevel,
            UserName,
		    [Password],
			FirstName,
			LastName,
			City,
			[State],
			Country,
			Email,
			DOB,
			AboutMe,
			FavoriteFoods1,
			FavoriteFoods2,
			FavoriteFoods3,
			NewsLetter,
			DateJoined,
			Photo,
			Website,
			Hits,
			@PostedRecipeCount PostedRecipeCount,
            @PostedArticleCount PostedArticleCount,
			@SavedRecipeCount SavedRecipeCount,
			@CommentsRecipeCount CommentsRecipeCount,
			@CommentsArticleCount CommentsArticleCount,
			@FriendsCount FriendsCount,
			LastVisit,
			LastUpdated,
			ContactMe,
			isActive,
            [GUID],
            Activation

	FROM 
		dbo.usersmain WITH (NOLOCK) 
	WHERE 
		[UID] = @UserID;

    --Update hits
    UPDATE dbo.usersmain SET Hits = Hits + 1 WHERE [UID] = @UserID

RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[spSelectUpComingPublicEvents]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectUpComingPublicEvents]

@EventType varchar(50) = 'All' 

AS
BEGIN

	SET NOCOUNT ON;

    DECLARE @Counter int

    IF (@EventType = 'All')
       BEGIN
			SELECT @Counter = Count(*)
			FROM Events WITH (NOLOCK)
			WHERE [PRIVATE] = 0 AND [START_DATE] >= GETDATE() And [START_DATE] <= DateAdd(day,30,GETDATE())

			IF (@Counter > 0)
				 BEGIN
					SELECT EVENT_ID, 
						   EVENT_TITLE,
						   CATEGORY,
                           [START_DATE],
                           APPMEETING_STARTTIME,
                           APPMEETING_ENDTIME,
						   @Counter as RCount
					FROM Events WITH (NOLOCK)
					WHERE [PRIVATE] = 0 AND [START_DATE] >= GETDATE() And [START_DATE] <= DateAdd(day,30,GETDATE())
					ORDER BY [START_DATE], EVENT_ID ASC
				 END
			ELSE
				 BEGIN
					SELECT 1 as EVENT_ID, 
						   'NA' as EVENT_TITLE,
						   'NA' as CATEGORY,
                           NULL as [START_DATE],
                           NULL as APPMEETING_STARTTIME,
                           NULL as APPMEETING_ENDTIME,
						   0 as RCount
				 END
	   END
   ELSE
       BEGIN
			SELECT @Counter = Count(*)
			FROM Events WITH (NOLOCK)
			WHERE [PRIVATE] = 0 AND CATEGORY = @EventType AND [START_DATE] >= GETDATE() And [START_DATE] <= DateAdd(day,30,GETDATE())

			IF (@Counter > 0)
				 BEGIN
					SELECT EVENT_ID, 
						   EVENT_TITLE,
						   CATEGORY,
                           [START_DATE],
                           APPMEETING_STARTTIME,
                           APPMEETING_ENDTIME,
						   @Counter as RCount
					FROM Events WITH (NOLOCK)
					WHERE [PRIVATE] = 0 AND CATEGORY = @EventType AND [START_DATE] >= GETDATE() And [START_DATE] <= DateAdd(day,30,GETDATE())
					ORDER BY [START_DATE], EVENT_ID ASC
				 END
			ELSE
				 BEGIN
					SELECT 1 as EVENT_ID, 
						   'NA' as EVENT_TITLE,
						   'NA' as CATEGORY,
                           NULL as [START_DATE],
                           NULL as APPMEETING_STARTTIME,
                           NULL as APPMEETING_ENDTIME,
						   0 as RCount
				 END
	   END

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectUnApprovedArticle]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectUnApprovedArticle] 

AS
BEGIN

	SET NOCOUNT ON;

	SELECT a.ID, 
		   a.CAT_ID, 
		   ac.CAT_NAME,
		   a.Title, 
		   a.Post_Date, 
		   a.Author,
		   a.UID
	FROM 
		dbo.Cooking_Article a
	INNER JOIN
		dbo.Cooking_Article_Category ac
	ON
		a.CAT_ID = ac.CAT_ID
	WHERE 
		a.Show = 0
	ORDER BY a.Post_Date

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectTop50UsersWhoHasNotActivatedAnAccount]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectTop50UsersWhoHasNotActivatedAnAccount]

AS
BEGIN

	SET NOCOUNT ON;

	SELECT TOP 50 [UID], 
		   UserName,
           Email, 
		   [GUID],
           DateJoined
	FROM
		dbo.usersmain
	WHERE 
		Activation = 0

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectTop25UsersWhoCommentARecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectTop25UsersWhoCommentARecipe] 

AS
BEGIN

	SET NOCOUNT ON;

	SELECT AUTHOR, 
           Count(*) TotalComments 
    FROM 
		dbo.COMMENTS_RECIPE
	GROUP BY AUTHOR

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectTop25UsersWhoCommentAnArticle]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectTop25UsersWhoCommentAnArticle] 

AS
BEGIN

	SET NOCOUNT ON;

	SELECT AUTHOR, 
	       Count(*) TotalComments 
    FROM 
		dbo.COMMENTS_ARTICLE
	GROUP BY AUTHOR

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectSiteStatistics]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectSiteStatistics] 

AS
BEGIN

SET NOCOUNT ON;

DECLARE @TotalRecipe int
DECLARE @TotalArticle int
DECLARE @TotalMembers int
DECLARE @TotalRecipeComments int
DECLARE @TotalArticleComments int
DECLARE @TotalSavedRecipesInCookBook int
DECLARE @TotalUsersWhoUseCookBook int
DECLARE @TotalFriendsList int
DECLARE @TotalUsersWhoUseFriendsList int
DECLARE @TotalPrivateMessage int
DECLARE @TotalUsersJoinedToday int
DECLARE @TotalUsersJoinedYesterday int
DECLARE @TotalUsersJoinedInAWeek int
DECLARE @TotalUsersJoinedInAMonth int
DECLARE @TotalUnActivatedAccount int
DECLARE @TotalSuspendedAccount int

SELECT @TotalRecipe = Count(*) FROM dbo.Recipes WITH (NOLOCK) WHERE LINK_APPROVED = 1
SELECT @TotalArticle = Count(*) FROM dbo.Cooking_Article WITH (NOLOCK) WHERE Show = 1
SELECT @TotalMembers = Count(*) FROM dbo.usersmain WITH (NOLOCK)
SELECT @TotalRecipeComments = Count(*) FROM dbo.COMMENTS_RECIPE WITH (NOLOCK)
SELECT @TotalArticleComments = Count(*) FROM dbo.COMMENTS_ARTICLE WITH (NOLOCK)
SELECT @TotalSavedRecipesInCookBook = COUNT(*) FROM dbo.userCookBook WITH (NOLOCK)
SELECT @TotalUsersWhoUseCookBook = COUNT(DISTINCT [UID]) FROM dbo.userCookBook WITH (NOLOCK)
SELECT @TotalUsersWhoUseFriendsList = Count(DISTINCT [UID]) FROM dbo.FriendsList WITH (NOLOCK)
SELECT @TotalPrivateMessage = Count(*) FROM dbo.PrivateMessage WITH (NOLOCK)
SELECT @TotalUsersJoinedToday = Count(*) FROM dbo.usersmain WITH (NOLOCK) WHERE DateJoined = DATEADD(dd,DATEDIFF(dd,0,GETDATE()),0)
AND DateJoined < DATEADD(dd,DATEDIFF(dd,0,GETDATE()),1)
SELECT @TotalUsersJoinedYesterday = Count(*) FROM dbo.usersmain WITH (NOLOCK) WHERE DateJoined = dateadd(day, datediff(day, 0, getdate()), -1)
SELECT @TotalUsersJoinedInAWeek = Count(*) FROM dbo.usersmain WITH (NOLOCK) WHERE DateJoined >= DATEADD(day, - 7, GETDATE())
SELECT @TotalUsersJoinedInAMonth = Count(*) FROM dbo.usersmain WITH (NOLOCK) WHERE DateJoined >= DATEADD(day, - 31, GETDATE())
SELECT @TotalUnActivatedAccount = Count(*) FROM dbo.usersmain WITH (NOLOCK) WHERE Activation = 0
SELECT @TotalSuspendedAccount = Count(*) FROM dbo.usersmain WITH (NOLOCK) WHERE isActive = 0

SELECT @TotalRecipe TotalRecipe, 
		@TotalArticle TotalArticle,
		@TotalMembers TotalMembers,
		@TotalRecipeComments TotalRecipeComments,
        @TotalArticleComments TotalArticleComments,
		@TotalSavedRecipesInCookBook TotalSavedRecipesInCookBook,
		@TotalUsersWhoUseCookBook TotalUsersWhoUseCookBook,
		@TotalUsersWhoUseFriendsList TotalUsersWhoUseFriendsList,
		@TotalPrivateMessage TotalPrivateMessage,
		@TotalUsersJoinedToday TotalUsersJoinedToday,
        @TotalUsersJoinedYesterday TotalUsersJoinedYesterday,
		@TotalUsersJoinedInAWeek TotalUsersJoinedInAWeek,
		@TotalUsersJoinedInAMonth TotalUsersJoinedInAMonth,
        @TotalUnActivatedAccount  TotalUnActivatedAccount,
        @TotalSuspendedAccount TotalSuspendedAccount

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectSiteConfigurationAdmin]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectSiteConfigurationAdmin] 

AS
BEGIN

	SET NOCOUNT ON;

    DECLARE @LastViewedHours int

    SELECT @LastViewedHours = (Hourspan / 60) FROM ConfigureLastViewedHours WITH (NOLOCK)

	SELECT HideShowComment,
			HideShowArticleComment,
            NumberOfrecipeInCookBook,
			NumberOfFriendsInFriendsList,
			Email as AdminToEmail,
			SmtpServer as AdminFromEmail,
			PublicPrivateProfile,
            @LastViewedHours as MinuteSpan
	FROM dbo.Configuration WITH (NOLOCK)

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectShowAllPMBlockedUsersByUserID]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectShowAllPMBlockedUsersByUserID]

 @UserID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT bu.ID,
		   u.UID, 
		   u.UserName,
		   bu.Date
	FROM 
		dbo.PrivateMessageBlockedUsers bu WITH (NOLOCK)
	INNER JOIN
		dbo.usersmain u WITH (NOLOCK)
	ON
		bu.BlockedUID = u.UID
	WHERE 
		bu.UID = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectSearchUser]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectSearchUser]

@Input varchar(50),
@Condition int = 1,
@PageIndex int = 1,
@PageSize int = 20

AS
BEGIN

DECLARE @StartRow int
DECLARE @EndRow int

SET @StartRow = (@PageSize * (@PageIndex - 1))  + 1  
SET @EndRow = @PageSize * @PageIndex + 1

SET NOCOUNT ON;

	WITH Users AS
	(
		SELECT
		   ROW_NUMBER() OVER 
			 (
			   -- Dynamic bidirectional sorting
				ORDER BY UserName
			 ) AS RowNumber, 
					[UID], 
					UserName,
					FirstName,
					LastName,
					City,
					[State],
					Country,
					(SELECT Count(*) FROM dbo.usersmain WITH (NOLOCK) WHERE 
					(@Condition = 1 AND UserName LIKE COALESCE(@Input, '%')) OR
					(@Condition = 1 AND UserName LIKE COALESCE(@Input, UserName) + '%') OR
					(@Condition = 2 AND FirstName LIKE COALESCE(@Input, '%')) OR
					(@Condition = 3 AND LastName LIKE COALESCE(@Input, '%')) OR
					(@Condition = 4 AND City LIKE COALESCE(@Input, '%')) OR
					(@Condition = 5 AND [State] LIKE COALESCE(@Input, '%')) OR
					(@Condition = 6 AND Country LIKE COALESCE(@Input, '%'))) as TotalCount,
					COALESCE(NULLIF(Photo, ''), 'nophotoavailable.gif') as UserImage
					FROM 
						dbo.usersmain WITH (NOLOCK) WHERE
					(@Condition = 1 AND UserName LIKE COALESCE(@Input, '%')) OR
					(@Condition = 1 AND UserName LIKE COALESCE(@Input, UserName) + '%') OR --Alpha letter search
					(@Condition = 2 AND FirstName LIKE COALESCE(@Input, '%')) OR
					(@Condition = 3 AND LastName LIKE COALESCE(@Input, '%')) OR
					(@Condition = 4 AND City LIKE COALESCE(@Input, '%')) OR
					(@Condition = 5 AND [State] LIKE COALESCE(@Input, '%')) OR
					(@Condition = 6 AND Country LIKE COALESCE(@Input, '%'))
	)
	-- Statement that executes the CTE
	SELECT a.*
	FROM
		  Users a
	WHERE
		  a.RowNumber BETWEEN @StartRow AND @EndRow - 1
	ORDER BY
		  a.RowNumber


END
GO
/****** Object:  StoredProcedure [dbo].[spSelectRelatedArticle]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectRelatedArticle]

@CatID int,
@ID int

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @Counter int

	SELECT @Counter = Count(*) FROM dbo.Cooking_Article WHERE Show = 1 AND CAT_ID = @CatID

IF (@Counter > 1)
   BEGIN

		SELECT TOP 10 a.ID,
			   c.CAT_NAME,
			   a.Title,
			   a.Hits,
			   @Counter TotalCount
		FROM
			dbo.Cooking_Article a
		INNER JOIN
			dbo.Cooking_Article_Category c
		ON
			a.CAT_ID = c.CAT_ID
		WHERE 
			a.Show = 1 AND a.ID <> @ID AND c.CAT_ID = @CatID
		ORDER BY a.Hits DESC

   END
ELSE
	BEGIN
       SELECT 1 AS ID, 'Catname' AS CAT_NAME, 'Title' AS Title, 1 AS Hits, 1 AS TotalCount
	END

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectRecoverLostPassword]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Returns password
CREATE PROCEDURE [dbo].[spSelectRecoverLostPassword]

@Email varchar(50)

AS
BEGIN

IF Exists (SELECT Email FROM dbo.usersmain WHERE Email = @Email)
	BEGIN
		SELECT FirstName, UserName, [Password] FROM dbo.usersmain WHERE Email = @Email
	END
ELSE
	BEGIN
		SELECT 'NOTEXISTS' FirstName, 'NOTEXISTS' UserName, 'NOTEXISTS' [Password]
	END

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectRecipeCategory]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/17/2008>
-- Description:	<Get category for the homepage>
-- =============================================
CREATE PROCEDURE [dbo].[spSelectRecipeCategory]

AS
BEGIN

	SET NOCOUNT ON;

	SELECT *,
       (
         SELECT COUNT (*)  
		 FROM 
			dbo.Recipes WITH (NOLOCK) 
		 WHERE 
            Recipes.CAT_ID = RECIPE_CAT.CAT_ID AND LINK_APPROVED = 1
       ) AS REC_COUNT 
    FROM 
       dbo.RECIPE_CAT WITH (NOLOCK)
	ORDER BY 
	   CAT_TYPE ASC
END
GO
/****** Object:  StoredProcedure [dbo].[spSelectReadSentPrivateMessage]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectReadSentPrivateMessage]

@PMID int,
@UserID int 

AS
BEGIN

	SET NOCOUNT ON;

	SELECT pm.M_ID,
			pm.M_Subject, 
			pm.PM_Message, 
			pm.M_From,
			u.UserName,
			pm.M_Sent,
			pm.M_To 
	FROM 
		dbo.PrivateMessage pm WITH (NOLOCK)
	INNER JOIN
		dbo.usersmain u WITH (NOLOCK)
	ON
		pm.M_From = u.UID
	WHERE 
		pm.M_From = @UserID AND pm.M_ID = @PMID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectReadPrivateMessage]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectReadPrivateMessage]

@PMID int,
@UserID int 

AS
BEGIN

	SET NOCOUNT ON;

	SELECT pm.M_ID,
			pm.M_Subject, 
			pm.PM_Message, 
			pm.M_From,
			u.UserName,
			pm.M_Sent,
			pm.M_To 
	FROM 
		dbo.PrivateMessage pm WITH (NOLOCK)
	INNER JOIN
		dbo.usersmain u WITH (NOLOCK)
	ON
		pm.M_From = u.UID
	WHERE 
		pm.M_To = @UserID AND pm.M_ID = @PMID;

	UPDATE dbo.PrivateMessage SET M_Read = 1 WHERE M_ID = @PMID AND M_To = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectPrivateMessageStatistic]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectPrivateMessageStatistic]

AS
BEGIN

SET NOCOUNT ON;

DECLARE @CountAllPM int
DECLARE	@CountSentPMToday int

SELECT @CountAllPM = Count(*) FROM dbo.PrivateMessage WITH (NOLOCK)

SELECT @CountSentPMToday = Count(*) FROM dbo.PrivateMessage WITH (NOLOCK) WHERE M_Sent >= DATEADD(day, - 1, GETDATE())

SELECT @CountAllPM as TotalPMCount, @CountSentPMToday as SentTodayCount

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectPrivateMessages]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectPrivateMessages]

@folder varchar(20) = '',
@UserID int,
@OrderBy int = '',
@SortBy int = '',
@PageIndex int = 1,
@PageSize int = 20

AS
BEGIN

DECLARE @StartRow int
DECLARE @EndRow int

SET @StartRow = (@PageSize * (@PageIndex - 1))  + 1  
SET @EndRow = @PageSize * @PageIndex + 1

DECLARE @Counter int
DECLARE @CountUnRead int
DECLARE @CounterSentPM int
DECLARE @CountUnReadSentPM int
DECLARE @CountTrash int

SELECT @CountUnRead = Count(*) FROM dbo.PrivateMessage WITH (NOLOCK) WHERE M_To = @UserID AND M_Read = 0 
SELECT @Counter = Count(*) FROM dbo.PrivateMessage WITH (NOLOCK) WHERE M_To = @UserID

SELECT @CountUnReadSentPM = Count(*) FROM dbo.PrivateMessageSentMessages WITH (NOLOCK) WHERE M_From = @UserID AND M_Read = 0 
SELECT @CounterSentPM = Count(*) FROM dbo.PrivateMessageSentMessages WITH (NOLOCK) WHERE M_From = @UserID

SELECT @CountTrash = Count(*) FROM dbo.PrivateMessage WITH (NOLOCK) WHERE M_To = @UserID AND isTrash = 1

DECLARE @folder_Val varchar(20)

IF (@folder = 'inbox' OR @folder = '')
   BEGIN
	 SET @folder_Val = NULL
   END
ELSE
   BEGIN
	 SET @folder_Val = @folder
   END

SET NOCOUNT ON;

IF (@folder = 'sentitems')
	BEGIN

		WITH PrivateMessage AS
		(
			SELECT
			   ROW_NUMBER() OVER 
				 (
				   -- Dynamic bidirectional sorting
					ORDER BY 
						  CASE WHEN @OrderBy = 1 AND @SortBy = 1 THEN pm.M_Subject END DESC,
						  CASE WHEN @OrderBy = 1 AND @SortBy = '' THEN pm.M_Subject END DESC,
						  CASE WHEN @OrderBy = 1 AND @SortBy = 2 THEN pm.M_Subject END ASC,
						  CASE WHEN @OrderBy = 2 AND @SortBy = 1 THEN u.UserName END DESC,
						  CASE WHEN @OrderBy = 2 AND @SortBy = '' THEN u.UserName END DESC,
						  CASE WHEN @OrderBy = 2 AND @SortBy = 2 THEN u.UserName END ASC,
						  CASE WHEN @OrderBy = 3 AND @SortBy = 1 OR @OrderBy = '' THEN pm.M_Sent END DESC,
						  CASE WHEN @OrderBy = 3 AND @SortBy = '' OR @OrderBy = '' THEN pm.M_Sent END DESC,
						  CASE WHEN @OrderBy = 3 AND @SortBy = 2 THEN pm.M_Sent END ASC
				 ) AS RowNumber, 
					pm.M_ID,
					pm.M_Subject,
					pm.M_From,
					pm.M_To,
					u.UserName,
					pm.M_Sent,
					pm.M_Read,
					pm.M_OutBox,
					pm.PM_Message,
					@CounterSentPM as TotalCount,
					@CountUnReadSentPM as UnreadCount
			FROM
				dbo.PrivateMessageSentMessages pm WITH (NOLOCK) -- Use PM trash table
			INNER JOIN
				dbo.usersmain u WITH (NOLOCK)
			ON
				pm.M_To = u.UID
			WHERE 
				pm.M_From = @UserID AND pm.M_OutBox = 1
		)
		-- Statement that executes the CTE
		SELECT a.*
		FROM
			  PrivateMessage a
		WHERE
			  a.RowNumber BETWEEN @StartRow AND @EndRow - 1
		ORDER BY
			  a.RowNumber

   END

ELSE

   BEGIN

	WITH PrivateMessage AS
	(
		SELECT
		   ROW_NUMBER() OVER 
			 (
			   -- Dynamic bidirectional sorting
				ORDER BY 
					  CASE WHEN @OrderBy = 1 AND @SortBy = 1 THEN pm.M_Subject END DESC,
					  CASE WHEN @OrderBy = 1 AND @SortBy = '' THEN pm.M_Subject END DESC,
					  CASE WHEN @OrderBy = 1 AND @SortBy = 2 THEN pm.M_Subject END ASC,
					  CASE WHEN @OrderBy = 2 AND @SortBy = 1 THEN u.UserName END DESC,
					  CASE WHEN @OrderBy = 2 AND @SortBy = '' THEN u.UserName END DESC,
					  CASE WHEN @OrderBy = 2 AND @SortBy = 2 THEN u.UserName END ASC,
					  CASE WHEN @OrderBy = 3 AND @SortBy = 1 OR @OrderBy = '' THEN pm.M_Sent END DESC,
					  CASE WHEN @OrderBy = 3 AND @SortBy = '' OR @OrderBy = '' THEN pm.M_Sent END DESC,
					  CASE WHEN @OrderBy = 3 AND @SortBy = 2 THEN pm.M_Sent END ASC
			 ) AS RowNumber, 
				pm.M_ID,
				pm.M_Subject,
				pm.M_From,
				pm.M_To,
				u.UserName,
				pm.M_Sent,
				pm.M_Read,
				pm.M_OutBox,
				pm.PM_Message,
				@Counter as TotalCount,
				@CountUnRead as UnreadCount
		FROM
			dbo.PrivateMessage pm WITH (NOLOCK) -- Use main PM Table
		INNER JOIN
			dbo.usersmain u WITH (NOLOCK)
		ON
			pm.M_From = u.UID
		WHERE 
			(@folder_Val IS NULL AND (pm.M_To = @UserID AND pm.isTrash = 0)) OR
            (@folder_Val IS NOT NULL AND (pm.M_To = @UserID AND pm.isTrash = 1))
	)
	-- Statement that executes the CTE
	SELECT a.*
	FROM
		  PrivateMessage a
	WHERE
		  a.RowNumber BETWEEN @StartRow AND @EndRow - 1
	ORDER BY
		  a.RowNumber

   END

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectPrivateMessageByPMID]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectPrivateMessageByPMID]

@PMID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT PM_Message 
	FROM 
		dbo.PrivateMessage WITH (NOLOCK) 
	WHERE 
		M_ID = @PMID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectPMReadingSentMsgValidation]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectPMReadingSentMsgValidation] 

@PMID int,
@UserID int 

AS
BEGIN

	SET NOCOUNT ON;

    SELECT COUNT(*) col1 
	FROM 
		dbo.PrivateMessage pm WITH (NOLOCK)
	WHERE 
		M_From = @UserID AND M_ID = @PMID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectPMReadingMsgValidation]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectPMReadingMsgValidation]

@PMID int,
@UserID int 

AS
BEGIN

	SET NOCOUNT ON;

    SELECT COUNT(*) col1 
	FROM 
		dbo.PrivateMessage pm WITH (NOLOCK)
	WHERE 
		M_To = @UserID AND M_ID = @PMID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectPastPublicEvents]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectPastPublicEvents]

@EventType varchar(50) = 'All'

AS
BEGIN

	SET NOCOUNT ON;

    DECLARE @Counter int

    IF (@EventType = 'All')
       BEGIN
			SELECT @Counter = Count(*)
			FROM Events WITH (NOLOCK)
			WHERE [PRIVATE] = 0 AND [START_DATE] < GETDATE() And [START_DATE] > DateAdd(day,-30,GETDATE())

			IF (@Counter > 0)
				 BEGIN
					SELECT EVENT_ID, 
						   EVENT_TITLE,
						   CATEGORY,
                           [START_DATE],
                           APPMEETING_STARTTIME,
                           APPMEETING_ENDTIME,
						   @Counter as RCount
					FROM Events WITH (NOLOCK)
					WHERE [PRIVATE] = 0 AND [START_DATE] < GETDATE() And [START_DATE] > DateAdd(day,-30,GETDATE())
					ORDER BY [START_DATE], EVENT_ID ASC
				 END
			ELSE
				 BEGIN
					SELECT 1 as EVENT_ID, 
						   'NA' as EVENT_TITLE,
						   'NA' as CATEGORY,
                           NULL as [START_DATE],
                           NULL as APPMEETING_STARTTIME,
                           NULL as APPMEETING_ENDTIME,
						   0 as RCount
				 END
	   END
   ELSE
       BEGIN
			SELECT @Counter = Count(*)
			FROM Events WITH (NOLOCK)
			WHERE [PRIVATE] = 0 AND CATEGORY = @EventType AND [START_DATE] < GETDATE() And [START_DATE] > DateAdd(day,-30,GETDATE())

			IF (@Counter > 0)
				 BEGIN
					SELECT EVENT_ID, 
						   EVENT_TITLE,
						   CATEGORY,
                           [START_DATE],
                           APPMEETING_STARTTIME,
                           APPMEETING_ENDTIME,
						   @Counter as RCount
					FROM Events WITH (NOLOCK)
					WHERE [PRIVATE] = 0 AND CATEGORY = @EventType AND [START_DATE] < GETDATE() And [START_DATE] > DateAdd(day,-30,GETDATE())
					ORDER BY [START_DATE], EVENT_ID ASC
				 END
			ELSE
				 BEGIN
					SELECT 1 as EVENT_ID, 
						   'NA' as EVENT_TITLE,
						   'NA' as CATEGORY,
                           NULL as [START_DATE],
                           NULL as APPMEETING_STARTTIME,
                           NULL as APPMEETING_ENDTIME,
						   0 as RCount
				 END
	   END

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectOtherArticlesByThisAuthor]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectOtherArticlesByThisAuthor] 

@UserID int,
@ID int

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @Counter int

	SELECT @Counter = Count(*) FROM dbo.Cooking_Article WHERE Show = 1 AND [UID] =  @UserID

IF (@Counter > 1)
   BEGIN

		SELECT TOP 10 a.ID,
			   c.CAT_NAME,
			   a.Title,
			   a.Hits,
			   @Counter TotalCount
		FROM
			dbo.Cooking_Article a
		INNER JOIN
			dbo.Cooking_Article_Category c
		ON
			a.CAT_ID = c.CAT_ID
		WHERE 
			a.Show = 1 AND a.ID <> @ID AND a.UID = @UserID
		ORDER BY 
			a.Hits DESC

   END
ELSE
   BEGIN
      SELECT 1 AS ID, 'Catname' AS CAT_NAME, 'Title' AS Title, 1 AS Hits, 1 AS TotalCount
   END

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectNewFriendsWaitingForApproval]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectNewFriendsWaitingForApproval]

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT fl.ID,  
		   fl.FriendID,
		   fl.UID,
		   u.UserName,
		   u.Email,
		   fl.Date,
		   u.FirstName,
		   u.LastName,
		   u.Country,
		   COALESCE(NULLIF(u.Photo, ''), 'nophotoavailable.gif') as Photo,
		   u.Hits,
		   u.LastVisit,
           u.DateJoined
	FROM 
		dbo.FriendsList fl WITH (NOLOCK)
	INNER JOIN 
		dbo.usersmain u WITH (NOLOCK)
	ON
		fl.UID = u.UID
	WHERE 
		fl.IsApproved = 0 AND fl.FriendID = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectLast5UsersWhoSavedMyRecipeInCookBook]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectLast5UsersWhoSavedMyRecipeInCookBook]

@UserID int 

AS
BEGIN

	SET NOCOUNT ON;

	SELECT TOP 5 ucb.UID, u.UserName, max(ucb.Date) Date FROM dbo.userCookBook ucb WITH (NOLOCK)
	INNER JOIN
		dbo.Recipes r WITH (NOLOCK)
	ON
		ucb.RecipeID = r.ID
	INNER JOIN
		dbo.usersmain u WITH (NOLOCK)
	ON
		ucb.UID = u.UID
	WHERE 
		r.UID = @UserID
	GROUP BY
	ucb.UID,
	u.UserName

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectLast5RecipeByUser]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectLast5RecipeByUser] 

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT TOP 5 ID,
			  CAT_ID, 
			  Category, 
			  Name, 
			  Author, 
			  Date, 
			  HITS, 
			  RATING, 
			  NO_RATES,
			  [UID],
			  COALESCE(NULLIF(RecipeImage, ''), 'noimageavailable.gif') as RecipeImage,
			  Cast((1.0 * RATING/NO_RATES) as decimal(2,1)) as Rates
	FROM
		dbo.Recipes WITH (NOLOCK)
	WHERE 
		LINK_APPROVED = 1 AND [UID] = @UserID
	ORDER BY Date DESC

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectLast5ArticleByUser]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectLast5ArticleByUser]

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT TOP 5 a.ID,
			c.CAT_NAME,
            a.Title,
			ShortTitle = (Substring(a.Title, 1, 32) + '...')
	FROM
		dbo.Cooking_Article a WITH (NOLOCK)
	INNER JOIN
		dbo.Cooking_Article_Category c WITH (NOLOCK)
	ON
		a.CAT_ID = c.CAT_ID
	WHERE 
		a.Show = 1 AND a.UID = @UserID
	ORDER BY 
		Post_Date DESC

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectLast50ExceptionErrorLog]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectLast50ExceptionErrorLog] 

AS
BEGIN

SET NOCOUNT ON;

	SELECT TOP 50 ID,
           URL, 
		   Exception, 
		   Date
	FROM 
		dbo.ExceptionLog WITH (NOLOCK)
    ORDER BY Date DESC

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectLast25UsersWhoCommentedARecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectLast25UsersWhoCommentedARecipe] 

AS
BEGIN

	SET NOCOUNT ON;

	SELECT t1.*, r.Name 
	FROM 
		(
		  SELECT TOP 25 max(c.ID) as ID, 
					   max(c.UID) [UID], 
					   c.AUTHOR as UserName, 
					   max(c.Date) Date 
			FROM 
				dbo.COMMENTS_RECIPE c WITH (NOLOCK)
			INNER JOIN 
				dbo.Recipes r WITH (NOLOCK)
			ON
				c.ID = r.ID
			GROUP BY c.AUTHOR
		) t1
	INNER JOIN
		dbo.Recipes r WITH (NOLOCK)
	ON
		t1.ID = r.ID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectLast25UsersWhoAddedRecipeInCookBook]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectLast25UsersWhoAddedRecipeInCookBook] 

AS
BEGIN

SET NOCOUNT ON;

	SELECT TOP 25 max(ucb.UID) [UID],
				  max(t1.UserName) UserName,
				  max(ucb.RecipeID) RecipeID, 
				  max(ucb.RecipeName) RecipeName, 
				  max(ucb.Date) Date 
    FROM 
		dbo.userCookBook ucb WITH (nOLOCK)
	INNER JOIN
		(
		   SELECT [UID], 
				  UserName 
		   FROM 
              dbo.usersmain WITH (NOLOCK)
		) t1
	ON
		ucb.UID = t1.UID
	GROUP BY ucb.UID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectLast25UsersWhoAddedAFriend]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectLast25UsersWhoAddedAFriend]

AS
BEGIN

	SET NOCOUNT ON;

	SELECT	max(t1.UserName) UserName, 
			max(t1.UID) [UID], 
			max(t2.UserName) FUserName, 
			max(t2.FriendID) FriendID, max(t1.Date) Date
	FROM 
		(
			SELECT TOP 25 fl.ID, u.UserName, fl.UID, fl.Date
			FROM 
				dbo.FriendsList fl WITH (NOLOCK)
			INNER JOIN 
				dbo.usersmain u WITH (NOLOCK)
			ON
			   fl.UID = u.UID
			GROUP BY fl.ID, fl.UID, fl.Date, u.UserName
			ORDER BY fl.Date DESC
		) t1
	INNER JOIN 
		(
			SELECT TOP 25 fl.ID, u.UserName, fl.FriendID, fl.Date
			FROM 
				dbo.FriendsList fl WITH (NOLOCK)
			INNER JOIN 
				dbo.usersmain u WITH (NOLOCK)
			ON
			   fl.FriendID = u.UID
			GROUP BY fl.ID, fl.FriendID, fl.Date, u.UserName
			ORDER BY fl.Date DESC
		) t2
	ON 
		t1.ID = t2.ID
    GROUP BY t1.UserName

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectLast20UserWhoSubmittedRecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectLast20UserWhoSubmittedRecipe] 

AS
BEGIN

SET NOCOUNT ON;

	SELECT MAX(u.UID) [UID], 
		   u.UserName,
		   MAX(r.Date) Date
	FROM 
		 dbo.usersmain u WITH (NOLOCK)
	INNER JOIN
	(
		SELECT TOP 20 [UID], Date
		FROM 
			 dbo.Recipes WITH (NOLOCK)
		GROUP BY [UID], Date
		ORDER BY Date DESC
	) r
	ON
		r.UID = u.UID
	GROUP BY u.UserName 

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectLast20UsersWhoSubmittedArticle]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectLast20UsersWhoSubmittedArticle] 

AS
BEGIN

SET NOCOUNT ON;

	SELECT MAX(u.UID) [UID], 
		   u.UserName,
		   MAX(a.Post_Date) Date
	FROM 
		 dbo.usersmain u WITH (NOLOCK)
	INNER JOIN
	(
		SELECT TOP 20 [UID], Post_Date
		FROM 
			 dbo.Cooking_Article WITH (NOLOCK)
		GROUP BY [UID], Post_Date
		ORDER BY Post_Date DESC
	) a
	ON
		a.UID = u.UID
	GROUP BY u.UserName 

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectLast10UpdatedRecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectLast10UpdatedRecipe] 

AS
BEGIN

	SET NOCOUNT ON;

	SELECT TOP 10 rul.RID,
		   rul.DateUpdated,
		   r.Name
	FROM
		(
		   SELECT TOP 10 RID, Max(DateUpdated) DateUpdated 
		   FROM 
				dbo.RecipeUpdateLog WITH (NOLOCK)
		   GROUP BY RID
        ) rul
	INNER JOIN
		dbo.Recipes r WITH (NOLOCK)
	ON
		rul.RID = r.ID
	WHERE 
		r.LINK_APPROVED = 1
	ORDER BY 
		rul.DateUpdated DESC

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectLast10UpdatedArticle]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectLast10UpdatedArticle]

AS
BEGIN

	SET NOCOUNT ON;

	SELECT TOP 10 aul.AID,
		   aul.DateUpdated,
		   a.Title,
		   a.Author
	FROM
		(
		   SELECT TOP 10 AID, Max(DateUpdated) DateUpdated 
		   FROM 
			  dbo.ArticleUpdateLog WITH (NOLOCK)
		   GROUP BY AID
	    ) aul
	INNER JOIN
		dbo.Cooking_Article a WITH (NOLOCK)
	ON
		aul.AID = a.ID
	WHERE 
		a.Show = 1
	ORDER BY 
		aul.DateUpdated DESC

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectIsUserBlockedFromSendingPM]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectIsUserBlockedFromSendingPM]

@ToUsername varchar(50),
@FromUserID int

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @ToUserID int

	SELECT @ToUserID = [UID] FROM dbo.usersmain WITH (NOLOCK) WHERE UserName = @ToUsername

	SELECT Count(*) Col1 
	FROM 
		dbo.PrivateMessageBlockedUsers WITH (NOLOCK) 
	WHERE 
		BlockedUID = @FromUserID AND [UID] = @ToUserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectIsProfilePagePublicOrPrivate]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectIsProfilePagePublicOrPrivate] 

AS
BEGIN

	SET NOCOUNT ON;

    SELECT PublicPrivateProfile 
	FROM 
		dbo.Configuration WITH (NOLOCK)

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectGetUserIDByUsername]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectGetUserIDByUsername]

@Username varchar(50)

AS
BEGIN

	SET NOCOUNT ON;

	SELECT [UID] 
	FROM 
		dbo.usersmain WITH (NOLOCK) 
	WHERE 
		UserName = @Username

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectGetUserArticleCommentByUser]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectGetUserArticleCommentByUser] 

@FindByAuthor varchar(50),
@OrderBy int,
@SortBy int,
@PageIndex int,
@PageSize int

AS
BEGIN

DECLARE @StartRow int
DECLARE @EndRow int

SET @StartRow = (@PageSize * (@PageIndex - 1))  + 1  
SET @EndRow = @PageSize * @PageIndex + 1

DECLARE @UserID int
DECLARE @Counter int

SELECT @UserID = [UID] FROM dbo.usersmain WITH (NOLOCK) WHERE UserName = @FindByAuthor

SELECT @Counter = Count(DISTINCT ID) FROM dbo.COMMENTS_ARTICLE WITH (NOLOCK) WHERE [UID] = @UserID

SET NOCOUNT ON;

	WITH Article AS
	(
		SELECT
		   ROW_NUMBER() OVER 
			 (
				-- Dynamic sorting
				ORDER BY 
					  CASE WHEN @OrderBy = 1 AND @SortBy = 1 THEN a.Hits END DESC,
					  CASE WHEN @OrderBy = 1 AND @SortBy = '' THEN a.Hits END DESC,
					  CASE WHEN @OrderBy = 1 AND @SortBy = 2 THEN a.Hits END ASC,
					  CASE WHEN @OrderBy = 2 AND @SortBy = 1 THEN a.No_Rates END DESC,
					  CASE WHEN @OrderBy = 2 AND @SortBy = '' THEN a.No_Rates END DESC,
					  CASE WHEN @OrderBy = 2 AND @SortBy = 2 THEN a.No_Rates END ASC,
					  CASE WHEN @OrderBy = 3 AND @SortBy = 2 THEN a.Title END ASC,
					  CASE WHEN @OrderBy = 3 AND @SortBy = '' THEN a.Title END ASC,
					  CASE WHEN @OrderBy = 3 AND @SortBy = 1 THEN a.Title END DESC,
					  CASE WHEN @OrderBy = 4 AND @SortBy = 1 OR @OrderBy = '' THEN a.Post_Date END DESC,
					  CASE WHEN @OrderBy = 4 AND @SortBy = '' OR @OrderBy = '' THEN a.Post_Date END DESC,
					  CASE WHEN @OrderBy = 4 AND @SortBy = 2 THEN a.Post_Date END ASC
			 ) AS RowNumber, 
				  a.ID,
				  a.CAT_ID,
				  b.CAT_NAME, 
				  a.Title, 
				  a.Post_Date, 
				  a.Content, 
				  a.Hits, 
				  a.Author,
				  a.Keyword,
				  a.No_Rates,
				  a.UID,
				  CAST((1.0 * a.No_Rating/a.No_Rates) AS DECIMAL(2,1)) AS Rates,
				  @Counter As RCount, 
				  a.Summary,
				  a.Total_Comments        
		   FROM 
				dbo.Cooking_Article a WITH (NOLOCK)
		   INNER JOIN 
				dbo.Cooking_Article_Category b WITH (NOLOCK)
		   ON 
				a.CAT_ID = b.CAT_ID
		   INNER JOIN 
				dbo.COMMENTS_ARTICLE c WITH (NOLOCK)
		   ON
				a.ID = c.ID
		   WHERE 
				a.Show = 1 AND c.UID = @UserID
		   GROUP BY
				  a.ID,
				  a.CAT_ID,
				  b.CAT_NAME, 
				  a.Title, 
				  a.Post_Date, 
				  a.Content, 
				  a.Hits, 
				  a.Author,
				  a.Keyword,
				  a.No_Rates,
				  a.UID,
				  a.No_Rating,
				  a.Summary,
				  a.Total_Comments   
	)
	-- Statement that executes the CTE
	SELECT a.*
	FROM
		  Article a
	WHERE
		  a.RowNumber BETWEEN @StartRow AND @EndRow - 1
	ORDER BY
		  a.RowNumber

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectGetPublicEventDetails]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectGetPublicEventDetails]

@ID int 

AS
BEGIN

	SET NOCOUNT ON;

	SELECT e.DATE_ADDED,
			e.START_DATE,
			e.END_DATE,
			e.CATEGORY,
			e.EVENT_TITLE,
			e.EVENT_DETAILS,
			e.UID,
			u.UserName,
            e.START_DATE,
            e.APPMEETING_STARTTIME,
            e.APPMEETING_ENDTIME
	FROM
		dbo.Events e WITH (NOLOCK)
	INNER JOIN
		dbo.usersmain u WITH (NOLOCK)
	ON
		e.UID = u.UID
	WHERE 
		e.EVENT_ID = @ID AND e.PRIVATE = 0

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectGetAllRecipeCommentByUser]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectGetAllRecipeCommentByUser] 

@CommentsByAuthor varchar(50),
@OrderBy int = '',
@PageIndex int = 1,
@PageSize int = 20

AS
BEGIN

DECLARE @UserID int
DECLARE @Counter int

SELECT @UserID = [UID] FROM dbo.usersmain WITH (NOLOCK) WHERE UserName = @CommentsByAuthor

SELECT @Counter = Count(DISTINCT ID) FROM dbo.COMMENTS_RECIPE WITH (NOLOCK) WHERE [UID] = @UserID

DECLARE @StartRow int
DECLARE @EndRow int

SET @StartRow = (@PageSize * (@PageIndex - 1))  + 1  
SET @EndRow = @PageSize * @PageIndex + 1

SET NOCOUNT ON;


		WITH RecipeSearch AS
		(
			SELECT
			   ROW_NUMBER() OVER 
				 (
				   -- Dynamic sorting
					ORDER BY 
						  CASE WHEN @OrderBy = 1 THEN r.HITS END DESC,
						  CASE WHEN @OrderBy = 2 THEN r.NO_RATES END DESC,
						  CASE WHEN @OrderBy = 3 THEN Name END,
						  CASE WHEN @OrderBy = 4 OR @OrderBy = '' THEN r.Date END DESC
				 ) AS RowNumber, 
					  r.ID, 
					  r.CAT_ID, 
					  r.Category, 
					  r.Name, 
					  r.Author, 
					  r.Date, 
					  r.HITS, 
					  r.RATING, 
					  r.NO_RATES,
                      r.UID,
					  Cast((1.0 * r.RATING/r.NO_RATES) as decimal(2,1)) as Rates,
                      COALESCE(NULLIF(r.RecipeImage, ''), 'noimageavailable.gif') as RecipeImage,
					  @Counter As RCount  
			   FROM 
					Recipes r WITH (NOLOCK)
               INNER JOIN 
					dbo.COMMENTS_RECIPE c WITH (NOLOCK)
			   ON 
					r.ID = c.ID
			   WHERE 
					r.LINK_APPROVED = 1 AND c.UID = @UserID
               GROUP BY
					  r.ID, 
					  r.CAT_ID, 
					  r.Category, 
					  r.Name, 
					  r.Author, 
					  r.Date, 
					  r.HITS, 
					  r.RATING, 
					  r.NO_RATES,
                      r.RecipeImage,
                      r.UID
		)
		-- Statement that executes the CTE
		SELECT a.*
		FROM
			  RecipeSearch a
		WHERE
			  a.RowNumber BETWEEN @StartRow AND @EndRow - 1
		ORDER BY
			  a.RowNumber

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectGetAllRecipeByUser]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectGetAllRecipeByUser] 

@FindByAuthor varchar(50),
@OrderBy int = '',
@PageIndex int = 1,
@PageSize int = 20

AS
BEGIN

DECLARE @StartRow int
DECLARE @EndRow int

SET @StartRow = (@PageSize * (@PageIndex - 1))  + 1  
SET @EndRow = @PageSize * @PageIndex + 1

DECLARE @UserID int
DECLARE @Counter int

SELECT @UserID = [UID] FROM dbo.usersmain WITH (NOLOCK) WHERE UserName = @FindByAuthor

SELECT @Counter = Count(*) FROM dbo.Recipes WITH (NOLOCK) WHERE [UID] = @UserID

SET NOCOUNT ON;

		WITH RecipeSearch AS
		(
			SELECT
			   ROW_NUMBER() OVER 
				 (
				   -- Dynamic sorting
					ORDER BY 
						  CASE WHEN @OrderBy = 1 THEN HITS END DESC,
						  CASE WHEN @OrderBy = 2 THEN NO_RATES END DESC,
						  CASE WHEN @OrderBy = 3 THEN Name END,
						  CASE WHEN @OrderBy = 4 OR @OrderBy = '' THEN Date END DESC
				 ) AS RowNumber, 
					  ID, 
					  CAT_ID, 
					  Category, 
					  Name, 
					  Author, 
					  Date, 
					  HITS, 
					  RATING, 
					  NO_RATES,
					  Cast((1.0 * RATING/NO_RATES) as decimal(2,1)) as Rates,
                      COALESCE(NULLIF(RecipeImage, ''), 'noimageavailable.gif') as RecipeImage,
					  @Counter As RCount,
                      [UID]  
			   FROM 
					dbo.Recipes WITH (NOLOCK) 
			   WHERE 
					LINK_APPROVED = 1 AND [UID] = @UserID
		)
		-- Statement that executes the CTE
		SELECT a.*
		FROM
			  RecipeSearch a
		WHERE
			  a.RowNumber BETWEEN @StartRow AND @EndRow - 1
		ORDER BY
			  a.RowNumber

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectFriendsListUserConfig]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectFriendsListUserConfig] 

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

    SELECT ShowFriendsListinProfile 
	FROM 
		dbo.usersmain 
	WHERE 
		[UID] = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectFriendsListMainPage]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectFriendsListMainPage] 

@UserID int

AS
BEGIN

	DECLARE @NumRecords int

	SELECT @NumRecords = NumberOfFriendsInFriendsList FROM dbo.Configuration WITH (NOLOCK)

	SET ROWCOUNT @NumRecords

	DECLARE @TotalCount int
	SELECT @TotalCount = Count(*) FROM dbo.FriendsList WITH (NOLOCK) WHERE IsApproved = 1 AND [UID] = @UserID

	SELECT fl.ID, 
		   @TotalCount TotalCount,
		   fl.FriendID, 
		   u.UserName, 
		   fl.Date,
		   u.FirstName,
		   u.LastName,
		   u.Country,
		   COALESCE(NULLIF(u.Photo, ''), 'nophotoavailable.gif') as Photo,
		   u.Hits,
		   u.LastVisit,
           u.DateJoined
	FROM 
		dbo.FriendsList fl WITH (NOLOCK)
	INNER JOIN 
		dbo.usersmain u WITH (NOLOCK)
	ON
		fl.FriendID = u.UID
	WHERE 
		fl.IsApproved = 1 AND fl.UID = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectFriendsList]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectFriendsList]

@UserID int,
@NumRecords int

AS
BEGIN

SET ROWCOUNT @NumRecords

	DECLARE @TotalCount int

	SELECT @TotalCount = Count(*) FROM dbo.FriendsList WITH (NOLOCK) WHERE IsApproved = 1 AND [UID] = @UserID

	SELECT fl.ID, 
		   @TotalCount TotalCount, 
		   fl.FriendID, 
		   u.UserName, 
		   fl.Date,
		   u.FirstName,
		   u.LastName,
		   u.Country,
		   COALESCE(NULLIF(u.Photo, ''), 'nophotoavailable.gif') as Photo,
		   u.Hits,
		   u.LastVisit,
           u.DateJoined
	FROM 
		dbo.FriendsList fl WITH (NOLOCK)
	INNER JOIN 
		dbo.usersmain u WITH (NOLOCK)
	ON
		fl.FriendID = u.UID
	WHERE 
		fl.IsApproved = 1 AND fl.UID = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectDisplayAllMembers]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectDisplayAllMembers]

@OrderBy int = '',
@SortBy int = '',
@PageIndex int = 1,
@PageSize int = 20

AS
BEGIN

DECLARE @StartRow int
DECLARE @EndRow int

SET @StartRow = (@PageSize * (@PageIndex - 1))  + 1  
SET @EndRow = @PageSize * @PageIndex + 1

DECLARE @TotalUsersCount int

SELECT @TotalUsersCount = Count(*) FROM dbo.usersmain WITH (NOLOCK)

SET NOCOUNT ON;

	WITH Users AS
	(
		SELECT
		   ROW_NUMBER() OVER 
			 (
       -- Dynamic bidirectional sorting
        ORDER BY 
              CASE WHEN @OrderBy = 1 AND @SortBy = 1 THEN Hits END DESC,
              CASE WHEN @OrderBy = 1 AND @SortBy = '' THEN Hits END DESC,
              CASE WHEN @OrderBy = 1 AND @SortBy = 2 THEN Hits END ASC,
              CASE WHEN @OrderBy = 2 AND @SortBy = 2 THEN LastVisit END ASC,
              CASE WHEN @OrderBy = 2 AND @SortBy = '' THEN LastVisit END ASC,
              CASE WHEN @OrderBy = 2 AND @SortBy = 1 THEN LastVisit END DESC,
              CASE WHEN @OrderBy = 3 AND @SortBy = 2 THEN UserName END ASC,
              CASE WHEN @OrderBy = 3 AND @SortBy = '' THEN UserName END ASC,
              CASE WHEN @OrderBy = 3 AND @SortBy = 1 THEN UserName END DESC,
              CASE WHEN @OrderBy = 4 AND @SortBy = 1 OR @OrderBy = '' THEN DateJoined END DESC,
              CASE WHEN @OrderBy = 4 AND @SortBy = '' OR @OrderBy = '' THEN DateJoined END DESC,
              CASE WHEN @OrderBy = 4 AND @SortBy = 2 THEN DateJoined END ASC
			 ) AS RowNumber, 
				[UID], 
				UserName,	
				FirstName,
				LastName,
				City,
				[State],
				Country,
				DateJoined,
				LastVisit,
				Hits,
				@TotalUsersCount as TotalCount,
				COALESCE(NULLIF(Photo, ''), 'nophotoavailable.gif') as UserImage
				FROM 
					dbo.usersmain WITH (NOLOCK)
	)
	-- Statement that executes the CTE
	SELECT a.*
	FROM
		  Users a
	WHERE
		  a.RowNumber BETWEEN @StartRow AND @EndRow - 1
	ORDER BY
		  a.RowNumber

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectCountUserWhoAddMeInFriendsList]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectCountUserWhoAddMeInFriendsList] 

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Count(*) col1 
	FROM 
		dbo.FriendsList WITH (NOLOCK) 
	WHERE 
		FriendID = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectCountUsersWhoSavedMyRecipeInCookBook]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectCountUsersWhoSavedMyRecipeInCookBook]

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT COUNT(DISTINCT ucb.UID) as Counter 
	FROM 
		dbo.userCookBook ucb WITH (NOLOCK)
	INNER JOIN
		dbo.Recipes r WITH (NOLOCK)
	ON
		ucb.RecipeID = r.ID
	INNER JOIN
		dbo.usersmain u WITH (NOLOCK)
	ON
		ucb.UID = u.UID
	WHERE 
		r.UID = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectCountUnApprovedFriends]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectCountUnApprovedFriends]

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Count(*) col1 FROM dbo.FriendsList WITH (NOLOCK) WHERE FriendID = @UserID AND IsApproved = 0

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectCountSentPM]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectCountSentPM]

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Count(*) SentPMCount 
	FROM 
		dbo.PrivateMessageSentMessages WITH (NOLOCK) 
	WHERE 
		M_From = @UserID AND M_OutBox = 1

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectCountPMinTrashByUserID]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectCountPMinTrashByUserID] 

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Count(*) Col1 FROM dbo.PrivateMessage WITH (NOLOCK) WHERE M_To = @UserID AND isTrash = 1	

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectCountPMBlocklistedUsers]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectCountPMBlocklistedUsers]

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Count(*) Col1 FROM dbo.PrivateMessageBlockedUsers bu WITH (NOLOCK) WHERE [UID] = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectCommentRecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/23/2008>
-- Description:	<Returns comments>
-- =============================================
CREATE PROCEDURE [dbo].[spSelectCommentRecipe]

@ID int

AS
BEGIN

	SET NOCOUNT ON;

       SELECT ID, 
				AUTHOR, 
				EMAIL, 
				COMMENTS, 
				DATE, 
				[UID] 
			FROM 
				dbo.COMMENTS_RECIPE WITH (NOLOCK) 
			WHERE 
				ID = @ID
			ORDER BY DATE DESC

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectCommentArticle]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectCommentArticle]

@ID int

AS
BEGIN

	SET NOCOUNT ON;

       SELECT ID, 
				Author, 
				Email, 
				Comments, 
				Date, 
				[UID] 
			FROM 
				dbo.COMMENTS_ARTICLE WITH (NOLOCK) 
			WHERE 
				ID = @ID
			ORDER BY DATE DESC

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectCheckUserActivation]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectCheckUserActivation]

@Username varchar(50),
@UserPassword varchar(50) 

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Activation 
	FROM 
		dbo.usersmain WITH (NOLOCK) 
	WHERE 
		UserName = @Username AND [Password] = @UserPassword

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectCheckIfUserAlreadyBlocked]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectCheckIfUserAlreadyBlocked]

@UserID int,
@BlockedUID int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Count(*) Col1 FROM dbo.PrivateMessageBlockedUsers WITH (NOLOCK) 
	WHERE [UID] = @UserID AND BlockedUID = @BlockedUID

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectArticleCommentAdmin]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectArticleCommentAdmin]

@FindByAuthor varchar(50) = ''

AS
BEGIN

SET NOCOUNT ON;

DECLARE @FindByAuthor_Val varchar(50)

IF (@FindByAuthor = '')
   BEGIN
	 SET @FindByAuthor_Val = NULL
   END
ELSE
   BEGIN
	 SET @FindByAuthor_Val = @FindByAuthor
   END

	SELECT COM_ID, 
			ID, 
			Author, 
			Email, 
			Date, 
			Comments  
	FROM 
		dbo.COMMENTS_ARTICLE WITH (NOLOCK)
	WHERE (@FindByAuthor_Val IS NOT NULL AND Author = @FindByAuthor) OR (@FindByAuthor = '')
	ORDER By DATE DESC

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectAllPublicEvents]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[spSelectAllPublicEvents]

@StartDate datetime,
@EndDate datetime,
@EventType varchar(50) = 'All'

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @EventType_Val varchar(50)

	IF (@EventType = 'All')
		 BEGIN
			SET @EventType_Val = NULL
		 END
	ELSE
		 BEGIN
			SET @EventType_Val = @EventType
		 END

	SELECT EVENT_ID, 
		   DATE_ADDED, 
		   [START_DATE], 
		   END_DATE,
		   CATEGORY,
		   EVENT_TITLE, 
		   EVENT_DETAILS,
		   APPMEETING_STARTTIME,
		   APPMEETING_ENDTIME,
		   [UID], 
		   [PRIVATE]
	FROM 
		dbo.Events WITH (NOLOCK)
	WHERE 
	(@EventType_Val IS NULL AND ([PRIVATE] = 0 AND [START_DATE] >= @StartDate AND [START_DATE] <= @EndDate))
	OR
	(@EventType_Val IS NOT NULL AND ([PRIVATE] = 0 AND CATEGORY = @EventType AND [START_DATE] >= @StartDate AND [START_DATE] <= @EndDate))

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectAllArticleByUser]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectAllArticleByUser]

@FindByAuthor varchar(50),
@OrderBy int,
@SortBy int,
@PageIndex int,
@PageSize int

AS
BEGIN

DECLARE @StartRow int
DECLARE @EndRow int

SET @StartRow = (@PageSize * (@PageIndex - 1))  + 1  
SET @EndRow = @PageSize * @PageIndex + 1

DECLARE @UserID int
DECLARE @Counter int

SELECT @UserID = [UID] FROM dbo.usersmain WITH (NOLOCK) WHERE UserName = @FindByAuthor

SELECT @Counter = Count(*) FROM dbo.Cooking_Article WITH (NOLOCK) WHERE Show = 1 AND [UID] = @UserID

SET NOCOUNT ON;

	WITH ArticleSearch AS
	(
		SELECT
		   ROW_NUMBER() OVER 
			 (
				-- Dynamic sorting
				ORDER BY 
					  CASE WHEN @OrderBy = 1 AND @SortBy = 1 THEN a.Hits END DESC,
					  CASE WHEN @OrderBy = 1 AND @SortBy = '' THEN a.Hits END DESC,
					  CASE WHEN @OrderBy = 1 AND @SortBy = 2 THEN a.Hits END ASC,
					  CASE WHEN @OrderBy = 2 AND @SortBy = 1 THEN a.No_Rates END DESC,
					  CASE WHEN @OrderBy = 2 AND @SortBy = '' THEN a.No_Rates END DESC,
					  CASE WHEN @OrderBy = 2 AND @SortBy = 2 THEN a.No_Rates END ASC,
					  CASE WHEN @OrderBy = 3 AND @SortBy = 2 THEN a.Title END ASC,
					  CASE WHEN @OrderBy = 3 AND @SortBy = '' THEN a.Title END ASC,
					  CASE WHEN @OrderBy = 3 AND @SortBy = 1 THEN a.Title END DESC,
					  CASE WHEN @OrderBy = 4 AND @SortBy = 1 OR @OrderBy = '' THEN a.Post_Date END DESC,
					  CASE WHEN @OrderBy = 4 AND @SortBy = '' OR @OrderBy = '' THEN a.Post_Date END DESC,
					  CASE WHEN @OrderBy = 4 AND @SortBy = 2 THEN a.Post_Date END ASC
			 ) AS RowNumber, 
				  a.ID,
				  a.CAT_ID,
				  b.CAT_NAME, 
				  a.Title, 
				  a.Post_Date, 
				  a.Content, 
				  a.Hits, 
				  a.Author,
				  a.Keyword,
				  a.No_Rates,
				  a.UID,
				  CAST((1.0 * a.No_Rating/a.No_Rates) AS DECIMAL(2,1)) AS Rates,
				  @Counter As RCount, 
				  a.Summary,
				  a.Total_Comments        
		   FROM 
				dbo.Cooking_Article a WITH (NOLOCK)
		   INNER JOIN 
				dbo.Cooking_Article_Category b WITH (NOLOCK)
		   ON 
				a.CAT_ID = b.CAT_ID
		   WHERE 
				a.Show = 1 AND a.UID = @UserID
	)
	-- Statement that executes the CTE
	SELECT a.*
	FROM
		  ArticleSearch a
	WHERE
		  a.RowNumber BETWEEN @StartRow AND @EndRow - 1
	ORDER BY
		  a.RowNumber

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectAdminUserLogin]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectAdminUserLogin]

@Username varchar(50),
@UserPassword varchar(50)

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Count(*) col1 FROM dbo.usersadmin WITH (NOLOCK) WHERE uname = @Username AND [password] = @UserPassword

END
GO
/****** Object:  StoredProcedure [dbo].[spRemovedUserFromPMBlockedList]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRemovedUserFromPMBlockedList]

@ID int,
@UserID int 

AS
BEGIN

	SET NOCOUNT ON;

	DELETE dbo.PrivateMessageBlockedUsers WHERE ID = @ID AND [UID] = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spReinstateUserAccount]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spReinstateUserAccount]
 
@UserID int

AS
BEGIN


SET NOCOUNT ON;

IF Exists (SELECT [UID] FROM dbo.usersmain WITH (NOLOCK) WHERE [UID] = @UserID)

	BEGIN

		--Update status
		UPDATE dbo.usersmain SET isActive = 1 WHERE [UID] = @UserID;

	   --Insert suspension note
		INSERT INTO dbo.UserSuspenionLog ([UID], [Type], Note, Date)
		VALUES (@UserID, 'Reinstate Account',  'Account reinstated.', GETDATE())

	END

END
GO
/****** Object:  StoredProcedure [dbo].[spMovePMToTrash]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMovePMToTrash]

@UserID int,
@ID int

AS
BEGIN

	SET NOCOUNT ON;

    UPDATE dbo.PrivateMessage SET isTrash = 1 WHERE M_ID = @ID AND M_To = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spMovePMBackToInbox]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMovePMBackToInbox]

@UserID int,
@ID int

AS
BEGIN

	SET NOCOUNT ON;

    UPDATE dbo.PrivateMessage SET isTrash = 0 WHERE M_ID = @ID AND M_To = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spInsertUser]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spInsertUser] 

@Username varchar(50),
@Password varchar(50),
@Email    varchar(50),
@Firstname varchar(50),
@Lastname  varchar(50),
@City	   varchar(50) = '',
@State     varchar(50) = '',
@Country   varchar(50),
@DOB       varchar(50) = '',
@FavoriteFoods1 varchar(50) = '',
@FavoriteFoods2 varchar(50) = '',
@FavoriteFoods3 varchar(50) = '',
@Newsletter     int = 1,
@ContactMe      int = 1,
@Website        varchar(100) = '',
@AboutMe        varchar(1000) = '',
@Photo          varchar(50) = '',
@Guid           varchar(100)


AS

DECLARE @ErrorCode int

SET @ErrorCode = @@error

BEGIN TRANSACTION

IF ( @ErrorCode = 0 )

BEGIN

DECLARE @CityValue varchar(50)
DECLARE @StateValue varchar(50)
DECLARE @FavoriteFoods1Value varchar(50)
DECLARE @FavoriteFoods2Value varchar(50)
DECLARE @FavoriteFoods3Value varchar(50)
DECLARE @WebsiteValue varchar(50)
DECLARE @AboutMeValue varchar(50)

--Instead of NULL, we use NA.
IF (@City = '')
  BEGIN
    SET @CityValue = 'NA'
  END
ELSE
  BEGIN
    SET @CityValue = @City
  END

IF (@State = '')
  BEGIN
    SET @StateValue = 'NA'
  END
ELSE
  BEGIN
    SET @StateValue = @State
  END

IF (@FavoriteFoods1 = '')
  BEGIN
    SET @FavoriteFoods1Value = 'NA'
  END
ELSE
  BEGIN
    SET @FavoriteFoods1Value = @FavoriteFoods1
  END

IF (@FavoriteFoods2 = '')
  BEGIN
    SET @FavoriteFoods2Value = 'NA'
  END
ELSE
  BEGIN
    SET @FavoriteFoods2Value = @FavoriteFoods2
  END

IF (@FavoriteFoods3 = '')
  BEGIN
    SET @FavoriteFoods3Value = 'NA'
  END
ELSE
  BEGIN
    SET @FavoriteFoods3Value = @FavoriteFoods3
  END

IF (@Website = '')
  BEGIN
    SET @WebsiteValue = 'NA'
  END
ELSE
  BEGIN
    SET @WebsiteValue = @Website
  END

IF (@AboutMe = '')
  BEGIN
    SET @AboutMeValue = 'NA'
  END
ELSE
  BEGIN
    SET @AboutMeValue = @AboutMe
  END

 INSERT INTO dbo.usersmain
(
	UserName,
	[Password],
	Email,
	FirstName,
	LastName,
	City,
	[State],
	Country,
	DOB,
	FavoriteFoods1,
	FavoriteFoods2,
	FavoriteFoods3,
	NewsLetter,
	DateJoined,
	ContactMe,
	Website,
	AboutMe,
	Photo,
    [GUID]
)
VALUES
(
	@Username,
	@Password,
	@Email,
	@Firstname,
	@Lastname,
	@CityValue,
	@StateValue,
	@Country,
	@DOB,
	@FavoriteFoods1Value,
	@FavoriteFoods2Value,
	@FavoriteFoods3Value,
	@Newsletter,
    GETDATE(),
	@ContactMe,
	@WebsiteValue,
	@AboutMeValue,
	@Photo,
    @Guid
)

END

IF ( @ErrorCode = 0 )
	COMMIT TRANSACTION
ELSE
	ROLLBACK TRANSACTION

RETURN @ErrorCode
GO
/****** Object:  StoredProcedure [dbo].[spInsertPrivateMessage]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spInsertPrivateMessage]

@Subject varchar(100),
@FromUserID int,
@ToUserName varchar(50),
@Message varchar(4000)

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @ToUserID int

	IF Exists (SELECT [UID] FROM dbo.usersmain WITH (NOLOCK) WHERE UserName = @ToUserName)
		BEGIN

			SELECT @ToUserID = [UID] FROM dbo.usersmain WITH (NOLOCK) WHERE UserName = @ToUserName;

			INSERT INTO dbo.PrivateMessage (M_Subject, M_From, M_To, M_Sent, PM_Message)
			VALUES(@Subject, @FromUserID, @ToUserID, GETDATE(), @Message);

			INSERT INTO dbo.PrivateMessageSentMessages (M_Subject, M_From, M_To, M_Sent, PM_Message)
			VALUES(@Subject, @FromUserID, @ToUserID, GETDATE(), @Message)

		END

END
GO
/****** Object:  StoredProcedure [dbo].[spInsertPMBlockedUser]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spInsertPMBlockedUser]

@UserID int,
@BlockedUID int

AS
BEGIN

	SET NOCOUNT ON;

    IF NOT Exists
		(
			SELECT * FROM dbo.PrivateMessageBlockedUsers WITH (NOLOCK) 
			WHERE [UID] = @UserID AND BlockedUID = @BlockedUID
         )

		 BEGIN
			INSERT INTO dbo.PrivateMessageBlockedUsers ([UID], BlockedUID, Date)
			VALUES(@UserID, @BlockedUID, GETDATE())
         END

END
GO
/****** Object:  StoredProcedure [dbo].[spInsertIsProfilePagePublicOrPrivate]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spInsertIsProfilePagePublicOrPrivate]

@Value int

AS
BEGIN

	SET NOCOUNT ON;

	UPDATE dbo.Configuration SET PublicPrivateProfile = @Value

END
GO
/****** Object:  StoredProcedure [dbo].[spInsertFavoriteRecipeToCookBook]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spInsertFavoriteRecipeToCookBook]

@UserID int,
@RecipeID int

AS
BEGIN

--Check if the recipe exists in the database.
IF Exists(SELECT ID FROM dbo.Recipes WHERE ID = @RecipeID)
   BEGIN

		DECLARE @RecipeName varchar(50)
		DECLARE @Hits int

		SELECT @RecipeName = [Name] FROM dbo.Recipes WHERE ID = @RecipeID
		SELECT @Hits = HITS FROM dbo.Recipes WHERE ID = @RecipeID

        --Check if the recipe already exists in the user cookbook.
        --If exists, then just update the hits.
		IF Exists(SELECT [UID], RecipeID FROM dbo.userCookBook WHERE [UID] = @UserID AND RecipeID = @RecipeID)
		   BEGIN

			  UPDATE dbo.userCookBook SET
			  Hits = @Hits
			  WHERE [UID] = @UserID AND RecipeID = @RecipeID

		   END
		ELSE
		   BEGIN

			  INSERT INTO dbo.userCookBook([UID], RecipeID, RecipeName, Hits)
			  VALUES(@UserID, @RecipeID, @RecipeName, @Hits)

		   END

   END

END
GO
/****** Object:  StoredProcedure [dbo].[spInsertExceptionError]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spInsertExceptionError]

@URL varchar(100),
@Exception varchar(1000)

AS

SET NOCOUNT ON;

INSERT INTO dbo.ExceptionLog (URL, Exception, Date)
VALUES (@URL, @Exception, GETDATE())

Return 0
GO
/****** Object:  StoredProcedure [dbo].[spInsertDeletedUserLog]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spInsertDeletedUserLog] 

@UserID int,
@UserName varchar(50),
@Reason varchar(250)

AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO dbo.DeletedUserLog ([UID], UserName, Reason, CreatedDate)
    VALUES (@UserID, @UserName, @Reason, GETDATE())

END
GO
/****** Object:  StoredProcedure [dbo].[spInsertArticleComment]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spInsertArticleComment]

@ID int,
@Author varchar(20),
@Email varchar(50),
@Comments varchar(200),
@UserID int

AS

DECLARE @ErrorCode int

SET @ErrorCode = @@error

BEGIN TRANSACTION

IF ( @ErrorCode = 0 )

Begin

	IF Exists (SELECT ID FROM dbo.Cooking_Article WITH (NOLOCK) WHERE ID = @ID)
	  BEGIN
		-- Insert
		INSERT INTO dbo.COMMENTS_ARTICLE (ID,Author,Email,Comments, [UID])
			VALUES(
				@ID,
				@Author,
				@Email,
				@Comments,
				@UserID
				);

		-- Update comment count
		UPDATE dbo.Cooking_Article SET Total_Comments = Total_Comments + 1 WHERE ID = @ID
	END

End

IF ( @ErrorCode = 0 )
	COMMIT TRANSACTION
ELSE
	ROLLBACK TRANSACTION

RETURN @ErrorCode
GO
/****** Object:  StoredProcedure [dbo].[spInsertArticle]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spInsertArticle]

@UserID int,
@Title varchar(200),
@Content varchar(8000),
@Author varchar(50),
@CAT_ID int,
@Keyword varchar(100),
@Summary varchar(500)

AS

DECLARE @ErrorCode int

SET @ErrorCode = @@error

BEGIN TRANSACTION

IF ( @ErrorCode = 0 )

BEGIN

	IF Exists (SELECT CAT_ID FROM dbo.Cooking_Article_Category WITH (NOLOCK) WHERE CAT_ID = @CAT_ID)
	BEGIN

		INSERT INTO Cooking_Article ([UID],Title,[Content],Author,CAT_ID,Keyword,Summary)
			VALUES(
				@UserID,
				@Title,
				@Content,
				@Author,
				@CAT_ID,
				@Keyword,
				@Summary
				)
	END

END

IF ( @ErrorCode = 0 )
	COMMIT TRANSACTION
ELSE
	ROLLBACK TRANSACTION

RETURN @ErrorCode
GO
/****** Object:  StoredProcedure [dbo].[spInsertAFriendToFriendsList]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spInsertAFriendToFriendsList] 

@UserID int,
@FriendID int

AS
BEGIN
    --Prevent user from adding himsel/herself
	IF (@UserID <> @FriendID)
		BEGIN
			--Check if the friend userID exist in the "dbo.usersmain" table.
			IF Exists (SELECT [UID] FROM dbo.usersmain WITH (NOLOCK) WHERE [UID] = @FriendID)
			   BEGIN
				--If the friendID already added for this user, then just update it.
				--Else insert a new friend.
				IF Exists (SELECT * FROM dbo.FriendsList WITH (NOLOCK) WHERE [UID] = @UserID AND FriendID = @FriendID)
				   BEGIN
					 UPDATE  dbo.FriendsList
					 SET FriendID = @FriendID
					 WHERE [UID] = @UserID
				   END
				ELSE
				   BEGIN
					 INSERT INTO dbo.FriendsList ([UID], FriendID, Date)
					 VALUES (@UserID, @FriendID, GETDATE())
				   END
			 END

		END

END
GO
/****** Object:  StoredProcedure [dbo].[spGetUserID]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetUserID] 

@Username varchar(50),
@UserPassword varchar(50)

AS
BEGIN

	SET NOCOUNT ON;

	SELECT [UID] 
	FROM 
		dbo.usersmain WITH (NOLOCK) 
	WHERE 
		UserName = @Username AND [Password] = @UserPassword

END
GO
/****** Object:  StoredProcedure [dbo].[spGetRecipeDetail]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/23/2008>
-- Description:	<Return recipe details>
-- =============================================
CREATE PROCEDURE [dbo].[spGetRecipeDetail]

@ID int,
@Approved int

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @Approved_Val int

	IF (@Approved = 1)
		BEGIN
		   SET @Approved_Val = 1
		END
	ELSE
		BEGIN
		   SET @Approved_Val = NULL
		END

	DECLARE @CountUserWhoSavedThisRecipeInCookBook int

	SELECT @CountUserWhoSavedThisRecipeInCookBook = Count(*) FROM dbo.userCookBook WITH (NOLOCK) WHERE RecipeID = @ID

	-- Get recipe
	SELECT ID, 
		   CAT_ID, 
		   Category,
		   Date,
		   [Name],  
		   HITS, 
		   NO_RATES,
		   Ingredients,
		   Instructions,
		   Author,
		   TOTAL_COMMENTS,
		   LINK_APPROVED,
		   RecipeImage,
		   [UID],
		   HIT_DATE,
		   CAST((1.0 * RATING/NO_RATES) as decimal(2,1)) as Rates,
		   @CountUserWhoSavedThisRecipeInCookBook as CountSavedInCookBook
		   FROM 
			 dbo.Recipes WITH (NOLOCK) 
		   WHERE
		   (@Approved_Val IS NOT NULL AND (LINK_APPROVED = 1 AND ID = @ID)) OR
		   (@Approved_Val IS NULL AND ID = @ID)

		IF (@Approved_Val IS NOT NULL)
			BEGIN
			   --Update hits
			   UPDATE Recipes set HITS = HITS + 1  WHERE ID = @ID;
			   --Update hit_date - use display todays 100 viewed recipes and last 4 hours
			   UPDATE Recipes SET HIT_DATE = getdate() WHERE ID = @ID
			END

END
GO
/****** Object:  StoredProcedure [dbo].[spGetCountofUnApprovedArticle]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetCountofUnApprovedArticle] 

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Count(*) TotalCount 
	FROM 
		dbo.Cooking_Article WITH (NOLOCK) 
	WHERE 
		Show = 0

END
GO
/****** Object:  StoredProcedure [dbo].[spGetActivationUserName]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetActivationUserName]

@Guid varchar(100)

AS
BEGIN

	SET NOCOUNT ON;

	SELECT UserName 
	FROM 
		dbo.usersmain WITH (NOLOCK) 
	WHERE 
		[GUID] = @Guid

END
GO
/****** Object:  StoredProcedure [dbo].[spDeleteUserRecipeInCookBook]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteUserRecipeInCookBook]

@UserID int,
@ID int

AS
BEGIN

 IF Exists (SELECT * FROM dbo.userCookBook WITH (NOLOCK) WHERE [UID] = @UserID AND ID = @ID)
    BEGIN
       DELETE dbo.userCookBook WHERE ID = @ID AND [UID] = @UserID
    END

END
GO
/****** Object:  StoredProcedure [dbo].[spDeleteUser]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteUser] 

@UserID int

AS
BEGIN

SET NOCOUNT ON;

--Cascade delete

	--Delete user
	DELETE dbo.usersmain WHERE [UID] = @UserID;

	--Delete all recipe entry
	DELETE dbo.Recipes WHERE [UID] = @UserID;

	--Delete article entry
	DELETE dbo.Cooking_Article WHERE [UID] = @UserID;

	--Delete cookbook entry
	DELETE dbo.userCookBook WHERE [UID] = @UserID;

	--Delete Friendslist entry
	DELETE dbo.FriendsList WHERE [UID] = @UserID;

	--Delete Friendslist entry
	DELETE dbo.FriendsList WHERE FriendID = @UserID;

	--Delete recipe comments entry
	DELETE dbo.COMMENTS_RECIPE WHERE [UID] = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spDeleteUnApprovedFriends]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteUnApprovedFriends]

@UserID int,
@ID int  

AS
BEGIN

	SET NOCOUNT ON;

	DELETE dbo.FriendsList WHERE ID = @ID AND FriendID = @UserID AND IsApproved = 0

END
GO
/****** Object:  StoredProcedure [dbo].[spDeletePrivateMessageSent]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeletePrivateMessageSent]

@UserID int,
@ID int

AS
BEGIN

	SET NOCOUNT ON;

	DELETE dbo.PrivateMessageSentMessages WHERE M_ID = @ID AND M_From = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spDeletePrivateMessage]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeletePrivateMessage]

@UserID int,
@ID int

AS
BEGIN

	SET NOCOUNT ON;

	DELETE dbo.PrivateMessage WHERE M_ID = @ID AND M_To = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spDeleteMultipleRecipeComment]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteMultipleRecipeComment]

@CsvID varchar(1000),
@CsvItemID varchar(1000)

AS
BEGIN

	SET NOCOUNT ON;

    DELETE dbo.COMMENTS_RECIPE WHERE COM_ID IN (SELECT * from dbo.fnConvertCSVToINT(@CsvID));

    -- Decrement Total comments count in recipe tabale
    UPDATE dbo.Recipes SET TOTAL_COMMENTS = TOTAL_COMMENTS - 1 WHERE ID IN (SELECT * from dbo.fnConvertCSVToINT(@CsvItemID))

END
GO
/****** Object:  StoredProcedure [dbo].[spDeleteExceptionLog]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteExceptionLog]

@CsvID varchar(200)

AS
BEGIN

	 SET NOCOUNT ON;

	 DELETE dbo.ExceptionLog WHERE ID IN (SELECT * from dbo.fnConvertCSVToINT(@CsvID))

END
GO
/****** Object:  StoredProcedure [dbo].[spDeleteAllPMInTrash]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteAllPMInTrash]

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

	DELETE dbo.PrivateMessage WHERE M_To = @UserID AND isTrash = 1

END
GO
/****** Object:  StoredProcedure [dbo].[spDeleteAFriendInFriendsList]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDeleteAFriendInFriendsList] 

@UserID int,
@FriendID int

AS
BEGIN

	SET NOCOUNT ON;
    
    IF Exists (SELECT [UID], FriendID FROM dbo.FriendsList WHERE [UID] = @UserID AND FriendID = @FriendID)
		BEGIN

          DELETE dbo.FriendsList WHERE [UID] = @UserID AND FriendID = @FriendID

		END

END
GO
/****** Object:  StoredProcedure [dbo].[spCountAllArticleComments]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCountAllArticleComments]

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Count(*) Col1 FROM dbo.COMMENTS_ARTICLE WITH (NOLOCK)

END
GO
/****** Object:  StoredProcedure [dbo].[spCheckValidateProfileUserIDQuerystring]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCheckValidateProfileUserIDQuerystring]

@UserID int

AS
BEGIN

	SET NOCOUNT ON;

    SELECT COUNT(*) Col1 
	FROM 
		dbo.usersmain WITH (NOLOCK) 
	WHERE 
		[UID] = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spCheckUsernameAvailabilityAjax]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCheckUsernameAvailabilityAjax]

@Username varchar(50)

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Count(*) Col1 
	FROM 
		dbo.usersmain WITH (NOLOCK) 
	WHERE 
		UserName = @Username


END
GO
/****** Object:  StoredProcedure [dbo].[spCheckIfFrienExistsInFriendsList]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCheckIfFrienExistsInFriendsList] 

@UserID int,
@FriendID int

AS
BEGIN

	SET NOCOUNT ON;

    SELECT COUNT(*) Col1 
	FROM 
		dbo.FriendsList WITH (NOLOCK) 
	WHERE 
		[UID] = @UserID AND FriendID = @FriendID

END
GO
/****** Object:  StoredProcedure [dbo].[spCheckIfActivationCodeIsvalid]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCheckIfActivationCodeIsvalid]

@Guid varchar(100)

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Count(*) col1 
	FROM 
		dbo.usersmain WITH (NOLOCK) 
	WHERE 
		[GUID] = @Guid

END
GO
/****** Object:  StoredProcedure [dbo].[spCheckIfAccountIsActivated]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCheckIfAccountIsActivated]

@Guid varchar(100)

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Activation 
	FROM 
		dbo.usersmain WITH (NOLOCK) 
	WHERE 
		[GUID] = @Guid

END
GO
/****** Object:  StoredProcedure [dbo].[spCheckEmailIfExistsAjax]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCheckEmailIfExistsAjax]

@Email varchar(50)

AS
BEGIN

	SET NOCOUNT ON;
     
    SELECT COUNT(*) Col1 
	FROM 
		dbo.usersmain WITH (NOLOCK) 
	WHERE 
		Email = @Email

END
GO
/****** Object:  StoredProcedure [dbo].[spAddRecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/28/2008>
-- Description:	<Add recipe>
-- =============================================
CREATE PROCEDURE [dbo].[spAddRecipe]

@Name varchar(50),
@Author varchar(20),
@Cat_Id int,
@Ingredients varchar(1000),
@Instructions varchar(2000),
@RecipeImage varchar(50) = Null,
@UserID int

AS

DECLARE @ErrorCode int

SET @ErrorCode = @@error

BEGIN TRANSACTION

IF ( @ErrorCode = 0 )

BEGIN

	DECLARE @CategoryValue varchar(50)

	SELECT @CategoryValue = CAT_TYPE FROM dbo.RECIPE_CAT WHERE CAT_ID = @Cat_Id

	DECLARE @RecipeImage_Val varchar(50)

	IF (@RecipeImage = '' OR @RecipeImage = NULL)
		BEGIN
		  SET @RecipeImage_Val = NULL
		END
	ELSE
		BEGIN
		  SET @RecipeImage_Val = @RecipeImage
		END

	INSERT INTO Recipes (Name,Author,CAT_ID,Category,Ingredients,Instructions, RecipeImage, [UID])
		VALUES(
				@Name,
				@Author,
				@Cat_Id,
				@CategoryValue,
				@Ingredients,
				@Instructions,
				@RecipeImage_Val,
				@UserID
			  )

END

IF ( @ErrorCode = 0 )
	COMMIT TRANSACTION
ELSE
	ROLLBACK TRANSACTION

RETURN @ErrorCode
GO
/****** Object:  StoredProcedure [dbo].[spActivateAccount]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActivateAccount]

@GUID varchar(100)

AS
BEGIN

	SET NOCOUNT ON;

    IF Exists (SELECT [GUID] FROM dbo.usersmain WITH (NOLOCK) WHERE [GUID] = @GUID)
       BEGIN
         
          UPDATE dbo.usersmain
          SET Activation = 1
          WHERE [GUID] = @GUID

       END

END
GO
/****** Object:  StoredProcedure [dbo].[FinalizeArticleSubmission]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <6/6/2008>
-- Description:	<Finlize article submission>
-- =============================================
CREATE PROCEDURE [dbo].[FinalizeArticleSubmission]

@ID int

AS
BEGIN

	SET NOCOUNT ON;

	UPDATE Cooking_Article SET Show = 1, Post_Date = GETDATE()
    Where ID = @ID

END
GO
/****** Object:  StoredProcedure [dbo].[ArticleDelete]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <6/28/2008>
-- Description:	<Delete article>
-- =============================================
CREATE PROCEDURE [dbo].[ArticleDelete] 

@ID int

AS
BEGIN
    
DELETE dbo.Cooking_Article WHERE ID = @ID

END
GO
/****** Object:  StoredProcedure [dbo].[ArticleCountAll]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <7/4/2008>
-- Description:	<Count All Article>
-- =============================================
CREATE PROCEDURE [dbo].[ArticleCountAll] 

AS
BEGIN

	SET NOCOUNT ON;

    Select Count(*) From Cooking_Article Where Show = 1

END
GO
/****** Object:  StoredProcedure [dbo].[AdminUpdateShowHideComment]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/31/2008>
-- Description:	<Show or hide comment>
-- =============================================
CREATE PROCEDURE [dbo].[AdminUpdateShowHideComment] 

@Showhide int

AS
BEGIN

	SET NOCOUNT ON;

    UPDATE Configuration SET HideShowComment = @Showhide

END
GO
/****** Object:  StoredProcedure [dbo].[AdminUpdateLastViewedHours]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/31/2008>
-- Description:	<Update Last Viewed Hours Span>
-- =============================================
CREATE PROCEDURE [dbo].[AdminUpdateLastViewedHours]
 
@Minutes int

AS
BEGIN

	SET NOCOUNT ON;

    UPDATE ConfigureLastViewedHours SET Hourspan = @Minutes

END
GO
/****** Object:  StoredProcedure [dbo].[AdminUpdateEmailAndSMTPAddress]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <6/13/2008>
-- Description:	<Update Email and SMTP server address.>
-- =============================================
CREATE PROCEDURE [dbo].[AdminUpdateEmailAndSMTPAddress] 

@Email varchar(100),
@SMTP varchar(50)

AS
BEGIN

	SET NOCOUNT ON;

Update Configuration SET
                        Email = @Email,
                        SmtpServer = @SMTP

END
GO
/****** Object:  StoredProcedure [dbo].[AdminManagerGetRecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/29/2008>
-- Description:	<Returns admin manager recipe with custom paging and filter>
-- =============================================
CREATE PROCEDURE [dbo].[AdminManagerGetRecipe]

@Letter char(1) = '',
@CAT_ID int = '',
@Tab int = '',
@Find varchar(50) = '',
@Top int = '',
@Year int = '',
@Month int = '',
@RecipeImage int = '',
@LastViewed int = '',
@PageIndex int = 1,
@PageSize int = 20

AS
BEGIN

DECLARE @StartRow int
DECLARE @EndRow int

SET @StartRow = (@PageSize * (@PageIndex - 1))  + 1  
SET @EndRow = @PageSize * @PageIndex + 1

IF (@LastViewed <> '')
    BEGIN

    DECLARE @NumDays int

    IF (@LastViewed = 1)
        BEGIN
	        SET @NumDays = 1 -- 1 day
        END
    ELSE IF (@LastViewed = 2) 
        BEGIN
	        SET @NumDays = 2 -- 2 days
        END
    ELSE IF (@LastViewed = 3)
        BEGIN
	        SET @NumDays = 3 -- 3 days
        END
    ELSE IF (@LastViewed = 4)
        BEGIN
	        SET @NumDays = 4 -- 4 days
        END
    ELSE IF (@LastViewed = 5)
        BEGIN
	        SET @NumDays = 5 -- 5 days
        END
    ELSE IF (@LastViewed = 6)
        BEGIN
	        SET @NumDays = 6 -- 6 days
        END
    ELSE IF (@LastViewed = 7)
        BEGIN
	        SET @NumDays = 7 -- 1 week
        END
    ELSE IF (@LastViewed = 14)
        BEGIN
	       SET @NumDays = 14 -- 2 weeks
        END
    ELSE IF (@LastViewed = 30)
        BEGIN
	       SET @NumDays = 30 -- 1 month
        END
    ELSE
        BEGIN
	        SET @NumDays = 1 -- default to 1 day
        END
END

DECLARE @Letter_Val varchar(50)
DECLARE @CAT_ID_Val int
DECLARE @Tab_Val int
DECLARE @Find_Val varchar(50)
DECLARE @Top_Val int
DECLARE @Year_Val int
DECLARE @Month_Val int
DECLARE @Date_Val int
DECLARE @RecipeImage_Val int
DECLARE @LastViewed_Val int

IF (@Letter <> '')
   BEGIN
		SET @Letter_Val = @Letter
   END
ELSE
   BEGIN
		SET @Letter_Val = NULL
   END

IF (@CAT_ID <> '')
	BEGIN
		SET @CAT_ID_Val = @CAT_ID
	END
ELSE
	BEGIN
		SET @CAT_ID_Val = NULL
	END

IF (@Tab <> '')
	BEGIN
		SET @Tab_Val = @Tab
	END
ELSE
	BEGIN
		SET @Tab_Val = NULL
	END

IF (@Find <> '')
	BEGIN
		SET @Find_Val = @Find
	END
ELSE
	BEGIN
		SET @Find_Val = NULL
	END

IF (@Top <> '')
	BEGIN
		SET @Top_Val = @Top
	END
ELSE
	BEGIN
		SET @Top_Val = NULL
	END

IF (@Year <> '' AND @Month <> '')
	BEGIN
        SET @Date_Val = 1
		SET @Year_Val = @Year
		SET @Month_Val = @Month
	END
ELSE
	BEGIN
		SET @Date_Val = NULL
		SET @Year_Val = NULL
		SET @Month_Val = NULL
	END

IF (@RecipeImage <> '')
	BEGIN
		SET @RecipeImage_Val = @RecipeImage
	END
ELSE
	BEGIN
		SET @RecipeImage_Val = NULL
	END

IF (@LastViewed <> '')
	BEGIN
		SET @LastViewed_Val = @LastViewed
	END
ELSE
	BEGIN
		SET @LastViewed_Val = NULL
	END


DECLARE @MaxHits int
SET @MaxHits = 1000

DECLARE @CountRecord int

--Returns total count
SELECT @CountRecord = Count(*) FROM dbo.Recipes WITH (NOLOCK) 
	WHERE 
	(@Find_Val IS NOT NULL AND [Name] LIKE '%' + COALESCE(@Find, [Name]) + '%') OR
	(@Letter_Val IS NOT NULL AND [Name] LIKE COALESCE(@Letter, [Name]) + '%') OR
	(@CAT_ID_Val IS NOT NULL AND CAT_ID = @CAT_ID) OR
	(@Tab_Val IS NOT NULL AND LINK_APPROVED = 0) OR
	(@Top_Val IS NOT NULL AND Hits > @MaxHits) OR
	(@Date_Val IS NOT NULL AND (DATEPART([year], Date) = @Year AND DATEPART([month], Date) = @Month)) OR
	(@RecipeImage_Val IS NOT NULL AND (RecipeImage IS NOT NULL AND LEN(RecipeImage) > 1)) OR
	(@LastViewed_Val IS NOT NULL AND HIT_DATE >= DATEADD(day, - @NumDays, GETDATE()) OR
    (@Letter_Val IS NULL AND @CAT_ID_Val IS NULL AND @Find_Val IS NULL AND @Tab_Val IS NULL AND @Top_Val IS NULL 
    AND @Year_Val IS NULL AND @Month_Val IS NULL AND @RecipeImage_Val IS NULL AND @LastViewed_Val IS NULL))


 SET NOCOUNT ON;

 WITH Recipe AS
   (
	 SELECT
	   ROW_NUMBER() OVER 
		 (
			ORDER BY ID
		 ) AS RowNumber, 
		   ID, 
		   CAT_ID, 
		   Category, 
		   [Name], 
		   Author, 
		   Date, 
		   HITS,
           HIT_DATE,
		   RecipeImage,
		   @CountRecord AS RCount
	  FROM dbo.Recipes WITH (NOLOCK) 
		  WHERE 
		  (@Find_Val IS NOT NULL AND [Name] LIKE '%' + COALESCE(@Find, [Name]) + '%') OR
		  (@Letter_Val IS NOT NULL AND [Name] LIKE COALESCE(@Letter, [Name]) + '%') OR
		  (@CAT_ID_Val IS NOT NULL AND CAT_ID = @CAT_ID) OR
		  (@Tab_Val IS NOT NULL AND LINK_APPROVED = 0) OR
		  (@Top_Val IS NOT NULL AND Hits >= @MaxHits) OR
		  (@Date_Val IS NOT NULL AND (DATEPART([year], Date) = @Year AND DATEPART([month], Date) = @Month)) OR
		  (@RecipeImage_Val IS NOT NULL AND (RecipeImage IS NOT NULL AND LEN(RecipeImage) > 1)) OR
		  (@LastViewed_Val IS NOT NULL AND HIT_DATE >= DATEADD(day, - @NumDays, GETDATE()) 
		  OR --Returns no filter record set
          (@Letter_Val IS NULL AND @CAT_ID_Val IS NULL AND @Find_Val IS NULL AND @Tab_Val IS NULL AND @Top_Val IS NULL 
		  AND @Year_Val IS NULL AND @Month_Val IS NULL AND @RecipeImage_Val IS NULL AND @LastViewed_Val IS NULL))
	 )
	 -- Statement that executes the CTE
	 SELECT a.*
	 FROM
		   Recipe a
	 WHERE
		   a.RowNumber BETWEEN @StartRow AND @EndRow - 1
	 ORDER BY
		   a.RowNumber

END
GO
/****** Object:  StoredProcedure [dbo].[AdminManagerDeleteRecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/29/2008>
-- Description:	<Perform delete from Admin recipe manager>
-- =============================================
CREATE PROCEDURE [dbo].[AdminManagerDeleteRecipe]

@ID int

AS
BEGIN

	SET NOCOUNT ON;

   DELETE dbo.Recipes WHERE ID = @ID;

   -- Cascade delete to CookBook table. Delete all recipe saved in cookbook.
   DELETE dbo.userCookBook WHERE RecipeID = @ID

END
GO
/****** Object:  StoredProcedure [dbo].[AdminGetRecipeComments]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <7/3/2008>
-- Description:	<Admin display comments in datagrid>
-- =============================================
CREATE PROCEDURE [dbo].[AdminGetRecipeComments]

@FindByAuthor varchar(50) = ''

AS
BEGIN

SET NOCOUNT ON;

DECLARE @FindByAuthor_Val varchar(50)

IF (@FindByAuthor = '')
   BEGIN
	 SET @FindByAuthor_Val = NULL
   END
ELSE
   BEGIN
	 SET @FindByAuthor_Val = @FindByAuthor
   END

	SELECT COM_ID, 
			ID, 
			AUTHOR, 
			EMAIL, 
			COMMENTS, 
			DATE 
	FROM 
		dbo.COMMENTS_RECIPE WITH (NOLOCK)
	WHERE (@FindByAuthor_Val IS NOT NULL AND AUTHOR = @FindByAuthor) OR (@FindByAuthor = '')
	ORDER By DATE DESC

END
GO
/****** Object:  StoredProcedure [dbo].[AdminGetRecipeCategoryManager]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<DExter Zafra>
-- Create date: <7/4/2008>
-- Description:	<Return admin category manager grid>
-- =============================================
CREATE PROCEDURE [dbo].[AdminGetRecipeCategoryManager] 

AS
BEGIN

	SET NOCOUNT ON;

    SELECT CAT_ID, CAT_TYPE, 
           CASE GROUPCAT
              WHEN '1' THEN 'Main Course'
              WHEN '2' THEN 'Ethnic Regional'
           END AS GROUPCAT, (SELECT COUNT (*)
     FROM Recipes WITH (NOLOCK) WHERE Recipes.CAT_ID = RECIPE_CAT.CAT_ID 
     AND LINK_APPROVED = 1) AS REC_COUNT
     FROM RECIPE_CAT WITH (NOLOCK)
     ORDER BY CAT_ID ASC

END
GO
/****** Object:  StoredProcedure [dbo].[AdminDeleteRecipeComments]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <7/3/2008>
-- Description:	<Delete Comment>
-- =============================================
CREATE PROCEDURE [dbo].[AdminDeleteRecipeComments] 

@COMID int,
@RecipeID int

AS
BEGIN

	SET NOCOUNT ON;

    DELETE dbo.COMMENTS_RECIPE WHERE COM_ID = @COMID;

    -- Decrement Total comments count in recipe tabale
    UPDATE dbo.Recipes SET TOTAL_COMMENTS = TOTAL_COMMENTS - 1 WHERE ID = @RecipeID

END
GO
/****** Object:  StoredProcedure [dbo].[AdminDeleteRecipeCategory]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <7/4/2008>
-- Description:	<Delete recipe category>
-- =============================================
CREATE PROCEDURE [dbo].[AdminDeleteRecipeCategory] 

@CatId int

AS
BEGIN

	SET NOCOUNT ON;

    -- Category table
    DELETE dbo.RECIPE_CAT WHERE CAT_ID = @CatId;

    --Cscade Delete to Recipe table, delete all associated recipes.
    DELETE dbo.Recipes WHERE CAT_ID = @CatId;

    -- Cascade delete to userCookBook table. Delete all recipe in CookBook belong to this category.
    DELETE dbo.userCookBook WHERE RecipeID IN (SELECT ID FROM dbo.Recipes WHERE CAT_ID = @CatId)

END
GO
/****** Object:  StoredProcedure [dbo].[AdminDeleteArticleComments]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AdminDeleteArticleComments] 

@ID int,
@AID int

AS
BEGIN

	SET NOCOUNT ON;

    DELETE dbo.COMMENTS_ARTICLE WHERE COM_ID = @ID;

    -- Decrement Total comments count in article tabale
    UPDATE dbo.Cooking_Article SET Total_Comments = Total_Comments - 1 WHERE ID = @AID

END
GO
/****** Object:  StoredProcedure [dbo].[AdminDeleteArticleCategory]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <7/4/2008>
-- Description:	<Delete Article Category>
-- =============================================
CREATE PROCEDURE [dbo].[AdminDeleteArticleCategory] 

@CatId int

AS
BEGIN

	SET NOCOUNT ON;

    DELETE dbo.Cooking_Article_Category WHERE CAT_ID = @CatId

    -- Cscade Delete to Article table, delete all associated articles
    DELETE dbo.Cooking_Article WHERE CAT_ID = @CatId

END
GO
/****** Object:  StoredProcedure [dbo].[AdminApproveRecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/29/2008>
-- Description:	<Approved recipe>
-- =============================================
CREATE PROCEDURE [dbo].[AdminApproveRecipe]

@ID int

AS
BEGIN

	SET NOCOUNT ON;

       -- Approve recipe
       UPDATE dbo.Recipes Set LINK_APPROVED = 1, Date = Getdate() Where ID = @ID

END
GO
/****** Object:  StoredProcedure [dbo].[AdminAddNewRecipeCategory]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <7/4/2008>
-- Description:	<Add new recipe category>
-- =============================================
CREATE PROCEDURE [dbo].[AdminAddNewRecipeCategory] 

@CatName varchar(100),
@Group int

AS

declare @ErrorCode int

set @ErrorCode = @@error

BEGIN TRANSACTION

if ( @ErrorCode = 0 )

Begin

-- Insert
INSERT INTO RECIPE_CAT (CAT_TYPE, GROUPCAT)
	VALUES(@CatName, @Group)

End

if ( @ErrorCode = 0 )
	COMMIT TRANSACTION
else
	ROLLBACK TRANSACTION

return @ErrorCode
GO
/****** Object:  StoredProcedure [dbo].[AdminAddNewArticleCategory]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <7/4/2008>
-- Description:	<Add new article category>
-- =============================================
CREATE PROCEDURE [dbo].[AdminAddNewArticleCategory] 

@CatName varchar(100)

AS

declare @ErrorCode int

set @ErrorCode = @@error

BEGIN TRANSACTION

IF ( @ErrorCode = 0 )

BEGIN

	-- Insert
	INSERT INTO Cooking_Article_Category (CAT_NAME)
		VALUES(@CatName)

END

IF ( @ErrorCode = 0 )
	COMMIT TRANSACTION
ELSE
	ROLLBACK TRANSACTION

RETURN @ErrorCode
GO
/****** Object:  StoredProcedure [dbo].[AdminAddCookingArticle]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <6/5/2008>
-- Description:	<Add cooking article>
-- =============================================
CREATE PROCEDURE [dbo].[AdminAddCookingArticle] 

@Title varchar(200),
@Content ntext,
@Author varchar(50),
@CAT_ID int,
@Keyword varchar(255),
@Summary ntext

AS

DECLARE @ErrorCode int

SET @ErrorCode = @@error

BEGIN TRANSACTION

IF ( @ErrorCode = 0 )

	BEGIN

	INSERT INTO dbo.Cooking_Article (Title,[Content],Author,CAT_ID,Keyword,Summary)
		VALUES(
			@Title,
			@Content,
			@Author,
			@CAT_ID,
			@Keyword,
			@Summary
			)
	END

IF ( @ErrorCode = 0 )
	COMMIT TRANSACTION
ELSE
	ROLLBACK TRANSACTION

RETURN @ErrorCode
GO
/****** Object:  StoredProcedure [dbo].[AddRating]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/23/2008>
-- Description:	<Insert rating>
-- =============================================
CREATE PROCEDURE [dbo].[AddRating]

@ID int,
@Rating int

AS
BEGIN

SET NOCOUNT ON;

	IF Exists (SELECT ID FROM dbo.Recipes WITH (NOLOCK) WHERE ID = @ID)
	  BEGIN
		 UPDATE dbo.Recipes SET RATING = RATING + dbo.fnValidateRatingValue(@Rating), NO_RATES = NO_RATES + 1 WHERE ID = @ID
	  END

END
GO
/****** Object:  StoredProcedure [dbo].[AddComments]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/23/2008>
-- Description:	<Add comments>
-- =============================================
CREATE PROCEDURE [dbo].[AddComments]

@ID int,
@Author varchar(20),
@Email varchar(50),
@Comments varchar(200),
@UserID int

AS

DECLARE @ErrorCode int

SET @ErrorCode = @@error

BEGIN TRANSACTION

IF ( @ErrorCode = 0 )

BEGIN

	IF Exists (SELECT ID FROM dbo.Recipes WITH (NOLOCK) WHERE ID = @ID)
	  BEGIN
		-- Insert
		INSERT INTO COMMENTS_RECIPE (ID,AUTHOR,EMAIL,COMMENTS, [UID])
			VALUES(
				@ID,
				@Author,
				@Email,
				@Comments,
				@UserID
				);

		-- Update comment count
		Update Recipes SET TOTAL_COMMENTS = TOTAL_COMMENTS + 1 where ID = @ID
	  END

END

IF ( @ErrorCode = 0 )
	COMMIT TRANSACTION
ELSE
	ROLLBACK TRANSACTION

RETURN @ErrorCode
GO
/****** Object:  StoredProcedure [dbo].[AddArticleRating]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <6/6/2008>
-- Description:	<Add article rating>
-- =============================================
CREATE PROCEDURE [dbo].[AddArticleRating] 

@ID int,
@Rating int

AS
BEGIN

SET NOCOUNT ON;

	IF Exists (SELECT ID FROM dbo.Cooking_Article WITH (NOLOCK) WHERE ID = @ID)
	  BEGIN
		 UPDATE dbo.Cooking_Article Set No_Rating = No_Rating + dbo.fnValidateRatingValue(@Rating), No_Rates = No_Rates + 1 WHERE ID = @ID
	  END

END
GO
/****** Object:  StoredProcedure [dbo].[CategoryPage_GetRecipesCount]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/20/2008>
-- Description:	<Get recipe count in category>
-- =============================================
CREATE PROCEDURE [dbo].[CategoryPage_GetRecipesCount]

@CatId int

AS
BEGIN

SET NOCOUNT ON;

SELECT COUNT(*) FROM Recipes WITH (NOLOCK) 
WHERE LINK_APPROVED = 1 AND CAT_ID = @CatId

END
GO
/****** Object:  StoredProcedure [dbo].[GetXMLToprecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/28/2008>
-- Description:	<Return Top 20 RSS>
-- =============================================
CREATE PROCEDURE [dbo].[GetXMLToprecipe]

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Top 20 ID, 
			[Name], 
			HITS, 
			Date,
			Category 
	FROM 
		dbo.Recipes WITH (NOLOCK)
	WHERE 
		LINK_APPROVED = 1 
	ORDER BY Hits DESC

END
GO
/****** Object:  StoredProcedure [dbo].[GetXMLNewestRecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/28/2008>
-- Description:	<Return 20 newest RSS XML>
-- =============================================
CREATE PROCEDURE [dbo].[GetXMLNewestRecipe] 

AS
BEGIN

	SET NOCOUNT ON;

	SELECT Top 20 ID, 
			[Name], 
			HITS, 
			Date,
			Category 
	FROM 
		dbo.Recipes WITH (NOLOCK)
	WHERE 
		LINK_APPROVED = 1 
	ORDER BY Date DESC

END
GO
/****** Object:  StoredProcedure [dbo].[GetUnApprovedRecipeCount]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/29/2008>
-- Description:	<Returns waiting for approval recipe count.>
-- =============================================
CREATE PROCEDURE [dbo].[GetUnApprovedRecipeCount]

AS
BEGIN

	SET NOCOUNT ON;

    SELECT Count(*) FROM dbo.Recipes WITH (NOLOCK) WHERE LINK_APPROVED = 0

END
GO
/****** Object:  StoredProcedure [dbo].[GetTotalCommentsCount]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/29/2008>
-- Description:	<Returns total comments count>
-- =============================================
CREATE PROCEDURE [dbo].[GetTotalCommentsCount]

AS
BEGIN

	SET NOCOUNT ON;

    SELECT Count(*) FROM dbo.COMMENTS_RECIPE WITH (NOLOCK)

END
GO
/****** Object:  StoredProcedure [dbo].[GetTotalCategoryCount]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/21/2008>
-- Description:	<Return total category count>
-- =============================================
CREATE PROCEDURE [dbo].[GetTotalCategoryCount]

AS
BEGIN

	SET NOCOUNT ON;

SELECT COUNT(*) FROM dbo.Recipes WITH (NOLOCK)

END
GO
/****** Object:  StoredProcedure [dbo].[GetTopRecipesSideMenu]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/18/2008>
-- Description:	<Get the most popular recipes for the homepage and category page side menu.>
-- =============================================
CREATE PROCEDURE [dbo].[GetTopRecipesSideMenu] 

@CatId int = '',
@Top int

AS
BEGIN

DECLARE @CatID_Val int

SET ROWCOUNT @Top

If (@CatId <> '')
   BEGIN
     SET @CatID_Val = 1
   END
ELSE
   BEGIN
     SET @CatID_Val = NULL
   END

   SELECT ID,
         [Name],
         HITS,
         Category,
         COALESCE(NULLIF(RecipeImage, ''), 'noimageavailable.gif') as RecipeImage
   FROM 
       dbo.Recipes WITH (NOLOCK)
   WHERE
   (@CatID_Val IS NOT NULL AND (LINK_APPROVED = 1 AND CAT_ID = @CatId)) OR
   (@CatID_Val IS NULL AND LINK_APPROVED = 1)
   ORDER BY 
       HITS DESC

   -- never forget to set it back to 0! 
   SET ROWCOUNT 0 

END
GO
/****** Object:  StoredProcedure [dbo].[GetSortingRecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/22/2008>
-- Description:	<Perform sorting>
-- =============================================
CREATE PROCEDURE [dbo].[GetSortingRecipe]

@Sid int,
@SortBy int = '',
@PageIndex int = 1,
@PageSize int = 20

AS
BEGIN

DECLARE @StartRow int
DECLARE @EndRow int

SET @StartRow = (@PageSize * (@PageIndex - 1))  + 1  
SET @EndRow = @PageSize * @PageIndex + 1

SET NOCOUNT ON;

WITH RecipeSorting AS
(
    SELECT TOP 100
       ROW_NUMBER() OVER 
         (
           -- Dynamic bidirectional sorting
            ORDER BY 
                  CASE WHEN @Sid = 1 AND @SortBy = 1 THEN HITS END DESC,
                  CASE WHEN @Sid = 1 AND @SortBy = '' THEN HITS END DESC,
                  CASE WHEN @Sid = 1 AND @SortBy = 2 THEN HITS END ASC,
                  CASE WHEN @Sid = 2 AND @SortBy = 1 THEN NO_RATES END DESC,
                  CASE WHEN @Sid = 2 AND @SortBy = '' THEN NO_RATES END DESC,
                  CASE WHEN @Sid = 2 AND @SortBy = 2 THEN NO_RATES END ASC,
                  CASE WHEN @Sid = 3 AND @SortBy = 2 THEN Name END ASC,
                  CASE WHEN @Sid = 3 AND @SortBy = '' THEN Name END ASC,
                  CASE WHEN @Sid = 3 AND @SortBy = 1 THEN Name END DESC,
                  CASE WHEN @Sid = 4 AND @SortBy = 1 OR @Sid = '' THEN Date END DESC,
                  CASE WHEN @Sid = 4 AND @SortBy = '' OR @Sid = '' THEN Date END DESC,
                  CASE WHEN @Sid = 4 AND @SortBy = 2 THEN Date END ASC
         ) AS RowNumber, 
              ID, 
              CAT_ID, 
              Category, 
              Name, 
              Author, 
              Date, 
              HITS, 
              RATING, 
              NO_RATES,
              [UID], 
              CAST((1.0 * RATING/NO_RATES) as decimal(2,1)) as Rates,
              COALESCE(NULLIF(RecipeImage, ''), 'noimageavailable.gif') as RecipeImage
    FROM
         dbo.Recipes WITH (NOLOCK)
    WHERE 
         LINK_APPROVED = 1
)
-- Statement that executes the CTE
SELECT a.*
FROM
      RecipeSorting a
WHERE
      a.RowNumber BETWEEN @StartRow AND @EndRow - 1
ORDER BY
      a.RowNumber

END
GO
/****** Object:  UserDefinedFunction [dbo].[GetSearchResultCount]    Script Date: 03/23/2012 10:10:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/24/2008>
-- Description:	<Returns search result count>
-- =============================================
CREATE FUNCTION [dbo].[GetSearchResultCount] 
(
@Search varchar(50),
@CAT_ID int
)
RETURNS int
AS
BEGIN

	-- Declare the return variable here
	DECLARE @GetCountSearchResult int

if (@CAT_ID <> 0)
 
 Begin

    -- Specific category search result count
	Set @GetCountSearchResult = (SELECT Count(*) As RecCount from Recipes
    Where LINK_APPROVED = 1 AND CAT_ID = @CAT_ID AND Name Like '%' + @Search + '%')

End

Else

Begin

    -- All category search result count
	Set @GetCountSearchResult = (SELECT Count(*) As RecCount from Recipes
    Where LINK_APPROVED = 1 AND Name Like '%' + @Search + '%')

End

	-- Return the result of the function
	RETURN @GetCountSearchResult

END
GO
/****** Object:  UserDefinedFunction [dbo].[GetSearchResultArticleCount]    Script Date: 03/23/2012 10:10:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <7/25/2008>
-- Description:	<Returns article search result count>
-- =============================================
CREATE FUNCTION [dbo].[GetSearchResultArticleCount] 
(
@Search varchar(50),
@CATID int
)
RETURNS int
AS
BEGIN

	-- Declare the return variable here
	DECLARE @GetCountSearchResult int

if (@CATID <> 0)
 
 Begin

    -- Specific category search result count
	Set @GetCountSearchResult = (SELECT Count(*) As RecCount from Cooking_Article
    Where Show = 1 AND CAT_ID = @CATID AND Title Like '%' + @Search + '%')

End

Else

Begin

    -- All category search result count
	Set @GetCountSearchResult = (SELECT Count(*) As RecCount from Cooking_Article
    Where Show = 1 AND Title Like '%' + @Search + '%')

End

	-- Return the result of the function
	RETURN @GetCountSearchResult

END
GO
/****** Object:  StoredProcedure [dbo].[UpdateRecipeComments]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <7/3/2008>
-- Description:	<Update recipe comment>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateRecipeComments] 

@ID int,
@Comment varchar(255)

AS

declare @ErrorCode int

Begin

Update COMMENTS_RECIPE Set 
                       COMMENTS = @Comment
                       Where COM_ID = @ID

set @ErrorCode = @@error
		
End

return @ErrorCode
GO
/****** Object:  StoredProcedure [dbo].[UpdateRecipeCategory]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <7/4/2008>
-- Description:	<Update recipe category>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateRecipeCategory] 

@Catid int,
@CatName varchar(100)

AS
BEGIN

	SET NOCOUNT ON;
    
    -- Category table
    Update RECIPE_CAT Set CAT_TYPE = @CatName Where CAT_ID = @Catid;

    -- Recipe table
    Update Recipes set Category = @CatName Where CAT_ID = @Catid
 
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateArticleComments]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateArticleComments]

@ID int,
@Comment varchar(255)

AS

DECLARE @ErrorCode int

BEGIN

UPDATE dbo.COMMENTS_ARTICLE SET 
                       Comments = @Comment
                       WHERE COM_ID = @ID

SET @ErrorCode = @@error
		
END

RETURN @ErrorCode
GO
/****** Object:  StoredProcedure [dbo].[UpdateArticleCategory]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <7/4/2008>
-- Description:	<Update article category>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateArticleCategory]

@Catid int,
@CatName varchar(100)

AS
BEGIN

	SET NOCOUNT ON;
    
    Update Cooking_Article_Category Set CAT_NAME = @CatName Where CAT_ID = @Catid

 
END
GO
/****** Object:  StoredProcedure [dbo].[spVerifyUserLoginCredential]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spVerifyUserLoginCredential]

@Username varchar(50),
@UserPassword varchar(50)

AS
BEGIN

	SET NOCOUNT ON;

	SELECT COUNT(*) AS UCount FROM dbo.usersmain WITH (NOLOCK) WHERE UserName = @Username AND Password = @UserPassword

END
GO
/****** Object:  StoredProcedure [dbo].[spValidateUsernameAndEmailOnRegistration]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spValidateUsernameAndEmailOnRegistration] 

@UserName varchar(50),
@Email varchar(50)

AS
BEGIN

--This sp will validate the username and email during registration.
--Preventing duplicate username and email.

IF Exists (SELECT UserName, Email FROM dbo.usersmain WITH (NOLOCK) WHERE UserName = @UserName AND Email = @Email)
	BEGIN
		SELECT 'USERNAME AND EMAIL ALREADY TAKEN' as Result
	END
ELSE IF Exists (SELECT UserName, Email FROM dbo.usersmain WITH (NOLOCK) WHERE UserName = @UserName)
	BEGIN
		SELECT 'USERNAME ALREADY TAKEN' as Result
	END
ELSE IF Exists (SELECT UserName, Email FROM dbo.usersmain WITH (NOLOCK) WHERE Email = @Email)
	BEGIN
		SELECT 'EMAIL ALREADY TAKEN' as Result
	END
ELSE
	BEGIN
		SELECT 'GOOD' as Result
	END

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateUserReceivePMEmailAlert]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateUserReceivePMEmailAlert]

@UserID int,
@NewVal int

AS
BEGIN

	UPDATE dbo.usersmain SET PMEmailNotification = @NewVal
	WHERE [UID] = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateUserReceivePM]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateUserReceivePM]

@UserID int,
@NewVal int

AS
BEGIN

	UPDATE dbo.usersmain SET ReceivePM = @NewVal 
	WHERE [UID] = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateUserPreferredPageSize]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateUserPreferredPageSize]

@UserID int,
@PreferredPagesize int

AS
BEGIN

SET NOCOUNT ON;

--Here we create a temp table variable to store our pagesize value for validation
--We don't want pagesize value that does not exists or too high.
DECLARE @TemptableVar TABLE (Pagesize int)
INSERT INTO @TemptableVar (Pagesize)
SELECT 10
UNION
SELECT 20
UNION
SELECT 30
UNION
SELECT 40
UNION
SELECT 50

--Check is the passed in pagesize value is exists before updating.
IF Exists (SELECT Pagesize FROM @TemptableVar WHERE Pagesize = @PreferredPagesize)
   BEGIN
	 UPDATE dbo.usersmain SET PreferredPageSize = @PreferredPagesize
     WHERE [UID] = @UserID
   END

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateUserPreferredLayout]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateUserPreferredLayout]

@UserID int,
@PreferredLayout int

AS
BEGIN

SET NOCOUNT ON;

--Here we create a temp table variable to store our layout value for validation
--We don't want layout value that does not exists.
DECLARE @TemptableVar TABLE (Layout int)
INSERT INTO @TemptableVar (Layout)
SELECT 1
UNION
SELECT 2
UNION
SELECT 3

--Check is the passed in layout value is exists before updating.
IF Exists (SELECT Layout FROM @TemptableVar WHERE Layout = @PreferredLayout)
   BEGIN
	 UPDATE dbo.usersmain SET PreferredLayout = @PreferredLayout
     WHERE [UID] = @UserID
   END

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateUser]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateUser] 

@UserID int,
@Password varchar(50) = '',
@Email    varchar(50) = '',
@Firstname varchar(50) = '',
@Lastname  varchar(50) = '',
@City	   varchar(50) = '',
@State     varchar(50) = '',
@Country   varchar(50) = '',
@DOB       varchar(50),
@FavoriteFoods1 varchar(50) = '',
@FavoriteFoods2 varchar(50) = '',
@FavoriteFoods3 varchar(50) = '',
@Newsletter     int,
@ContactMe      int,
@Website        varchar(100) = '',
@AboutMe        varchar(1000) = '',
@Photo          varchar(50) = ''

AS
BEGIN

SET NOCOUNT ON;

DECLARE @CityValue varchar(50)
DECLARE @PasswordValue varchar(50)
DECLARE @FirstnameValue varchar(50)
DECLARE @LastnameValue varchar(50)
DECLARE @EmailValue varchar(50)
DECLARE @StateValue varchar(50)
DECLARE @FavoriteFoods1Value varchar(50)
DECLARE @FavoriteFoods2Value varchar(50)
DECLARE @FavoriteFoods3Value varchar(50)
DECLARE @WebsiteValue varchar(50)
DECLARE @AboutMeValue varchar(50)
DECLARE @PhotoValue varchar(50)

IF (@City = '')
  BEGIN
    SET @CityValue = 'NA'
  END
ELSE
  BEGIN
    SET @CityValue = @City
  END

IF (@State = '')
  BEGIN
    SET @StateValue = 'NA'
  END
ELSE
  BEGIN
    SET @StateValue = @State
  END

IF (@FavoriteFoods1 = '')
  BEGIN
    SET @FavoriteFoods1Value = 'NA'
  END
ELSE
  BEGIN
    SET @FavoriteFoods1Value = @FavoriteFoods1
  END

IF (@FavoriteFoods2 = '')
  BEGIN
    SET @FavoriteFoods2Value = 'NA'
  END
ELSE
  BEGIN
    SET @FavoriteFoods2Value = @FavoriteFoods2
  END

IF (@FavoriteFoods3 = '')
  BEGIN
    SET @FavoriteFoods3Value = 'NA'
  END
ELSE
  BEGIN
    SET @FavoriteFoods3Value = @FavoriteFoods3
  END

IF (@Website = '')
  BEGIN
    SET @WebsiteValue = 'NA'
  END
ELSE
  BEGIN
    SET @WebsiteValue = @Website
  END

IF (@AboutMe = '')
  BEGIN
    SET @AboutMeValue = 'NA'
  END
ELSE
  BEGIN
    SET @AboutMeValue = @AboutMe
  END

IF (@Password = '')
  BEGIN
    SET @PasswordValue = (SELECT [Password] FROM dbo.usersmain WHERE [UID] = @UserID)
  END
ELSE
  BEGIN
    SET @PasswordValue = @Password
  END

IF (@Email = '')
  BEGIN
    SET @EmailValue = (SELECT Email FROM dbo.usersmain WHERE [UID] = @UserID)
  END
ELSE
  BEGIN
    SET @EmailValue = @Email
  END

IF (@Firstname = '')
  BEGIN
    SET @FirstnameValue = (SELECT FirstName FROM dbo.usersmain WHERE [UID] = @UserID)
  END
ELSE
  BEGIN
    SET @FirstnameValue = @Firstname
  END

IF (@Lastname = '')
  BEGIN
    SET @LastnameValue = (SELECT LastName FROM dbo.usersmain WHERE [UID] = @UserID)
  END
ELSE
  BEGIN
    SET @LastnameValue = @Lastname
  END

IF (@Photo = '')
  BEGIN
    SET @PhotoValue = (SELECT Photo FROM dbo.usersmain WHERE [UID] = @UserID)
  END
ELSE
  BEGIN
    SET @PhotoValue = @Photo
  END


IF Exists (SELECT [UID] FROM dbo.usersmain WHERE [UID] = @UserID)
   BEGIN

	UPDATE dbo.usersmain
	SET [Password]			= @PasswordValue,
		Email				= @EmailValue,
		FirstName			= @FirstnameValue,			
		LastName			= @LastnameValue,
		City				= @CityValue,
		[State]				= @StateValue,
		Country				= @Country,
		DOB					= @DOB,
		FavoriteFoods1		= @FavoriteFoods1Value,
		FavoriteFoods2		= @FavoriteFoods2Value,
		FavoriteFoods3		= @FavoriteFoods3Value,
		NewsLetter			= @Newsletter,
		ContactMe			= @ContactMe,
		Website				= @WebsiteValue,
		AboutMe				= @AboutMeValue,
		Photo				= @PhotoValue,
        LastUpdated			= GETDATE()

   WHERE [UID] = @UserID

   END


END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateShowHideFriendsListProfile]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateShowHideFriendsListProfile] 

@UserID int,
@NewValue int

AS
BEGIN

	SET NOCOUNT ON;

    UPDATE dbo.usersmain SET ShowFriendsListinProfile = @NewValue
    WHERE [UID] = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateShowHideCookBookInProfile]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateShowHideCookBookInProfile] 

@UserID int,
@NewValue int

AS
BEGIN

	SET NOCOUNT ON;

    UPDATE dbo.usersmain SET ShowCookBookinProfile = @NewValue
    WHERE [UID] = @UserID

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateRecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <6/12/2008>
-- Description:	<Update Recipe>
-- =============================================
CREATE PROCEDURE [dbo].[spUpdateRecipe] 

@UserID int,
@ID int,
@Name varchar(50),
@Cat_Id int,
@Ingredients varchar(1000),
@Instructions varchar(2000),
@Hits int,
@RecipeImage varchar(50) = Null

AS

DECLARE @ErrorCode int
DECLARE @Image varchar(50)
DECLARE @CatName varchar(50)

BEGIN

IF (@RecipeImage = '')
    BEGIN 
        SET @Image = NULL
     END
ELSE
    BEGIN
        SET @Image = @RecipeImage
    END

--Make sure it belongs to the right owner.
IF Exists (SELECT ID FROM dbo.Recipes WHERE [UID] = @UserID AND ID = @ID)

BEGIN

		IF (@Cat_Id = 0)

			BEGIN

			UPDATE Recipes SET 
						   [Name] = @Name,
						   Ingredients = @Ingredients,
						   Instructions = @Instructions,
						   HITS = @Hits,
						   RecipeImage = @Image,
						   [UID] = @UserID
						   WHERE ID = @ID
			SET @ErrorCode = @@error

			END

		ELSE

			BEGIN

			--Get Category Name
			SELECT @CatName = CAT_TYPE From RECIPE_CAT WHERE CAT_ID = @Cat_Id

			UPDATE Recipes SET 
						   Name = @Name,
						   CAT_ID = @Cat_Id,
						   Category = @CatName,
						   Ingredients = @Ingredients,
						   Instructions = @Instructions,
						   HITS = @Hits,
						   RecipeImage = @Image,
						   [UID] = @UserID
						   WHERE ID = @ID
			SET @ErrorCode = @@error

			END

--Insert Recipe Update Log
INSERT INTO dbo.RecipeUpdateLog(RID, [UID], DateUpdated) VALUES(@ID, @UserID, GETDATE())

END
		
END

RETURN @ErrorCode
GO
/****** Object:  StoredProcedure [dbo].[GetRandomRecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/21/2008>
-- Description:	<Return random recipe>
-- =============================================
CREATE PROCEDURE [dbo].[GetRandomRecipe]

@CatId int

AS
BEGIN

SET NOCOUNT ON;

DECLARE @CatIdValue int
DECLARE @CatID_Val int

If (@CatId <> '')
   BEGIN
	 IF NOT Exists (SELECT CAT_ID FROM dbo.RECIPE_CAT WITH (NOLOCK) WHERE CAT_ID = @CatId)
		  BEGIN
			SET @CatIdValue = (SELECT TOP 1 CAT_ID FROM dbo.RECIPE_CAT WITH (NOLOCK))
		  END
		ELSE
		  BEGIN
			SET @CatIdValue = @CatId
		  END
     SET @CatID_Val = 1
   END
ELSE
   BEGIN
     SET @CatID_Val = NULL
   END

SELECT ID, 
       CAT_ID, 
       Category, 
       [Name],  
       HITS, 
       RATING,
       NO_RATES, 
       Cast((1.0 * RATING/NO_RATES) as decimal(2,1)) as Rates,
       COALESCE(NULLIF(RecipeImage, ''), 'noimageavailable.gif') as RecipeImage 
       FROM 
			dbo.Recipes WITH (NOLOCK) 
       WHERE 
	   (@CatID_Val IS NOT NULL AND (LINK_APPROVED = 1 AND CAT_ID = @CatIdValue)) OR
       (@CatID_Val IS NULL AND LINK_APPROVED = 1)
       ORDER BY NEWID()

END
GO
/****** Object:  StoredProcedure [dbo].[GetNewestRecipesSideMenu]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/21/2008>
-- Description:	<Get the newest and top recipes for the sidemenu with count date difference.>
-- =============================================
CREATE PROCEDURE [dbo].[GetNewestRecipesSideMenu] 

@CatId int = '',
@Top int

AS
BEGIN

DECLARE @CatIdValue int
DECLARE @CatID_Val int

SET ROWCOUNT @Top

If (@CatId <> '')
   BEGIN
	 IF NOT Exists (SELECT CAT_ID FROM dbo.RECIPE_CAT WITH (NOLOCK) WHERE CAT_ID = @CatId)
		  BEGIN
			SET @CatIdValue = (SELECT TOP 1 CAT_ID FROM dbo.RECIPE_CAT WITH (NOLOCK))
		  END
		ELSE
		  BEGIN
			SET @CatIdValue = @CatId
		  END
     SET @CatID_Val = 1
   END
ELSE
   BEGIN
     SET @CatID_Val = NULL
   END


   SELECT ID,
         [Name],
         HITS,
         Category,
         Date,
         COALESCE(NULLIF(RecipeImage, ''), 'noimageavailable.gif') as RecipeImage
   FROM 
		Recipes WITH (NOLOCK)
   WHERE
   (@CatID_Val IS NOT NULL AND (LINK_APPROVED = 1 AND CAT_ID = @CatIdValue)) OR
   (@CatID_Val IS NULL AND LINK_APPROVED = 1)
   ORDER BY 
		Date DESC

   -- never forget to set it back to 0! 
   SET ROWCOUNT 0 

END
GO
/****** Object:  StoredProcedure [dbo].[GetNewestArticleSidePanel]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <6/6/2008>
-- Description:	<Returns 10 newest cooking articles in the right side panel.>
-- =============================================
CREATE PROCEDURE [dbo].[GetNewestArticleSidePanel] 

@Top int

AS
BEGIN

	SET ROWCOUNT @Top

    SELECT a.ID, 
           a.CAT_ID,
           a.Title,
           a.Hits,
           a.Post_Date,
           b.CAT_NAME
       FROM 
           dbo.Cooking_Article a WITH (NOLOCK) 
	   INNER JOIN 
           dbo.Cooking_Article_Category b WITH (NOLOCK)
       ON 
           a.CAT_ID = b.CAT_ID
       WHERE 
           a.Show = 1
       ORDER BY 
           a.Post_Date DESC

    -- never forget to set it back to 0! 
    SET ROWCOUNT 0 

END
GO
/****** Object:  StoredProcedure [dbo].[GetLastViewedRecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/29/2008>
-- Description:	<Returns last viewed>
-- =============================================
CREATE PROCEDURE [dbo].[GetLastViewedRecipe]

AS
BEGIN

	SET NOCOUNT ON;

	-- Use sub-query to get the datediff
	DECLARE @HourSpan int

	SELECT @HourSpan = HourSpan FROM ConfigureLastViewedHours WITH (NOLOCK)

	SELECT Top 15 ID, 
		   [Name], 
		   Category, 
		   HITS, 
		   HIT_DATE,
		   COALESCE(NULLIF(RecipeImage, ''), 'noimageavailable.gif') as RecipeImage,
		   TotalTime / 3600 as Hours, 
		   (TotalTime % 3600) / 60 as Minutes, 
		   TotalTime % 60 as Seconds,
		   (@HourSpan / 60) as MinuteSpan
	FROM
		  (
			SELECT ID, 
				   [Name], 
				   Category, 
				   HITS, 
				   HIT_DATE,
				   COALESCE(NULLIF(RecipeImage, ''), 'noimageavailable.gif') as RecipeImage,
				   DateDiff(second, HIT_DATE, GetDate()) As TotalTime 
				   FROM 
					 Recipes WITH (NOLOCK)  
				   WHERE 
					 DateDiff(minute, HIT_DATE, GetDate()) <= @HourSpan
	            
	) a
	ORDER BY HIT_DATE DESC
          
END
GO
/****** Object:  StoredProcedure [dbo].[GetArticleForDropdownlist]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <6/5/2008>
-- Description:	<Return article category for the dropdown list.>
-- =============================================
CREATE PROCEDURE [dbo].[GetArticleForDropdownlist]

AS
BEGIN

	SET NOCOUNT ON;
  
	SELECT CAT_ID, CAT_NAME From Cooking_Article_Category WITH (NOLOCK)

END
GO
/****** Object:  StoredProcedure [dbo].[GetArticleDetails]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <6/5/2008>
-- Description:	<Returns article details>
-- =============================================
CREATE PROCEDURE [dbo].[GetArticleDetails] 

@AID int,
@Show int

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @Show_Val int

	IF (@Show = 1)
		BEGIN
		   SET @Show_Val = 1
		END
	ELSE
		BEGIN
		   SET @Show_Val = NULL
		END

	SELECT a.ID,
		   a.CAT_ID,
		   b.CAT_NAME, 
		   a.Title, 
		   a.Post_Date, 
		   a.Content, 
		   a.Hits, 
		   a.Author,
		   a.Keyword,
		   a.No_Rates, 
		   CAST((1.0 * a.No_Rating/a.No_Rates) as decimal(2,1)) as Rates,
		   a.Summary,
		   a.Total_Comments,
		   a.UID       
		   FROM 
				dbo.Cooking_Article a WITH (NOLOCK) 
		   INNER JOIN 
				dbo.Cooking_Article_Category b WITH (NOLOCK)
		   ON 
				a.CAT_ID = b.CAT_ID
		   WHERE
		   (@Show_Val IS NOT NULL AND (a.Show = 1 AND a.ID = @AID)) OR
		   (@Show_Val IS NULL AND a.ID = @AID)

	IF (@Show_Val IS NOT NULL)
		BEGIN
		   -- Update article hit counter
		   UPDATE dbo.Cooking_Article set Hits = Hits + 1 WHERE ID = @AID
		END

END
GO
/****** Object:  StoredProcedure [dbo].[GetArticleCategoryName]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter zafra>
-- Create date: <6/5/2008>
-- Description:	<Return article category name>
-- =============================================
CREATE PROCEDURE [dbo].[GetArticleCategoryName] 

@CAT_ID int

AS
BEGIN

	SET NOCOUNT ON;
  
	SELECT CAT_NAME From Cooking_Article_Category WITH (NOLOCK) Where CAT_ID = @CAT_ID

END
GO
/****** Object:  StoredProcedure [dbo].[GetArticleCategoryListing]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <6/6/2008>
-- Description:	<Return Article Category with count.>
-- =============================================
CREATE PROCEDURE [dbo].[GetArticleCategoryListing]

AS
BEGIN

	SET NOCOUNT ON;

   SELECT *,
      (
        SELECT COUNT (*)  
        FROM 
          Cooking_Article WITH (NOLOCK) 
        WHERE 
          Cooking_Article.CAT_ID = Cooking_Article_Category.CAT_ID AND Show = 1
      ) AS REC_COUNT 
     FROM 
        Cooking_Article_Category WITH (NOLOCK)
     ORDER BY 
        CAT_NAME ASC

END
GO
/****** Object:  StoredProcedure [dbo].[GetArticleCategoryList]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <6/5/2008>
-- Description:	<Returns article category list>
-- =============================================
CREATE PROCEDURE [dbo].[GetArticleCategoryList] 

AS
BEGIN

	SET NOCOUNT ON;

     SELECT *,
		(
		  SELECT COUNT (*)  
		  FROM 
			Cooking_Article WITH (NOLOCK) 
		  WHERE 
	        Cooking_Article.CAT_ID = Cooking_Article_Category.CAT_ID AND Show = 1
		) AS REC_COUNT 
     FROM 
		Cooking_Article_Category WITH (NOLOCK)
     ORDER BY 
		CAT_NAME ASC

END
GO
/****** Object:  UserDefinedFunction [dbo].[GetAlphaLetterCount]    Script Date: 03/23/2012 10:10:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/23/2008>
-- Description:	<Return count first letter recipe>
-- =============================================
CREATE FUNCTION [dbo].[GetAlphaLetterCount]
(
@Letter char(1)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @GetCountLetter int

	Set @GetCountLetter = (SELECT Count(*) As RecCount from Recipes
    Where LINK_APPROVED = 1 AND Name Like @Letter + '%')

	-- Return the result of the function
	RETURN @GetCountLetter

END
GO
/****** Object:  StoredProcedure [dbo].[GetHompageTotalCategoryCount]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/23/2008>
-- Description:	<Returns homepage total category count>
-- =============================================
CREATE PROCEDURE [dbo].[GetHompageTotalCategoryCount] 

AS
BEGIN

	SET NOCOUNT ON;

    SELECT COUNT(*) FROM RECIPE_CAT WITH (NOLOCK)

END
GO
/****** Object:  StoredProcedure [dbo].[GetHomepageEthnicRegionalCategory]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/23/2008>
-- Description:	<Returns homepage ethnic category>
-- =============================================
CREATE PROCEDURE [dbo].[GetHomepageEthnicRegionalCategory]

AS
BEGIN

	SET NOCOUNT ON;

     SELECT *,
        (
          SELECT COUNT (*)  
          FROM 
             Recipes WITH (NOLOCK) 
          WHERE 
             Recipes.CAT_ID = RECIPE_CAT.CAT_ID AND LINK_APPROVED = 1
        ) AS REC_COUNT 
     FROM 
          RECIPE_CAT WITH (NOLOCK) 
     WHERE 
          GROUPCAT = 2
     ORDER BY 
          CAT_TYPE ASC

END
GO
/****** Object:  StoredProcedure [dbo].[GetHomePageCategoryMainCourseRecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/21/2008>
-- Description:	<Return recipe homepage category main course>
-- =============================================
CREATE PROCEDURE [dbo].[GetHomePageCategoryMainCourseRecipe] 

AS
BEGIN

	SET NOCOUNT ON;

     SELECT *,
        (
          SELECT COUNT (*)  
          FROM 
             Recipes WITH (NOLOCK) 
          WHERE 
             Recipes.CAT_ID = RECIPE_CAT.CAT_ID AND LINK_APPROVED = 1
        ) AS REC_COUNT 
     FROM 
          RECIPE_CAT WITH (NOLOCK) 
     WHERE 
          GROUPCAT = 1
     ORDER BY 
          CAT_TYPE ASC

END
GO
/****** Object:  StoredProcedure [dbo].[GetCountTotalRecipes]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/21/2008>
-- Description:	<Count total recipes>
-- =============================================
CREATE PROCEDURE [dbo].[GetCountTotalRecipes] 

AS
BEGIN

	SET NOCOUNT ON;

     SELECT COUNT(*) FROM Recipes WITH (NOLOCK) 
     WHERE LINK_APPROVED = 1

END
GO
/****** Object:  StoredProcedure [dbo].[GetConfiguration]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/21/2008>
-- Description:	<Show hide comments>
-- =============================================
CREATE PROCEDURE [dbo].[GetConfiguration]

AS
BEGIN

	SET NOCOUNT ON;

Select HideShowComment, HideShowArticleComment, Email, SmtpServer from Configuration WITH (NOLOCK)

END
GO
/****** Object:  UserDefinedFunction [dbo].[GetCategoryRecipeCount]    Script Date: 03/23/2012 10:10:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/22/2008>
-- Description:	<Return recipe count>
-- =============================================
CREATE FUNCTION [dbo].[GetCategoryRecipeCount]
(
@CatId int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @GetCount int

	Set @GetCount = (SELECT Count(*) As RecCount from Recipes
    Where LINK_APPROVED = 1 AND CAT_ID = @CatId)

	-- Return the result of the function
	RETURN @GetCount

END
GO
/****** Object:  StoredProcedure [dbo].[GetCategoryName]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/21/2008>
-- Description:	<Get Category name>
-- =============================================
CREATE PROCEDURE [dbo].[GetCategoryName] 

@CatId int

AS
BEGIN

SET NOCOUNT ON;

     SELECT CAT_TYPE From RECIPE_CAT WITH (NOLOCK)
     Where CAT_ID = @CatId 

END
GO
/****** Object:  UserDefinedFunction [dbo].[GetCategoryArticleCount]    Script Date: 03/23/2012 10:10:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <7/25/2008>
-- Description:	<Return Article category count>
-- =============================================
CREATE FUNCTION [dbo].[GetCategoryArticleCount] 
(
@CatId int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @GetCount int

	Set @GetCount = (SELECT Count(*) As RecCount from Cooking_Article
    Where Show = 1 AND CAT_ID = @CatId)

	-- Return the result of the function
	RETURN @GetCount

END
GO
/****** Object:  View [dbo].[usersview]    Script Date: 03/23/2012 10:10:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[usersview]
AS

SELECT 	u.[UID], 
		u.UserName,
		u.[Password],
		u.Email,
		u.FirstName,
		u.LastName,
		u.City,
		u.[State],
		u.Country,
		u.isActive,
		u.DateJoined,
		u.Activation,
		u.LastVisit,
		u.Hits,
        u.LastUpdated,
		u.ShowFriendsListinProfile,
		u.ShowCookBookinProfile,
        u.NumRecordsCookBookQuickView,
        u.NumRecordsFriendsList,
		u.PreferredLayout,
		u.PreferredPageSize,
		u.IsUserChoosePreferredLayout,
		u.ReceivePM,
		u.PMEmailNotification,
		CASE u.UserLevel
		WHEN '1' THEN 'Regular Member'
		WHEN '2' THEN 'Editor'
		WHEN '3' THEN 'Administrator'
		END AS UserLevel,
		ISNULL(tsr.TotalSavedRecipe, 0) TotalSavedRecipe,
		ISNULL(tf.TotalFriends, 0) TotalFriends,
		ISNULL(tr.TotalSubmittedRecipe, 0) TotalSubmittedRecipe,
		ISNULL(tsa.TotalSubmittedArticle, 0) TotalSubmittedArticle,
        ISNULL(tcr.TotalCount, 0) TotalCommentRecipe,
        ISNULL(tca.TotalCount, 0) TotalCommentArticle,
		COALESCE(NULLIF(u.Photo, ''), 'nophotoavailable.gif') as UserImage
		FROM 
			dbo.usersmain u WITH (NOLOCK)
		LEFT OUTER JOIN
		(
			SELECT [UID], Count(*) as TotalSavedRecipe FROM dbo.userCookBook WITH (NOLOCK)
			GROUP BY [UID]
		) tsr
		ON
			u.[UID] = tsr.[UID]
		LEFT OUTER JOIN
        (
			SELECT [UID], Count(*) as TotalFriends FROM dbo.FriendsList WITH (NOLOCK)
			WHERE IsApproved = 1
			GROUP BY [UID]
         ) tf
		ON
			u.[UID] = tf.UID
		LEFT OUTER JOIN
		(
			SELECT [UID], Count(*) as TotalSubmittedRecipe FROM dbo.Recipes WITH (NOLOCK)
			GROUP BY [UID]
		) tr
		ON
			u.[UID] = tr.UID
		LEFT OUTER JOIN
		(
			SELECT [UID], Count(*) as TotalSubmittedArticle FROM dbo.Cooking_Article WITH (NOLOCK)
			GROUP BY [UID]
		) tsa
		ON
			u.[UID] = tsa.UID
		LEFT OUTER JOIN
		(
			SELECT [UID], Count(*) as TotalCount FROM dbo.COMMENTS_RECIPE WITH (NOLOCK)
			GROUP BY [UID]
		) tcr
		ON
			u.UID = tcr.UID
        LEFT OUTER JOIN
		(
			SELECT [UID], Count(*) as TotalCount FROM dbo.COMMENTS_ARTICLE WITH (NOLOCK)
			GROUP BY [UID]
		) tca
		ON
			u.UID = tca.UID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[16] 4[21] 2[45] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "u"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 274
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tsr"
            Begin Extent = 
               Top = 6
               Left = 312
               Bottom = 91
               Right = 479
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tf"
            Begin Extent = 
               Top = 6
               Left = 517
               Bottom = 91
               Right = 669
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tr"
            Begin Extent = 
               Top = 6
               Left = 707
               Bottom = 91
               Right = 892
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tsa"
            Begin Extent = 
               Top = 96
               Left = 312
               Bottom = 181
               Right = 495
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tcr"
            Begin Extent = 
               Top = 96
               Left = 533
               Bottom = 181
               Right = 685
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tca"
            Begin Extent = 
               Top = 96
               Left = 723
               Bottom = 181
               Right = 875
            End
            DisplayFlags = 280
            TopColumn = 0
         End' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'usersview'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'usersview'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'usersview'
GO
/****** Object:  StoredProcedure [dbo].[GetRelatedRecipe]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/23/2008>
-- Description:	<Return related recipes in the recipedetail page.>
-- =============================================
CREATE PROCEDURE [dbo].[GetRelatedRecipe]

@CatId int

AS
BEGIN

	SET NOCOUNT ON;

	SELECT TOP 15 ID,
				  CAT_ID, 
				  Category, 
				  [Name], 
				  Author, 
				  Date, 
				  HITS, 
				  RATING, 
				  NO_RATES,
                  [UID],
				  COALESCE(NULLIF(RecipeImage, ''), 'noimageavailable.gif') as RecipeImage,
				  Cast((1.0 * RATING/NO_RATES) as decimal(2,1)) as Rates
           FROM 
               dbo.Recipes WITH (NOLOCK)
           WHERE 
               LINK_APPROVED = 1 AND CAT_ID = @CatId
           ORDER BY
	           HITS DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetRecipeOfTheDay]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <2/23/2008>
-- Description:	<Returns recipe of the day query with sub-query>
-- =============================================
CREATE PROCEDURE [dbo].[GetRecipeOfTheDay]

AS
BEGIN

SET TEXTSIZE 150 --Set Ingredients and Instruction output character

	SET NOCOUNT ON;

/**********************************************************************************
* This query will return the recipe of the day. Use sub-query to claculate the absolute  
* date and modulo by the total rows count.
* You can use substring in SP to limit the character output for Text field.
* Example Code:
* Ingred = (Substring(Ingredients, 1, 100) + '...'), 
* Instruct = (Substring(Instructions, 1, 100) + '...'),
* Note: ROW_NUMBER() function don't work on SQL 2000
***********************************************************************************/

SELECT ID, 
       CAT_ID, 
       Category, 
       [Name],  
       HITS, 
       RATING,
       NO_RATES, 
       Ingredients = (Substring(Ingredients, 1, 150) + '...'),
       Instructions = (Substring(Instructions, 1, 100) + '...'),
       Cast((1.0 * RATING/NO_RATES) as decimal(2,1)) as Rates
FROM	(
	   SELECT ID, 
       CAT_ID, 
       Category, 
       [Name],  
       HITS, 
       RATING,
       NO_RATES, 
       Ingredients,
       Instructions,
       Cast((1.0 * RATING/NO_RATES) as decimal(2,1)) as Rates,
	   ROW_NUMBER() OVER (ORDER BY ID) - 1 as RecID
	   FROM	
          dbo.Recipes WITH (NOLOCK)
	) AS d
WHERE 
     RecID = ABS(CHECKSUM(CONVERT(varchar(10), GETDATE(), 120))) % (SELECT COUNT(*) FROM Recipes WITH (NOLOCK))

END
GO
/****** Object:  StoredProcedure [dbo].[GetRecipeImageFileNameForUpdate]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <9/7/2008>
-- Description:	<Get image filename for update>
-- =============================================
CREATE PROCEDURE [dbo].[GetRecipeImageFileNameForUpdate] 

@ID int

AS
BEGIN

	SET NOCOUNT ON;

    SELECT RecipeImage FROM Recipes WITH (NOLOCK) WHERE ID = @ID
END
GO
/****** Object:  StoredProcedure [dbo].[GetRecipeCategoryListSideMenu]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/21/2008>
-- Description:	<Returns category list for the side menu with count>
-- =============================================
CREATE PROCEDURE [dbo].[GetRecipeCategoryListSideMenu]

AS
BEGIN

	SET NOCOUNT ON;

	SELECT *, 
       (
         SELECT COUNT (*) 
         FROM 
            Recipes WITH (NOLOCK) 
         WHERE 
            Recipes.CAT_ID = RECIPE_CAT.CAT_ID AND LINK_APPROVED = 1
       ) AS REC_COUNT 
    FROM 
         RECIPE_CAT WITH (NOLOCK) 
    ORDER BY 
         CAT_TYPE ASC

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectEventWeekView]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectEventWeekView]

@StartDate datetime,
@EventType varchar(50) = 'All' 

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @EventType_Val varchar(50)

	IF (@EventType = 'All')
		 BEGIN
			SET @EventType_Val = NULL
		 END
	ELSE
		 BEGIN
			SET @EventType_Val = @EventType
		 END

	SELECT EVENT_ID, 
		   DATE_ADDED, 
		   [START_DATE], 
		   END_DATE,
		   CATEGORY,
		   EVENT_TITLE, 
		   EVENT_DETAILS,
		   APPMEETING_STARTTIME,
		   APPMEETING_ENDTIME,
		   [UID], 
		   [PRIVATE]
	FROM 
		 dbo.Events WITH (NOLOCK)
	WHERE 
	(@EventType_Val IS NULL AND ([PRIVATE] = 0 AND [START_DATE] = @StartDate))
	 OR
	(@EventType_Val IS NOT NULL AND ([PRIVATE] = 0 AND CATEGORY = @EventType AND [START_DATE] = @StartDate))

END
GO
/****** Object:  StoredProcedure [dbo].[spSelectDisplayAllMembersAdmin]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spSelectDisplayAllMembersAdmin]

@Input varchar(50),
@NumDays int = 0,
@OrderBy int = '',
@SortBy int = '',
@PageIndex int = 1,
@PageSize int = 20

AS
BEGIN

DECLARE @StartRow int
DECLARE @EndRow int

SET @StartRow = (@PageSize * (@PageIndex - 1))  + 1  
SET @EndRow = @PageSize * @PageIndex + 1

DECLARE @ItemCounter int

--Returns total records count
SELECT @ItemCounter = Count(*) 
FROM 
	dbo.usersview 
WHERE
(UserName LIKE COALESCE(@Input, '%')
 OR FirstName LIKE COALESCE(@Input, '%')
 OR LastName LIKE COALESCE(@Input, '%')
 OR City LIKE COALESCE(@Input, '%')
 OR [State] LIKE COALESCE(@Input, '%')
 OR Country LIKE COALESCE(@Input, '%')
 OR Email LIKE COALESCE(@Input, '%')
 OR (@NumDays > 0 AND DateJoined >= DATEADD(day, - @NumDays, GETDATE()))
 OR UserName LIKE COALESCE(@Input, UserName) + '%') -- Counter for Username alpha Letter search
 OR (@Input = 'none' AND @NumDays = 0) --Count all, no filter

SET NOCOUNT ON;

WITH Users AS
	(
		SELECT
		   ROW_NUMBER() OVER 
			 (
			  ORDER BY 
              CASE WHEN @OrderBy = 1 AND @SortBy = 1 THEN Hits END DESC,
              CASE WHEN @OrderBy = 1 AND @SortBy = '' THEN Hits END DESC,
              CASE WHEN @OrderBy = 1 AND @SortBy = 2 THEN Hits END ASC,
              CASE WHEN @OrderBy = 2 AND @SortBy = 1 THEN Email END DESC,
              CASE WHEN @OrderBy = 2 AND @SortBy = '' THEN Email END DESC,
              CASE WHEN @OrderBy = 2 AND @SortBy = 2 THEN Email END ASC,
              CASE WHEN @OrderBy = 3 AND @SortBy = 2 THEN UserName END ASC,
              CASE WHEN @OrderBy = 3 AND @SortBy = '' THEN UserName END ASC,
              CASE WHEN @OrderBy = 3 AND @SortBy = 1 THEN UserName END DESC,
              CASE WHEN @OrderBy = 4 AND @SortBy = 1 OR @OrderBy = '' THEN DateJoined END DESC,
              CASE WHEN @OrderBy = 4 AND @SortBy = '' OR @OrderBy = '' THEN DateJoined END DESC,
              CASE WHEN @OrderBy = 4 AND @SortBy = 2 THEN DateJoined END ASC,
              CASE WHEN @OrderBy = 5 AND @SortBy = 1 THEN LastVisit END DESC,
              CASE WHEN @OrderBy = 5 AND @SortBy = '' THEN LastVisit END DESC,
              CASE WHEN @OrderBy = 5 AND @SortBy = 2 THEN LastVisit END ASC,
              CASE WHEN @OrderBy = 6 AND @SortBy = 1 THEN isActive END DESC,
              CASE WHEN @OrderBy = 6 AND @SortBy = '' THEN isActive END DESC,
              CASE WHEN @OrderBy = 6 AND @SortBy = 2 THEN isActive END ASC,
              CASE WHEN @OrderBy = 7 AND @SortBy = 1 THEN TotalSavedRecipe END DESC,
              CASE WHEN @OrderBy = 7 AND @SortBy = '' THEN TotalSavedRecipe END DESC,
              CASE WHEN @OrderBy = 7 AND @SortBy = 2 THEN TotalSavedRecipe END ASC,
              CASE WHEN @OrderBy = 8 AND @SortBy = 1 THEN TotalFriends END DESC,
              CASE WHEN @OrderBy = 8 AND @SortBy = '' THEN TotalFriends END DESC,
              CASE WHEN @OrderBy = 8 AND @SortBy = 2 THEN TotalFriends END ASC,
              CASE WHEN @OrderBy = 9 AND @SortBy = 1 THEN TotalSubmittedRecipe END DESC,
              CASE WHEN @OrderBy = 9 AND @SortBy = '' THEN TotalSubmittedRecipe END DESC,
              CASE WHEN @OrderBy = 9 AND @SortBy = 2 THEN TotalSubmittedRecipe END ASC,
              CASE WHEN @OrderBy = 10 AND @SortBy = 1 THEN TotalSubmittedArticle END DESC,
              CASE WHEN @OrderBy = 10 AND @SortBy = '' THEN TotalSubmittedArticle END DESC,
              CASE WHEN @OrderBy = 10 AND @SortBy = 2 THEN TotalSubmittedArticle END ASC,
              CASE WHEN @OrderBy = 11 AND @SortBy = 1 THEN LastUpdated END DESC,
              CASE WHEN @OrderBy = 11 AND @SortBy = '' THEN LastUpdated END DESC,
              CASE WHEN @OrderBy = 11 AND @SortBy = 2 THEN LastUpdated END ASC,
              CASE WHEN @OrderBy = 12 AND @SortBy = 1 THEN TotalCommentRecipe END DESC,
              CASE WHEN @OrderBy = 12 AND @SortBy = '' THEN TotalCommentRecipe END DESC,
              CASE WHEN @OrderBy = 12 AND @SortBy = 2 THEN TotalCommentRecipe END ASC,
              CASE WHEN @OrderBy = 13 AND @SortBy = 1 THEN TotalCommentArticle END DESC,
              CASE WHEN @OrderBy = 13 AND @SortBy = '' THEN TotalCommentArticle END DESC,
              CASE WHEN @OrderBy = 13 AND @SortBy = 2 THEN TotalCommentArticle END ASC
			 ) AS RowNumber, 
				[UID], 
				UserName,
				[Password],
				Email,
				FirstName,
				LastName,
				City,
				[State],
				Country,
				isActive,
				DateJoined,
				Activation,
				LastVisit,
				Hits,
                LastUpdated,
				ShowFriendsListinProfile,
				ShowCookBookinProfile,
                NumRecordsCookBookQuickView,
                NumRecordsFriendsList,
				PreferredLayout,
				PreferredPageSize,
				IsUserChoosePreferredLayout,
				ReceivePM,
				PMEmailNotification,
				UserLevel,
				TotalSavedRecipe,
				TotalFriends,
				TotalSubmittedRecipe,
				TotalSubmittedArticle,
                TotalCommentRecipe,
                TotalCommentArticle,
				@ItemCounter TotalCount,
				UserImage
				FROM 
					dbo.usersview
                WHERE (
                 UserName LIKE COALESCE(@Input, '%') OR
                 FirstName LIKE COALESCE(@Input, '%') OR
                 LastName LIKE COALESCE(@Input, '%') OR
                 City LIKE COALESCE(@Input, '%') OR
                 [State] LIKE COALESCE(@Input, '%') OR
                 Country LIKE COALESCE(@Input, '%') OR
                 Email LIKE COALESCE(@Input, '%') OR
                 (@NumDays > 0 AND DateJoined >= DATEADD(day, - @NumDays, GETDATE())) OR
                 UserName LIKE COALESCE(@Input, UserName) + '%')-- User name letter search
                 OR (@Input = 'none' AND @NumDays = 0) -- Returns default no filter record set.
                 
	)
	-- Statement that executes the CTE
	SELECT a.*
	FROM
		  Users a
	WHERE
		  a.RowNumber BETWEEN @StartRow AND @EndRow - 1
	ORDER BY
		  a.RowNumber

END
GO
/****** Object:  StoredProcedure [dbo].[GetRecipeCategory]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <8/9/08>
-- Description:	<Returns Category Recipes with custom paging and dynamic sorting using CTE>
-- =============================================
CREATE PROCEDURE [dbo].[GetRecipeCategory] 

@CatId int,
@OrderBy int = '',
@SortBy int = '',
@PageIndex int = 1,
@PageSize int = 20

AS
BEGIN

DECLARE @StartRow int
DECLARE @EndRow int

SET @StartRow = (@PageSize * (@PageIndex - 1))  + 1  
SET @EndRow = @PageSize * @PageIndex + 1

SET NOCOUNT ON;

WITH Recipe AS
(
    SELECT
       ROW_NUMBER() OVER 
         (
           -- Dynamic bidirectional sorting
            ORDER BY 
                  CASE WHEN @OrderBy = 1 AND @SortBy = 1 THEN HITS END DESC,
                  CASE WHEN @OrderBy = 1 AND @SortBy = '' THEN HITS END DESC,
                  CASE WHEN @OrderBy = 1 AND @SortBy = 2 THEN HITS END ASC,
                  CASE WHEN @OrderBy = 2 AND @SortBy = 1 THEN NO_RATES END DESC,
                  CASE WHEN @OrderBy = 2 AND @SortBy = '' THEN NO_RATES END DESC,
                  CASE WHEN @OrderBy = 2 AND @SortBy = 2 THEN NO_RATES END ASC,
                  CASE WHEN @OrderBy = 3 AND @SortBy = 2 THEN Name END ASC,
                  CASE WHEN @OrderBy = 3 AND @SortBy = '' THEN Name END ASC,
                  CASE WHEN @OrderBy = 3 AND @SortBy = 1 THEN Name END DESC,
                  CASE WHEN @OrderBy = 4 AND @SortBy = 1 OR @OrderBy = '' THEN Date END DESC,
                  CASE WHEN @OrderBy = 4 AND @SortBy = '' OR @OrderBy = '' THEN Date END DESC,
                  CASE WHEN @OrderBy = 4 AND @SortBy = 2 THEN Date END ASC
         ) AS RowNumber, 
              ID, 
              CAT_ID, 
              Category, 
              Name, 
              Author, 
              Date, 
              HITS, 
              RATING, 
              NO_RATES,
              [UID],
              CAST((1.0 * RATING/NO_RATES) AS DECIMAL(2,1)) AS Rates,
              COALESCE(NULLIF(RecipeImage, ''), 'noimageavailable.gif') as RecipeImage,
              dbo.GetCategoryRecipeCount(@CatId) AS RCount
    FROM
         dbo.Recipes WITH (NOLOCK)
    WHERE 
		 LINK_APPROVED = 1 AND CAT_ID = @CatId
)
-- Statement that executes the CTE
SELECT a.*
FROM
      Recipe a
WHERE
      a.RowNumber BETWEEN @StartRow AND @EndRow - 1
ORDER BY
      a.RowNumber

END
GO
/****** Object:  StoredProcedure [dbo].[GetRecipeFirstAlphaLetterName]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/23/2008>
-- Description:	<Return first letter recipe name.>
-- =============================================
CREATE PROCEDURE [dbo].[GetRecipeFirstAlphaLetterName] 

@Letter varchar,
@OrderBy int = '',
@SortBy int = '',
@PageIndex int = 1,
@PageSize int = 20

AS
BEGIN

DECLARE @StartRow int
DECLARE @EndRow int

SET @StartRow = (@PageSize * (@PageIndex - 1))  + 1  
SET @EndRow = @PageSize * @PageIndex + 1

SET NOCOUNT ON;

WITH RecipeAlphaLetter AS
(
    SELECT
       ROW_NUMBER() OVER 
         (
           -- Dynamic bidirectional sorting
            ORDER BY 
                  CASE WHEN @OrderBy = 1 AND @SortBy = 1 THEN HITS END DESC,
                  CASE WHEN @OrderBy = 1 AND @SortBy = '' THEN HITS END DESC,
                  CASE WHEN @OrderBy = 1 AND @SortBy = 2 THEN HITS END ASC,
                  CASE WHEN @OrderBy = 2 AND @SortBy = 1 THEN NO_RATES END DESC,
                  CASE WHEN @OrderBy = 2 AND @SortBy = '' THEN NO_RATES END DESC,
                  CASE WHEN @OrderBy = 2 AND @SortBy = 2 THEN NO_RATES END ASC,
                  CASE WHEN @OrderBy = 3 AND @SortBy = 2 THEN Name END ASC,
                  CASE WHEN @OrderBy = 3 AND @SortBy = '' THEN Name END ASC,
                  CASE WHEN @OrderBy = 3 AND @SortBy = 1 THEN Name END DESC,
                  CASE WHEN @OrderBy = 4 AND @SortBy = 1 OR @OrderBy = '' THEN Date END DESC,
                  CASE WHEN @OrderBy = 4 AND @SortBy = '' OR @OrderBy = '' THEN Date END DESC,
                  CASE WHEN @OrderBy = 4 AND @SortBy = 2 THEN Date END ASC
         ) AS RowNumber, 
              ID, 
              CAT_ID, 
              Category, 
              Name, 
              Author, 
              Date, 
              HITS, 
              RATING, 
              NO_RATES,
              [UID],
              Cast((1.0 * RATING/NO_RATES) as decimal(2,1)) as Rates,
              COALESCE(NULLIF(RecipeImage, ''), 'noimageavailable.gif') as RecipeImage,
              dbo.GetAlphaLetterCount(@Letter) As RCount
    FROM
         dbo.Recipes WITH (NOLOCK)
    WHERE 
	     LINK_APPROVED = 1 AND [Name] Like @Letter + '%'
)
-- Statement that executes the CTE
SELECT a.*
FROM
      RecipeAlphaLetter a
WHERE
      a.RowNumber BETWEEN @StartRow AND @EndRow - 1
ORDER BY
      a.RowNumber

END
GO
/****** Object:  StoredProcedure [dbo].[GetCategoryArticle]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <6/6/2008>
-- Description:	<Returns Category Articles custom paging and bidirectional dynamic sorting>
-- =============================================
CREATE PROCEDURE [dbo].[GetCategoryArticle] 

@CATID int,
@OrderBy int = '',
@SortBy int = '',
@PageIndex int = 1,
@PageSize int = 20

AS
BEGIN

DECLARE @StartRow int
DECLARE @EndRow int

SET @StartRow = (@PageSize * (@PageIndex - 1))  + 1  
SET @EndRow = @PageSize * @PageIndex + 1

SET NOCOUNT ON;

WITH ArticleCategory AS
(
    SELECT
       ROW_NUMBER() OVER 
         (
            -- Dynamic bidirectional sorting
            ORDER BY 
                  CASE WHEN @OrderBy = 1 AND @SortBy = 1 THEN a.Hits END DESC,
                  CASE WHEN @OrderBy = 1 AND @SortBy = '' THEN a.Hits END DESC,
                  CASE WHEN @OrderBy = 1 AND @SortBy = 2 THEN a.Hits END ASC,
                  CASE WHEN @OrderBy = 2 AND @SortBy = 1 THEN a.No_Rates END DESC,
                  CASE WHEN @OrderBy = 2 AND @SortBy = '' THEN a.No_Rates END DESC,
                  CASE WHEN @OrderBy = 2 AND @SortBy = 2 THEN a.No_Rates END ASC,
                  CASE WHEN @OrderBy = 3 AND @SortBy = 2 THEN a.Title END ASC,
                  CASE WHEN @OrderBy = 3 AND @SortBy = '' THEN a.Title END ASC,
                  CASE WHEN @OrderBy = 3 AND @SortBy = 1 THEN a.Title END DESC,
                  CASE WHEN @OrderBy = 4 AND @SortBy = 1 OR @OrderBy = '' THEN a.Post_Date END DESC,
                  CASE WHEN @OrderBy = 4 AND @SortBy = '' OR @OrderBy = '' THEN a.Post_Date END DESC,
                  CASE WHEN @OrderBy = 4 AND @SortBy = 2 THEN a.Post_Date END ASC
         ) AS RowNumber, 
              a.ID,
              a.CAT_ID,
              b.CAT_NAME, 
              a.Title, 
              a.Post_Date, 
              a.Content, 
              a.Hits, 
              a.Author,
              a.Keyword,
              a.No_Rates,
              a.UID, 
              CAST((1.0 * a.No_Rating/a.No_Rates) as decimal(2,1)) as Rates,
              dbo.GetCategoryArticleCount(@CATID) As RCount, 
              a.Summary,
              a.Total_Comments        
       FROM Cooking_Article a WITH (NOLOCK) 
            INNER JOIN Cooking_Article_Category b WITH (NOLOCK)
       ON 
            a.CAT_ID = b.CAT_ID
       WHERE a.Show = 1 AND a.CAT_ID = @CATID
)
-- Statement that executes the CTE
SELECT a.*
FROM
      ArticleCategory a
WHERE
      a.RowNumber BETWEEN @StartRow AND @EndRow - 1
ORDER BY
      a.RowNumber

END
GO
/****** Object:  StoredProcedure [dbo].[GetArticleSearchResult]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <7/28/2008>
-- Description:	<Return article search result with custom paging and bidirectional dynamic sorting>
-- =============================================
CREATE PROCEDURE [dbo].[GetArticleSearchResult] 

@Search varchar(50),
@CATID int,
@OrderBy int = '',
@SortBy int = '',
@PageIndex int = 1,
@PageSize int = 20

AS
BEGIN

DECLARE @StartRow int
DECLARE @EndRow int

SET @StartRow = (@PageSize * (@PageIndex - 1))  + 1  
SET @EndRow = @PageSize * @PageIndex + 1

IF (@CATID = 0)
 BEGIN
      SET @CATID = Null
 END

SET NOCOUNT ON;

WITH ArticleSearch AS
(
    SELECT
       ROW_NUMBER() OVER 
         (
            -- Dynamic sorting
            ORDER BY 
                  CASE WHEN @OrderBy = 1 AND @SortBy = 1 THEN a.Hits END DESC,
                  CASE WHEN @OrderBy = 1 AND @SortBy = '' THEN a.Hits END DESC,
                  CASE WHEN @OrderBy = 1 AND @SortBy = 2 THEN a.Hits END ASC,
                  CASE WHEN @OrderBy = 2 AND @SortBy = 1 THEN a.No_Rates END DESC,
                  CASE WHEN @OrderBy = 2 AND @SortBy = '' THEN a.No_Rates END DESC,
                  CASE WHEN @OrderBy = 2 AND @SortBy = 2 THEN a.No_Rates END ASC,
                  CASE WHEN @OrderBy = 3 AND @SortBy = 2 THEN a.Title END ASC,
                  CASE WHEN @OrderBy = 3 AND @SortBy = '' THEN a.Title END ASC,
                  CASE WHEN @OrderBy = 3 AND @SortBy = 1 THEN a.Title END DESC,
                  CASE WHEN @OrderBy = 4 AND @SortBy = 1 OR @OrderBy = '' THEN a.Post_Date END DESC,
                  CASE WHEN @OrderBy = 4 AND @SortBy = '' OR @OrderBy = '' THEN a.Post_Date END DESC,
                  CASE WHEN @OrderBy = 4 AND @SortBy = 2 THEN a.Post_Date END ASC
         ) AS RowNumber, 
              a.ID,
              a.CAT_ID,
              b.CAT_NAME, 
              a.Title, 
              a.Post_Date, 
              a.Content, 
              a.Hits, 
              a.Author,
              a.Keyword,
              a.No_Rates,
              a.UID, 
              CAST((1.0 * a.No_Rating/a.No_Rates) AS DECIMAL(2,1)) AS Rates,
              dbo.GetSearchResultArticleCount(@Search, @CATID) AS RCount, 
              a.Summary,
              a.Total_Comments        
       FROM Cooking_Article a WITH (NOLOCK)
            INNER JOIN Cooking_Article_Category b WITH (NOLOCK)
       ON 
            a.CAT_ID = b.CAT_ID
       WHERE Show = 1 AND a.CAT_ID = COALESCE(@CATID, a.CAT_ID) AND a.Title Like '%' + @Search + '%'
)
-- Statement that executes the CTE
SELECT a.*
FROM
      ArticleSearch a
WHERE
      a.RowNumber BETWEEN @StartRow AND @EndRow - 1
ORDER BY
      a.RowNumber

END
GO
/****** Object:  StoredProcedure [dbo].[spUpdatePreferredLayoutPageSizeFromMyAccount]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdatePreferredLayoutPageSizeFromMyAccount] 

@UserID int,
@ChoosePreferredLayout int,
@PreferredLayout int,
@PreferredPagesize int

AS
BEGIN

SET NOCOUNT ON;

	UPDATE dbo.usersmain SET IsUserChoosePreferredLayout = @ChoosePreferredLayout WHERE [UID] = @UserID;

	EXEC spUpdateUserPreferredLayout @UserID, @PreferredLayout

	EXEC spUpdateUserPreferredPageSize @UserID, @PreferredPagesize

END
GO
/****** Object:  StoredProcedure [dbo].[GetSearchResult]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <5/24/2008>
-- Description:	<Returns search result>
-- =============================================
CREATE PROCEDURE [dbo].[GetSearchResult]

@Search varchar(50),
@CAT_ID int,
@OrderBy int = '',
@PageIndex int = 1,
@PageSize int = 20

AS
BEGIN

DECLARE @StartRow int
DECLARE @EndRow int

SET @StartRow = (@PageSize * (@PageIndex - 1))  + 1  
SET @EndRow = @PageSize * @PageIndex + 1

IF (@CAT_ID = 0)
 BEGIN
      SET @CAT_ID = Null
 END

	SET NOCOUNT ON;

	WITH RecipeSearch AS
	(
		SELECT
		   ROW_NUMBER() OVER 
			 (
			   -- Dynamic sorting
				ORDER BY 
					  CASE WHEN @OrderBy = 1 THEN HITS END DESC,
					  CASE WHEN @OrderBy = 2 THEN NO_RATES END DESC,
					  CASE WHEN @OrderBy = 3 THEN Name END,
					  CASE WHEN @OrderBy = 4 OR @OrderBy = '' THEN Date END DESC
			 ) AS RowNumber, 
				  ID, 
				  CAT_ID, 
				  Category, 
				  Name, 
				  Author, 
				  Date, 
				  HITS, 
				  RATING, 
				  NO_RATES,
                  [UID],
				  COALESCE(NULLIF(RecipeImage, ''), 'noimageavailable.gif') as RecipeImage,
				  Cast((1.0 * RATING/NO_RATES) as decimal(2,1)) as Rates,
				  dbo.GetSearchResultCount(@Search, @CAT_ID) As RCount  
		   FROM 
               dbo.Recipes WITH (NOLOCK) 
		   WHERE 
               LINK_APPROVED = 1 AND CAT_ID = COALESCE(@CAT_ID, CAT_ID) AND [Name] Like '%' + @Search + '%'
	)
	-- Statement that executes the CTE
	SELECT a.*
	FROM
		  RecipeSearch a
	WHERE
		  a.RowNumber BETWEEN @StartRow AND @EndRow - 1
	ORDER BY
		  a.RowNumber

END
GO
/****** Object:  StoredProcedure [dbo].[CategoryPage_Article]    Script Date: 03/23/2012 10:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dexter Zafra>
-- Create date: <6/6/2008>
-- Description:	<Returns Category Articles custom paging and bidirectional dynamic sorting>
-- =============================================
CREATE PROCEDURE [dbo].[CategoryPage_Article] 

@CATID int,
@OrderBy int = '',
@SortBy int = ''

AS
BEGIN

	SET NOCOUNT ON;

    SELECT a.ID,
       a.CAT_ID,
       b.CAT_NAME, 
       a.Title, 
       a.Post_Date, 
       a.Content, 
       a.Hits, 
       a.Author,
       a.Keyword,
       a.No_Rates, 
       CAST((1.0 * a.No_Rating/a.No_Rates) as decimal(2,1)) as Rates,
       dbo.GetCategoryArticleCount(@CATID) As RCount, 
       a.Summary,
       a.Total_Comments        
       FROM 
			Cooking_Article a WITH (NOLOCK) 
	   INNER JOIN 
			Cooking_Article_Category b WITH (NOLOCK)
       ON 
			a.CAT_ID = b.CAT_ID
       WHERE Show = 1 AND a.CAT_ID = @CATID
		ORDER BY
		CASE WHEN @OrderBy = 1 AND @SortBy = 1 THEN a.Hits END DESC,
		CASE WHEN @OrderBy = 1 AND @SortBy = '' THEN a.Hits END DESC,
		CASE WHEN @OrderBy = 1 AND @SortBy = 2 THEN a.Hits END ASC,
		CASE WHEN @OrderBy = 2 AND @SortBy = 1 THEN a.No_Rates END DESC,
		CASE WHEN @OrderBy = 2 AND @SortBy = '' THEN a.No_Rates END DESC,
		CASE WHEN @OrderBy = 2 AND @SortBy = 2 THEN a.No_Rates END ASC,
		CASE WHEN @OrderBy = 3 AND @SortBy = 2 THEN a.Title END ASC,
		CASE WHEN @OrderBy = 3 AND @SortBy = '' THEN a.Title END ASC,
		CASE WHEN @OrderBy = 3 AND @SortBy = 1 THEN a.Title END DESC,
		CASE WHEN @OrderBy = 4 AND @SortBy = 1 OR @OrderBy = '' THEN a.Post_Date END DESC,
		CASE WHEN @OrderBy = 4 AND @SortBy = '' OR @OrderBy = '' THEN a.Post_Date END DESC,
		CASE WHEN @OrderBy = 4 AND @SortBy = 2 THEN a.Post_Date END ASC

END
GO
/****** Object:  Default [DF_COMMENTS_ARTICLE_Date]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[COMMENTS_ARTICLE] ADD  CONSTRAINT [DF_COMMENTS_ARTICLE_Date]  DEFAULT (CONVERT([datetime],CONVERT([varchar],getdate(),(1)),(1))) FOR [Date]
GO
/****** Object:  Default [DF__COMMENTS_REC__ID__0F975522]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[COMMENTS_RECIPE] ADD  CONSTRAINT [DF__COMMENTS_REC__ID__0F975522]  DEFAULT ((0)) FOR [ID]
GO
/****** Object:  Default [DF__COMMENTS_R__DATE__108B795B]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[COMMENTS_RECIPE] ADD  CONSTRAINT [DF__COMMENTS_R__DATE__108B795B]  DEFAULT (CONVERT([datetime],CONVERT([varchar],getdate(),(1)),(1))) FOR [DATE]
GO
/****** Object:  Default [DF_Configuration_PublicPrivateProfile]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Configuration] ADD  CONSTRAINT [DF_Configuration_PublicPrivateProfile]  DEFAULT ((1)) FOR [PublicPrivateProfile]
GO
/****** Object:  Default [DF_Article_Post_Date]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Cooking_Article] ADD  CONSTRAINT [DF_Article_Post_Date]  DEFAULT (CONVERT([datetime],CONVERT([varchar],getdate(),(1)),(1))) FOR [Post_Date]
GO
/****** Object:  Default [DF_Cooking_Article_Hits]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Cooking_Article] ADD  CONSTRAINT [DF_Cooking_Article_Hits]  DEFAULT ((1)) FOR [Hits]
GO
/****** Object:  Default [DF_Cooking_Article_Show]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Cooking_Article] ADD  CONSTRAINT [DF_Cooking_Article_Show]  DEFAULT ((0)) FOR [Show]
GO
/****** Object:  Default [DF_Article_No_Rating]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Cooking_Article] ADD  CONSTRAINT [DF_Article_No_Rating]  DEFAULT ((5)) FOR [No_Rating]
GO
/****** Object:  Default [DF_Article_No_Rates]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Cooking_Article] ADD  CONSTRAINT [DF_Article_No_Rates]  DEFAULT ((1)) FOR [No_Rates]
GO
/****** Object:  Default [DF_Cooking_Article_Total_Comments]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Cooking_Article] ADD  CONSTRAINT [DF_Cooking_Article_Total_Comments]  DEFAULT ((0)) FOR [Total_Comments]
GO
/****** Object:  Default [DF_Cooking_Article_Updated]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Cooking_Article] ADD  CONSTRAINT [DF_Cooking_Article_Updated]  DEFAULT (CONVERT([datetime],CONVERT([varchar],getdate(),(1)),(1))) FOR [Update_date]
GO
/****** Object:  Default [DF_Events_PRIVATE]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Events] ADD  CONSTRAINT [DF_Events_PRIVATE]  DEFAULT ((0)) FOR [PRIVATE]
GO
/****** Object:  Default [DF_ExceptionLog_Date]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[ExceptionLog] ADD  CONSTRAINT [DF_ExceptionLog_Date]  DEFAULT (CONVERT([datetime],CONVERT([varchar],getdate(),(1)),(1))) FOR [Date]
GO
/****** Object:  Default [DF_FriendsList_Date]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[FriendsList] ADD  CONSTRAINT [DF_FriendsList_Date]  DEFAULT (CONVERT([datetime],CONVERT([varchar],getdate(),(1)),(1))) FOR [Date]
GO
/****** Object:  Default [DF_FriendsList_IsApproved]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[FriendsList] ADD  CONSTRAINT [DF_FriendsList_IsApproved]  DEFAULT ((0)) FOR [IsApproved]
GO
/****** Object:  Default [DF_PrivateMessage_M_Sent]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[PrivateMessage] ADD  CONSTRAINT [DF_PrivateMessage_M_Sent]  DEFAULT (CONVERT([datetime],CONVERT([varchar],getdate(),(1)),(1))) FOR [M_Sent]
GO
/****** Object:  Default [DF_PrivateMessage_M_Read]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[PrivateMessage] ADD  CONSTRAINT [DF_PrivateMessage_M_Read]  DEFAULT ((0)) FOR [M_Read]
GO
/****** Object:  Default [DF_PrivateMessage_M_OutBox]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[PrivateMessage] ADD  CONSTRAINT [DF_PrivateMessage_M_OutBox]  DEFAULT ((1)) FOR [M_OutBox]
GO
/****** Object:  Default [DF_PrivateMessage_M_mail]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[PrivateMessage] ADD  CONSTRAINT [DF_PrivateMessage_M_mail]  DEFAULT ((0)) FOR [M_mail]
GO
/****** Object:  Default [DF_PrivateMessage_isTrash]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[PrivateMessage] ADD  CONSTRAINT [DF_PrivateMessage_isTrash]  DEFAULT ((0)) FOR [isTrash]
GO
/****** Object:  Default [DF_PrivateMessageBlockedUsers_Date]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[PrivateMessageBlockedUsers] ADD  CONSTRAINT [DF_PrivateMessageBlockedUsers_Date]  DEFAULT (CONVERT([datetime],CONVERT([varchar],getdate(),(1)),(1))) FOR [Date]
GO
/****** Object:  Default [DF_PrivateMessageSentMessages_M_Sent]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[PrivateMessageSentMessages] ADD  CONSTRAINT [DF_PrivateMessageSentMessages_M_Sent]  DEFAULT (CONVERT([datetime],CONVERT([varchar],getdate(),(1)),(1))) FOR [M_Sent]
GO
/****** Object:  Default [DF_PrivateMessageSentMessages_M_Read]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[PrivateMessageSentMessages] ADD  CONSTRAINT [DF_PrivateMessageSentMessages_M_Read]  DEFAULT ((0)) FOR [M_Read]
GO
/****** Object:  Default [DF_PrivateMessageSentMessages_M_OutBox]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[PrivateMessageSentMessages] ADD  CONSTRAINT [DF_PrivateMessageSentMessages_M_OutBox]  DEFAULT ((1)) FOR [M_OutBox]
GO
/****** Object:  Default [DF_PrivateMessageSentMessages_M_mail]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[PrivateMessageSentMessages] ADD  CONSTRAINT [DF_PrivateMessageSentMessages_M_mail]  DEFAULT ((0)) FOR [M_mail]
GO
/****** Object:  Default [DF__Recipes__CAT_ID__00551192]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Recipes] ADD  CONSTRAINT [DF__Recipes__CAT_ID__00551192]  DEFAULT ((0)) FOR [CAT_ID]
GO
/****** Object:  Default [DF__Recipes__Date__014935CB]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Recipes] ADD  CONSTRAINT [DF__Recipes__Date__014935CB]  DEFAULT (CONVERT([datetime],CONVERT([varchar],getdate(),(1)),(1))) FOR [Date]
GO
/****** Object:  Default [DF__Recipes__HOMEPAG__023D5A04]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Recipes] ADD  CONSTRAINT [DF__Recipes__HOMEPAG__023D5A04]  DEFAULT ('N/A') FOR [HOMEPAGE]
GO
/****** Object:  Default [DF__Recipes__LINK_AP__03317E3D]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Recipes] ADD  CONSTRAINT [DF__Recipes__LINK_AP__03317E3D]  DEFAULT ((0)) FOR [LINK_APPROVED]
GO
/****** Object:  Default [DF__Recipes__HITS__0425A276]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Recipes] ADD  CONSTRAINT [DF__Recipes__HITS__0425A276]  DEFAULT ((0)) FOR [HITS]
GO
/****** Object:  Default [DF__Recipes__RATING__0519C6AF]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Recipes] ADD  CONSTRAINT [DF__Recipes__RATING__0519C6AF]  DEFAULT ((5)) FOR [RATING]
GO
/****** Object:  Default [DF__Recipes__NO_RATE__060DEAE8]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Recipes] ADD  CONSTRAINT [DF__Recipes__NO_RATE__060DEAE8]  DEFAULT ((1)) FOR [NO_RATES]
GO
/****** Object:  Default [DF__Recipes__TOTAL_C__07020F21]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[Recipes] ADD  CONSTRAINT [DF__Recipes__TOTAL_C__07020F21]  DEFAULT ((0)) FOR [TOTAL_COMMENTS]
GO
/****** Object:  Default [DF_userCookBook_Date]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[userCookBook] ADD  CONSTRAINT [DF_userCookBook_Date]  DEFAULT (CONVERT([datetime],CONVERT([varchar],getdate(),(1)),(1))) FOR [Date]
GO
/****** Object:  Default [DF_users_CreatedDate]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersadmin] ADD  CONSTRAINT [DF_users_CreatedDate]  DEFAULT (CONVERT([datetime],CONVERT([varchar],getdate(),(1)),(1))) FOR [CreatedDate]
GO
/****** Object:  Default [DF_usersmain_UserLevel]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersmain] ADD  CONSTRAINT [DF_usersmain_UserLevel]  DEFAULT ((1)) FOR [UserLevel]
GO
/****** Object:  Default [DF_usersmain_Hits]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersmain] ADD  CONSTRAINT [DF_usersmain_Hits]  DEFAULT ((0)) FOR [Hits]
GO
/****** Object:  Default [DF_usersmain_LastVisit]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersmain] ADD  CONSTRAINT [DF_usersmain_LastVisit]  DEFAULT (CONVERT([datetime],CONVERT([varchar],getdate(),(1)),(1))) FOR [LastVisit]
GO
/****** Object:  Default [DF_usersmain_LastUpdated]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersmain] ADD  CONSTRAINT [DF_usersmain_LastUpdated]  DEFAULT (CONVERT([datetime],CONVERT([varchar],getdate(),(1)),(1))) FOR [LastUpdated]
GO
/****** Object:  Default [DF_usersmain_isActive]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersmain] ADD  CONSTRAINT [DF_usersmain_isActive]  DEFAULT ((1)) FOR [isActive]
GO
/****** Object:  Default [DF_usersmain_ReceivePM]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersmain] ADD  CONSTRAINT [DF_usersmain_ReceivePM]  DEFAULT ((1)) FOR [ReceivePM]
GO
/****** Object:  Default [DF_usersmain_PMEmailNotification]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersmain] ADD  CONSTRAINT [DF_usersmain_PMEmailNotification]  DEFAULT ((1)) FOR [PMEmailNotification]
GO
/****** Object:  Default [DF_usersmain_Activation]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersmain] ADD  CONSTRAINT [DF_usersmain_Activation]  DEFAULT ((0)) FOR [Activation]
GO
/****** Object:  Default [DF_usersmain_ShowFriendsListinProfile]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersmain] ADD  CONSTRAINT [DF_usersmain_ShowFriendsListinProfile]  DEFAULT ((1)) FOR [ShowFriendsListinProfile]
GO
/****** Object:  Default [DF_usersmain_ShowCookBookinProfile]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersmain] ADD  CONSTRAINT [DF_usersmain_ShowCookBookinProfile]  DEFAULT ((1)) FOR [ShowCookBookinProfile]
GO
/****** Object:  Default [DF_usersmain_NumRecordsCookBookQuickView]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersmain] ADD  CONSTRAINT [DF_usersmain_NumRecordsCookBookQuickView]  DEFAULT ((10)) FOR [NumRecordsCookBookQuickView]
GO
/****** Object:  Default [DF_usersmain_NumRecordsFriendsList]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersmain] ADD  CONSTRAINT [DF_usersmain_NumRecordsFriendsList]  DEFAULT ((10)) FOR [NumRecordsFriendsList]
GO
/****** Object:  Default [DF_usersmain_PreferredLayout]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersmain] ADD  CONSTRAINT [DF_usersmain_PreferredLayout]  DEFAULT ((1)) FOR [PreferredLayout]
GO
/****** Object:  Default [DF_usersmain_PreferredPageSize]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersmain] ADD  CONSTRAINT [DF_usersmain_PreferredPageSize]  DEFAULT ((10)) FOR [PreferredPageSize]
GO
/****** Object:  Default [DF_usersmain_IsUserChoosePreferredLayout]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersmain] ADD  CONSTRAINT [DF_usersmain_IsUserChoosePreferredLayout]  DEFAULT ((1)) FOR [IsUserChoosePreferredLayout]
GO
/****** Object:  Default [DF_usersmain_IsFirsTimeLogin]    Script Date: 03/23/2012 10:10:01 ******/
ALTER TABLE [dbo].[usersmain] ADD  CONSTRAINT [DF_usersmain_IsFirsTimeLogin]  DEFAULT ((0)) FOR [IsFirsTimeLogin]
GO
