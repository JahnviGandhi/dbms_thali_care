USE [Thali_Care_Database]
GO

ALTER TABLE [dbo].[Age_Gender_Parameter_Mapping] DROP CONSTRAINT [CK__Age_Gende__isDel__489AC854]
GO

/****** Object:  Table [dbo].[Age_Gender_Parameter_Mapping]    Script Date: 12/7/2015 1:24:25 PM ******/
DROP TABLE [dbo].[Age_Gender_Parameter_Mapping]
GO

/****** Object:  Table [dbo].[Age_Gender_Parameter_Mapping]    Script Date: 12/7/2015 1:24:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Age_Gender_Parameter_Mapping](
	[Age_Gender_Parameter_Mapping_ID] [int] IDENTITY(1,1) NOT NULL,
	[Min_Age] [int] NULL,
	[Max_Age] [int] NULL,
	[Gender] [char](1) NULL,
	[isDeleted] [char](1) NULL DEFAULT ('N'),
	[Min_HB] [decimal](4, 2) NULL,
	[Min_MCV] [decimal](4, 2) NULL,
	[Min_MCH] [decimal](4, 2) NULL,
	[Min_HbA2] [decimal](4, 2) NULL,
	[Min_Hbf] [decimal](4, 2) NULL,
	[Max_HB] [decimal](4, 2) NULL,
	[Max_MCV] [decimal](4, 2) NULL,
	[Max_MCH] [decimal](4, 2) NULL,
	[Max_HbA2] [decimal](4, 2) NULL,
	[Max_Hbf] [decimal](4, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[Age_Gender_Parameter_Mapping_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Age_Gender_Parameter_Mapping]  WITH CHECK ADD CHECK  (([isDeleted]='N' OR [isDeleted]='Y'))
GO

