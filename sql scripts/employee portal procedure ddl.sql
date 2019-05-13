USE EmployeePortal
GO

CREATE PROCEDURE dbo.getAllIssues @PostedBY int = NULL, @IsActive bit = NULL
AS
SELECT i.*,ISNULL(ih.[Status],1) as Status,ih.AssignedTo FROM Issues i
LEFT JOIN IssueHistories ih
ON ih.IssueId = i.IssueId

WHERE (ih.ModifiedOn =
(
       SELECT MAX(ihi.ModifiedOn) FROM IssueHistories ihi
       GROUP BY ihi.IssueId
       HAVING ihi.IssueId = i.IssueId
       
)
OR ih.ModifiedOn IS NULL) AND i.PostedBy = ISNULL(@PostedBy,i.PostedBy) AND i.IsActive = ISNULL(@IsActive,i.IsActive)


USE EmployeePortal
GO

CREATE PROCEDURE dbo.getAdmins
AS
SELECT e.EmployeeId,e.FirstName +' '+ e.LastName as FullName FROM [Users] u
JOIN [Employees] e
ON u.EmployeeId = e.EmployeeId 
WHERE u.IsAdmin = 1
GO


USE EmployeePortal
GO

CREATE PROCEDURE [dbo].insertEmployee @fn nvarchar(50),@ln  nvarchar(50),
                                                                 @email nvarchar(100), @doj date,
                                                                 @dot date = null, @dept int,@pwd nvarchar(40),
                                                                 @IsAdmin bit
AS
DECLARE @EmpId INT
DECLARE @UserId INT

INSERT INTO [dbo].[Employees]
VALUES(@fn,@ln,@email,@doj,@dot,@dept)

SELECT @EmpId = SCOPE_IDENTITY()

INSERT INTO [dbo].[Users] 
VALUES(@EmpId,@pwd,@IsAdmin)

SELECT @UserId = SCOPE_IDENTITY()

SELECT @EmpId as EmpId,@UserId as UserId
       
GO


USE EmployeePortal
GO

CREATE PROCEDURE [dbo].updateEmployee @EmpId int, @fn nvarchar(50),@ln  nvarchar(50),
                                                                 @email nvarchar(100), @doj date,
                                                                 @dot date = null, @dept int,@pwd nvarchar(40),
                                                                 @IsAdmin bit
AS
UPDATE [dbo].[Employees]
SET FirstName = @fn, LastName = @ln,Email = @email,
       DateOfJoining = @doj,TerminationDate = @dot,DepartmentId = @dept
WHERE EmployeeId = @EmpId


UPDATE [dbo].[Users] 
SET Password = @pwd, IsAdmin = @IsAdmin
WHERE EmployeeId = @EmpId
GO


USE EmployeePortal
GO

CREATE PROCEDURE [dbo].searchEmployees @fn nvarchar(50) = null,@ln  nvarchar(50) = null,
                                                                 @email nvarchar(100) = null, @bd date = null,
                                                                 @ed date = null, @dept int = null,
                                                                 @IsAdmin bit
AS
SELECT e.*, d.DepartmentName FROM Employees e
JOIN Departments d
ON e.DepartmentId = d.DepartmentId
WHERE 1 = CASE
                     WHEN(@IsAdmin =1)
                     THEN 1
                     WHEN( e.TerminationDate IS NULL)
                     THEN 1
                     ELSE 0
              END 
              AND ((@fn IS NOT NULL AND e.FirstName LIKE '%'+@fn+'%')
              OR(@ln IS NOT NULL AND e.LastName LIKE '%'+@ln+'%')
              OR(@email IS NOT NULL AND e.Email LIKE '%'+@email+'%')
              OR(@bd IS NOT NULL AND e.DateOfJoining >= @bd)
              OR(@ed IS NOT NULL AND e.DateOfJoining <= @ed)
              OR(@dept IS NOT NULL AND d.DepartmentId = @dept))
       
GO
