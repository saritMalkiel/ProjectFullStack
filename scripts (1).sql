CREATE DATABASE Images1
use Images1 
CREATE TABLE [dbo].[DocumentMarkers] (
    [docID]      INT            NULL,
    [MarkerID]   INT            IDENTITY (1, 1) NOT NULL,
    [MarkerType] NVARCHAR (50)  NULL,
    [cx]         FLOAT (53)     NULL,
    [cy]         FLOAT (53)     NULL,
    [rx]         FLOAT (53)     NULL,
    [ry]         FLOAT (53)     NULL,
    [Fore]       NVARCHAR (50)  NULL,
    [userID]     VARCHAR (50)   NULL,
    [status]     BIT            NULL,
    [text]       NVARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([MarkerID] ASC),
    FOREIGN KEY ([userID]) REFERENCES [dbo].[Users] ([UserID]),
    FOREIGN KEY ([docID]) REFERENCES [dbo].[Documents] ([docID])
);

CREATE TABLE [dbo].[Documents] (
    [UserID]       VARCHAR (50)   NULL,
    [ImageURL]     NVARCHAR (100) NULL,
    [DocumentName] NVARCHAR (50)  NULL,
    [docID]        INT            IDENTITY (1, 1) NOT NULL,
    [statusDoc]    BIT            NULL,
    PRIMARY KEY CLUSTERED ([docID] ASC),
    FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
);

CREATE TABLE [dbo].[SharedDocuments] (
    [docID]  INT          NULL,
    [userID] VARCHAR (50) NULL,
    FOREIGN KEY ([docID]) REFERENCES [dbo].[Documents] ([docID]),
    FOREIGN KEY ([userID]) REFERENCES [dbo].[Users] ([UserID])
);

CREATE TABLE [dbo].[Users] (
    [UserID]   VARCHAR (50) NOT NULL,
    [UserName] VARCHAR (50) NULL,
    [status]   BIT          NULL,
    PRIMARY KEY CLUSTERED ([UserID] ASC)
);

create procedure changeTrueStatus @userID VARCHAR(50)
AS
BEGIN 
UPDATE Users
SET status = 1
WHERE userID=@userID
END

CREATE PROCEDURE CreateDocument @UserID VARCHAR(50), @ImageURL NVARCHAR(100),@DocumentName NVARCHAR(50)
AS
BEGIN 
INSERT INTO Documents (UserID, ImageURL,DocumentName,statusDoc)
VALUES(@UserID, @ImageURL,@DocumentName,1)

select CAST( @@IDENTITY AS int)
from Documents
END


CREATE PROCEDURE CreateMarker @docID [int] ,@MarkerType nvarchar(50) ,@cx FLOAT,@cy FLOAT,@rx FLOAT,@ry FLOAT,@Fore nvarchar(50),@userID varchar(50),@text varchar(100)
AS
begin
INSERT INTO DocumentMarkers  (docID , MarkerType  ,cx ,cy ,rx ,ry ,Fore,userID,status,text)
VALUES (@docID, @MarkerType,@cx ,@cy ,@rx ,@ry  , @Fore,@userID,1,@text)
select CAST( @@IDENTITY AS int)
from [dbo].[DocumentMarkers]
END

CREATE PROCEDURE  CreateShare @docID [int] ,@userID varchar(50)
AS
declare @cnt  [int]
select @cnt = COUNT(*)
from SharedDocuments
where docID=@docID and userID=@userID

if(@cnt=0)
begin
INSERT INTO SharedDocuments (docID , userID)
VALUES (@docID, @userID)
end

CREATE PROCEDURE CreateUser @UserID VARCHAR(50), @UserName VARCHAR(50)
AS
BEGIN 
INSERT INTO Users (UserID,UserName,status)
VALUES (@UserID,@UserName,1)
END

create procedure delMarkersOfDocument @docID INT
AS
begin 
delete from  DocumentMarkers
WHERE [docID] =@docID 
end

create procedure DocsIParticipateIn @userid  VARCHAR (50)
as
select d.*
from [dbo].[SharedDocuments]sd join [dbo].[Documents]d
on sd.docID=d.docID
where @userid=sd.userID


CREATE PROCEDURE GetDocument @docID INT
AS
BEGIN 
select * from Documents 
where docID=@docID and [statusDoc]=1
END

create procedure getDocumentsForUser @userID VARCHAR(50)
AS 
SELECT * FROM Documents
WHERE userID=@userID and statusDoc=1

create procedure getMarkerByIDMarker @markerid int 
as 
select *
from [dbo].[DocumentMarkers]
where @markerid=MarkerID and status=1

CREATE PROCEDURE GetMarkers @docID INT
AS
SELECT * FROM DocumentMarkers
WHERE docID=@docID and status=1

CREATE PROCEDURE GetShaDocumentsForUser @userID varchar(50)
AS
SELECT * FROM [dbo].[SharedDocuments]
where [UserID]=@userID  

CREATE PROCEDURE getShare @docID int 
AS						  
SELECT * FROM SharedDocuments
where  docID=@docID


CREATE PROCEDURE GetSharedDocuments
AS
SELECT * FROM SharedDocuments

CREATE PROCEDURE GetSharedDocumentsFor_User @userID varchar(50)
AS
SELECT * FROM [dbo].[SharedDocuments]
where [UserID]=@userID  

CREATE PROCEDURE GetSharedDocumentsForUser @userID varchar(50)
AS
SELECT * FROM [dbo].[SharedDocuments]
where [UserID]=@userID  

CREATE PROCEDURE GetuserID @userID varchar(50)
AS
BEGIN 
select * from  Users 
WHERE userID=@userID
END

CREATE PROCEDURE GetUsers
AS
BEGIN 
select * from  Users 
where status=1
END

CREATE PROCEDURE login @UserID VARCHAR(50), @UserName VARCHAR(50)
AS
BEGIN 
select * from  Users 
where UserID=@UserID and UserName=@UserName
END

CREATE PROCEDURE RemoveDocument  @docID INT
AS
BEGIN 
UPDATE Documents
SET statusDoc = 0
WHERE docID = @docID

exec delMarkersOfDocument @docID
END

CREATE PROCEDURE RemoveMarker @MarkerID [int]
AS
begin 
delete from  DocumentMarkers
WHERE MarkerID = @MarkerID
end

CREATE PROCEDURE RemoveShare @docID [int] , @userID varchar(50)
AS
DELETE from  SharedDocuments
WHERE docID = @docID AND userID=@userID

CREATE PROCEDURE RemoveUser  @UserID VARCHAR(50)
AS
BEGIN 
UPDATE Users
SET status = 0
WHERE UserID=@UserID;
END

create procedure updatetxt @MarkerID INT ,@text  NVARCHAR (100)  
as 
UPDATE [dbo].[DocumentMarkers]
SET [text] =@text
WHERE [MarkerID]=@MarkerID


