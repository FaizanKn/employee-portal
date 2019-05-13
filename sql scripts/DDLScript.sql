Create DATABASE EmployeePortal;

GO

Use EmployeePortal

GO

CREATE TABLE [dbo].[Departments](
	[DepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentName] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[Employees](
	[EmployeeId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[DateOfJoining] [date] NOT NULL,
	[TerminationDate] [date] NULL,
	[DepartmentId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[Password] [nvarchar](20) NOT NULL,
	[IsAdmin] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[Issues](
	[IssueId] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[PostedBy] [int] NOT NULL,
	[Priority] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IssueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[IssueHistories](
	[IssueHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[IssueId] [int] NOT NULL,
	[Comments] [nvarchar](500) NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [date] NOT NULL,
	[AssignedTo] [int] NULL,
	[Status] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IssueHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[Notices](
	[NoticeId] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[PostedBy] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
	[ExpirationDate] [date] NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NoticeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Employees]  WITH CHECK ADD FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Departments] ([DepartmentId])
GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employees] ([EmployeeId])
GO

ALTER TABLE [dbo].[Issues]  WITH CHECK ADD FOREIGN KEY([PostedBy])
REFERENCES [dbo].[Employees] ([EmployeeId])
GO

ALTER TABLE [dbo].[IssueHistories]  WITH CHECK ADD FOREIGN KEY([IssueId])
REFERENCES [dbo].[Issues] ([IssueId])
GO

ALTER TABLE [dbo].[IssueHistories]  WITH CHECK ADD FOREIGN KEY([AssignedTo])
REFERENCES [dbo].[Employees] ([EmployeeId])
GO

ALTER TABLE [dbo].[IssueHistories]  WITH CHECK ADD FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[Employees] ([EmployeeId])
GO

ALTER TABLE [dbo].[Notices]  WITH CHECK ADD FOREIGN KEY([PostedBy])
REFERENCES [dbo].[Employees] ([EmployeeId])
GO

ALTER TABLE Departments WITH CHECK ADD UNIQUE (DepartmentName)
GO

ALTER TABLE Employees WITH CHECK ADD UNIQUE(Email)
GO

ALTER TABLE Users WITH CHECK ADD UNIQUE(EmployeeId)
GO

INSERT INTO Departments(DepartmentName)
  VALUES('Administration')

GO

INSERT INTO Departments(DepartmentName)
  VALUES('Finance')
GO

INSERT INTO Departments(DepartmentName)
  VALUES('HR')
GO

INSERT INTO Departments(DepartmentName)
  VALUES('Engineering')
GO

INSERT INTO Departments(DepartmentName)
  VALUES('IT')
GO

INSERT INTO Departments(DepartmentName)
  VALUES('Marketing')
GO

INSERT INTO Employees(FirstName,LastName,Email,DateOfJoining,TerminationDate,DepartmentId)
 VALUES('System','Admin','system.admin@nagarro.com','1996-03-01',null,(SELECT DepartmentId from Departments WHERE DepartmentName = 'Administration'))
GO

INSERT INTO Users(EmployeeId,Password,IsAdmin)
  VALUES((SELECT EmployeeId from Employees WHERE Email = 'system.admin@nagarro.com'),'admin',1)