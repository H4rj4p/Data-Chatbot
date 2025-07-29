/****** Object:  Table [BlueBird].[Account]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Account](
	[AccountId] [int] IDENTITY(1,1) NOT NULL,
	[AccountType] [nvarchar](255) NULL,
	[OrganizationId] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[PrimaryContact] [nvarchar](255) NULL,
	[SecondaryContact] [nvarchar](255) NULL,
	[PrimaryEmail] [nvarchar](255) NULL,
	[SecondaryEmail] [nvarchar](255) NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
	[NPI] [nvarchar](255) NULL,
	[Website] [nvarchar](255) NULL,
	[IsHouseAccount] [tinyint] NULL,
	[SourceSystem] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AccountId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[AccountAddress]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[AccountAddress](
	[AccountAddressId] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[AddressType] [int] NOT NULL,
	[AddressLine1] [nvarchar](255) NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Zipcode] [nvarchar](255) NULL,
	[Latitude] [nvarchar](255) NULL,
	[Longitude] [nvarchar](255) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
	[IsPrimaryAddress] [tinyint] NOT NULL,
	[AddressTypeId] [int] NULL,
	[SourceSystem] [tinyint] NOT NULL,
 CONSTRAINT [PK__AccountA__BF0A0553866950B8] PRIMARY KEY CLUSTERED 
(
	[AccountAddressId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[AccountContact]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[AccountContact](
	[AccountContactId] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[AccountContactAddressId] [int] NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Phone] [nvarchar](255) NULL,
	[Email] [nvarchar](255) NULL,
	[Role] [nvarchar](255) NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[AccountContactId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[AccountContactAddress]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[AccountContactAddress](
	[AccountContactAddressId] [int] IDENTITY(1,1) NOT NULL,
	[AddressLine1] [nvarchar](255) NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Zipcode] [nvarchar](255) NULL,
	[Latitude] [nvarchar](255) NULL,
	[Longitude] [nvarchar](255) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[AccountContactAddressId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[AccountContactImpDate]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[AccountContactImpDate](
	[AccountContactImpDateId] [int] IDENTITY(1,1) NOT NULL,
	[AccountContactId] [int] NOT NULL,
	[OccasionDate] [datetime] NOT NULL,
	[OccasionType] [tinyint] NOT NULL,
	[OccasionUriId] [varchar](255) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AccountContactImpDateId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[AccountSegmentCallFrequencyMap]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[AccountSegmentCallFrequencyMap](
	[CustomerSystemID] [varchar](100) NULL,
	[Segment] [varchar](2) NOT NULL,
	[CallFrequencyByWeekly] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[AccountTerritoryMap]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[AccountTerritoryMap](
	[AccountTerritoryMapId] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[TerritoryId] [nvarchar](255) NOT NULL,
	[ServiceLine] [nvarchar](255) NOT NULL,
	[DaysPriority] [nvarchar](255) NOT NULL,
	[AccountSegment] [tinyint] NOT NULL,
	[AccountTier] [tinyint] NOT NULL,
	[CallFrequency] [int] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AccountTerritoryMapId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[AddressType]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[AddressType](
	[AddressTypeId] [int] IDENTITY(1,1) NOT NULL,
	[AddressType] [nvarchar](255) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[AddressTypeId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[AiAuditLog]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[AiAuditLog](
	[AiAuditLogId] [int] IDENTITY(1,1) NOT NULL,
	[SalesRepId] [int] NOT NULL,
	[EntityType] [int] NOT NULL,
	[Channel] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AiAuditLogId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[BranchMaster]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[BranchMaster](
	[BranchSystemID] [varchar](100) NULL,
	[CustomerSystemID] [varchar](50) NULL,
	[BranchCode] [varchar](50) NULL,
	[BranchName] [varchar](100) NULL,
	[StateCodeDescription] [varchar](100) NULL,
	[StateCode] [varchar](50) NULL,
	[BranchStatus] [varchar](20) NULL,
	[AreaCode] [varchar](50) NULL,
	[AreaDescription] [varchar](200) NULL,
	[BranchCity] [varchar](50) NULL,
	[ServiceLine] [varchar](50) NULL,
	[GraphChartColorCode] [varchar](10) NULL,
	[ServiceLineSystemID] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[RegionName] [varchar](100) NULL,
	[RegionCode] [varchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[DataSyncJobAuditLog]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[DataSyncJobAuditLog](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[JobName] [varchar](255) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[Status] [varchar](50) NOT NULL,
	[DurationInSeconds] [int] NULL,
	[ErrorMessage] [nvarchar](max) NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[DebugLogger]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[DebugLogger](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[LoggedAt] [datetime] NULL,
	[ObjectName] [sysname] NOT NULL,
	[LogLevel] [varchar](20) NULL,
	[Message] [nvarchar](max) NULL,
	[UserName] [sysname] NOT NULL,
	[SessionID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[Event]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Event](
	[EventId] [int] IDENTITY(1,1) NOT NULL,
	[SalesRepId] [int] NOT NULL,
	[EventCategoryId] [int] NOT NULL,
	[AccountId] [int] NULL,
	[UUID] [nvarchar](255) NOT NULL,
	[Timezone] [nvarchar](255) NOT NULL,
	[Title] [nvarchar](255) NULL,
	[StartDate] [datetime2](7) NULL,
	[EndDate] [datetime2](7) NULL,
	[StartTime] [datetime2](7) NULL,
	[EndTime] [datetime2](7) NULL,
	[TravelTime] [int] NOT NULL,
	[RepeatSchedule] [nvarchar](255) NOT NULL,
	[IsAllDay] [bit] NOT NULL,
	[EventType] [tinyint] NOT NULL,
	[EventUri] [nvarchar](255) NULL,
	[Interval] [int] NULL,
	[Unit] [nvarchar](255) NULL,
	[RepeatOnWeek] [nvarchar](255) NULL,
	[RepeatOnMonth] [tinyint] NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[EventUriID] [nvarchar](255) NULL,
	[PreCallNoteId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[EventAttendee]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[EventAttendee](
	[EventAttendeeId] [int] IDENTITY(1,1) NOT NULL,
	[EventCallLogId] [int] NULL,
	[AccountContactId] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EventAttendeeId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[EventAuditLog]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[EventAuditLog](
	[EventAuditLogId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[EntityType] [tinyint] NOT NULL,
	[EntityId] [int] NOT NULL,
	[ActivityType] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[Description] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[EventAuditLogId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[EventCallLog]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[EventCallLog](
	[EventCallLogId] [int] IDENTITY(1,1) NOT NULL,
	[EventId] [int] NULL,
	[LogType] [tinyint] NOT NULL,
	[Notes] [nvarchar](max) NOT NULL,
	[NotesQuality] [float] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EventCallLogId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[EventCategory]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[EventCategory](
	[EventCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Color] [nvarchar](255) NOT NULL,
	[IsEditable] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EventCategoryId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[EventNotification]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[EventNotification](
	[EventNotificationId] [int] IDENTITY(1,1) NOT NULL,
	[EventId] [int] NOT NULL,
	[NotificationCount] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EventNotificationId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[ExpenseCategory]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[ExpenseCategory](
	[ExpenseCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[Uuid] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[Color] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ExpenseCategoryId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[ExpenseReceipt]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[ExpenseReceipt](
	[ExpenseReceiptId] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NOT NULL,
	[AccountId] [int] NOT NULL,
	[ExpenseCategoryId] [int] NOT NULL,
	[MerchantName] [nvarchar](255) NULL,
	[ExpenseType] [tinyint] NOT NULL,
	[TransactionDate] [nvarchar](255) NULL,
	[ExpenseNotes] [nvarchar](max) NULL,
	[AttachmentUri] [nvarchar](255) NULL,
	[Amount] [float] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[Attendees] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ExpenseReceiptId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[ManagerRosterMaster]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[ManagerRosterMaster](
	[ManagerRosterSystemID] [varchar](100) NULL,
	[CustomerSystemID] [varchar](50) NULL,
	[SalesAgentID] [varchar](50) NULL,
	[BranchCode] [varchar](25) NULL,
	[BranchSystemID] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[FirstName] [varchar](100) NULL,
	[MiddleName] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[HRWorkerID] [varchar](50) NULL,
	[WorkerEmail] [varchar](150) NULL,
	[IsActive] [bit] NULL,
	[IsDualSL] [bit] NULL,
	[IsMultiRole] [bit] NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[RefreshDateTime] [datetime] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[ManagerSalesRepMap]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[ManagerSalesRepMap](
	[ManagerSalesRepMapId] [int] IDENTITY(1,1) NOT NULL,
	[SalesRepId] [int] NOT NULL,
	[ManagerId] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[SourceSystem] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ManagerSalesRepMapId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[MileageEntry]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[MileageEntry](
	[MileageEntryId] [int] IDENTITY(1,1) NOT NULL,
	[MileageReportId] [int] NOT NULL,
	[TripName] [nvarchar](255) NOT NULL,
	[TripDate] [datetime2](7) NOT NULL,
	[MileageNotes] [nvarchar](255) NULL,
	[TotalDistance] [float] NOT NULL,
	[TotalAmount] [float] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[ReimbursedDistance] [float] NULL,
	[MileageType] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MileageEntryId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[MileageLocationMap]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[MileageLocationMap](
	[MileageLocationMapId] [int] IDENTITY(1,1) NOT NULL,
	[MileageEntryId] [int] NOT NULL,
	[Address] [nvarchar](255) NOT NULL,
	[Latitude] [nvarchar](255) NOT NULL,
	[Longitude] [nvarchar](255) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MileageLocationMapId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[Module]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Module](
	[ModuleId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ModuleId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[ModuleOrganizationMap]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[ModuleOrganizationMap](
	[ModuleOrganizationMapId] [int] IDENTITY(1,1) NOT NULL,
	[ModuleId] [int] NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ModuleOrganizationMapId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[NotesQuestion]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[NotesQuestion](
	[NotesQuestionId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[Question] [nvarchar](2000) NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NotesQuestionId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[Organization]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Organization](
	[OrganizationId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationName] [nvarchar](255) NOT NULL,
	[AddressLine1] [nvarchar](255) NOT NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[City] [nvarchar](255) NOT NULL,
	[State] [nvarchar](255) NOT NULL,
	[Country] [nvarchar](255) NOT NULL,
	[Zipcode] [nvarchar](255) NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
	[SourceSystem] [tinyint] NOT NULL,
	[WeeklyCallsGoal] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrganizationId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[OrganizationBranch]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[OrganizationBranch](
	[OrganizationBranchId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[BranchCode] [nvarchar](255) NOT NULL,
	[BranchName] [nvarchar](255) NOT NULL,
	[AddressLine1] [nvarchar](255) NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Zipcode] [nvarchar](255) NULL,
	[Latitude] [nvarchar](255) NULL,
	[Longitude] [nvarchar](255) NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
	[SourceSystem] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrganizationBranchId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[OrganizationSetting]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[OrganizationSetting](
	[OrganizationSettingId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[MinAmountForReceipt] [float] NULL,
	[MaxAmountLimit] [float] NULL,
	[MaxEventsPerDay] [int] NOT NULL,
	[AutoscheduleWeeks] [int] NOT NULL,
	[NotificationDuration] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DefaultMeetingTime] [int] NOT NULL,
	[DefaultTravelTime] [int] NOT NULL,
	[DefaultClusterRadius] [int] NOT NULL,
	[StandardIRSRate] [float] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrganizationSettingId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[PreCallNote]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[PreCallNote](
	[PreCallNoteId] [int] IDENTITY(1,1) NOT NULL,
	[SalesRepId] [int] NOT NULL,
	[AccountType] [nvarchar](255) NOT NULL,
	[Note] [nvarchar](2000) NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime] NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PreCallNoteId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[Referrals]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Referrals](
	[ReferralSystemID] [varchar](100) NULL,
	[CustomerSystemID] [varchar](50) NULL,
	[AccountSystemID] [varchar](100) NULL,
	[ClientSystemID] [varchar](100) NULL,
	[ReferralID] [varchar](100) NULL,
	[BranchSystemID] [varchar](100) NULL,
	[ReferralDate] [date] NULL,
	[CalendarSystemIDRefDate] [int] NULL,
	[PayorMasterID] [varchar](100) NULL,
	[ReferralStatus] [varchar](50) NULL,
	[CalendarSystemIDAdmDate] [int] NULL,
	[CalendarSystemIDDCDate] [int] NULL,
	[NTUCDate] [date] NULL,
	[CalendarSystemIDNTUCDate] [int] NULL,
	[RepRosterSystemID] [varchar](100) NULL,
	[WasAdmitted] [bit] NULL,
	[WasDischarged] [bit] NULL,
	[WasNTUC] [bit] NULL,
	[DischargeTypeCode] [varchar](200) NULL,
	[NTUCCode] [varchar](50) NULL,
	[RefreshDateTime] [datetime] NULL,
	[MRN] [varchar](100) NULL,
	[ServiceLine] [varchar](50) NULL,
	[NursePractitioner] [bit] NULL,
	[OrdersRecieved] [varchar](50) NULL,
	[AdmissionNurse] [varchar](50) NULL,
	[ReferringFacilityName] [varchar](100) NULL,
	[PayorTypeID] [varchar](50) NULL,
	[EPIStatus] [varchar](50) NULL,
	[EPIStatusTypeDescription] [varchar](100) NULL,
	[ServiceLineID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[RepAttributes]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[RepAttributes](
	[CustomerSystemID] [varchar](50) NULL,
	[RepRosterSystemID] [varchar](100) NULL,
	[BranchSystemID] [varchar](100) NULL,
	[ServiceLineID] [varchar](50) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[Report]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Report](
	[ReportId] [int] IDENTITY(1,1) NOT NULL,
	[EventCallLogId] [int] NULL,
	[SalesRepId] [int] NOT NULL,
	[ReportTitle] [nvarchar](255) NOT NULL,
	[ReportType] [tinyint] NOT NULL,
	[ReportStatus] [tinyint] NOT NULL,
	[ReportTotalAmount] [float] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ReportId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[ReportApproval]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[ReportApproval](
	[ReportApprovalId] [int] IDENTITY(1,1) NOT NULL,
	[ManagerId] [int] NOT NULL,
	[ReportId] [int] NOT NULL,
	[Type] [tinyint] NOT NULL,
	[RejectedReason] [nvarchar](2000) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ReportApprovalId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[RepRosterMaster]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[RepRosterMaster](
	[RepRosterSystemID] [varchar](100) NULL,
	[CustomerSystemID] [varchar](50) NULL,
	[SalesAgentID] [varchar](50) NULL,
	[BranchCode] [varchar](25) NULL,
	[BranchSystemID] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[FirstName] [varchar](100) NULL,
	[MiddleName] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[HRWorkerID] [varchar](50) NULL,
	[WorkerEmail] [varchar](150) NULL,
	[IsActive] [bit] NULL,
	[IsDualSL] [bit] NULL,
	[IsMultiRole] [bit] NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[RefreshDateTime] [datetime] NULL,
	[SalesRep] [varchar](252) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[RepToManagerMapping]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[RepToManagerMapping](
	[RepRosterSystemID] [varchar](100) NULL,
	[ManagerRosterSystemID] [varchar](100) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[RoleMap]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[RoleMap](
	[RoleMapId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Role] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleMapId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[SalesRep]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[SalesRep](
	[SalesRepId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[OrganizationBranchId] [int] NULL,
	[NotificationId] [nvarchar](max) NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[EmployeePosition] [tinyint] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
	[Timezone] [nvarchar](255) NULL,
	[HasAutoscheduleStarted] [tinyint] NOT NULL,
	[DeviceType] [tinyint] NULL,
	[AutoScheduleStartDate] [datetime2](7) NULL,
	[SourceSystem] [tinyint] NOT NULL,
	[OID] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[SalesRepId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[SalesRepTerritoryBranchMap]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[SalesRepTerritoryBranchMap](
	[SalesRepTerritoryBranchMapId] [int] IDENTITY(1,1) NOT NULL,
	[SalesRepId] [int] NOT NULL,
	[TerritoryId] [nvarchar](255) NOT NULL,
	[OrganizationBranchId] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[SalesRepTerritoryBranchMapId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[SuperAdmin]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[SuperAdmin](
	[SuperAdminId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[Password] [nvarchar](255) NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[OID] [nvarchar](225) NULL,
PRIMARY KEY CLUSTERED 
(
	[SuperAdminId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[Task]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Task](
	[TaskId] [int] IDENTITY(1,1) NOT NULL,
	[AssignedBy] [int] NOT NULL,
	[AssignedTo] [int] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Description] [text] NULL,
	[DueDate] [datetime] NULL,
	[CompletionDate] [datetime] NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime] NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TaskId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[Territory]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Territory](
	[TerritoryId] [nvarchar](255) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[TerritoryName] [nvarchar](255) NOT NULL,
	[Active] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
	[SourceSystem] [tinyint] NOT NULL,
 CONSTRAINT [Territory_pkey] PRIMARY KEY CLUSTERED 
(
	[TerritoryId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[TokenUsage]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[TokenUsage](
	[TokenUsageId] [int] IDENTITY(1,1) NOT NULL,
	[SalesRepId] [int] NOT NULL,
	[Usage] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TokenUsageId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[UserAuditLog]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[UserAuditLog](
	[UserAuditLogId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[EntityType] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[Z_Account_TMP]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Z_Account_TMP](
	[AccountId] [int] NOT NULL,
	[AccountType] [nvarchar](255) NULL,
	[OrganizationId] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[PrimaryContact] [nvarchar](255) NULL,
	[SecondaryContact] [nvarchar](255) NULL,
	[PrimaryEmail] [nvarchar](255) NULL,
	[SecondaryEmail] [nvarchar](255) NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
	[NPI] [nvarchar](255) NULL,
	[Website] [nvarchar](255) NULL,
	[IsHouseAccount] [tinyint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[Z_AccountAddress_TMP]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Z_AccountAddress_TMP](
	[AccountAddressId] [int] NULL,
	[AccountId] [int] NULL,
	[AddressType] [int] NULL,
	[AddressLine1] [nvarchar](255) NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Zipcode] [nvarchar](255) NULL,
	[Latitude] [nvarchar](255) NULL,
	[Longitude] [nvarchar](255) NULL,
	[CreatedAt] [datetime2](7) NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
	[IsPrimaryAddress] [tinyint] NULL,
	[AddressTypeId] [int] NULL,
	[SourceSystem] [tinyint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[Z_AccountContact_TMP]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Z_AccountContact_TMP](
	[AccountContactId] [int] NOT NULL,
	[AccountId] [int] NOT NULL,
	[AccountContactAddressId] [int] NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Phone] [nvarchar](255) NULL,
	[Email] [nvarchar](255) NULL,
	[Role] [nvarchar](255) NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[Z_AccountContactAddress_TMP]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Z_AccountContactAddress_TMP](
	[AccountContactAddressId] [int] NOT NULL,
	[AddressLine1] [nvarchar](255) NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Zipcode] [nvarchar](255) NULL,
	[Latitude] [nvarchar](255) NULL,
	[Longitude] [nvarchar](255) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[Z_AccountTerritoryMap_25325]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Z_AccountTerritoryMap_25325](
	[AccountTerritoryMapId] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[TerritoryId] [nvarchar](255) NOT NULL,
	[ServiceLine] [nvarchar](255) NOT NULL,
	[DaysPriority] [nvarchar](255) NOT NULL,
	[AccountSegment] [tinyint] NOT NULL,
	[AccountTier] [tinyint] NOT NULL,
	[CallFrequency] [int] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[Z_OrganizationBranch_TMP]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Z_OrganizationBranch_TMP](
	[OrganizationBranchId] [int] NULL,
	[OrganizationId] [int] NOT NULL,
	[BranchCode] [nvarchar](255) NOT NULL,
	[BranchName] [nvarchar](255) NOT NULL,
	[AddressLine1] [nvarchar](255) NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Zipcode] [nvarchar](255) NULL,
	[Latitude] [nvarchar](255) NULL,
	[Longitude] [nvarchar](255) NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[Z_Referrals_DELETE]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Z_Referrals_DELETE](
	[ReferralSystemID] [varchar](100) NULL,
	[CustomerSystemID] [varchar](50) NULL,
	[AccountSystemID] [varchar](100) NULL,
	[ClientSystemID] [varchar](100) NULL,
	[ReferralID] [varchar](100) NULL,
	[BranchSystemID] [varchar](100) NULL,
	[ReferralDate] [date] NULL,
	[CalendarSystemIDRefDate] [int] NULL,
	[PayorMasterID] [varchar](100) NULL,
	[ReferralStatus] [varchar](50) NULL,
	[CalendarSystemIDAdmDate] [int] NULL,
	[CalendarSystemIDDCDate] [int] NULL,
	[NTUCDate] [date] NULL,
	[CalendarSystemIDNTUCDate] [int] NULL,
	[RepRosterSystemID] [varchar](100) NULL,
	[WasAdmitted] [bit] NULL,
	[WasDischarged] [bit] NULL,
	[WasNTUC] [bit] NULL,
	[DischargeTypeCode] [varchar](200) NULL,
	[NTUCCode] [varchar](50) NULL,
	[RefreshDateTime] [datetime] NULL,
	[MRN] [varchar](100) NULL,
	[ServiceLine] [varchar](50) NULL,
	[NursePractitioner] [bit] NULL,
	[OrdersRecieved] [varchar](50) NULL,
	[AdmissionNurse] [varchar](50) NULL,
	[ReferringFacilityName] [varchar](100) NULL,
	[PayorTypeID] [varchar](50) NULL,
	[EPIStatus] [varchar](50) NULL,
	[EPIStatusTypeDescription] [varchar](100) NULL,
	[ServiceLineID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[Z_SBX_Account_1095]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Z_SBX_Account_1095](
	[AccountId] [int] IDENTITY(1,1) NOT NULL,
	[AccountType] [nvarchar](255) NULL,
	[OrganizationId] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[PrimaryContact] [nvarchar](255) NULL,
	[SecondaryContact] [nvarchar](255) NULL,
	[PrimaryEmail] [nvarchar](255) NULL,
	[SecondaryEmail] [nvarchar](255) NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
	[NPI] [nvarchar](255) NULL,
	[Website] [nvarchar](255) NULL,
	[IsHouseAccount] [tinyint] NULL,
	[SourceSystem] [tinyint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBird].[Z_SBX_Referrals_1095]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBird].[Z_SBX_Referrals_1095](
	[ReferralSystemID] [varchar](100) NULL,
	[CustomerSystemID] [varchar](50) NULL,
	[AccountSystemID] [varchar](100) NULL,
	[ClientSystemID] [varchar](100) NULL,
	[ReferralID] [varchar](100) NULL,
	[BranchSystemID] [varchar](100) NULL,
	[ReferralDate] [date] NULL,
	[CalendarSystemIDRefDate] [int] NULL,
	[PayorMasterID] [varchar](100) NULL,
	[ReferralStatus] [varchar](50) NULL,
	[CalendarSystemIDAdmDate] [int] NULL,
	[CalendarSystemIDDCDate] [int] NULL,
	[NTUCDate] [date] NULL,
	[CalendarSystemIDNTUCDate] [int] NULL,
	[RepRosterSystemID] [varchar](100) NULL,
	[WasAdmitted] [bit] NULL,
	[WasDischarged] [bit] NULL,
	[WasNTUC] [bit] NULL,
	[DischargeTypeCode] [varchar](200) NULL,
	[NTUCCode] [varchar](50) NULL,
	[RefreshDateTime] [datetime] NULL,
	[MRN] [varchar](100) NULL,
	[ServiceLine] [varchar](50) NULL,
	[NursePractitioner] [bit] NULL,
	[OrdersRecieved] [varchar](50) NULL,
	[AdmissionNurse] [varchar](50) NULL,
	[ReferringFacilityName] [varchar](100) NULL,
	[PayorTypeID] [varchar](50) NULL,
	[EPIStatus] [varchar](50) NULL,
	[EPIStatusTypeDescription] [varchar](100) NULL,
	[ServiceLineID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBirdLoad].[AccountFacilityContacts]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBirdLoad].[AccountFacilityContacts](
	[fak_id] [int] NOT NULL,
	[fak_faid] [int] NOT NULL,
	[fak_ctid] [int] NULL,
	[fak_contact_name] [varchar](100) NOT NULL,
	[fak_best_time] [varchar](50) NULL,
	[fak_schedule] [varchar](255) NULL,
	[fak_companion] [varchar](100) NULL,
	[fak_children] [varchar](255) NULL,
	[fak_food] [varchar](100) NULL,
	[fak_hobby] [varchar](100) NULL,
	[fak_education] [varchar](100) NULL,
	[fak_restaurant] [varchar](100) NULL,
	[fak_prof_org] [varchar](200) NULL,
	[fak_birthday] [datetime] NULL,
	[fak_anniversary] [datetime] NULL,
	[fak_date1] [datetime] NULL,
	[fak_date1_desc] [varchar](50) NULL,
	[fak_date2] [datetime] NULL,
	[fak_date2_desc] [varchar](50) NULL,
	[fak_comments] [varchar](500) NULL,
	[fak_active] [char](1) NOT NULL,
	[fak_insertdate] [datetime] NOT NULL,
	[fak_lastupdate] [datetime] NOT NULL,
	[fak_prioritycodeid] [int] NULL,
	[fak_workphone] [varchar](25) NULL,
	[fak_workphoneextension] [varchar](4) NULL,
	[fak_mobilephone] [varchar](25) NULL,
	[fak_email] [varchar](100) NULL,
	[fak_title] [varchar](4) NULL,
	[fak_prid] [int] NULL,
	[fak_firstname] [varchar](50) NULL,
	[fak_lastname] [varchar](50) NULL,
	[fak_homephone] [varchar](20) NULL,
	[fak_voiddate] [datetime] NULL,
	[fak_mobile_id] [int] NULL,
	[fak_dsmnetwork] [int] NULL,
	[fak_dsmaddress] [varchar](8000) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBirdLoad].[AccountPhysicianOfficeContacts]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBirdLoad].[AccountPhysicianOfficeContacts](
	[phk_id] [int] NOT NULL,
	[phk_poid] [int] NULL,
	[phk_ctid] [int] NULL,
	[phk_contact_type] [char](2) NULL,
	[phk_contact_name] [varchar](100) NOT NULL,
	[phk_best_time] [varchar](50) NULL,
	[phk_schedule] [varchar](255) NULL,
	[phk_companion] [varchar](100) NULL,
	[phk_children] [varchar](255) NULL,
	[phk_food] [varchar](100) NULL,
	[phk_hobby] [varchar](100) NULL,
	[phk_education] [varchar](100) NULL,
	[phk_restaurant] [varchar](100) NULL,
	[phk_prof_org] [varchar](200) NULL,
	[phk_birthday] [smalldatetime] NULL,
	[phk_anniversary] [smalldatetime] NULL,
	[phk_date1] [smalldatetime] NULL,
	[phk_date1_desc] [varchar](50) NULL,
	[phk_date2] [smalldatetime] NULL,
	[phk_date2_desc] [varchar](50) NULL,
	[phk_comments] [varchar](500) NULL,
	[phk_uid] [int] NULL,
	[phk_active] [char](1) NOT NULL,
	[phk_insertdate] [smalldatetime] NOT NULL,
	[phk_lastupdate] [smalldatetime] NOT NULL,
	[phk_prioritycodeid] [int] NULL,
	[phk_workphone] [varchar](25) NULL,
	[phk_workphoneextension] [varchar](4) NULL,
	[phk_mobilephone] [varchar](25) NULL,
	[phk_email] [varchar](100) NULL,
	[phk_title] [varchar](4) NULL,
	[phk_prid] [int] NULL,
	[phk_firstname] [varchar](50) NULL,
	[phk_lastname] [varchar](50) NULL,
	[phk_homephone] [varchar](20) NULL,
	[phk_voiddate] [smalldatetime] NULL,
	[phk_mobile_id] [int] NULL,
	[phk_dsmnetwork] [int] NULL,
	[phk_dsmaddress] [varchar](8000) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBirdLoad].[AccountPhysicianOffices]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBirdLoad].[AccountPhysicianOffices](
	[po_id] [int] NOT NULL,
	[po_phid] [int] NOT NULL,
	[po_address] [varchar](100) NOT NULL,
	[po_city] [varchar](50) NOT NULL,
	[po_state] [char](2) NOT NULL,
	[po_zip] [varchar](10) NOT NULL,
	[po_phone] [varchar](25) NULL,
	[po_fax] [varchar](25) NULL,
	[po_notifyphone] [bit] NOT NULL,
	[po_notifyfax] [bit] NOT NULL,
	[po_notifyemail] [bit] NOT NULL,
	[po_notifyweb] [bit] NOT NULL,
	[po_pcmid] [int] NOT NULL,
	[po_pgid] [int] NULL,
	[po_active] [char](1) NOT NULL,
	[po_pmid] [int] NOT NULL,
	[po_insertdate] [datetime] NOT NULL,
	[po_lastupdate] [datetime] NOT NULL,
	[po_vnweb] [char](1) NOT NULL,
	[po_AddressMapped] [char](1) NULL,
	[po_Latitude] [decimal](18, 15) NULL,
	[po_Longitude] [decimal](18, 15) NULL,
	[po_LatLongMethod] [varchar](10) NULL,
	[po_otgid] [int] NULL,
	[po_dsmnetwork] [int] NULL,
	[po_dsmaddress] [varchar](8000) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBirdLoad].[Accounts]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBirdLoad].[Accounts](
	[AccountSystemID] [varchar](50) NULL,
	[CustomerSystemID] [varchar](50) NULL,
	[AccountID] [text] NULL,
	[AccountType] [varchar](50) NULL,
	[AccountName] [varchar](200) NULL,
	[AccountFirstName] [varchar](100) NULL,
	[AccountLastName] [varchar](100) NULL,
	[AccountMiddleName] [varchar](50) NULL,
	[AddressLine1] [varchar](100) NULL,
	[AddressLine2] [varchar](100) NULL,
	[AddressCity] [varchar](100) NULL,
	[AddressState] [varchar](100) NULL,
	[AddressZip] [varchar](50) NULL,
	[GPSCoordinates] [varchar](100) NULL,
	[Latitude] [varchar](50) NULL,
	[Longitude] [varchar](50) NULL,
	[RefreshDateTime] [datetime] NULL,
	[BlueBirdAccountID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [BlueBirdLoad].[BranchDetails]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBirdLoad].[BranchDetails](
	[branch_code] [char](3) NOT NULL,
	[branch_name] [varchar](100) NOT NULL,
	[branch_street] [varchar](100) NOT NULL,
	[branch_city] [varchar](50) NOT NULL,
	[branch_state] [char](2) NOT NULL,
	[branch_zip] [varchar](10) NOT NULL,
	[branch_phone] [varchar](25) NOT NULL,
	[branch_fax] [varchar](25) NOT NULL,
	[branch_FederalId] [varchar](10) NOT NULL,
	[branch_ProviderNumber] [varchar](10) NULL,
	[branch_StateLicense] [varchar](15) NULL,
	[branch_active] [char](1) NOT NULL,
	[branch_insertdate] [datetime] NOT NULL,
	[branch_lastupdate] [datetime] NOT NULL,
	[branch_corpoffice] [char](1) NOT NULL,
	[branch_tzid] [int] NULL,
	[branch_parent] [char](3) NULL,
	[branch_branchGL] [nvarchar](25) NULL,
	[branch_regid] [int] NULL,
	[branch_RemittanceID] [int] NULL,
	[branch_HosStateLicense] [varchar](15) NULL,
	[branch_FederalTaxID] [varchar](10) NULL,
	[branch_county] [varchar](50) NULL,
	[branch_IncludeInAll] [char](1) NOT NULL,
	[branch_HHMedicareExpectedGMStandard] [int] NOT NULL,
	[branch_HHMedicareExpectedGMOutlier] [int] NOT NULL,
	[branch_HHMedicareExpectedGMLUPA] [int] NOT NULL,
	[branch_HHMedicareExpectedGMTherapy] [int] NOT NULL,
	[branch_IncludeOnPhysicianWebsite] [char](1) NOT NULL,
	[branch_AddressMapped] [char](1) NULL,
	[branch_rslid] [int] NULL,
	[branch_Latitude] [decimal](18, 15) NULL,
	[branch_Longitude] [decimal](18, 15) NULL,
	[branch_LatLongMethod] [varchar](10) NULL,
	[branch_SilentGPSAtPCVisitStart] [char](1) NULL,
	[branch_SilentGPSAtPCVisitEnd] [char](1) NULL,
	[branch_PayrollCode] [varchar](25) NULL,
	[branch_email] [varchar](50) NULL,
	[branch_webaddress] [varchar](50) NULL,
	[branch_PayrollCode2] [varchar](25) NULL,
	[branch_MCCM] [char](1) NOT NULL,
	[branch_IsHospiceInpatientUnit] [char](1) NOT NULL,
	[branch_contact] [varchar](101) NULL,
	[branch_medalogixbackofficeintegration] [char](1) NOT NULL,
	[BRANCH_IDENTITY] [int] NOT NULL,
	[branch_friendlyname] [nvarchar](50) NULL,
	[branch_smshelpphone] [varchar](25) NULL,
	[branch_schedulingphone] [varchar](25) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBirdLoad].[BranchMaster]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBirdLoad].[BranchMaster](
	[BranchSystemID] [varchar](100) NULL,
	[CustomerSystemID] [varchar](50) NULL,
	[BranchCode] [varchar](50) NULL,
	[BranchName] [varchar](100) NULL,
	[StateCodeDescription] [varchar](100) NULL,
	[StateCode] [varchar](50) NULL,
	[BranchStatus] [varchar](20) NULL,
	[AreaCode] [varchar](50) NULL,
	[AreaDescription] [varchar](200) NULL,
	[BranchCity] [varchar](50) NULL,
	[ServiceLine] [varchar](50) NULL,
	[GraphChartColorCode] [varchar](10) NULL,
	[ServiceLineSystemID] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[RegionName] [varchar](100) NULL,
	[RegionCode] [varchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBirdLoad].[ContactTypes]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBirdLoad].[ContactTypes](
	[ct_id] [int] NULL,
	[ct_desc] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBirdLoad].[Referrals]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBirdLoad].[Referrals](
	[ReferralSystemID] [varchar](100) NULL,
	[CustomerSystemID] [varchar](50) NULL,
	[AccountSystemID] [varchar](100) NULL,
	[ClientSystemID] [varchar](100) NULL,
	[ReferralID] [varchar](100) NULL,
	[BranchSystemID] [varchar](100) NULL,
	[ReferralDate] [date] NULL,
	[CalendarSystemIDRefDate] [int] NULL,
	[PayorMasterID] [varchar](100) NULL,
	[ReferralStatus] [varchar](50) NULL,
	[CalendarSystemIDAdmDate] [int] NULL,
	[CalendarSystemIDDCDate] [int] NULL,
	[NTUCDate] [date] NULL,
	[CalendarSystemIDNTUCDate] [int] NULL,
	[RepRosterSystemID] [varchar](100) NULL,
	[WasAdmitted] [bit] NULL,
	[WasDischarged] [bit] NULL,
	[WasNTUC] [bit] NULL,
	[DischargeTypeCode] [varchar](200) NULL,
	[NTUCCode] [varchar](50) NULL,
	[RefreshDateTime] [datetime] NULL,
	[MRN] [varchar](100) NULL,
	[ServiceLine] [varchar](50) NULL,
	[NursePractitioner] [bit] NULL,
	[OrdersRecieved] [varchar](50) NULL,
	[AdmissionNurse] [varchar](50) NULL,
	[ReferringFacilityName] [varchar](100) NULL,
	[PayorTypeID] [varchar](50) NULL,
	[EPIStatus] [varchar](50) NULL,
	[EPIStatusTypeDescription] [varchar](100) NULL,
	[ServiceLineID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [BlueBirdLoad].[RepRosterMaster]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [BlueBirdLoad].[RepRosterMaster](
	[RepRosterSystemID] [varchar](100) NULL,
	[CustomerSystemID] [varchar](50) NULL,
	[SalesAgentID] [varchar](50) NULL,
	[BranchCode] [varchar](25) NULL,
	[BranchSystemID] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[FirstName] [varchar](100) NULL,
	[MiddleName] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[HRWorkerID] [varchar](50) NULL,
	[WorkerEmail] [varchar](150) NULL,
	[IsActive] [bit] NULL,
	[IsDualSL] [bit] NULL,
	[IsMultiRole] [bit] NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[RefreshDateTime] [datetime] NULL,
	[SalesRep] [varchar](252) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Account]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[AccountId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[AccountType] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NOT NULL,
	[PrimaryContact] [nvarchar](255) NULL,
	[SecondaryContact] [nvarchar](255) NULL,
	[PrimaryEmail] [nvarchar](255) NULL,
	[SecondaryEmail] [nvarchar](255) NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[IsHouseAccount] [tinyint] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
	[NPI] [nvarchar](255) NULL,
	[Website] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[AccountId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccountAddress]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountAddress](
	[AccountAddressId] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[AddressTypeId] [int] NOT NULL,
	[IsPrimaryAddress] [tinyint] NULL,
	[AddressLine1] [nvarchar](255) NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Zipcode] [nvarchar](255) NULL,
	[Latitude] [nvarchar](255) NOT NULL,
	[Longitude] [nvarchar](255) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
	[AddressType] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AccountAddressId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccountContact]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountContact](
	[AccountContactId] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[AccountContactAddressId] [int] NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Phone] [nvarchar](255) NULL,
	[Email] [nvarchar](255) NULL,
	[Role] [nvarchar](255) NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[AccountContactId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccountContactAddress]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountContactAddress](
	[AccountContactAddressId] [int] IDENTITY(1,1) NOT NULL,
	[AddressLine1] [nvarchar](255) NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Zipcode] [nvarchar](255) NULL,
	[Latitude] [nvarchar](255) NOT NULL,
	[Longitude] [nvarchar](255) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[AccountContactAddressId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccountDetails]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountDetails](
	[AccountDetailsId] [int] IDENTITY(1,1) NOT NULL,
	[AccountSystemId] [nvarchar](255) NULL,
	[CustomerSystemId] [nvarchar](255) NULL,
	[AccountId] [int] NULL,
	[AccountType] [nvarchar](255) NULL,
	[AccountName] [nvarchar](255) NULL,
	[AccountFirstName] [nvarchar](255) NULL,
	[AccountMiddleName] [nvarchar](255) NULL,
	[AccountLastName] [nvarchar](255) NULL,
	[AddressLine1] [nvarchar](100) NULL,
	[AddressLine2] [nvarchar](100) NULL,
	[AddressCity] [nvarchar](100) NULL,
	[AddressState] [nvarchar](100) NULL,
	[AddressZip] [nvarchar](100) NULL,
	[GPSCoordinates] [nvarchar](100) NULL,
	[Latitude] [nvarchar](100) NULL,
	[Longitude] [nvarchar](100) NULL,
	[RefreshDateTime] [nvarchar](100) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[AccountDetailsId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccountTerritoryMap]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountTerritoryMap](
	[AccountTerritoryMapId] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[TerritoryId] [nvarchar](255) NOT NULL,
	[ServiceLine] [nvarchar](255) NOT NULL,
	[DaysPriority] [nvarchar](255) NOT NULL,
	[AccountSegment] [tinyint] NOT NULL,
	[AccountTier] [tinyint] NOT NULL,
	[CallFrequency] [int] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AccountTerritoryMapId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AddressType]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AddressType](
	[AddressTypeId] [int] IDENTITY(1,1) NOT NULL,
	[AddressType] [nvarchar](255) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[AddressTypeId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Admissions]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Admissions](
	[AdmissionsId] [int] IDENTITY(1,1) NOT NULL,
	[SalesRepId] [int] NOT NULL,
	[ServiceLine] [nvarchar](255) NULL,
	[PatientId] [int] NULL,
	[PatientName] [nvarchar](255) NULL,
	[AdmitDate] [date] NULL,
	[CommisionEligibility] [nvarchar](255) NULL,
	[NonEligibleReason] [nvarchar](255) NULL,
	[ReferralSystemId] [nvarchar](255) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[AdmissionsId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AiAuditLog]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AiAuditLog](
	[AiAuditLogId] [int] IDENTITY(1,1) NOT NULL,
	[SalesRepId] [int] NOT NULL,
	[EntityType] [int] NOT NULL,
	[Channel] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AiAuditLogId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CommissionPayout]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CommissionPayout](
	[CommissionPayoutId] [int] IDENTITY(1,1) NOT NULL,
	[SalesRepId] [int] NOT NULL,
	[PlanType] [nvarchar](255) NULL,
	[TimeDimension] [nvarchar](255) NULL,
	[BranchId] [int] NOT NULL,
	[BranchCode] [nvarchar](255) NULL,
	[AdmitMonth] [int] NULL,
	[AdmitQtr] [int] NULL,
	[AdmitYear] [int] NULL,
	[ServiceLine] [nvarchar](255) NULL,
	[PayoutAmount] [float] NULL,
	[AdmitsGoal] [int] NULL,
	[EligibleTotalReAdmits] [int] NULL,
	[EligibleTotalAdmitsAndReAdmits] [int] NULL,
	[Referrals] [int] NULL,
	[TtlAdmitsMinusGoal] [int] NULL,
	[ADCGoal] [float] NULL,
	[ADCActual] [float] NULL,
	[Tier] [nvarchar](255) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[CommissionPayoutId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CommSalesRep]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CommSalesRep](
	[SalesRepId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[PhoneNumber] [nvarchar](255) NOT NULL,
	[IdToken] [nvarchar](max) NULL,
	[RefreshToken] [nvarchar](max) NULL,
	[HireDate] [date] NOT NULL,
	[EmployeePosition] [tinyint] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[Timezone] [nvarchar](255) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[SalesRepId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[countries]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[countries](
	[id] [int] NOT NULL,
	[name] [nvarchar](75) NOT NULL,
	[emoji] [nvarchar](75) NOT NULL,
	[country_code] [nvarchar](5) NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
	[updated_at] [datetime2](7) NOT NULL,
 CONSTRAINT [countries_pkey] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[emails]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emails](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[to] [nvarchar](max) NOT NULL,
	[data] [nvarchar](max) NULL,
	[from] [nvarchar](255) NOT NULL,
	[subject] [nvarchar](255) NOT NULL,
	[text] [nvarchar](255) NULL,
	[template] [nvarchar](255) NULL,
	[email_delay] [datetime2](7) NULL,
	[created_at] [datetime2](7) NOT NULL,
	[updated_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Event]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Event](
	[EventId] [int] IDENTITY(1,1) NOT NULL,
	[SalesRepId] [int] NOT NULL,
	[EventCategoryId] [int] NOT NULL,
	[AccountId] [int] NULL,
	[UUID] [nvarchar](255) NOT NULL,
	[Timezone] [nvarchar](255) NOT NULL,
	[Title] [nvarchar](255) NULL,
	[StartDate] [datetime2](7) NULL,
	[EndDate] [datetime2](7) NULL,
	[StartTime] [datetime2](7) NULL,
	[EndTime] [datetime2](7) NULL,
	[TravelTime] [int] NOT NULL,
	[RepeatSchedule] [nvarchar](255) NOT NULL,
	[IsAllDay] [bit] NOT NULL,
	[EventType] [tinyint] NOT NULL,
	[EventUri] [nvarchar](255) NULL,
	[Interval] [int] NULL,
	[Unit] [nvarchar](255) NULL,
	[RepeatOnWeek] [nvarchar](255) NULL,
	[RepeatOnMonth] [tinyint] NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[EventUriID] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventAttendee]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventAttendee](
	[EventAttendeeId] [int] IDENTITY(1,1) NOT NULL,
	[EventCallLogId] [int] NULL,
	[AccountContactId] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EventAttendeeId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventAuditLog]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventAuditLog](
	[EventAuditLogId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[EntityType] [tinyint] NOT NULL,
	[EntityId] [int] NOT NULL,
	[ActivityType] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EventAuditLogId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventCallLog]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventCallLog](
	[EventCallLogId] [int] IDENTITY(1,1) NOT NULL,
	[EventId] [int] NULL,
	[LogType] [tinyint] NOT NULL,
	[Notes] [nvarchar](max) NOT NULL,
	[NotesQuality] [float] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EventCallLogId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventCategory]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventCategory](
	[EventCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Color] [nvarchar](255) NOT NULL,
	[IsEditable] [bit] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EventCategoryId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventNotification]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventNotification](
	[EventNotificationId] [int] IDENTITY(1,1) NOT NULL,
	[EventId] [int] NOT NULL,
	[NotificationCount] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EventNotificationId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExpenseCategory]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExpenseCategory](
	[ExpenseCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[Uuid] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ExpenseCategoryId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExpenseReceipt]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExpenseReceipt](
	[ExpenseReceiptId] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NOT NULL,
	[AccountId] [int] NOT NULL,
	[ExpenseCategoryId] [int] NOT NULL,
	[MerchantName] [nvarchar](255) NULL,
	[ExpenseType] [tinyint] NOT NULL,
	[TransactionDate] [nvarchar](255) NOT NULL,
	[ExpenseNotes] [nvarchar](255) NULL,
	[AttachmentUri] [nvarchar](255) NULL,
	[Amount] [float] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[Attendees] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ExpenseReceiptId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[knex_migrations]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[knex_migrations](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NULL,
	[batch] [int] NULL,
	[migration_time] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[knex_migrations_lock]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[knex_migrations_lock](
	[index] [int] IDENTITY(1,1) NOT NULL,
	[is_locked] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[index] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ManagerSalesRepMap]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ManagerSalesRepMap](
	[ManagerSalesRepMapId] [int] IDENTITY(1,1) NOT NULL,
	[SalesRepId] [int] NOT NULL,
	[ManagerId] [int] NOT NULL,
	[ApprovalType] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ManagerSalesRepMapId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MileageEntry]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MileageEntry](
	[MileageEntryId] [int] IDENTITY(1,1) NOT NULL,
	[MileageReportId] [int] NOT NULL,
	[TripName] [nvarchar](255) NOT NULL,
	[TripDate] [datetime2](7) NOT NULL,
	[MileageNotes] [nvarchar](255) NULL,
	[TotalDistance] [float] NOT NULL,
	[TotalAmount] [float] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[ReimbursedDistance] [float] NULL,
	[MileageType] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MileageEntryId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MileageLocationMap]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MileageLocationMap](
	[MileageLocationMapId] [int] IDENTITY(1,1) NOT NULL,
	[MileageEntryId] [int] NOT NULL,
	[Address] [nvarchar](255) NOT NULL,
	[Latitude] [nvarchar](255) NOT NULL,
	[Longitude] [nvarchar](255) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MileageLocationMapId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Module]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Module](
	[ModuleId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ModuleId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ModuleOrganizationMap]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ModuleOrganizationMap](
	[ModuleOrganizationMapId] [int] IDENTITY(1,1) NOT NULL,
	[ModuleId] [int] NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ModuleOrganizationMapId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotesQuestion]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotesQuestion](
	[NotesQuestionId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[Question] [nvarchar](2000) NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NotesQuestionId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Organization]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organization](
	[OrganizationId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationName] [nvarchar](255) NOT NULL,
	[AddressLine1] [nvarchar](255) NOT NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[City] [nvarchar](255) NOT NULL,
	[State] [nvarchar](255) NOT NULL,
	[Country] [nvarchar](255) NOT NULL,
	[Zipcode] [nvarchar](255) NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[OrganizationId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrganizationBranch]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrganizationBranch](
	[OrganizationBranchId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[BranchCode] [nvarchar](255) NOT NULL,
	[BranchName] [nvarchar](255) NOT NULL,
	[AddressLine1] [nvarchar](255) NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Zipcode] [nvarchar](255) NULL,
	[Latitude] [nvarchar](255) NULL,
	[Longitude] [nvarchar](255) NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[OrganizationBranchId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrganizationSetting]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrganizationSetting](
	[OrganizationSettingId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[MinAmountForReceipt] [float] NULL,
	[MaxAmountLimit] [float] NULL,
	[MaxEventsPerDay] [int] NOT NULL,
	[AutoscheduleWeeks] [int] NOT NULL,
	[NotificationDuration] [int] NOT NULL,
	[DefaultMeetingTime] [int] NOT NULL,
	[DefaultTravelTime] [int] NOT NULL,
	[StandardIRSRate] [decimal](10, 2) NOT NULL,
	[DefaultClusterRadius] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrganizationSettingId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Report]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Report](
	[ReportId] [int] IDENTITY(1,1) NOT NULL,
	[EventCallLogId] [int] NULL,
	[SalesRepId] [int] NOT NULL,
	[ReportTitle] [nvarchar](255) NOT NULL,
	[ReportType] [tinyint] NOT NULL,
	[ReportStatus] [tinyint] NOT NULL,
	[ReportTotalAmount] [float] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ReportId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReportApproval]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportApproval](
	[ReportApprovalId] [int] IDENTITY(1,1) NOT NULL,
	[ManagerId] [int] NOT NULL,
	[ReportId] [int] NOT NULL,
	[Type] [tinyint] NOT NULL,
	[RejectedReason] [nvarchar](2000) NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ReportApprovalId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleMap]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleMap](
	[RoleMapId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Role] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleMapId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SalesRep]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalesRep](
	[SalesRepId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[OrganizationBranchId] [int] NOT NULL,
	[NotificationId] [nvarchar](max) NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[PhoneNumber] [nvarchar](255) NOT NULL,
	[IdToken] [nvarchar](max) NULL,
	[HireDate] [date] NOT NULL,
	[EmployeePosition] [tinyint] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
	[RefreshToken] [nvarchar](max) NULL,
	[Timezone] [nvarchar](255) NULL,
	[HasAutoscheduleStarted] [tinyint] NOT NULL,
	[DeviceType] [tinyint] NULL,
	[AutoScheduleStartDate] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[SalesRepId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SalesRepTerritoryBranchMap]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalesRepTerritoryBranchMap](
	[SalesRepTerritoryBranchMapId] [int] IDENTITY(1,1) NOT NULL,
	[SalesRepId] [int] NOT NULL,
	[TerritoryId] [nvarchar](255) NOT NULL,
	[OrganizationBranchId] [int] NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[SalesRepTerritoryBranchMapId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[states]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[states](
	[id] [int] NOT NULL,
	[country_id] [int] NOT NULL,
	[name] [nvarchar](75) NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
	[updated_at] [datetime2](7) NOT NULL,
 CONSTRAINT [states_pkey] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SuperAdmin]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SuperAdmin](
	[SuperAdminId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[Password] [nvarchar](255) NULL,
	[IdToken] [nvarchar](max) NULL,
	[RefreshToken] [nvarchar](max) NULL,
	[Timezone] [nvarchar](255) NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SuperAdminId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Territory]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Territory](
	[TerritoryId] [nvarchar](255) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[TerritoryName] [nvarchar](255) NOT NULL,
	[Active] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime2](7) NOT NULL,
	[UpdatedBy] [int] NOT NULL,
	[DataSourceId] [nvarchar](255) NULL,
 CONSTRAINT [Territory_pkey] PRIMARY KEY CLUSTERED 
(
	[TerritoryId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TokenUsage]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TokenUsage](
	[TokenUsageId] [int] IDENTITY(1,1) NOT NULL,
	[SalesRepId] [int] NOT NULL,
	[Usage] [int] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TokenUsageId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAuditLog]    Script Date: 6/9/2025 11:16:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAuditLog](
	[UserAuditLogId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[EntityType] [tinyint] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserAuditLogId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [BlueBirdRpt].[Account] ADD  CONSTRAINT [account_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [BlueBirdRpt].[Account] ADD  CONSTRAINT [account_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[Account] ADD  CONSTRAINT [account_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[Account] ADD  DEFAULT ('0') FOR [IsHouseAccount]
GO
ALTER TABLE [BlueBirdRpt].[Account] ADD  DEFAULT ((1)) FOR [SourceSystem]
GO
ALTER TABLE [BlueBirdRpt].[AccountAddress] ADD  CONSTRAINT [accountaddress_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[AccountAddress] ADD  CONSTRAINT [accountaddress_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[AccountAddress] ADD  CONSTRAINT [DF__AccountAd__IsPri__25676607]  DEFAULT ((0)) FOR [IsPrimaryAddress]
GO
ALTER TABLE [BlueBirdRpt].[AccountAddress] ADD  CONSTRAINT [DF__AccountAd__Sourc__6FCA6F65]  DEFAULT ((1)) FOR [SourceSystem]
GO
ALTER TABLE [BlueBirdRpt].[AccountContact] ADD  CONSTRAINT [accountcontact_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [BlueBirdRpt].[AccountContact] ADD  CONSTRAINT [accountcontact_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[AccountContact] ADD  CONSTRAINT [accountcontact_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[AccountContactAddress] ADD  CONSTRAINT [accountcontactaddress_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[AccountContactAddress] ADD  CONSTRAINT [accountcontactaddress_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[AccountContactImpDate] ADD  DEFAULT (sysdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[AccountContactImpDate] ADD  DEFAULT (sysdatetime()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[AccountTerritoryMap] ADD  CONSTRAINT [accountterritorymap_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [BlueBirdRpt].[AccountTerritoryMap] ADD  CONSTRAINT [accountterritorymap_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[AccountTerritoryMap] ADD  CONSTRAINT [accountterritorymap_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[AddressType] ADD  CONSTRAINT [addresstype_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[AddressType] ADD  CONSTRAINT [addresstype_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[AiAuditLog] ADD  CONSTRAINT [aiauditlog_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[DataSyncJobAuditLog] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[DataSyncJobAuditLog] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[DebugLogger] ADD  DEFAULT (getdate()) FOR [LoggedAt]
GO
ALTER TABLE [BlueBirdRpt].[DebugLogger] ADD  DEFAULT (suser_sname()) FOR [UserName]
GO
ALTER TABLE [BlueBirdRpt].[DebugLogger] ADD  DEFAULT (@@spid) FOR [SessionID]
GO
ALTER TABLE [BlueBirdRpt].[Event] ADD  CONSTRAINT [event_eventcategoryid_default]  DEFAULT ('0') FOR [EventCategoryId]
GO
ALTER TABLE [BlueBirdRpt].[Event] ADD  CONSTRAINT [event_traveltime_default]  DEFAULT ('0') FOR [TravelTime]
GO
ALTER TABLE [BlueBirdRpt].[Event] ADD  CONSTRAINT [event_repeatschedule_default]  DEFAULT ('0days') FOR [RepeatSchedule]
GO
ALTER TABLE [BlueBirdRpt].[Event] ADD  CONSTRAINT [event_isallday_default]  DEFAULT ('0') FOR [IsAllDay]
GO
ALTER TABLE [BlueBirdRpt].[Event] ADD  CONSTRAINT [event_eventtype_default]  DEFAULT ('0') FOR [EventType]
GO
ALTER TABLE [BlueBirdRpt].[Event] ADD  CONSTRAINT [event_status_default]  DEFAULT ('0') FOR [Status]
GO
ALTER TABLE [BlueBirdRpt].[Event] ADD  CONSTRAINT [event_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[Event] ADD  CONSTRAINT [event_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[Event] ADD  CONSTRAINT [event_eventuriid_default]  DEFAULT (NULL) FOR [EventUriID]
GO
ALTER TABLE [BlueBirdRpt].[EventAttendee] ADD  CONSTRAINT [eventattendee_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[EventAttendee] ADD  CONSTRAINT [eventattendee_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[EventAuditLog] ADD  CONSTRAINT [eventauditlog_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[EventCallLog] ADD  CONSTRAINT [eventcalllog_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[EventCallLog] ADD  CONSTRAINT [eventcalllog_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[EventCategory] ADD  CONSTRAINT [eventcategory_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[EventCategory] ADD  CONSTRAINT [eventcategory_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[EventNotification] ADD  CONSTRAINT [eventnotification_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[EventNotification] ADD  CONSTRAINT [eventnotification_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[ExpenseCategory] ADD  CONSTRAINT [expensecategory_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[ExpenseCategory] ADD  CONSTRAINT [expensecategory_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[ExpenseCategory] ADD  DEFAULT ('#FFFFFF') FOR [Color]
GO
ALTER TABLE [BlueBirdRpt].[ExpenseReceipt] ADD  CONSTRAINT [expensereceipt_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[ExpenseReceipt] ADD  CONSTRAINT [expensereceipt_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[ExpenseReceipt] ADD  CONSTRAINT [expensereceipt_attendees_default]  DEFAULT ('1') FOR [Attendees]
GO
ALTER TABLE [BlueBirdRpt].[ManagerRosterMaster] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[ManagerRosterMaster] ADD  DEFAULT ((-1)) FOR [CreatedBy]
GO
ALTER TABLE [BlueBirdRpt].[ManagerRosterMaster] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[ManagerRosterMaster] ADD  DEFAULT ((-1)) FOR [UpdatedBy]
GO
ALTER TABLE [BlueBirdRpt].[ManagerSalesRepMap] ADD  CONSTRAINT [managersalesrepmap_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[ManagerSalesRepMap] ADD  CONSTRAINT [managersalesrepmap_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[ManagerSalesRepMap] ADD  DEFAULT ((1)) FOR [SourceSystem]
GO
ALTER TABLE [BlueBirdRpt].[MileageEntry] ADD  CONSTRAINT [mileageentry_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[MileageEntry] ADD  CONSTRAINT [mileageentry_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[MileageEntry] ADD  CONSTRAINT [mileageentry_mileagetype_default]  DEFAULT ('2') FOR [MileageType]
GO
ALTER TABLE [BlueBirdRpt].[MileageLocationMap] ADD  CONSTRAINT [mileagelocationmap_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[MileageLocationMap] ADD  CONSTRAINT [mileagelocationmap_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[Module] ADD  CONSTRAINT [module_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [BlueBirdRpt].[Module] ADD  CONSTRAINT [module_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[Module] ADD  CONSTRAINT [module_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[ModuleOrganizationMap] ADD  CONSTRAINT [moduleorganizationmap_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [BlueBirdRpt].[ModuleOrganizationMap] ADD  CONSTRAINT [moduleorganizationmap_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[ModuleOrganizationMap] ADD  CONSTRAINT [moduleorganizationmap_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[NotesQuestion] ADD  CONSTRAINT [notesquestion_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [BlueBirdRpt].[NotesQuestion] ADD  CONSTRAINT [notesquestion_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[NotesQuestion] ADD  CONSTRAINT [notesquestion_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[Organization] ADD  CONSTRAINT [organization_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [BlueBirdRpt].[Organization] ADD  CONSTRAINT [organization_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[Organization] ADD  CONSTRAINT [organization_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[Organization] ADD  DEFAULT ((1)) FOR [SourceSystem]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationBranch] ADD  CONSTRAINT [organizationbranch_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationBranch] ADD  CONSTRAINT [organizationbranch_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationBranch] ADD  CONSTRAINT [organizationbranch_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationBranch] ADD  DEFAULT ((1)) FOR [SourceSystem]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_minamountforreceipt_default]  DEFAULT (NULL) FOR [MinAmountForReceipt]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_maxamountlimit_default]  DEFAULT (NULL) FOR [MaxAmountLimit]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_maxeventsperday_default]  DEFAULT ('6') FOR [MaxEventsPerDay]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_autoscheduleweeks_default]  DEFAULT ('4') FOR [AutoscheduleWeeks]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_notificationduration_default]  DEFAULT ('24') FOR [NotificationDuration]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationSetting] ADD  DEFAULT ((30)) FOR [DefaultMeetingTime]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationSetting] ADD  DEFAULT ((30)) FOR [DefaultTravelTime]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationSetting] ADD  DEFAULT ((5)) FOR [DefaultClusterRadius]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationSetting] ADD  DEFAULT ((0.67)) FOR [StandardIRSRate]
GO
ALTER TABLE [BlueBirdRpt].[PreCallNote] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [BlueBirdRpt].[PreCallNote] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[PreCallNote] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[RepAttributes] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[RepAttributes] ADD  DEFAULT ((1)) FOR [CreatedBy]
GO
ALTER TABLE [BlueBirdRpt].[RepAttributes] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[RepAttributes] ADD  DEFAULT ((1)) FOR [UpdatedBy]
GO
ALTER TABLE [BlueBirdRpt].[Report] ADD  CONSTRAINT [report_reportstatus_default]  DEFAULT ('0') FOR [ReportStatus]
GO
ALTER TABLE [BlueBirdRpt].[Report] ADD  CONSTRAINT [report_reporttotalamount_default]  DEFAULT ('0') FOR [ReportTotalAmount]
GO
ALTER TABLE [BlueBirdRpt].[Report] ADD  CONSTRAINT [report_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[Report] ADD  CONSTRAINT [report_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[ReportApproval] ADD  CONSTRAINT [reportapproval_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[ReportApproval] ADD  CONSTRAINT [reportapproval_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[RepToManagerMapping] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[RepToManagerMapping] ADD  DEFAULT ((-1)) FOR [CreatedBy]
GO
ALTER TABLE [BlueBirdRpt].[RepToManagerMapping] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[RepToManagerMapping] ADD  DEFAULT ((-1)) FOR [UpdatedBy]
GO
ALTER TABLE [BlueBirdRpt].[RoleMap] ADD  CONSTRAINT [rolemap_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[RoleMap] ADD  CONSTRAINT [rolemap_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[SalesRep] ADD  CONSTRAINT [salesrep_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [BlueBirdRpt].[SalesRep] ADD  CONSTRAINT [salesrep_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[SalesRep] ADD  CONSTRAINT [salesrep_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[SalesRep] ADD  CONSTRAINT [salesrep_timezone_default]  DEFAULT (NULL) FOR [Timezone]
GO
ALTER TABLE [BlueBirdRpt].[SalesRep] ADD  CONSTRAINT [salesrep_hasautoschedulestarted_default]  DEFAULT ('0') FOR [HasAutoscheduleStarted]
GO
ALTER TABLE [BlueBirdRpt].[SalesRep] ADD  CONSTRAINT [salesrep_devicetype_default]  DEFAULT (NULL) FOR [DeviceType]
GO
ALTER TABLE [BlueBirdRpt].[SalesRep] ADD  CONSTRAINT [salesrep_autoschedulestartdate_default]  DEFAULT (NULL) FOR [AutoScheduleStartDate]
GO
ALTER TABLE [BlueBirdRpt].[SalesRep] ADD  CONSTRAINT [salesrep_sourcesystem_default]  DEFAULT ('1') FOR [SourceSystem]
GO
ALTER TABLE [BlueBirdRpt].[SalesRep] ADD  DEFAULT (NULL) FOR [OID]
GO
ALTER TABLE [BlueBirdRpt].[SalesRepTerritoryBranchMap] ADD  CONSTRAINT [salesrepterritorybranchmap_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[SalesRepTerritoryBranchMap] ADD  CONSTRAINT [salesrepterritorybranchmap_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[SuperAdmin] ADD  CONSTRAINT [superadmin_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [BlueBirdRpt].[SuperAdmin] ADD  CONSTRAINT [superadmin_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[SuperAdmin] ADD  CONSTRAINT [superadmin_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
/*
ALTER TABLE [BlueBirdRpt].[Task] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [BlueBirdRpt].[Task] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[Task] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[Territory] ADD  CONSTRAINT [territory_active_default]  DEFAULT ('1') FOR [Active]
GO
ALTER TABLE [BlueBirdRpt].[Territory] ADD  CONSTRAINT [territory_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[Territory] ADD  CONSTRAINT [territory_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [BlueBirdRpt].[Territory] ADD  DEFAULT ((1)) FOR [SourceSystem]
GO
ALTER TABLE [BlueBirdRpt].[TokenUsage] ADD  CONSTRAINT [tokenusage_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[UserAuditLog] ADD  CONSTRAINT [userauditlog_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [BlueBirdRpt].[Z_AccountAddress_TMP] ADD  DEFAULT ((1)) FOR [SourceSystem]
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [account_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [account_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [account_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [account_ishouseaccount_default]  DEFAULT ('0') FOR [IsHouseAccount]
GO
ALTER TABLE [dbo].[AccountAddress] ADD  CONSTRAINT [accountaddress_isprimaryaddress_default]  DEFAULT ('0') FOR [IsPrimaryAddress]
GO
ALTER TABLE [dbo].[AccountAddress] ADD  CONSTRAINT [accountaddress_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[AccountAddress] ADD  CONSTRAINT [accountaddress_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[AccountContact] ADD  CONSTRAINT [accountcontact_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [dbo].[AccountContact] ADD  CONSTRAINT [accountcontact_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[AccountContact] ADD  CONSTRAINT [accountcontact_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[AccountContactAddress] ADD  CONSTRAINT [accountcontactaddress_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[AccountContactAddress] ADD  CONSTRAINT [accountcontactaddress_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[AccountDetails] ADD  CONSTRAINT [accountdetails_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[AccountDetails] ADD  CONSTRAINT [accountdetails_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[AccountTerritoryMap] ADD  CONSTRAINT [accountterritorymap_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [dbo].[AccountTerritoryMap] ADD  CONSTRAINT [accountterritorymap_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[AccountTerritoryMap] ADD  CONSTRAINT [accountterritorymap_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[AddressType] ADD  CONSTRAINT [addresstype_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[AddressType] ADD  CONSTRAINT [addresstype_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Admissions] ADD  CONSTRAINT [admissions_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Admissions] ADD  CONSTRAINT [admissions_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[AiAuditLog] ADD  CONSTRAINT [aiauditlog_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[CommissionPayout] ADD  CONSTRAINT [commissionpayout_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[CommissionPayout] ADD  CONSTRAINT [commissionpayout_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[CommSalesRep] ADD  CONSTRAINT [commsalesrep_idtoken_default]  DEFAULT (NULL) FOR [IdToken]
GO
ALTER TABLE [dbo].[CommSalesRep] ADD  CONSTRAINT [commsalesrep_refreshtoken_default]  DEFAULT (NULL) FOR [RefreshToken]
GO
ALTER TABLE [dbo].[CommSalesRep] ADD  CONSTRAINT [commsalesrep_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [dbo].[CommSalesRep] ADD  CONSTRAINT [commsalesrep_timezone_default]  DEFAULT (NULL) FOR [Timezone]
GO
ALTER TABLE [dbo].[CommSalesRep] ADD  CONSTRAINT [commsalesrep_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[CommSalesRep] ADD  CONSTRAINT [commsalesrep_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[countries] ADD  CONSTRAINT [countries_created_at_default]  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[countries] ADD  CONSTRAINT [countries_updated_at_default]  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[emails] ADD  CONSTRAINT [emails_email_delay_default]  DEFAULT (getdate()) FOR [email_delay]
GO
ALTER TABLE [dbo].[emails] ADD  CONSTRAINT [emails_created_at_default]  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[emails] ADD  CONSTRAINT [emails_updated_at_default]  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [event_eventcategoryid_default]  DEFAULT ('0') FOR [EventCategoryId]
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [event_traveltime_default]  DEFAULT ('0') FOR [TravelTime]
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [event_repeatschedule_default]  DEFAULT ('0days') FOR [RepeatSchedule]
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [event_isallday_default]  DEFAULT ('0') FOR [IsAllDay]
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [event_eventtype_default]  DEFAULT ('0') FOR [EventType]
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [event_status_default]  DEFAULT ('0') FOR [Status]
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [event_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [event_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [event_eventuriid_default]  DEFAULT (NULL) FOR [EventUriID]
GO
ALTER TABLE [dbo].[EventAttendee] ADD  CONSTRAINT [eventattendee_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[EventAttendee] ADD  CONSTRAINT [eventattendee_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[EventAuditLog] ADD  CONSTRAINT [eventauditlog_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[EventCallLog] ADD  CONSTRAINT [eventcalllog_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[EventCallLog] ADD  CONSTRAINT [eventcalllog_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[EventCategory] ADD  CONSTRAINT [eventcategory_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[EventCategory] ADD  CONSTRAINT [eventcategory_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[EventNotification] ADD  CONSTRAINT [eventnotification_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[EventNotification] ADD  CONSTRAINT [eventnotification_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[ExpenseCategory] ADD  CONSTRAINT [expensecategory_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ExpenseCategory] ADD  CONSTRAINT [expensecategory_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[ExpenseReceipt] ADD  CONSTRAINT [expensereceipt_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ExpenseReceipt] ADD  CONSTRAINT [expensereceipt_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[ExpenseReceipt] ADD  CONSTRAINT [expensereceipt_attendees_default]  DEFAULT ('1') FOR [Attendees]
GO
ALTER TABLE [dbo].[ManagerSalesRepMap] ADD  CONSTRAINT [managersalesrepmap_approvaltype_default]  DEFAULT ('0') FOR [ApprovalType]
GO
ALTER TABLE [dbo].[ManagerSalesRepMap] ADD  CONSTRAINT [managersalesrepmap_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ManagerSalesRepMap] ADD  CONSTRAINT [managersalesrepmap_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[MileageEntry] ADD  CONSTRAINT [mileageentry_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[MileageEntry] ADD  CONSTRAINT [mileageentry_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[MileageEntry] ADD  CONSTRAINT [mileageentry_mileagetype_default]  DEFAULT ('2') FOR [MileageType]
GO
ALTER TABLE [dbo].[MileageLocationMap] ADD  CONSTRAINT [mileagelocationmap_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[MileageLocationMap] ADD  CONSTRAINT [mileagelocationmap_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Module] ADD  CONSTRAINT [module_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [dbo].[Module] ADD  CONSTRAINT [module_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Module] ADD  CONSTRAINT [module_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[ModuleOrganizationMap] ADD  CONSTRAINT [moduleorganizationmap_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [dbo].[ModuleOrganizationMap] ADD  CONSTRAINT [moduleorganizationmap_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ModuleOrganizationMap] ADD  CONSTRAINT [moduleorganizationmap_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[NotesQuestion] ADD  CONSTRAINT [notesquestion_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [dbo].[NotesQuestion] ADD  CONSTRAINT [notesquestion_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[NotesQuestion] ADD  CONSTRAINT [notesquestion_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Organization] ADD  CONSTRAINT [organization_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [dbo].[Organization] ADD  CONSTRAINT [organization_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Organization] ADD  CONSTRAINT [organization_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[OrganizationBranch] ADD  CONSTRAINT [organizationbranch_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [dbo].[OrganizationBranch] ADD  CONSTRAINT [organizationbranch_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[OrganizationBranch] ADD  CONSTRAINT [organizationbranch_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_minamountforreceipt_default]  DEFAULT (NULL) FOR [MinAmountForReceipt]
GO
ALTER TABLE [dbo].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_maxamountlimit_default]  DEFAULT (NULL) FOR [MaxAmountLimit]
GO
ALTER TABLE [dbo].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_maxeventsperday_default]  DEFAULT ('6') FOR [MaxEventsPerDay]
GO
ALTER TABLE [dbo].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_autoscheduleweeks_default]  DEFAULT ('4') FOR [AutoscheduleWeeks]
GO
ALTER TABLE [dbo].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_notificationduration_default]  DEFAULT ('24') FOR [NotificationDuration]
GO
ALTER TABLE [dbo].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_defaultmeetingtime_default]  DEFAULT ('30') FOR [DefaultMeetingTime]
GO
ALTER TABLE [dbo].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_defaulttraveltime_default]  DEFAULT ('30') FOR [DefaultTravelTime]
GO
ALTER TABLE [dbo].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_standardirsrate_default]  DEFAULT ('0.67') FOR [StandardIRSRate]
GO
ALTER TABLE [dbo].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_defaultclusterradius_default]  DEFAULT ('5') FOR [DefaultClusterRadius]
GO
ALTER TABLE [dbo].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[OrganizationSetting] ADD  CONSTRAINT [organizationsetting_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Report] ADD  CONSTRAINT [report_reportstatus_default]  DEFAULT ('0') FOR [ReportStatus]
GO
ALTER TABLE [dbo].[Report] ADD  CONSTRAINT [report_reporttotalamount_default]  DEFAULT ('0') FOR [ReportTotalAmount]
GO
ALTER TABLE [dbo].[Report] ADD  CONSTRAINT [report_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Report] ADD  CONSTRAINT [report_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[ReportApproval] ADD  CONSTRAINT [reportapproval_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[ReportApproval] ADD  CONSTRAINT [reportapproval_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[RoleMap] ADD  CONSTRAINT [rolemap_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[RoleMap] ADD  CONSTRAINT [rolemap_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[SalesRep] ADD  CONSTRAINT [salesrep_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [dbo].[SalesRep] ADD  CONSTRAINT [salesrep_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[SalesRep] ADD  CONSTRAINT [salesrep_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[SalesRep] ADD  CONSTRAINT [salesrep_refreshtoken_default]  DEFAULT (NULL) FOR [RefreshToken]
GO
ALTER TABLE [dbo].[SalesRep] ADD  CONSTRAINT [salesrep_timezone_default]  DEFAULT (NULL) FOR [Timezone]
GO
ALTER TABLE [dbo].[SalesRep] ADD  CONSTRAINT [salesrep_hasautoschedulestarted_default]  DEFAULT ('0') FOR [HasAutoscheduleStarted]
GO
ALTER TABLE [dbo].[SalesRep] ADD  CONSTRAINT [salesrep_devicetype_default]  DEFAULT (NULL) FOR [DeviceType]
GO
ALTER TABLE [dbo].[SalesRep] ADD  CONSTRAINT [salesrep_autoschedulestartdate_default]  DEFAULT (NULL) FOR [AutoScheduleStartDate]
GO
ALTER TABLE [dbo].[SalesRepTerritoryBranchMap] ADD  CONSTRAINT [salesrepterritorybranchmap_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[SalesRepTerritoryBranchMap] ADD  CONSTRAINT [salesrepterritorybranchmap_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[states] ADD  CONSTRAINT [states_created_at_default]  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[states] ADD  CONSTRAINT [states_updated_at_default]  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[SuperAdmin] ADD  CONSTRAINT [superadmin_status_default]  DEFAULT ('1') FOR [Status]
GO
ALTER TABLE [dbo].[SuperAdmin] ADD  CONSTRAINT [superadmin_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[SuperAdmin] ADD  CONSTRAINT [superadmin_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Territory] ADD  CONSTRAINT [territory_active_default]  DEFAULT ('1') FOR [Active]
GO
ALTER TABLE [dbo].[Territory] ADD  CONSTRAINT [territory_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Territory] ADD  CONSTRAINT [territory_updatedat_default]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[TokenUsage] ADD  CONSTRAINT [tokenusage_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[UserAuditLog] ADD  CONSTRAINT [userauditlog_createdat_default]  DEFAULT (getdate()) FOR [CreatedAt]
GO
*/
ALTER TABLE [BlueBirdRpt].[Account]  WITH NOCHECK ADD  CONSTRAINT [account_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[Account] NOCHECK CONSTRAINT [account_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[Account]  WITH NOCHECK ADD  CONSTRAINT [account_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[Account] NOCHECK CONSTRAINT [account_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[AccountAddress]  WITH CHECK ADD  CONSTRAINT [accountaddress_addresstype_foreign] FOREIGN KEY([AddressType])
REFERENCES [BlueBirdRpt].[AddressType] ([AddressTypeId])
GO
ALTER TABLE [BlueBirdRpt].[AccountAddress] CHECK CONSTRAINT [accountaddress_addresstype_foreign]
GO
ALTER TABLE [BlueBirdRpt].[AccountAddress]  WITH CHECK ADD  CONSTRAINT [accountaddress_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[AccountAddress] CHECK CONSTRAINT [accountaddress_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[AccountAddress]  WITH CHECK ADD  CONSTRAINT [accountaddress_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[AccountAddress] CHECK CONSTRAINT [accountaddress_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[AccountContact]  WITH NOCHECK ADD  CONSTRAINT [accountcontact_accountcontactaddressid_foreign] FOREIGN KEY([AccountContactAddressId])
REFERENCES [BlueBirdRpt].[AccountContactAddress] ([AccountContactAddressId])
ON DELETE CASCADE
GO
ALTER TABLE [BlueBirdRpt].[AccountContact] NOCHECK CONSTRAINT [accountcontact_accountcontactaddressid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[AccountContact]  WITH CHECK ADD  CONSTRAINT [accountcontact_accountid_foreign] FOREIGN KEY([AccountId])
REFERENCES [BlueBirdRpt].[Account] ([AccountId])
ON DELETE CASCADE
GO
ALTER TABLE [BlueBirdRpt].[AccountContact] CHECK CONSTRAINT [accountcontact_accountid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[AccountContact]  WITH CHECK ADD  CONSTRAINT [accountcontact_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[AccountContact] CHECK CONSTRAINT [accountcontact_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[AccountContact]  WITH CHECK ADD  CONSTRAINT [accountcontact_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[AccountContact] CHECK CONSTRAINT [accountcontact_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[AccountContactAddress]  WITH CHECK ADD  CONSTRAINT [accountcontactaddress_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[AccountContactAddress] CHECK CONSTRAINT [accountcontactaddress_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[AccountContactAddress]  WITH CHECK ADD  CONSTRAINT [accountcontactaddress_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[AccountContactAddress] CHECK CONSTRAINT [accountcontactaddress_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[AccountContactImpDate]  WITH CHECK ADD  CONSTRAINT [FK_AccountContactSpecialDates_AccountContact] FOREIGN KEY([AccountContactId])
REFERENCES [BlueBirdRpt].[AccountContact] ([AccountContactId])
ON DELETE CASCADE
GO
ALTER TABLE [BlueBirdRpt].[AccountContactImpDate] CHECK CONSTRAINT [FK_AccountContactSpecialDates_AccountContact]
GO
ALTER TABLE [BlueBirdRpt].[AccountContactImpDate]  WITH CHECK ADD  CONSTRAINT [FK_AccountContactSpecialDates_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[AccountContactImpDate] CHECK CONSTRAINT [FK_AccountContactSpecialDates_CreatedBy]
GO
ALTER TABLE [BlueBirdRpt].[AccountContactImpDate]  WITH CHECK ADD  CONSTRAINT [FK_AccountContactSpecialDates_UpdatedBy] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[AccountContactImpDate] CHECK CONSTRAINT [FK_AccountContactSpecialDates_UpdatedBy]
GO
ALTER TABLE [BlueBirdRpt].[AccountTerritoryMap]  WITH CHECK ADD  CONSTRAINT [accountterritorymap_accountid_foreign] FOREIGN KEY([AccountId])
REFERENCES [BlueBirdRpt].[Account] ([AccountId])
GO
ALTER TABLE [BlueBirdRpt].[AccountTerritoryMap] CHECK CONSTRAINT [accountterritorymap_accountid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[AccountTerritoryMap]  WITH CHECK ADD  CONSTRAINT [accountterritorymap_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[AccountTerritoryMap] CHECK CONSTRAINT [accountterritorymap_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[AccountTerritoryMap]  WITH CHECK ADD  CONSTRAINT [accountterritorymap_territoryid_foreign] FOREIGN KEY([TerritoryId])
REFERENCES [BlueBirdRpt].[Territory] ([TerritoryId])
GO
ALTER TABLE [BlueBirdRpt].[AccountTerritoryMap] CHECK CONSTRAINT [accountterritorymap_territoryid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[AccountTerritoryMap]  WITH CHECK ADD  CONSTRAINT [accountterritorymap_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[AccountTerritoryMap] CHECK CONSTRAINT [accountterritorymap_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[AddressType]  WITH CHECK ADD  CONSTRAINT [addresstype_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[AddressType] CHECK CONSTRAINT [addresstype_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[AddressType]  WITH CHECK ADD  CONSTRAINT [addresstype_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[AddressType] CHECK CONSTRAINT [addresstype_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[AiAuditLog]  WITH CHECK ADD  CONSTRAINT [aiauditlog_salesrepid_foreign] FOREIGN KEY([SalesRepId])
REFERENCES [BlueBirdRpt].[SalesRep] ([SalesRepId])
GO
ALTER TABLE [BlueBirdRpt].[AiAuditLog] CHECK CONSTRAINT [aiauditlog_salesrepid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[Event]  WITH CHECK ADD  CONSTRAINT [event_accountid_foreign] FOREIGN KEY([AccountId])
REFERENCES [BlueBirdRpt].[Account] ([AccountId])
GO
ALTER TABLE [BlueBirdRpt].[Event] CHECK CONSTRAINT [event_accountid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[Event]  WITH CHECK ADD  CONSTRAINT [event_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[Event] CHECK CONSTRAINT [event_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[Event]  WITH CHECK ADD  CONSTRAINT [event_eventcategoryid_foreign] FOREIGN KEY([EventCategoryId])
REFERENCES [BlueBirdRpt].[EventCategory] ([EventCategoryId])
GO
ALTER TABLE [BlueBirdRpt].[Event] CHECK CONSTRAINT [event_eventcategoryid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[Event]  WITH CHECK ADD  CONSTRAINT [event_salesrepid_foreign] FOREIGN KEY([SalesRepId])
REFERENCES [BlueBirdRpt].[SalesRep] ([SalesRepId])
GO
ALTER TABLE [BlueBirdRpt].[Event] CHECK CONSTRAINT [event_salesrepid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[Event]  WITH CHECK ADD  CONSTRAINT [event_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[Event] CHECK CONSTRAINT [event_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_PreCallNote] FOREIGN KEY([PreCallNoteId])
REFERENCES [BlueBirdRpt].[PreCallNote] ([PreCallNoteId])
GO
ALTER TABLE [BlueBirdRpt].[Event] CHECK CONSTRAINT [FK_Event_PreCallNote]
GO
ALTER TABLE [BlueBirdRpt].[EventAttendee]  WITH CHECK ADD  CONSTRAINT [eventattendee_accountcontactid_foreign] FOREIGN KEY([AccountContactId])
REFERENCES [BlueBirdRpt].[AccountContact] ([AccountContactId])
GO
ALTER TABLE [BlueBirdRpt].[EventAttendee] CHECK CONSTRAINT [eventattendee_accountcontactid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[EventAttendee]  WITH CHECK ADD  CONSTRAINT [eventattendee_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[EventAttendee] CHECK CONSTRAINT [eventattendee_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[EventAttendee]  WITH CHECK ADD  CONSTRAINT [eventattendee_eventcalllogid_foreign] FOREIGN KEY([EventCallLogId])
REFERENCES [BlueBirdRpt].[EventCallLog] ([EventCallLogId])
ON DELETE CASCADE
GO
ALTER TABLE [BlueBirdRpt].[EventAttendee] CHECK CONSTRAINT [eventattendee_eventcalllogid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[EventAttendee]  WITH CHECK ADD  CONSTRAINT [eventattendee_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[EventAttendee] CHECK CONSTRAINT [eventattendee_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[EventAuditLog]  WITH CHECK ADD  CONSTRAINT [eventauditlog_userid_foreign] FOREIGN KEY([UserId])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[EventAuditLog] CHECK CONSTRAINT [eventauditlog_userid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[EventCallLog]  WITH CHECK ADD  CONSTRAINT [eventcalllog_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[EventCallLog] CHECK CONSTRAINT [eventcalllog_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[EventCallLog]  WITH CHECK ADD  CONSTRAINT [eventcalllog_eventid_foreign] FOREIGN KEY([EventId])
REFERENCES [BlueBirdRpt].[Event] ([EventId])
ON DELETE CASCADE
GO
ALTER TABLE [BlueBirdRpt].[EventCallLog] CHECK CONSTRAINT [eventcalllog_eventid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[EventCallLog]  WITH CHECK ADD  CONSTRAINT [eventcalllog_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[EventCallLog] CHECK CONSTRAINT [eventcalllog_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[EventCategory]  WITH CHECK ADD  CONSTRAINT [eventcategory_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[EventCategory] CHECK CONSTRAINT [eventcategory_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[EventCategory]  WITH CHECK ADD  CONSTRAINT [eventcategory_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[EventCategory] CHECK CONSTRAINT [eventcategory_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[EventNotification]  WITH CHECK ADD  CONSTRAINT [eventnotification_eventid_foreign] FOREIGN KEY([EventId])
REFERENCES [BlueBirdRpt].[Event] ([EventId])
ON DELETE CASCADE
GO
ALTER TABLE [BlueBirdRpt].[EventNotification] CHECK CONSTRAINT [eventnotification_eventid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ExpenseCategory]  WITH CHECK ADD  CONSTRAINT [expensecategory_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[ExpenseCategory] CHECK CONSTRAINT [expensecategory_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ExpenseCategory]  WITH CHECK ADD  CONSTRAINT [expensecategory_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[ExpenseCategory] CHECK CONSTRAINT [expensecategory_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ExpenseReceipt]  WITH CHECK ADD  CONSTRAINT [expensereceipt_accountid_foreign] FOREIGN KEY([AccountId])
REFERENCES [BlueBirdRpt].[Account] ([AccountId])
GO
ALTER TABLE [BlueBirdRpt].[ExpenseReceipt] CHECK CONSTRAINT [expensereceipt_accountid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ExpenseReceipt]  WITH CHECK ADD  CONSTRAINT [expensereceipt_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[ExpenseReceipt] CHECK CONSTRAINT [expensereceipt_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ExpenseReceipt]  WITH CHECK ADD  CONSTRAINT [expensereceipt_expensecategoryid_foreign] FOREIGN KEY([ExpenseCategoryId])
REFERENCES [BlueBirdRpt].[ExpenseCategory] ([ExpenseCategoryId])
GO
ALTER TABLE [BlueBirdRpt].[ExpenseReceipt] CHECK CONSTRAINT [expensereceipt_expensecategoryid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ExpenseReceipt]  WITH CHECK ADD  CONSTRAINT [expensereceipt_reportid_foreign] FOREIGN KEY([ReportId])
REFERENCES [BlueBirdRpt].[Report] ([ReportId])
ON DELETE CASCADE
GO
ALTER TABLE [BlueBirdRpt].[ExpenseReceipt] CHECK CONSTRAINT [expensereceipt_reportid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ExpenseReceipt]  WITH CHECK ADD  CONSTRAINT [expensereceipt_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[ExpenseReceipt] CHECK CONSTRAINT [expensereceipt_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ManagerSalesRepMap]  WITH CHECK ADD  CONSTRAINT [managersalesrepmap_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[ManagerSalesRepMap] CHECK CONSTRAINT [managersalesrepmap_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ManagerSalesRepMap]  WITH CHECK ADD  CONSTRAINT [managersalesrepmap_salesrepid_foreign] FOREIGN KEY([SalesRepId])
REFERENCES [BlueBirdRpt].[SalesRep] ([SalesRepId])
GO
ALTER TABLE [BlueBirdRpt].[ManagerSalesRepMap] CHECK CONSTRAINT [managersalesrepmap_salesrepid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ManagerSalesRepMap]  WITH CHECK ADD  CONSTRAINT [managersalesrepmap_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[ManagerSalesRepMap] CHECK CONSTRAINT [managersalesrepmap_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[MileageEntry]  WITH CHECK ADD  CONSTRAINT [mileageentry_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[MileageEntry] CHECK CONSTRAINT [mileageentry_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[MileageEntry]  WITH CHECK ADD  CONSTRAINT [mileageentry_mileagereportid_foreign] FOREIGN KEY([MileageReportId])
REFERENCES [BlueBirdRpt].[Report] ([ReportId])
ON DELETE CASCADE
GO
ALTER TABLE [BlueBirdRpt].[MileageEntry] CHECK CONSTRAINT [mileageentry_mileagereportid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[MileageEntry]  WITH CHECK ADD  CONSTRAINT [mileageentry_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[MileageEntry] CHECK CONSTRAINT [mileageentry_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[MileageLocationMap]  WITH CHECK ADD  CONSTRAINT [mileagelocationmap_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[MileageLocationMap] CHECK CONSTRAINT [mileagelocationmap_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[MileageLocationMap]  WITH CHECK ADD  CONSTRAINT [mileagelocationmap_mileageentryid_foreign] FOREIGN KEY([MileageEntryId])
REFERENCES [BlueBirdRpt].[MileageEntry] ([MileageEntryId])
ON DELETE CASCADE
GO
ALTER TABLE [BlueBirdRpt].[MileageLocationMap] CHECK CONSTRAINT [mileagelocationmap_mileageentryid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[MileageLocationMap]  WITH CHECK ADD  CONSTRAINT [mileagelocationmap_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[MileageLocationMap] CHECK CONSTRAINT [mileagelocationmap_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[Module]  WITH CHECK ADD  CONSTRAINT [module_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[Module] CHECK CONSTRAINT [module_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[Module]  WITH CHECK ADD  CONSTRAINT [module_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[Module] CHECK CONSTRAINT [module_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ModuleOrganizationMap]  WITH CHECK ADD  CONSTRAINT [moduleorganizationmap_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[ModuleOrganizationMap] CHECK CONSTRAINT [moduleorganizationmap_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ModuleOrganizationMap]  WITH CHECK ADD  CONSTRAINT [moduleorganizationmap_moduleid_foreign] FOREIGN KEY([ModuleId])
REFERENCES [BlueBirdRpt].[Module] ([ModuleId])
GO
ALTER TABLE [BlueBirdRpt].[ModuleOrganizationMap] CHECK CONSTRAINT [moduleorganizationmap_moduleid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ModuleOrganizationMap]  WITH CHECK ADD  CONSTRAINT [moduleorganizationmap_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[ModuleOrganizationMap] CHECK CONSTRAINT [moduleorganizationmap_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[NotesQuestion]  WITH CHECK ADD  CONSTRAINT [notesquestion_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[NotesQuestion] CHECK CONSTRAINT [notesquestion_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[NotesQuestion]  WITH CHECK ADD  CONSTRAINT [notesquestion_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[NotesQuestion] CHECK CONSTRAINT [notesquestion_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[Organization]  WITH CHECK ADD  CONSTRAINT [organization_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[Organization] CHECK CONSTRAINT [organization_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[Organization]  WITH CHECK ADD  CONSTRAINT [organization_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[Organization] CHECK CONSTRAINT [organization_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationBranch]  WITH CHECK ADD  CONSTRAINT [organizationbranch_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[OrganizationBranch] CHECK CONSTRAINT [organizationbranch_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationBranch]  WITH CHECK ADD  CONSTRAINT [organizationbranch_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[OrganizationBranch] CHECK CONSTRAINT [organizationbranch_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationSetting]  WITH CHECK ADD  CONSTRAINT [organizationsetting_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[OrganizationSetting] CHECK CONSTRAINT [organizationsetting_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[OrganizationSetting]  WITH CHECK ADD  CONSTRAINT [organizationsetting_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[OrganizationSetting] CHECK CONSTRAINT [organizationsetting_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[PreCallNote]  WITH CHECK ADD  CONSTRAINT [FK_PreCallNote_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[PreCallNote] CHECK CONSTRAINT [FK_PreCallNote_CreatedBy]
GO
ALTER TABLE [BlueBirdRpt].[PreCallNote]  WITH CHECK ADD  CONSTRAINT [FK_PreCallNote_SalesRep] FOREIGN KEY([SalesRepId])
REFERENCES [BlueBirdRpt].[SalesRep] ([SalesRepId])
GO
ALTER TABLE [BlueBirdRpt].[PreCallNote] CHECK CONSTRAINT [FK_PreCallNote_SalesRep]
GO
ALTER TABLE [BlueBirdRpt].[PreCallNote]  WITH CHECK ADD  CONSTRAINT [FK_PreCallNote_UpdatedBy] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[PreCallNote] CHECK CONSTRAINT [FK_PreCallNote_UpdatedBy]
GO
ALTER TABLE [BlueBirdRpt].[Report]  WITH CHECK ADD  CONSTRAINT [report_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[Report] CHECK CONSTRAINT [report_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[Report]  WITH CHECK ADD  CONSTRAINT [report_eventcalllogid_foreign] FOREIGN KEY([EventCallLogId])
REFERENCES [BlueBirdRpt].[EventCallLog] ([EventCallLogId])
GO
ALTER TABLE [BlueBirdRpt].[Report] CHECK CONSTRAINT [report_eventcalllogid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[Report]  WITH CHECK ADD  CONSTRAINT [report_salesrepid_foreign] FOREIGN KEY([SalesRepId])
REFERENCES [BlueBirdRpt].[SalesRep] ([SalesRepId])
GO
ALTER TABLE [BlueBirdRpt].[Report] CHECK CONSTRAINT [report_salesrepid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[Report]  WITH CHECK ADD  CONSTRAINT [report_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[Report] CHECK CONSTRAINT [report_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ReportApproval]  WITH CHECK ADD  CONSTRAINT [reportapproval_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[ReportApproval] CHECK CONSTRAINT [reportapproval_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ReportApproval]  WITH CHECK ADD  CONSTRAINT [reportapproval_managerid_foreign] FOREIGN KEY([ManagerId])
REFERENCES [BlueBirdRpt].[SalesRep] ([SalesRepId])
GO
ALTER TABLE [BlueBirdRpt].[ReportApproval] CHECK CONSTRAINT [reportapproval_managerid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ReportApproval]  WITH CHECK ADD  CONSTRAINT [reportapproval_reportid_foreign] FOREIGN KEY([ReportId])
REFERENCES [BlueBirdRpt].[Report] ([ReportId])
GO
ALTER TABLE [BlueBirdRpt].[ReportApproval] CHECK CONSTRAINT [reportapproval_reportid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[ReportApproval]  WITH CHECK ADD  CONSTRAINT [reportapproval_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[ReportApproval] CHECK CONSTRAINT [reportapproval_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[SalesRep]  WITH CHECK ADD  CONSTRAINT [salesrep_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[SalesRep] CHECK CONSTRAINT [salesrep_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[SalesRep]  WITH CHECK ADD  CONSTRAINT [salesrep_organizationbranchid_foreign] FOREIGN KEY([OrganizationBranchId])
REFERENCES [BlueBirdRpt].[OrganizationBranch] ([OrganizationBranchId])
GO
ALTER TABLE [BlueBirdRpt].[SalesRep] CHECK CONSTRAINT [salesrep_organizationbranchid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[SalesRep]  WITH CHECK ADD  CONSTRAINT [salesrep_organizationid_foreign] FOREIGN KEY([OrganizationId])
REFERENCES [BlueBirdRpt].[Organization] ([OrganizationId])
GO
ALTER TABLE [BlueBirdRpt].[SalesRep] CHECK CONSTRAINT [salesrep_organizationid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[SalesRep]  WITH CHECK ADD  CONSTRAINT [salesrep_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[SalesRep] CHECK CONSTRAINT [salesrep_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[SalesRepTerritoryBranchMap]  WITH CHECK ADD  CONSTRAINT [salesrepterritorybranchmap_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[SalesRepTerritoryBranchMap] CHECK CONSTRAINT [salesrepterritorybranchmap_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[SalesRepTerritoryBranchMap]  WITH CHECK ADD  CONSTRAINT [salesrepterritorybranchmap_organizationbranchid_foreign] FOREIGN KEY([OrganizationBranchId])
REFERENCES [BlueBirdRpt].[OrganizationBranch] ([OrganizationBranchId])
GO
ALTER TABLE [BlueBirdRpt].[SalesRepTerritoryBranchMap] CHECK CONSTRAINT [salesrepterritorybranchmap_organizationbranchid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[SalesRepTerritoryBranchMap]  WITH CHECK ADD  CONSTRAINT [salesrepterritorybranchmap_territoryid_foreign] FOREIGN KEY([TerritoryId])
REFERENCES [BlueBirdRpt].[Territory] ([TerritoryId])
GO
ALTER TABLE [BlueBirdRpt].[SalesRepTerritoryBranchMap] CHECK CONSTRAINT [salesrepterritorybranchmap_territoryid_foreign]
GO
ALTER TABLE [BlueBirdRpt].[SalesRepTerritoryBranchMap]  WITH CHECK ADD  CONSTRAINT [salesrepterritorybranchmap_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[SalesRepTerritoryBranchMap] CHECK CONSTRAINT [salesrepterritorybranchmap_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[SuperAdmin]  WITH CHECK ADD  CONSTRAINT [superadmin_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[SuperAdmin] CHECK CONSTRAINT [superadmin_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[SuperAdmin]  WITH CHECK ADD  CONSTRAINT [superadmin_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[SuperAdmin] CHECK CONSTRAINT [superadmin_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[Task]  WITH CHECK ADD FOREIGN KEY([AssignedBy])
REFERENCES [BlueBirdRpt].[SalesRep] ([SalesRepId])
GO
ALTER TABLE [BlueBirdRpt].[Task]  WITH CHECK ADD FOREIGN KEY([AssignedTo])
REFERENCES [BlueBirdRpt].[SalesRep] ([SalesRepId])
GO
ALTER TABLE [BlueBirdRpt].[Task]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[Task]  WITH CHECK ADD FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[Territory]  WITH CHECK ADD  CONSTRAINT [territory_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[Territory] CHECK CONSTRAINT [territory_createdby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[Territory]  WITH CHECK ADD  CONSTRAINT [territory_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [BlueBirdRpt].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [BlueBirdRpt].[Territory] CHECK CONSTRAINT [territory_updatedby_foreign]
GO
ALTER TABLE [BlueBirdRpt].[TokenUsage]  WITH CHECK ADD  CONSTRAINT [tokenusage_salesrepid_foreign] FOREIGN KEY([SalesRepId])
REFERENCES [BlueBirdRpt].[SalesRep] ([SalesRepId])
GO
ALTER TABLE [BlueBirdRpt].[TokenUsage] CHECK CONSTRAINT [tokenusage_salesrepid_foreign]
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [account_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [account_createdby_foreign]
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [account_organizationid_foreign] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [account_organizationid_foreign]
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [account_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [account_updatedby_foreign]
GO
ALTER TABLE [dbo].[AccountAddress]  WITH CHECK ADD  CONSTRAINT [accountaddress_accountid_foreign] FOREIGN KEY([AccountId])
REFERENCES [dbo].[Account] ([AccountId])
GO
ALTER TABLE [dbo].[AccountAddress] CHECK CONSTRAINT [accountaddress_accountid_foreign]
GO
ALTER TABLE [dbo].[AccountAddress]  WITH CHECK ADD  CONSTRAINT [accountaddress_addresstypeid_foreign] FOREIGN KEY([AddressTypeId])
REFERENCES [dbo].[AddressType] ([AddressTypeId])
GO
ALTER TABLE [dbo].[AccountAddress] CHECK CONSTRAINT [accountaddress_addresstypeid_foreign]
GO
ALTER TABLE [dbo].[AccountAddress]  WITH CHECK ADD  CONSTRAINT [accountaddress_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[AccountAddress] CHECK CONSTRAINT [accountaddress_createdby_foreign]
GO
ALTER TABLE [dbo].[AccountAddress]  WITH CHECK ADD  CONSTRAINT [accountaddress_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[AccountAddress] CHECK CONSTRAINT [accountaddress_updatedby_foreign]
GO
ALTER TABLE [dbo].[AccountContact]  WITH CHECK ADD  CONSTRAINT [accountcontact_accountcontactaddressid_foreign] FOREIGN KEY([AccountContactAddressId])
REFERENCES [dbo].[AccountContactAddress] ([AccountContactAddressId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AccountContact] CHECK CONSTRAINT [accountcontact_accountcontactaddressid_foreign]
GO
ALTER TABLE [dbo].[AccountContact]  WITH CHECK ADD  CONSTRAINT [accountcontact_accountid_foreign] FOREIGN KEY([AccountId])
REFERENCES [dbo].[Account] ([AccountId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AccountContact] CHECK CONSTRAINT [accountcontact_accountid_foreign]
GO
ALTER TABLE [dbo].[AccountContact]  WITH CHECK ADD  CONSTRAINT [accountcontact_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[AccountContact] CHECK CONSTRAINT [accountcontact_createdby_foreign]
GO
ALTER TABLE [dbo].[AccountContact]  WITH CHECK ADD  CONSTRAINT [accountcontact_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[AccountContact] CHECK CONSTRAINT [accountcontact_updatedby_foreign]
GO
ALTER TABLE [dbo].[AccountContactAddress]  WITH CHECK ADD  CONSTRAINT [accountcontactaddress_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[AccountContactAddress] CHECK CONSTRAINT [accountcontactaddress_createdby_foreign]
GO
ALTER TABLE [dbo].[AccountContactAddress]  WITH CHECK ADD  CONSTRAINT [accountcontactaddress_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[AccountContactAddress] CHECK CONSTRAINT [accountcontactaddress_updatedby_foreign]
GO
ALTER TABLE [dbo].[AccountDetails]  WITH CHECK ADD  CONSTRAINT [accountdetails_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[AccountDetails] CHECK CONSTRAINT [accountdetails_createdby_foreign]
GO
ALTER TABLE [dbo].[AccountDetails]  WITH CHECK ADD  CONSTRAINT [accountdetails_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[AccountDetails] CHECK CONSTRAINT [accountdetails_updatedby_foreign]
GO
ALTER TABLE [dbo].[AccountTerritoryMap]  WITH CHECK ADD  CONSTRAINT [accountterritorymap_accountid_foreign] FOREIGN KEY([AccountId])
REFERENCES [dbo].[Account] ([AccountId])
GO
ALTER TABLE [dbo].[AccountTerritoryMap] CHECK CONSTRAINT [accountterritorymap_accountid_foreign]
GO
ALTER TABLE [dbo].[AccountTerritoryMap]  WITH CHECK ADD  CONSTRAINT [accountterritorymap_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[AccountTerritoryMap] CHECK CONSTRAINT [accountterritorymap_createdby_foreign]
GO
ALTER TABLE [dbo].[AccountTerritoryMap]  WITH CHECK ADD  CONSTRAINT [accountterritorymap_territoryid_foreign] FOREIGN KEY([TerritoryId])
REFERENCES [dbo].[Territory] ([TerritoryId])
GO
ALTER TABLE [dbo].[AccountTerritoryMap] CHECK CONSTRAINT [accountterritorymap_territoryid_foreign]
GO
ALTER TABLE [dbo].[AccountTerritoryMap]  WITH CHECK ADD  CONSTRAINT [accountterritorymap_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[AccountTerritoryMap] CHECK CONSTRAINT [accountterritorymap_updatedby_foreign]
GO
ALTER TABLE [dbo].[AddressType]  WITH CHECK ADD  CONSTRAINT [addresstype_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[AddressType] CHECK CONSTRAINT [addresstype_createdby_foreign]
GO
ALTER TABLE [dbo].[AddressType]  WITH CHECK ADD  CONSTRAINT [addresstype_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[AddressType] CHECK CONSTRAINT [addresstype_updatedby_foreign]
GO
ALTER TABLE [dbo].[Admissions]  WITH CHECK ADD  CONSTRAINT [admissions_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[Admissions] CHECK CONSTRAINT [admissions_createdby_foreign]
GO
ALTER TABLE [dbo].[Admissions]  WITH CHECK ADD  CONSTRAINT [admissions_salesrepid_foreign] FOREIGN KEY([SalesRepId])
REFERENCES [dbo].[CommSalesRep] ([SalesRepId])
GO
ALTER TABLE [dbo].[Admissions] CHECK CONSTRAINT [admissions_salesrepid_foreign]
GO
ALTER TABLE [dbo].[Admissions]  WITH CHECK ADD  CONSTRAINT [admissions_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[Admissions] CHECK CONSTRAINT [admissions_updatedby_foreign]
GO
ALTER TABLE [dbo].[AiAuditLog]  WITH CHECK ADD  CONSTRAINT [aiauditlog_salesrepid_foreign] FOREIGN KEY([SalesRepId])
REFERENCES [dbo].[SalesRep] ([SalesRepId])
GO
ALTER TABLE [dbo].[AiAuditLog] CHECK CONSTRAINT [aiauditlog_salesrepid_foreign]
GO
ALTER TABLE [dbo].[CommissionPayout]  WITH CHECK ADD  CONSTRAINT [commissionpayout_branchid_foreign] FOREIGN KEY([BranchId])
REFERENCES [dbo].[OrganizationBranch] ([OrganizationBranchId])
GO
ALTER TABLE [dbo].[CommissionPayout] CHECK CONSTRAINT [commissionpayout_branchid_foreign]
GO
ALTER TABLE [dbo].[CommissionPayout]  WITH CHECK ADD  CONSTRAINT [commissionpayout_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[CommissionPayout] CHECK CONSTRAINT [commissionpayout_createdby_foreign]
GO
ALTER TABLE [dbo].[CommissionPayout]  WITH CHECK ADD  CONSTRAINT [commissionpayout_salesrepid_foreign] FOREIGN KEY([SalesRepId])
REFERENCES [dbo].[CommSalesRep] ([SalesRepId])
GO
ALTER TABLE [dbo].[CommissionPayout] CHECK CONSTRAINT [commissionpayout_salesrepid_foreign]
GO
ALTER TABLE [dbo].[CommissionPayout]  WITH CHECK ADD  CONSTRAINT [commissionpayout_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[CommissionPayout] CHECK CONSTRAINT [commissionpayout_updatedby_foreign]
GO
ALTER TABLE [dbo].[CommSalesRep]  WITH CHECK ADD  CONSTRAINT [commsalesrep_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[CommSalesRep] CHECK CONSTRAINT [commsalesrep_createdby_foreign]
GO
ALTER TABLE [dbo].[CommSalesRep]  WITH CHECK ADD  CONSTRAINT [commsalesrep_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[CommSalesRep] CHECK CONSTRAINT [commsalesrep_updatedby_foreign]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [event_accountid_foreign] FOREIGN KEY([AccountId])
REFERENCES [dbo].[Account] ([AccountId])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [event_accountid_foreign]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [event_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [event_createdby_foreign]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [event_eventcategoryid_foreign] FOREIGN KEY([EventCategoryId])
REFERENCES [dbo].[EventCategory] ([EventCategoryId])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [event_eventcategoryid_foreign]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [event_salesrepid_foreign] FOREIGN KEY([SalesRepId])
REFERENCES [dbo].[SalesRep] ([SalesRepId])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [event_salesrepid_foreign]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [event_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [event_updatedby_foreign]
GO
ALTER TABLE [dbo].[EventAttendee]  WITH CHECK ADD  CONSTRAINT [eventattendee_accountcontactid_foreign] FOREIGN KEY([AccountContactId])
REFERENCES [dbo].[AccountContact] ([AccountContactId])
GO
ALTER TABLE [dbo].[EventAttendee] CHECK CONSTRAINT [eventattendee_accountcontactid_foreign]
GO
ALTER TABLE [dbo].[EventAttendee]  WITH CHECK ADD  CONSTRAINT [eventattendee_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[EventAttendee] CHECK CONSTRAINT [eventattendee_createdby_foreign]
GO
ALTER TABLE [dbo].[EventAttendee]  WITH CHECK ADD  CONSTRAINT [eventattendee_eventcalllogid_foreign] FOREIGN KEY([EventCallLogId])
REFERENCES [dbo].[EventCallLog] ([EventCallLogId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EventAttendee] CHECK CONSTRAINT [eventattendee_eventcalllogid_foreign]
GO
ALTER TABLE [dbo].[EventAttendee]  WITH CHECK ADD  CONSTRAINT [eventattendee_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[EventAttendee] CHECK CONSTRAINT [eventattendee_updatedby_foreign]
GO
ALTER TABLE [dbo].[EventAuditLog]  WITH CHECK ADD  CONSTRAINT [eventauditlog_userid_foreign] FOREIGN KEY([UserId])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[EventAuditLog] CHECK CONSTRAINT [eventauditlog_userid_foreign]
GO
ALTER TABLE [dbo].[EventCallLog]  WITH CHECK ADD  CONSTRAINT [eventcalllog_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[EventCallLog] CHECK CONSTRAINT [eventcalllog_createdby_foreign]
GO
ALTER TABLE [dbo].[EventCallLog]  WITH CHECK ADD  CONSTRAINT [eventcalllog_eventid_foreign] FOREIGN KEY([EventId])
REFERENCES [dbo].[Event] ([EventId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EventCallLog] CHECK CONSTRAINT [eventcalllog_eventid_foreign]
GO
ALTER TABLE [dbo].[EventCallLog]  WITH CHECK ADD  CONSTRAINT [eventcalllog_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[EventCallLog] CHECK CONSTRAINT [eventcalllog_updatedby_foreign]
GO
ALTER TABLE [dbo].[EventCategory]  WITH CHECK ADD  CONSTRAINT [eventcategory_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[EventCategory] CHECK CONSTRAINT [eventcategory_createdby_foreign]
GO
ALTER TABLE [dbo].[EventCategory]  WITH CHECK ADD  CONSTRAINT [eventcategory_organizationid_foreign] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO
ALTER TABLE [dbo].[EventCategory] CHECK CONSTRAINT [eventcategory_organizationid_foreign]
GO
ALTER TABLE [dbo].[EventCategory]  WITH CHECK ADD  CONSTRAINT [eventcategory_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[EventCategory] CHECK CONSTRAINT [eventcategory_updatedby_foreign]
GO
ALTER TABLE [dbo].[EventNotification]  WITH CHECK ADD  CONSTRAINT [eventnotification_eventid_foreign] FOREIGN KEY([EventId])
REFERENCES [dbo].[Event] ([EventId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EventNotification] CHECK CONSTRAINT [eventnotification_eventid_foreign]
GO
ALTER TABLE [dbo].[ExpenseCategory]  WITH CHECK ADD  CONSTRAINT [expensecategory_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[ExpenseCategory] CHECK CONSTRAINT [expensecategory_createdby_foreign]
GO
ALTER TABLE [dbo].[ExpenseCategory]  WITH CHECK ADD  CONSTRAINT [expensecategory_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[ExpenseCategory] CHECK CONSTRAINT [expensecategory_updatedby_foreign]
GO
ALTER TABLE [dbo].[ExpenseReceipt]  WITH CHECK ADD  CONSTRAINT [expensereceipt_accountid_foreign] FOREIGN KEY([AccountId])
REFERENCES [dbo].[Account] ([AccountId])
GO
ALTER TABLE [dbo].[ExpenseReceipt] CHECK CONSTRAINT [expensereceipt_accountid_foreign]
GO
ALTER TABLE [dbo].[ExpenseReceipt]  WITH CHECK ADD  CONSTRAINT [expensereceipt_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[ExpenseReceipt] CHECK CONSTRAINT [expensereceipt_createdby_foreign]
GO
ALTER TABLE [dbo].[ExpenseReceipt]  WITH CHECK ADD  CONSTRAINT [expensereceipt_expensecategoryid_foreign] FOREIGN KEY([ExpenseCategoryId])
REFERENCES [dbo].[ExpenseCategory] ([ExpenseCategoryId])
GO
ALTER TABLE [dbo].[ExpenseReceipt] CHECK CONSTRAINT [expensereceipt_expensecategoryid_foreign]
GO
ALTER TABLE [dbo].[ExpenseReceipt]  WITH CHECK ADD  CONSTRAINT [expensereceipt_reportid_foreign] FOREIGN KEY([ReportId])
REFERENCES [dbo].[Report] ([ReportId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ExpenseReceipt] CHECK CONSTRAINT [expensereceipt_reportid_foreign]
GO
ALTER TABLE [dbo].[ExpenseReceipt]  WITH CHECK ADD  CONSTRAINT [expensereceipt_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[ExpenseReceipt] CHECK CONSTRAINT [expensereceipt_updatedby_foreign]
GO
ALTER TABLE [dbo].[ManagerSalesRepMap]  WITH CHECK ADD  CONSTRAINT [managersalesrepmap_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[ManagerSalesRepMap] CHECK CONSTRAINT [managersalesrepmap_createdby_foreign]
GO
ALTER TABLE [dbo].[ManagerSalesRepMap]  WITH CHECK ADD  CONSTRAINT [managersalesrepmap_managerid_foreign] FOREIGN KEY([ManagerId])
REFERENCES [dbo].[SalesRep] ([SalesRepId])
GO
ALTER TABLE [dbo].[ManagerSalesRepMap] CHECK CONSTRAINT [managersalesrepmap_managerid_foreign]
GO
ALTER TABLE [dbo].[ManagerSalesRepMap]  WITH CHECK ADD  CONSTRAINT [managersalesrepmap_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[ManagerSalesRepMap] CHECK CONSTRAINT [managersalesrepmap_updatedby_foreign]
GO
ALTER TABLE [dbo].[MileageEntry]  WITH CHECK ADD  CONSTRAINT [mileageentry_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[MileageEntry] CHECK CONSTRAINT [mileageentry_createdby_foreign]
GO
ALTER TABLE [dbo].[MileageEntry]  WITH CHECK ADD  CONSTRAINT [mileageentry_mileagereportid_foreign] FOREIGN KEY([MileageReportId])
REFERENCES [dbo].[Report] ([ReportId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MileageEntry] CHECK CONSTRAINT [mileageentry_mileagereportid_foreign]
GO
ALTER TABLE [dbo].[MileageEntry]  WITH CHECK ADD  CONSTRAINT [mileageentry_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[MileageEntry] CHECK CONSTRAINT [mileageentry_updatedby_foreign]
GO
ALTER TABLE [dbo].[MileageLocationMap]  WITH CHECK ADD  CONSTRAINT [mileagelocationmap_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[MileageLocationMap] CHECK CONSTRAINT [mileagelocationmap_createdby_foreign]
GO
ALTER TABLE [dbo].[MileageLocationMap]  WITH CHECK ADD  CONSTRAINT [mileagelocationmap_mileageentryid_foreign] FOREIGN KEY([MileageEntryId])
REFERENCES [dbo].[MileageEntry] ([MileageEntryId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MileageLocationMap] CHECK CONSTRAINT [mileagelocationmap_mileageentryid_foreign]
GO
ALTER TABLE [dbo].[MileageLocationMap]  WITH CHECK ADD  CONSTRAINT [mileagelocationmap_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[MileageLocationMap] CHECK CONSTRAINT [mileagelocationmap_updatedby_foreign]
GO
ALTER TABLE [dbo].[Module]  WITH CHECK ADD  CONSTRAINT [module_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[Module] CHECK CONSTRAINT [module_createdby_foreign]
GO
ALTER TABLE [dbo].[Module]  WITH CHECK ADD  CONSTRAINT [module_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[Module] CHECK CONSTRAINT [module_updatedby_foreign]
GO
ALTER TABLE [dbo].[ModuleOrganizationMap]  WITH CHECK ADD  CONSTRAINT [moduleorganizationmap_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[ModuleOrganizationMap] CHECK CONSTRAINT [moduleorganizationmap_createdby_foreign]
GO
ALTER TABLE [dbo].[ModuleOrganizationMap]  WITH CHECK ADD  CONSTRAINT [moduleorganizationmap_moduleid_foreign] FOREIGN KEY([ModuleId])
REFERENCES [dbo].[Module] ([ModuleId])
GO
ALTER TABLE [dbo].[ModuleOrganizationMap] CHECK CONSTRAINT [moduleorganizationmap_moduleid_foreign]
GO
ALTER TABLE [dbo].[ModuleOrganizationMap]  WITH CHECK ADD  CONSTRAINT [moduleorganizationmap_organizationid_foreign] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO
ALTER TABLE [dbo].[ModuleOrganizationMap] CHECK CONSTRAINT [moduleorganizationmap_organizationid_foreign]
GO
ALTER TABLE [dbo].[ModuleOrganizationMap]  WITH CHECK ADD  CONSTRAINT [moduleorganizationmap_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[ModuleOrganizationMap] CHECK CONSTRAINT [moduleorganizationmap_updatedby_foreign]
GO
ALTER TABLE [dbo].[NotesQuestion]  WITH CHECK ADD  CONSTRAINT [notesquestion_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[NotesQuestion] CHECK CONSTRAINT [notesquestion_createdby_foreign]
GO
ALTER TABLE [dbo].[NotesQuestion]  WITH CHECK ADD  CONSTRAINT [notesquestion_organizationid_foreign] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO
ALTER TABLE [dbo].[NotesQuestion] CHECK CONSTRAINT [notesquestion_organizationid_foreign]
GO
ALTER TABLE [dbo].[NotesQuestion]  WITH CHECK ADD  CONSTRAINT [notesquestion_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[NotesQuestion] CHECK CONSTRAINT [notesquestion_updatedby_foreign]
GO
ALTER TABLE [dbo].[Organization]  WITH CHECK ADD  CONSTRAINT [organization_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[Organization] CHECK CONSTRAINT [organization_createdby_foreign]
GO
ALTER TABLE [dbo].[Organization]  WITH CHECK ADD  CONSTRAINT [organization_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[Organization] CHECK CONSTRAINT [organization_updatedby_foreign]
GO
ALTER TABLE [dbo].[OrganizationBranch]  WITH CHECK ADD  CONSTRAINT [organizationbranch_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[OrganizationBranch] CHECK CONSTRAINT [organizationbranch_createdby_foreign]
GO
ALTER TABLE [dbo].[OrganizationBranch]  WITH CHECK ADD  CONSTRAINT [organizationbranch_organizationid_foreign] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO
ALTER TABLE [dbo].[OrganizationBranch] CHECK CONSTRAINT [organizationbranch_organizationid_foreign]
GO
ALTER TABLE [dbo].[OrganizationBranch]  WITH CHECK ADD  CONSTRAINT [organizationbranch_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[OrganizationBranch] CHECK CONSTRAINT [organizationbranch_updatedby_foreign]
GO
ALTER TABLE [dbo].[OrganizationSetting]  WITH CHECK ADD  CONSTRAINT [organizationsetting_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[OrganizationSetting] CHECK CONSTRAINT [organizationsetting_createdby_foreign]
GO
ALTER TABLE [dbo].[OrganizationSetting]  WITH CHECK ADD  CONSTRAINT [organizationsetting_organizationid_foreign] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO
ALTER TABLE [dbo].[OrganizationSetting] CHECK CONSTRAINT [organizationsetting_organizationid_foreign]
GO
ALTER TABLE [dbo].[OrganizationSetting]  WITH CHECK ADD  CONSTRAINT [organizationsetting_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[OrganizationSetting] CHECK CONSTRAINT [organizationsetting_updatedby_foreign]
GO
ALTER TABLE [dbo].[Report]  WITH CHECK ADD  CONSTRAINT [report_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[Report] CHECK CONSTRAINT [report_createdby_foreign]
GO
ALTER TABLE [dbo].[Report]  WITH CHECK ADD  CONSTRAINT [report_eventcalllogid_foreign] FOREIGN KEY([EventCallLogId])
REFERENCES [dbo].[EventCallLog] ([EventCallLogId])
GO
ALTER TABLE [dbo].[Report] CHECK CONSTRAINT [report_eventcalllogid_foreign]
GO
ALTER TABLE [dbo].[Report]  WITH CHECK ADD  CONSTRAINT [report_salesrepid_foreign] FOREIGN KEY([SalesRepId])
REFERENCES [dbo].[SalesRep] ([SalesRepId])
GO
ALTER TABLE [dbo].[Report] CHECK CONSTRAINT [report_salesrepid_foreign]
GO
ALTER TABLE [dbo].[Report]  WITH CHECK ADD  CONSTRAINT [report_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[Report] CHECK CONSTRAINT [report_updatedby_foreign]
GO
ALTER TABLE [dbo].[ReportApproval]  WITH CHECK ADD  CONSTRAINT [reportapproval_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[ReportApproval] CHECK CONSTRAINT [reportapproval_createdby_foreign]
GO
ALTER TABLE [dbo].[ReportApproval]  WITH CHECK ADD  CONSTRAINT [reportapproval_managerid_foreign] FOREIGN KEY([ManagerId])
REFERENCES [dbo].[SalesRep] ([SalesRepId])
GO
ALTER TABLE [dbo].[ReportApproval] CHECK CONSTRAINT [reportapproval_managerid_foreign]
GO
ALTER TABLE [dbo].[ReportApproval]  WITH CHECK ADD  CONSTRAINT [reportapproval_reportid_foreign] FOREIGN KEY([ReportId])
REFERENCES [dbo].[Report] ([ReportId])
GO
ALTER TABLE [dbo].[ReportApproval] CHECK CONSTRAINT [reportapproval_reportid_foreign]
GO
ALTER TABLE [dbo].[ReportApproval]  WITH CHECK ADD  CONSTRAINT [reportapproval_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[ReportApproval] CHECK CONSTRAINT [reportapproval_updatedby_foreign]
GO
ALTER TABLE [dbo].[SalesRep]  WITH NOCHECK ADD  CONSTRAINT [salesrep_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[SalesRep] CHECK CONSTRAINT [salesrep_createdby_foreign]
GO
ALTER TABLE [dbo].[SalesRep]  WITH NOCHECK ADD  CONSTRAINT [salesrep_organizationbranchid_foreign] FOREIGN KEY([OrganizationBranchId])
REFERENCES [dbo].[OrganizationBranch] ([OrganizationBranchId])
GO
ALTER TABLE [dbo].[SalesRep] CHECK CONSTRAINT [salesrep_organizationbranchid_foreign]
GO
ALTER TABLE [dbo].[SalesRep]  WITH NOCHECK ADD  CONSTRAINT [salesrep_organizationid_foreign] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO
ALTER TABLE [dbo].[SalesRep] CHECK CONSTRAINT [salesrep_organizationid_foreign]
GO
ALTER TABLE [dbo].[SalesRep]  WITH NOCHECK ADD  CONSTRAINT [salesrep_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[SalesRep] CHECK CONSTRAINT [salesrep_updatedby_foreign]
GO
ALTER TABLE [dbo].[SalesRepTerritoryBranchMap]  WITH CHECK ADD  CONSTRAINT [salesrepterritorybranchmap_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[SalesRepTerritoryBranchMap] CHECK CONSTRAINT [salesrepterritorybranchmap_createdby_foreign]
GO
ALTER TABLE [dbo].[SalesRepTerritoryBranchMap]  WITH CHECK ADD  CONSTRAINT [salesrepterritorybranchmap_organizationbranchid_foreign] FOREIGN KEY([OrganizationBranchId])
REFERENCES [dbo].[OrganizationBranch] ([OrganizationBranchId])
GO
ALTER TABLE [dbo].[SalesRepTerritoryBranchMap] CHECK CONSTRAINT [salesrepterritorybranchmap_organizationbranchid_foreign]
GO
ALTER TABLE [dbo].[SalesRepTerritoryBranchMap]  WITH CHECK ADD  CONSTRAINT [salesrepterritorybranchmap_salesrepid_foreign] FOREIGN KEY([SalesRepId])
REFERENCES [dbo].[SalesRep] ([SalesRepId])
GO
ALTER TABLE [dbo].[SalesRepTerritoryBranchMap] CHECK CONSTRAINT [salesrepterritorybranchmap_salesrepid_foreign]
GO
ALTER TABLE [dbo].[SalesRepTerritoryBranchMap]  WITH CHECK ADD  CONSTRAINT [salesrepterritorybranchmap_territoryid_foreign] FOREIGN KEY([TerritoryId])
REFERENCES [dbo].[Territory] ([TerritoryId])
GO
ALTER TABLE [dbo].[SalesRepTerritoryBranchMap] CHECK CONSTRAINT [salesrepterritorybranchmap_territoryid_foreign]
GO
ALTER TABLE [dbo].[SalesRepTerritoryBranchMap]  WITH CHECK ADD  CONSTRAINT [salesrepterritorybranchmap_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[SalesRepTerritoryBranchMap] CHECK CONSTRAINT [salesrepterritorybranchmap_updatedby_foreign]
GO
ALTER TABLE [dbo].[states]  WITH CHECK ADD  CONSTRAINT [states_country_id_foreign] FOREIGN KEY([country_id])
REFERENCES [dbo].[countries] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[states] CHECK CONSTRAINT [states_country_id_foreign]
GO
ALTER TABLE [dbo].[SuperAdmin]  WITH CHECK ADD  CONSTRAINT [superadmin_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[SuperAdmin] CHECK CONSTRAINT [superadmin_createdby_foreign]
GO
ALTER TABLE [dbo].[SuperAdmin]  WITH CHECK ADD  CONSTRAINT [superadmin_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[SuperAdmin] CHECK CONSTRAINT [superadmin_updatedby_foreign]
GO
ALTER TABLE [dbo].[Territory]  WITH CHECK ADD  CONSTRAINT [territory_createdby_foreign] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[Territory] CHECK CONSTRAINT [territory_createdby_foreign]
GO
ALTER TABLE [dbo].[Territory]  WITH CHECK ADD  CONSTRAINT [territory_organizationid_foreign] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO
ALTER TABLE [dbo].[Territory] CHECK CONSTRAINT [territory_organizationid_foreign]
GO
ALTER TABLE [dbo].[Territory]  WITH CHECK ADD  CONSTRAINT [territory_updatedby_foreign] FOREIGN KEY([UpdatedBy])
REFERENCES [dbo].[RoleMap] ([RoleMapId])
GO
ALTER TABLE [dbo].[Territory] CHECK CONSTRAINT [territory_updatedby_foreign]
GO
ALTER TABLE [dbo].[TokenUsage]  WITH CHECK ADD  CONSTRAINT [tokenusage_salesrepid_foreign] FOREIGN KEY([SalesRepId])
REFERENCES [dbo].[SalesRep] ([SalesRepId])
GO
ALTER TABLE [dbo].[TokenUsage] CHECK CONSTRAINT [tokenusage_salesrepid_foreign]
GO
