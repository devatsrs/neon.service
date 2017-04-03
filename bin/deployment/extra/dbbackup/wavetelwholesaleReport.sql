-- MySQL dump 10.13  Distrib 5.7.11, for Linux (x86_64)
--
-- Host: localhost    Database: wavetelwholesaleReport
-- ------------------------------------------------------
-- Server version	5.7.11

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tblDimDate`
--

DROP TABLE IF EXISTS `tblDimDate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblDimDate` (
  `DateID` bigint(20) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `day` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `day_abbrev` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL,
  `day_of_week` int(11) DEFAULT NULL,
  `day_of_month` int(11) DEFAULT NULL,
  `day_of_quarter` int(11) DEFAULT NULL,
  `day_of_semester` int(11) DEFAULT NULL,
  `day_of_year` int(11) DEFAULT NULL,
  `weekend` varchar(10) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'Weekday',
  `week_of_month` int(11) DEFAULT NULL,
  `week_of_quarter` int(11) DEFAULT NULL,
  `week_of_semester` int(11) DEFAULT NULL,
  `week_of_year` int(11) DEFAULT NULL,
  `month` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `month_abbrev` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL,
  `month_of_quarter` int(11) DEFAULT NULL,
  `month_of_year` int(11) DEFAULT NULL,
  `quarter_of_year` int(11) DEFAULT NULL,
  `previous_day` date NOT NULL,
  `next_day` date NOT NULL,
  `start_week` date NOT NULL,
  `end_week` date NOT NULL,
  `start_month` date NOT NULL,
  `end_month` date NOT NULL,
  `start_quarter` date NOT NULL,
  `end_quarter` date NOT NULL,
  `year` int(11) DEFAULT NULL,
  `week_month_name` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `week_quarter_name` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `week_year_name` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `month_quarter_name` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `month_year_name` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `quarter_year_name` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`DateID`),
  UNIQUE KEY `date` (`date`)
) ENGINE=InnoDB AUTO_INCREMENT=3654 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblDimTime`
--

DROP TABLE IF EXISTS `tblDimTime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblDimTime` (
  `TimeID` int(11) NOT NULL AUTO_INCREMENT,
  `fulltime` time DEFAULT NULL,
  `hour` int(11) DEFAULT NULL,
  `minute` int(11) DEFAULT NULL,
  `second` int(11) DEFAULT NULL,
  `ampm` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`TimeID`),
  KEY `IX_fulltime` (`fulltime`)
) ENGINE=InnoDB AUTO_INCREMENT=86401 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummaryHeader`
--

DROP TABLE IF EXISTS `tblSummaryHeader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummaryHeader` (
  `SummaryHeaderID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DateID` bigint(20) NOT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `Trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AreaPrefix` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CountryID` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`SummaryHeaderID`),
  KEY `FK_tblSummaryHeader_dim_date` (`DateID`),
  KEY `Unique_key` (`DateID`,`CompanyID`,`AccountID`,`GatewayAccountID`,`CompanyGatewayID`,`Trunk`,`AreaPrefix`),
  CONSTRAINT `FK_tblSummaryHeader_tblDimDate` FOREIGN KEY (`DateID`) REFERENCES `tblDimDate` (`DateID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=21830508 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblSummaryVendorHeader`
--

DROP TABLE IF EXISTS `tblSummaryVendorHeader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblSummaryVendorHeader` (
  `SummaryVendorHeaderID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DateID` bigint(20) NOT NULL,
  `CompanyID` int(11) NOT NULL,
  `AccountID` int(11) NOT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `CompanyGatewayID` int(11) NOT NULL,
  `Trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AreaPrefix` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CountryID` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`SummaryVendorHeaderID`),
  KEY `FK_tblSummaryVendorHeader_dim_date` (`DateID`),
  KEY `Unique_key` (`DateID`,`CompanyID`,`AccountID`,`GatewayAccountID`,`CompanyGatewayID`,`Trunk`,`AreaPrefix`),
  CONSTRAINT `tblSummaryVendorHeader_ibfk_1` FOREIGN KEY (`DateID`) REFERENCES `tblDimDate` (`DateID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7027468 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTicketGroupAgents`
--

DROP TABLE IF EXISTS `tblTicketGroupAgents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTicketGroupAgents` (
  `GroupAgentsID` int(11) NOT NULL AUTO_INCREMENT,
  `GroupID` int(11) NOT NULL DEFAULT '0',
  `UserID` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`GroupAgentsID`),
  KEY `FK_tblTicketGroupAgents_tblTicketGroups` (`GroupID`),
  KEY `FK_tblTicketGroupAgents_tblUser` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=209 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTicketGroups`
--

DROP TABLE IF EXISTS `tblTicketGroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTicketGroups` (
  `GroupID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyID` int(11) NOT NULL DEFAULT '0',
  `GroupName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `GroupDescription` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `GroupEmailAddress` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `GroupAssignTime` int(11) NOT NULL DEFAULT '0',
  `GroupAssignEmail` int(11) NOT NULL DEFAULT '0',
  `GroupAuomatedReply` text COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`GroupID`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTicketfields`
--

DROP TABLE IF EXISTS `tblTicketfields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTicketfields` (
  `TicketFieldsID` int(11) NOT NULL AUTO_INCREMENT,
  `FieldType` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 for static, 1 for dynmaic',
  `FieldHtmlType` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1 for Text,2 for Textarea,3 for checkbox,4 for text number,5 for dropdown,6 for date,7 for decimal',
  `FieldName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AgentReqSubmit` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 for unavialable,1 for disable unselecetd,2 for disable seleceted,3 for active unselecetd,4 for active seleceted',
  `AgentReqClose` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 for unavialable,1 for disable unselecetd,2 for disable seleceted,3 for active unselecetd,4 for active seleceted',
  `CustomerDisplay` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 for unavialable,1 for disable unselecetd,2 for disable seleceted,3 for active unselecetd,4 for active seleceted',
  `CustomerEdit` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 for unavialable,1 for disable unselecetd,2 for disable seleceted,3 for active unselecetd,4 for active seleceted',
  `CustomerReqSubmit` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 for unavialable,1 for disable unselecetd,2 for disable seleceted,3 for active unselecetd,4 for active seleceted',
  `AgentLabel` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CustomerLabel` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AgentCcDisplay` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 for unavialable,1 for disable unselecetd,2 for disable seleceted,3 for active unselecetd,4 for active seleceted',
  `CustomerCcDisplay` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 for unavialable,1 for disable unselecetd,2 for disable seleceted,3 for active unselecetd,4 for active seleceted',
  `FieldOrder` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  KEY `Index 1` (`TicketFieldsID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblTicketfieldsValues`
--

DROP TABLE IF EXISTS `tblTicketfieldsValues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblTicketfieldsValues` (
  `ValuesID` int(11) NOT NULL AUTO_INCREMENT,
  `FieldsID` int(11) NOT NULL DEFAULT '0',
  `FieldType` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 for static 1, for dynmaic',
  `FieldValueAgent` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FieldValueCustomer` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FieldSlaTime` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 for disable, 1 for active, 2 for inactive',
  `FieldOrder` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `updated_by` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  KEY `Index 1` (`ValuesID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageSummary`
--

DROP TABLE IF EXISTS `tblUsageSummary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageSummary` (
  `UsageSummaryID` bigint(20) NOT NULL AUTO_INCREMENT,
  `SummaryHeaderID` bigint(20) NOT NULL,
  `TotalCharges` double DEFAULT NULL,
  `TotalBilledDuration` int(11) DEFAULT NULL,
  `TotalDuration` int(11) DEFAULT NULL,
  `NoOfCalls` int(11) DEFAULT NULL,
  `NoOfFailCalls` int(11) DEFAULT NULL,
  `FinalStatus` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UsageSummaryID`),
  KEY `FK_tblUsageSummary_dim_date` (`SummaryHeaderID`),
  CONSTRAINT `FK_tblUsageSummary_tblSummaryHeader` FOREIGN KEY (`SummaryHeaderID`) REFERENCES `tblSummaryHeader` (`SummaryHeaderID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=170092141 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageSummaryDetail`
--

DROP TABLE IF EXISTS `tblUsageSummaryDetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageSummaryDetail` (
  `UsageSummaryDetailID` bigint(20) NOT NULL AUTO_INCREMENT,
  `SummaryHeaderID` bigint(20) NOT NULL,
  `TimeID` int(11) NOT NULL,
  `TotalCharges` double DEFAULT NULL,
  `TotalBilledDuration` int(11) DEFAULT NULL,
  `TotalDuration` int(11) DEFAULT NULL,
  `NoOfCalls` int(11) DEFAULT NULL,
  `NoOfFailCalls` int(11) DEFAULT NULL,
  `FinalStatus` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UsageSummaryDetailID`),
  KEY `FK_tblUsageSummaryDetail_dim_time` (`TimeID`),
  KEY `FK_tblUsageSummaryDetail_tblSummaryHeader` (`SummaryHeaderID`),
  CONSTRAINT `FK_tblUsageSummaryDetail_tblDimTime` FOREIGN KEY (`TimeID`) REFERENCES `tblDimTime` (`TimeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tblUsageSummaryDetail_tblSummaryHeader` FOREIGN KEY (`SummaryHeaderID`) REFERENCES `tblSummaryHeader` (`SummaryHeaderID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=600588803 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageSummaryDetailLive`
--

DROP TABLE IF EXISTS `tblUsageSummaryDetailLive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageSummaryDetailLive` (
  `UsageSummaryDetailLiveID` bigint(20) NOT NULL AUTO_INCREMENT,
  `SummaryHeaderID` bigint(20) NOT NULL,
  `TimeID` int(11) NOT NULL,
  `TotalCharges` double DEFAULT NULL,
  `TotalBilledDuration` int(11) DEFAULT NULL,
  `TotalDuration` int(11) DEFAULT NULL,
  `NoOfCalls` int(11) DEFAULT NULL,
  `NoOfFailCalls` int(11) DEFAULT NULL,
  `FinalStatus` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UsageSummaryDetailLiveID`),
  KEY `FK_tblUsageSummaryDetailLive_dim_time` (`TimeID`),
  KEY `FK_tblUsageSummaryDetailLive_tblSummaryHeader` (`SummaryHeaderID`),
  CONSTRAINT `tblUsageSummaryDetailLive_ibfk_1` FOREIGN KEY (`TimeID`) REFERENCES `tblDimTime` (`TimeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `tblUsageSummaryDetailLive_ibfk_2` FOREIGN KEY (`SummaryHeaderID`) REFERENCES `tblSummaryHeader` (`SummaryHeaderID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6579241065 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageSummaryLive`
--

DROP TABLE IF EXISTS `tblUsageSummaryLive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageSummaryLive` (
  `UsageSummaryLiveID` bigint(20) NOT NULL AUTO_INCREMENT,
  `SummaryHeaderID` bigint(20) NOT NULL,
  `TotalCharges` double DEFAULT NULL,
  `TotalBilledDuration` int(11) DEFAULT NULL,
  `TotalDuration` int(11) DEFAULT NULL,
  `NoOfCalls` int(11) DEFAULT NULL,
  `NoOfFailCalls` int(11) DEFAULT NULL,
  `FinalStatus` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UsageSummaryLiveID`),
  KEY `FK_tblUsageSummaryLive_dim_date` (`SummaryHeaderID`),
  CONSTRAINT `tblUsageSummaryLive_ibfk_1` FOREIGN KEY (`SummaryHeaderID`) REFERENCES `tblSummaryHeader` (`SummaryHeaderID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2102385722 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageVendorSummary`
--

DROP TABLE IF EXISTS `tblUsageVendorSummary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageVendorSummary` (
  `UsageVendorSummaryID` bigint(20) NOT NULL AUTO_INCREMENT,
  `SummaryVendorHeaderID` bigint(20) NOT NULL,
  `TotalCharges` double DEFAULT NULL,
  `TotalSales` double DEFAULT NULL,
  `TotalBilledDuration` int(11) DEFAULT NULL,
  `TotalDuration` int(11) DEFAULT NULL,
  `NoOfCalls` int(11) DEFAULT NULL,
  `NoOfFailCalls` int(11) DEFAULT NULL,
  `FinalStatus` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UsageVendorSummaryID`),
  KEY `FK_tblUsageVendorSummary_dim_date` (`SummaryVendorHeaderID`),
  CONSTRAINT `FK_tblUsageVendorSummary_tblSummaryVendorHeader` FOREIGN KEY (`SummaryVendorHeaderID`) REFERENCES `tblSummaryVendorHeader` (`SummaryVendorHeaderID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=36858588 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageVendorSummaryDetail`
--

DROP TABLE IF EXISTS `tblUsageVendorSummaryDetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageVendorSummaryDetail` (
  `UsageVendorSummaryDetailID` bigint(20) NOT NULL AUTO_INCREMENT,
  `SummaryVendorHeaderID` bigint(20) NOT NULL,
  `TimeID` int(11) NOT NULL,
  `TotalCharges` double DEFAULT NULL,
  `TotalSales` double DEFAULT NULL,
  `TotalBilledDuration` int(11) DEFAULT NULL,
  `TotalDuration` int(11) DEFAULT NULL,
  `NoOfCalls` int(11) DEFAULT NULL,
  `NoOfFailCalls` int(11) DEFAULT NULL,
  `FinalStatus` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UsageVendorSummaryDetailID`),
  KEY `FK_tblUsageVendorSummaryDetail_dim_time` (`TimeID`),
  KEY `FK_tblUsageVendorSummaryDetail_tblSummaryVendorHeader` (`SummaryVendorHeaderID`),
  CONSTRAINT `FK_tblUsageVendorSummaryDetail_tblDimTime` FOREIGN KEY (`TimeID`) REFERENCES `tblDimTime` (`TimeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_tblUsageVendorSummaryDetail_tblSummaryVendorHeader` FOREIGN KEY (`SummaryVendorHeaderID`) REFERENCES `tblSummaryVendorHeader` (`SummaryVendorHeaderID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=201496027 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageVendorSummaryDetailLive`
--

DROP TABLE IF EXISTS `tblUsageVendorSummaryDetailLive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageVendorSummaryDetailLive` (
  `UsageVendorSummaryDetailLiveID` bigint(20) NOT NULL AUTO_INCREMENT,
  `SummaryVendorHeaderID` bigint(20) NOT NULL,
  `TimeID` int(11) NOT NULL,
  `TotalCharges` double DEFAULT NULL,
  `TotalSales` double DEFAULT NULL,
  `TotalBilledDuration` int(11) DEFAULT NULL,
  `TotalDuration` int(11) DEFAULT NULL,
  `NoOfCalls` int(11) DEFAULT NULL,
  `NoOfFailCalls` int(11) DEFAULT NULL,
  `FinalStatus` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UsageVendorSummaryDetailLiveID`),
  KEY `FK_tblUsageVendorSummaryDetailLive_dim_time` (`TimeID`),
  KEY `FK_tblUsageVendorSummaryDetailLive_tblSummaryVendorHeader` (`SummaryVendorHeaderID`),
  CONSTRAINT `tblUsageVendorSummaryDetailLive_ibfk_1` FOREIGN KEY (`TimeID`) REFERENCES `tblDimTime` (`TimeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `tblUsageVendorSummaryDetailLive_ibfk_2` FOREIGN KEY (`SummaryVendorHeaderID`) REFERENCES `tblSummaryVendorHeader` (`SummaryVendorHeaderID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4340752465 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tblUsageVendorSummaryLive`
--

DROP TABLE IF EXISTS `tblUsageVendorSummaryLive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tblUsageVendorSummaryLive` (
  `UsageVendorSummaryLiveID` bigint(20) NOT NULL AUTO_INCREMENT,
  `SummaryVendorHeaderID` bigint(20) NOT NULL,
  `TotalCharges` double DEFAULT NULL,
  `TotalSales` double DEFAULT NULL,
  `TotalBilledDuration` int(11) DEFAULT NULL,
  `TotalDuration` int(11) DEFAULT NULL,
  `NoOfCalls` int(11) DEFAULT NULL,
  `NoOfFailCalls` int(11) DEFAULT NULL,
  `FinalStatus` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`UsageVendorSummaryLiveID`),
  KEY `FK_tblUsageVendorSummaryLive_dim_date` (`SummaryVendorHeaderID`),
  CONSTRAINT `tblUsageVendorSummaryLive_ibfk_1` FOREIGN KEY (`SummaryVendorHeaderID`) REFERENCES `tblSummaryVendorHeader` (`SummaryVendorHeaderID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1109861815 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_SummaryHeader`
--

DROP TABLE IF EXISTS `tmp_SummaryHeader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_SummaryHeader` (
  `SummaryHeaderID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `DateID` bigint(20) NOT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `Trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AreaPrefix` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CountryID` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`SummaryHeaderID`),
  KEY `Unique_key` (`DateID`,`CompanyID`,`AccountID`,`CompanyGatewayID`,`Trunk`,`AreaPrefix`)
) ENGINE=InnoDB AUTO_INCREMENT=21789606 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_SummaryHeaderLive`
--

DROP TABLE IF EXISTS `tmp_SummaryHeaderLive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_SummaryHeaderLive` (
  `SummaryHeaderID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `DateID` bigint(20) NOT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `Trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AreaPrefix` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CountryID` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`SummaryHeaderID`),
  KEY `Unique_key` (`DateID`,`CompanyID`,`AccountID`,`CompanyGatewayID`,`Trunk`,`AreaPrefix`)
) ENGINE=InnoDB AUTO_INCREMENT=21830381 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_SummaryVendorHeader`
--

DROP TABLE IF EXISTS `tmp_SummaryVendorHeader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_SummaryVendorHeader` (
  `SummaryVendorHeaderID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DateID` bigint(20) NOT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `Trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AreaPrefix` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CountryID` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`SummaryVendorHeaderID`),
  KEY `Unique_key` (`DateID`,`CompanyID`,`AccountID`,`CompanyGatewayID`,`Trunk`,`AreaPrefix`)
) ENGINE=InnoDB AUTO_INCREMENT=7013053 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_SummaryVendorHeaderLive`
--

DROP TABLE IF EXISTS `tmp_SummaryVendorHeaderLive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_SummaryVendorHeaderLive` (
  `SummaryVendorHeaderID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DateID` bigint(20) NOT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `Trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AreaPrefix` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CountryID` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`SummaryVendorHeaderID`),
  KEY `Unique_key` (`DateID`,`CompanyID`,`AccountID`,`CompanyGatewayID`,`Trunk`,`AreaPrefix`)
) ENGINE=InnoDB AUTO_INCREMENT=7027468 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_UsageSummary`
--

DROP TABLE IF EXISTS `tmp_UsageSummary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_UsageSummary` (
  `UsageSummaryID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `DateID` bigint(20) NOT NULL,
  `TimeID` int(11) NOT NULL,
  `CompanyID` int(11) NOT NULL,
  `CompanyGatewayID` int(11) NOT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) NOT NULL,
  `Trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AreaPrefix` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCharges` double DEFAULT NULL,
  `TotalBilledDuration` int(11) DEFAULT NULL,
  `TotalDuration` int(11) DEFAULT NULL,
  `NoOfCalls` int(11) DEFAULT '0',
  `NoOfFailCalls` int(11) DEFAULT '0',
  `FinalStatus` int(11) DEFAULT '0',
  `CountryID` int(11) DEFAULT NULL,
  PRIMARY KEY (`UsageSummaryID`),
  KEY `tblUsageSummary_dim_date` (`DateID`),
  KEY `tmp_UsageSummary_AreaPrefix` (`AreaPrefix`),
  KEY `Unique_key` (`DateID`,`CompanyID`,`AccountID`,`GatewayAccountID`,`CompanyGatewayID`,`Trunk`,`AreaPrefix`),
  KEY `IX_CompanyID` (`CompanyID`)
) ENGINE=InnoDB AUTO_INCREMENT=90800738 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_UsageSummaryLive`
--

DROP TABLE IF EXISTS `tmp_UsageSummaryLive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_UsageSummaryLive` (
  `UsageSummaryLiveID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `DateID` bigint(20) NOT NULL,
  `TimeID` int(11) NOT NULL,
  `CompanyID` int(11) NOT NULL,
  `CompanyGatewayID` int(11) NOT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) NOT NULL,
  `Trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AreaPrefix` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCharges` double DEFAULT NULL,
  `TotalBilledDuration` int(11) DEFAULT NULL,
  `TotalDuration` int(11) DEFAULT NULL,
  `NoOfCalls` int(11) DEFAULT '0',
  `NoOfFailCalls` int(11) DEFAULT '0',
  `FinalStatus` int(11) DEFAULT '0',
  `CountryID` int(11) DEFAULT NULL,
  PRIMARY KEY (`UsageSummaryLiveID`),
  KEY `tblUsageSummary_dim_date` (`DateID`),
  KEY `tmp_UsageSummary_AreaPrefix` (`AreaPrefix`),
  KEY `IX_CompanyID` (`CompanyID`),
  KEY `Unique_key` (`DateID`,`CompanyID`,`AccountID`,`CompanyGatewayID`,`Trunk`,`AreaPrefix`)
) ENGINE=InnoDB AUTO_INCREMENT=2073730821 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_VendorUsageSummary`
--

DROP TABLE IF EXISTS `tmp_VendorUsageSummary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_VendorUsageSummary` (
  `VendorUsageSummaryID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DateID` bigint(20) NOT NULL,
  `TimeID` int(11) NOT NULL,
  `CompanyID` int(11) NOT NULL,
  `CompanyGatewayID` int(11) NOT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) NOT NULL,
  `Trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AreaPrefix` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCharges` double DEFAULT NULL,
  `TotalSales` double DEFAULT NULL,
  `TotalBilledDuration` int(11) DEFAULT NULL,
  `TotalDuration` int(11) DEFAULT NULL,
  `NoOfCalls` int(11) DEFAULT '0',
  `NoOfFailCalls` int(11) DEFAULT '0',
  `FinalStatus` int(11) DEFAULT '0',
  `CountryID` int(11) DEFAULT NULL,
  PRIMARY KEY (`VendorUsageSummaryID`),
  KEY `tmp_VendorUsageSummary_AreaPrefix` (`AreaPrefix`),
  KEY `tmp_VendorUsageSummary_dim_date` (`DateID`),
  KEY `Unique_key` (`DateID`,`CompanyID`,`AccountID`,`GatewayAccountID`,`CompanyGatewayID`,`Trunk`,`AreaPrefix`),
  KEY `IX_CompanyID` (`CompanyID`)
) ENGINE=InnoDB AUTO_INCREMENT=44919902 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_VendorUsageSummaryLive`
--

DROP TABLE IF EXISTS `tmp_VendorUsageSummaryLive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_VendorUsageSummaryLive` (
  `VendorUsageSummaryLiveID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DateID` bigint(20) NOT NULL,
  `TimeID` int(11) NOT NULL,
  `CompanyID` int(11) NOT NULL,
  `CompanyGatewayID` int(11) NOT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccountID` int(11) NOT NULL,
  `Trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AreaPrefix` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TotalCharges` double DEFAULT NULL,
  `TotalSales` double DEFAULT NULL,
  `TotalBilledDuration` int(11) DEFAULT NULL,
  `TotalDuration` int(11) DEFAULT NULL,
  `NoOfCalls` int(11) DEFAULT '0',
  `NoOfFailCalls` int(11) DEFAULT '0',
  `FinalStatus` int(11) DEFAULT '0',
  `CountryID` int(11) DEFAULT NULL,
  PRIMARY KEY (`VendorUsageSummaryLiveID`),
  KEY `tmp_VendorUsageSummary_AreaPrefix` (`AreaPrefix`),
  KEY `tmp_VendorUsageSummary_dim_date` (`DateID`),
  KEY `Unique_key` (`DateID`,`CompanyID`,`AccountID`,`GatewayAccountID`,`CompanyGatewayID`,`Trunk`,`AreaPrefix`),
  KEY `IX_CompanyID` (`CompanyID`)
) ENGINE=InnoDB AUTO_INCREMENT=1371063051 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_tblUsageDetailsReport`
--

DROP TABLE IF EXISTS `tmp_tblUsageDetailsReport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_tblUsageDetailsReport` (
  `UsageDetailsReportID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `UsageDetailID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `cost` decimal(18,6) DEFAULT NULL,
  `connect_time` time DEFAULT NULL,
  `connect_date` date DEFAULT NULL,
  `call_status` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`UsageDetailsReportID`),
  KEY `temp_connect_time` (`connect_time`,`connect_date`),
  KEY `IX_CompanyID` (`CompanyID`)
) ENGINE=InnoDB AUTO_INCREMENT=1900445947 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_tblUsageDetailsReportLive`
--

DROP TABLE IF EXISTS `tmp_tblUsageDetailsReportLive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_tblUsageDetailsReportLive` (
  `UsageDetailsReportLiveID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `UsageDetailID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `cost` decimal(18,6) DEFAULT NULL,
  `connect_time` time DEFAULT NULL,
  `connect_date` date DEFAULT NULL,
  `call_status` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`UsageDetailsReportLiveID`),
  KEY `temp_connect_time` (`connect_time`,`connect_date`),
  KEY `IX_CompanyID` (`CompanyID`)
) ENGINE=InnoDB AUTO_INCREMENT=35603642834 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_tblVendorUsageDetailsReport`
--

DROP TABLE IF EXISTS `tmp_tblVendorUsageDetailsReport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_tblVendorUsageDetailsReport` (
  `VendorUsageDetailsReportID` bigint(20) NOT NULL AUTO_INCREMENT,
  `VendorCDRID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `buying_cost` decimal(18,6) DEFAULT NULL,
  `selling_cost` decimal(18,6) DEFAULT NULL,
  `connect_time` time DEFAULT NULL,
  `connect_date` date DEFAULT NULL,
  `call_status` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`VendorUsageDetailsReportID`),
  KEY `temp_connect_time` (`connect_time`,`connect_date`),
  KEY `IX_CompanyID` (`CompanyID`)
) ENGINE=InnoDB AUTO_INCREMENT=1835618645 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp_tblVendorUsageDetailsReportLive`
--

DROP TABLE IF EXISTS `tmp_tblVendorUsageDetailsReportLive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_tblVendorUsageDetailsReportLive` (
  `VendorUsageDetailsReportLiveID` bigint(20) NOT NULL AUTO_INCREMENT,
  `VendorCDRID` int(11) DEFAULT NULL,
  `AccountID` int(11) DEFAULT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  `CompanyGatewayID` int(11) DEFAULT NULL,
  `GatewayAccountID` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trunk` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `area_prefix` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `billed_duration` int(11) DEFAULT NULL,
  `buying_cost` decimal(18,6) DEFAULT NULL,
  `selling_cost` decimal(18,6) DEFAULT NULL,
  `connect_time` time DEFAULT NULL,
  `connect_date` date DEFAULT NULL,
  `call_status` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`VendorUsageDetailsReportLiveID`),
  KEY `temp_connect_time` (`connect_time`,`connect_date`),
  KEY `IX_CompanyID` (`CompanyID`)
) ENGINE=InnoDB AUTO_INCREMENT=44689862430 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'wavetelwholesaleReport'
--
/*!50003 DROP FUNCTION IF EXISTS `fnDurationmmss` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `fnDurationmmss`(`p_Duration` INT) RETURNS varchar(50) CHARSET utf8 COLLATE utf8_unicode_ci
BEGIN

DECLARE v_FormattedDuration_ VARCHAR(50);

SELECT CONCAT(FLOOR(p_Duration/60), ':' ,p_Duration % 60) INTO v_FormattedDuration_;

RETURN v_FormattedDuration_;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnGetCompanyGatewayName` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `fnGetCompanyGatewayName`(`p_CompanyGatewayID` INT) RETURNS varchar(200) CHARSET utf8 COLLATE utf8_unicode_ci
BEGIN
DECLARE v_Title_ VARCHAR(200);

SELECT cg.Title INTO v_Title_ from wavetelwholesaleRM.tblCompanyGateway cg where cg.CompanyGatewayID = p_CompanyGatewayID;

RETURN v_Title_;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fngetLastInvoiceDate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user`@`117.247.87.156` FUNCTION `fngetLastInvoiceDate`(
	`p_AccountID` INT
) RETURNS date
BEGIN
	
	DECLARE v_LastInvoiceDate_ DATE;
	
	SELECT 
		CASE WHEN tblAccountBilling.LastInvoiceDate IS NOT NULL AND tblAccountBilling.LastInvoiceDate <> '' 
		THEN 
			DATE_FORMAT(tblAccountBilling.LastInvoiceDate,'%Y-%m-%d')
		ELSE 
			CASE WHEN tblAccountBilling.BillingStartDate IS NOT NULL AND tblAccountBilling.BillingStartDate <> ''
			THEN
				DATE_FORMAT(tblAccountBilling.BillingStartDate,'%Y-%m-%d')
			ELSE DATE_FORMAT(tblAccount.created_at,'%Y-%m-%d')
			END 
		END
		INTO v_LastInvoiceDate_ 
	FROM wavetelwholesaleRM.tblAccount
	LEFT JOIN wavetelwholesaleRM.tblAccountBilling 
		ON tblAccountBilling.AccountID = tblAccount.AccountID
	WHERE tblAccount.AccountID = p_AccountID;
	
	RETURN v_LastInvoiceDate_;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fngetLastVendorInvoiceDate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `fngetLastVendorInvoiceDate`(
	`p_AccountID` INT




) RETURNS datetime
BEGIN
	
	DECLARE v_LastInvoiceDate_ DATETIME;
	
	SELECT
		CASE WHEN EndDate IS NOT NULL AND EndDate <> '' AND EndDate <> '0000-00-00 00:00:00'
		THEN 
			EndDate
		ELSE 
			CASE WHEN BillingStartDate IS NOT NULL AND BillingStartDate <> ''
			THEN
				DATE_FORMAT(BillingStartDate,'%Y-%m-%d')
			ELSE DATE_FORMAT(tblAccount.created_at,'%Y-%m-%d')
			END 
		END  INTO v_LastInvoiceDate_
 	FROM wavetelwholesaleRM.tblAccount
	LEFT JOIN wavetelwholesaleRM.tblAccountBilling 
		ON tblAccountBilling.AccountID = tblAccount.AccountID
	LEFT JOIN wavetelwholesaleBilling.tblInvoice 
		ON tblAccount.AccountID = tblInvoice.AccountID AND InvoiceType =2
	LEFT JOIN wavetelwholesaleBilling.tblInvoiceDetail
		ON tblInvoice.InvoiceID =  tblInvoiceDetail.InvoiceID
	WHERE tblAccount.AccountID = p_AccountID 
	ORDER BY IssueDate DESC 
	LIMIT 1;

	RETURN v_LastInvoiceDate_;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnGetMonthDifference` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `fnGetMonthDifference`(`p_Date1` DATE, `p_Date2` DATE) RETURNS int(11)
BEGIN

DECLARE v_Month INT;

SELECT 12 * (YEAR(p_Date2) - YEAR(p_Date1)) + MONTH(p_Date2) -  MONTH(p_Date1) INTO v_Month;

RETURN v_Month;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnGetRoundingPoint` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` FUNCTION `fnGetRoundingPoint`(
	`p_CompanyID` INT
) RETURNS int(11)
BEGIN

DECLARE v_Round_ int;

SELECT cs.Value INTO v_Round_ from wavetelwholesaleRM.tblCompanySetting cs where cs.`Key` = 'RoundChargesAmount' AND cs.CompanyID = p_CompanyID;

SET v_Round_ = IFNULL(v_Round_,2);

RETURN v_Round_;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnGetCountry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnGetCountry`()
BEGIN

DROP TEMPORARY TABLE IF EXISTS temptblCountry;
CREATE TEMPORARY TABLE IF NOT EXISTS `temptblCountry` (
	`CountryID` INT(11) NOT NULL AUTO_INCREMENT,
	`Prefix` VARCHAR(50) NULL DEFAULT NULL,
	`Country` VARCHAR(100) NULL DEFAULT NULL,
	`ISO2` VARCHAR(5)  NULL DEFAULT NULL,
	`ISO3` VARCHAR(5) NULL DEFAULT NULL,
	PRIMARY KEY (`CountryID`),
	INDEX tempCountry_Prefix(`Prefix`)
);
INSERT INTO temptblCountry(CountryID,Prefix,Country,ISO2,ISO3)
SELECT CountryID,Prefix,Country,ISO2,ISO3 FROM wavetelwholesaleRM.tblCountry;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fngetDefaultCodes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fngetDefaultCodes`(IN `p_CompanyID` INT)
BEGIN
	
	DROP TEMPORARY TABLE IF EXISTS tmp_codes_;
	CREATE TEMPORARY TABLE tmp_codes_ (
		CountryID INT,
		Code VARCHAR(50),
		INDEX tmp_codes_CountryID (`CountryID`),
		INDEX tmp_codes_Code (`Code`)
	);

	INSERT INTO tmp_codes_
	SELECT
	DISTINCT
		tblRate.CountryID,
		tblRate.Code
	FROM wavetelwholesaleRM.tblRate
	INNER JOIN wavetelwholesaleRM.tblCodeDeck
		ON tblCodeDeck.CodeDeckId = tblRate.CodeDeckId
	WHERE tblCodeDeck.CompanyId = p_CompanyID
	AND tblCodeDeck.DefaultCodedeck = 1 ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnGetUsageForSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnGetUsageForSummary`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DELETE FROM tmp_tblUsageDetailsReport WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_tblUsageDetailsReport (UsageDetailID,AccountID,CompanyID,CompanyGatewayID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,cost,connect_time,connect_date,call_status)  
	SELECT
		ud.UsageDetailID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		duration,
		billed_duration,
		cost,
		CONCAT(DATE_FORMAT(ud.connect_time,'%H'),':',IF(MINUTE(ud.connect_time)<30,'00','30'),':00'),
		DATE_FORMAT(ud.connect_time,'%Y-%m-%d'),
		1 as call_status
	FROM wavetelwholesaleCDR.tblUsageDetails  ud
	INNER JOIN wavetelwholesaleCDR.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID is not null
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

	INSERT INTO tmp_tblUsageDetailsReport (UsageDetailID,AccountID,CompanyID,CompanyGatewayID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,cost,connect_time,connect_date,call_status)   
	SELECT
		ud.UsageDetailFailedCallID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		duration,
		billed_duration,
		cost,
		CONCAT(DATE_FORMAT(ud.connect_time,'%H'),':',IF(MINUTE(ud.connect_time)<30,'00','30'),':00'),
		DATE_FORMAT(ud.connect_time,'%Y-%m-%d'),
		2 as call_status
	FROM wavetelwholesaleCDR.tblUsageDetailFailedCall  ud
	INNER JOIN wavetelwholesaleCDR.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID is not null
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnGetUsageForSummaryLive` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnGetUsageForSummaryLive`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DELETE FROM tmp_tblUsageDetailsReportLive WHERE CompanyID = p_CompanyID;
	
	INSERT INTO tmp_tblUsageDetailsReportLive (UsageDetailID,AccountID,CompanyID,CompanyGatewayID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,cost,connect_time,connect_date,call_status) 
	SELECT
		ud.UsageDetailID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		duration,
		billed_duration,
		cost,
		CONCAT(DATE_FORMAT(ud.connect_time,'%H'),':',IF(MINUTE(ud.connect_time)<30,'00','30'),':00'),
		DATE_FORMAT(ud.connect_time,'%Y-%m-%d'),
		1 AS call_status
	FROM wavetelwholesaleCDR.tblUsageDetails  ud
	INNER JOIN wavetelwholesaleCDR.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

	INSERT INTO tmp_tblUsageDetailsReportLive (UsageDetailID,AccountID,CompanyID,CompanyGatewayID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,cost,connect_time,connect_date,call_status)  
	SELECT
		ud.UsageDetailFailedCallID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		duration,
		billed_duration,
		cost,
		CONCAT(DATE_FORMAT(ud.connect_time,'%H'),':',IF(MINUTE(ud.connect_time)<30,'00','30'),':00'),
		DATE_FORMAT(ud.connect_time,'%Y-%m-%d'),
		2 AS call_status
	FROM wavetelwholesaleCDR.tblUsageDetailFailedCall  ud
	INNER JOIN wavetelwholesaleCDR.tblUsageHeader uh
		ON uh.UsageHeaderID = ud.UsageHeaderID
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID IS NOT NULL
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnGetVendorUsageForSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnGetVendorUsageForSummary`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DELETE FROM tmp_tblVendorUsageDetailsReport WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_tblVendorUsageDetailsReport (VendorCDRID,AccountID,CompanyID,CompanyGatewayID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,buying_cost,selling_cost,connect_time,connect_date,call_status)
	SELECT
		ud.VendorCDRID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		duration,
		billed_duration,
		buying_cost,
		selling_cost,
		CONCAT(DATE_FORMAT(ud.connect_time,'%H'),':',IF(MINUTE(ud.connect_time)<30,'00','30'),':00'),
		DATE_FORMAT(ud.connect_time,'%Y-%m-%d'),
		1 as call_status
	FROM wavetelwholesaleCDR.tblVendorCDR  ud
	INNER JOIN wavetelwholesaleCDR.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID 
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID is not null
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

	INSERT INTO tmp_tblVendorUsageDetailsReport (VendorCDRID,AccountID,CompanyID,CompanyGatewayID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,buying_cost,selling_cost,connect_time,connect_date,call_status)
	SELECT
		ud.VendorCDRFailedID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		duration,
		billed_duration,
		buying_cost,
		selling_cost,
		CONCAT(DATE_FORMAT(ud.connect_time,'%H'),':',IF(MINUTE(ud.connect_time)<30,'00','30'),':00'),
		DATE_FORMAT(ud.connect_time,'%Y-%m-%d'),
		2 as call_status
	FROM wavetelwholesaleCDR.tblVendorCDRFailed  ud
	INNER JOIN wavetelwholesaleCDR.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID 
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID is not null
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnGetVendorUsageForSummaryLive` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnGetVendorUsageForSummaryLive`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE
)
BEGIN

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DELETE FROM tmp_tblVendorUsageDetailsReportLive WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_tblVendorUsageDetailsReportLive (VendorCDRID,AccountID,CompanyID,CompanyGatewayID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,buying_cost,selling_cost,connect_time,connect_date,call_status)
	SELECT
		ud.VendorCDRID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		duration,
		billed_duration,
		buying_cost,
		selling_cost,
		CONCAT(DATE_FORMAT(ud.connect_time,'%H'),':',IF(MINUTE(ud.connect_time)<30,'00','30'),':00'),
		DATE_FORMAT(ud.connect_time,'%Y-%m-%d'),
		1 as call_status
	FROM wavetelwholesaleCDR.tblVendorCDR  ud
	INNER JOIN wavetelwholesaleCDR.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID 
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID is not null
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

	INSERT INTO tmp_tblVendorUsageDetailsReportLive (VendorCDRID,AccountID,CompanyID,CompanyGatewayID,GatewayAccountID,trunk,area_prefix,duration,billed_duration,buying_cost,selling_cost,connect_time,connect_date,call_status) 
	SELECT
		ud.VendorCDRFailedID,
		uh.AccountID,
		uh.CompanyID,
		uh.CompanyGatewayID,
		uh.GatewayAccountID,
		trunk,
		area_prefix,
		duration,
		billed_duration,
		buying_cost,
		selling_cost,
		CONCAT(DATE_FORMAT(ud.connect_time,'%H'),':',IF(MINUTE(ud.connect_time)<30,'00','30'),':00'),
		DATE_FORMAT(ud.connect_time,'%Y-%m-%d'),
		2 as call_status
	FROM wavetelwholesaleCDR.tblVendorCDRFailed  ud
	INNER JOIN wavetelwholesaleCDR.tblVendorCDRHeader uh
		ON uh.VendorCDRHeaderID = ud.VendorCDRHeaderID 
	WHERE
		uh.CompanyID = p_CompanyID
	AND uh.AccountID is not null
	AND uh.StartDate BETWEEN p_StartDate AND p_EndDate;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnUsageSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnUsageSummary`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT ,
	IN `p_isAdmin` INT,
	IN `p_Detail` INT





)
BEGIN
	DECLARE v_TimeId_ INT;
	
	IF DATEDIFF(p_EndDate,p_StartDate) > 31 AND p_Detail = 2
	THEN
		SET p_Detail = 1;
	END IF;

	IF p_Detail = 1 
	THEN
	
		DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageSummary_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageSummary_(
				`DateID` BIGINT(20) NOT NULL,
				`CompanyID` INT(11) NOT NULL,
				`AccountID` INT(11) NOT NULL,
				`GatewayAccountID` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`CompanyGatewayID` INT(11) NOT NULL,
				`Trunk` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`CountryID` INT(11) NULL DEFAULT NULL,
				`TotalCharges` DOUBLE NULL DEFAULT NULL,
				`TotalBilledDuration` INT(11) NULL DEFAULT NULL,
				`TotalDuration` INT(11) NULL DEFAULT NULL,
				`NoOfCalls` INT(11) NULL DEFAULT NULL,
				`NoOfFailCalls` INT(11) NULL DEFAULT NULL,
				`AccountName` varchar(100),
				INDEX `tblUsageSummary_dim_date` (`DateID`)
		);
		INSERT INTO tmp_tblUsageSummary_
		SELECT
			sh.DateID,
			sh.CompanyID,
			sh.AccountID,
			sh.GatewayAccountID,
			sh.CompanyGatewayID,
			sh.Trunk,
			sh.AreaPrefix,
			sh.CountryID,
			us.TotalCharges,
			us.TotalBilledDuration,
			us.TotalDuration,
			us.NoOfCalls,
			us.NoOfFailCalls,
			a.AccountName
		FROM tblSummaryHeader sh
		INNER JOIN tblUsageSummary us
			ON us.SummaryHeaderID = sh.SummaryHeaderID 
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN wavetelwholesaleRM.tblAccount a
			ON sh.AccountID = a.AccountID
		WHERE dd.date BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.AccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR sh.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR sh.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR sh.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);
		
		INSERT INTO tmp_tblUsageSummary_
		SELECT
			sh.DateID,
			sh.CompanyID,
			sh.AccountID,
			sh.GatewayAccountID,
			sh.CompanyGatewayID,
			sh.Trunk,
			sh.AreaPrefix,
			sh.CountryID,
			us.TotalCharges,
			us.TotalBilledDuration,
			us.TotalDuration,
			us.NoOfCalls,
			us.NoOfFailCalls,
			a.AccountName
		FROM tblSummaryHeader sh
		INNER JOIN tblUsageSummaryLive us
			ON us.SummaryHeaderID = sh.SummaryHeaderID 
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN wavetelwholesaleRM.tblAccount a
			ON sh.AccountID = a.AccountID
		WHERE dd.date BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.AccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR sh.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR sh.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR sh.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);
		
		
		
	END IF;
	
	IF p_Detail = 2
	THEN
	
		DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageSummary_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageSummary_(
				`DateID` BIGINT(20) NOT NULL,
				`TimeID` INT(11) NOT NULL,
				`CompanyID` INT(11) NOT NULL,
				`AccountID` INT(11) NOT NULL,
				`GatewayAccountID` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`CompanyGatewayID` INT(11) NOT NULL,
				`Trunk` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`CountryID` INT(11) NULL DEFAULT NULL,
				`TotalCharges` DOUBLE NULL DEFAULT NULL,
				`TotalBilledDuration` INT(11) NULL DEFAULT NULL,
				`TotalDuration` INT(11) NULL DEFAULT NULL,
				`NoOfCalls` INT(11) NULL DEFAULT NULL,
				`NoOfFailCalls` INT(11) NULL DEFAULT NULL,
				`AccountName` varchar(100),
				INDEX `tblUsageSummary_dim_date` (`DateID`)
		);
		
		INSERT INTO tmp_tblUsageSummary_
		SELECT
			sh.DateID,
			dt.TimeID,
			sh.CompanyID,
			sh.AccountID,
			sh.GatewayAccountID,
			sh.CompanyGatewayID,
			sh.Trunk,
			sh.AreaPrefix,
			sh.CountryID,
			usd.TotalCharges,
			usd.TotalBilledDuration,
			usd.TotalDuration,
			usd.NoOfCalls,
			usd.NoOfFailCalls,
			a.AccountName
		FROM tblSummaryHeader sh
		INNER JOIN tblUsageSummaryDetail usd
			ON usd.SummaryHeaderID = sh.SummaryHeaderID 
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN tblDimTime dt
			ON dt.TimeID = usd.TimeID
		INNER JOIN wavetelwholesaleRM.tblAccount a
			ON sh.AccountID = a.AccountID
		WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
		AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.AccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR sh.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR sh.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR sh.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);
		
		INSERT INTO tmp_tblUsageSummary_
		SELECT
			sh.DateID,
			dt.TimeID,
			sh.CompanyID,
			sh.AccountID,
			sh.GatewayAccountID,
			sh.CompanyGatewayID,
			sh.Trunk,
			sh.AreaPrefix,
			sh.CountryID,
			usd.TotalCharges,
			usd.TotalBilledDuration,
			usd.TotalDuration,
			usd.NoOfCalls,
			usd.NoOfFailCalls,
			a.AccountName
		FROM tblSummaryHeader sh
		INNER JOIN tblUsageSummaryDetailLive usd
			ON usd.SummaryHeaderID = sh.SummaryHeaderID 
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN tblDimTime dt
			ON dt.TimeID = usd.TimeID
		INNER JOIN wavetelwholesaleRM.tblAccount a
			ON sh.AccountID = a.AccountID
		WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
		AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.AccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR sh.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR sh.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR sh.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);			
		
	END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnUsageSummaryDetail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnUsageSummaryDetail`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` TEXT,
	IN `p_AccountID` TEXT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` TEXT,
	IN `p_Trunk` TEXT,
	IN `p_CountryID` TEXT,
	IN `p_UserID` INT ,
	IN `p_isAdmin` INT

)
BEGIN
	
	DECLARE i INTEGER;

	DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageSummary_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageSummary_(
			`DateID` BIGINT(20) NOT NULL,
			`TimeID` INT(11) NOT NULL,
			`Time` VARCHAR(50) NOT NULL,
			`CompanyID` INT(11) NOT NULL,
			`AccountID` INT(11) NOT NULL,
			`GatewayAccountID` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
			`CompanyGatewayID` INT(11) NOT NULL,
			`Trunk` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
			`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
			`CountryID` INT(11) NULL DEFAULT NULL,
			`TotalCharges` DOUBLE NULL DEFAULT NULL,
			`TotalBilledDuration` INT(11) NULL DEFAULT NULL,
			`TotalDuration` INT(11) NULL DEFAULT NULL,
			`NoOfCalls` INT(11) NULL DEFAULT NULL,
			`NoOfFailCalls` INT(11) NULL DEFAULT NULL,
			`AccountName` varchar(100),
			INDEX `tblUsageSummary_dim_date` (`DateID`)
	);
	
	DROP TEMPORARY TABLE IF EXISTS tmp_AreaPrefix_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_AreaPrefix_ (
		`Code` Text NULL DEFAULT NULL
	);
    
	SET i = 1;
	REPEAT
		INSERT INTO tmp_AreaPrefix_ ( Code)
		SELECT wavetelwholesaleRM.FnStringSplit(p_AreaPrefix, ',', i) FROM tblDimDate WHERE wavetelwholesaleRM.FnStringSplit(p_AreaPrefix, ',', i) IS NOT NULL LIMIT 1;
		SET i = i + 1;
		UNTIL ROW_COUNT() = 0
	END REPEAT;
		
	INSERT INTO tmp_tblUsageSummary_
	SELECT
		sh.DateID,
		dt.TimeID,
		CONCAT(dd.date,' ',dt.fulltime),
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		usd.TotalCharges,
		usd.TotalBilledDuration,
		usd.TotalDuration,
		usd.NoOfCalls,
		usd.NoOfFailCalls,
		a.AccountName
	FROM tblSummaryHeader sh
	INNER JOIN tblUsageSummaryDetail usd
		ON usd.SummaryHeaderID = sh.SummaryHeaderID 
	INNER JOIN tblDimDate dd
		ON dd.DateID = sh.DateID
	INNER JOIN tblDimTime dt
		ON dt.TimeID = usd.TimeID
	INNER JOIN wavetelwholesaleRM.tblAccount a
		ON sh.AccountID = a.AccountID
	LEFT JOIN wavetelwholesaleRM.tblTrunk t
		ON t.Trunk = sh.Trunk
	LEFT JOIN tmp_AreaPrefix_ ap 
		ON sh.AreaPrefix LIKE REPLACE(ap.Code, '*', '%')
	WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
	AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
	AND sh.CompanyID = p_CompanyID
	AND (p_AccountID = '' OR FIND_IN_SET(sh.AccountID,p_AccountID))
	AND (p_CompanyGatewayID = '' OR FIND_IN_SET(sh.CompanyGatewayID,p_CompanyGatewayID))
	AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
	AND (p_Trunk = '' OR FIND_IN_SET(t.TrunkID,p_Trunk))
	AND (p_CountryID = '' OR FIND_IN_SET(sh.CountryID,p_CountryID))
	AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
	AND (p_AreaPrefix ='' OR ap.Code IS NOT NULL);
		
	INSERT INTO tmp_tblUsageSummary_
	SELECT
		sh.DateID,
		dt.TimeID,
		CONCAT(dd.date,' ',dt.fulltime),
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		usd.TotalCharges,
		usd.TotalBilledDuration,
		usd.TotalDuration,
		usd.NoOfCalls,
		usd.NoOfFailCalls,
		a.AccountName
	FROM tblSummaryHeader sh
	INNER JOIN tblUsageSummaryDetailLive usd
		ON usd.SummaryHeaderID = sh.SummaryHeaderID 
	INNER JOIN tblDimDate dd
		ON dd.DateID = sh.DateID
	INNER JOIN tblDimTime dt
		ON dt.TimeID = usd.TimeID
	INNER JOIN wavetelwholesaleRM.tblAccount a
		ON sh.AccountID = a.AccountID
	LEFT JOIN wavetelwholesaleRM.tblTrunk t
		ON t.Trunk = sh.Trunk
	LEFT JOIN tmp_AreaPrefix_ ap 
		ON (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(ap.Code, '*', '%') )
	WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
	AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
	AND sh.CompanyID = p_CompanyID
	AND (p_AccountID = '' OR FIND_IN_SET(sh.AccountID,p_AccountID))
	AND (p_CompanyGatewayID = '' OR FIND_IN_SET(sh.CompanyGatewayID,p_CompanyGatewayID))
	AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
	AND (p_Trunk = '' OR FIND_IN_SET(t.TrunkID,p_Trunk))
	AND (p_CountryID = '' OR FIND_IN_SET(sh.CountryID,p_CountryID))
	AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
	AND (p_AreaPrefix ='' OR ap.Code IS NOT NULL);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnUsageVendorSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnUsageVendorSummary`(
	IN `p_CompanyID` int ,
	IN `p_CompanyGatewayID` int ,
	IN `p_AccountID` int ,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` datetime ,
	IN `p_EndDate` datetime ,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT ,
	IN `p_isAdmin` INT,
	IN `p_Detail` INT

)
BEGIN
	DECLARE v_TimeId_ INT;
	
	IF DATEDIFF(p_EndDate,p_StartDate) > 31 AND p_Detail =2
	THEN
		SET p_Detail = 1;
	END IF;
	
	IF p_Detail = 1 
	THEN
	
		DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageVendorSummary_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageVendorSummary_(
				`DateID` BIGINT(20) NOT NULL,
				`CompanyID` INT(11) NOT NULL,
				`AccountID` INT(11) NOT NULL,
				`GatewayAccountID` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`CompanyGatewayID` INT(11) NOT NULL,
				`Trunk` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`CountryID` INT(11) NULL DEFAULT NULL,
				`TotalCharges` DOUBLE NULL DEFAULT NULL,
				`TotalBilledDuration` INT(11) NULL DEFAULT NULL,
				`TotalDuration` INT(11) NULL DEFAULT NULL,
				`NoOfCalls` INT(11) NULL DEFAULT NULL,
				`NoOfFailCalls` INT(11) NULL DEFAULT NULL,
				`AccountName` varchar(100),
				INDEX `tblUsageSummary_dim_date` (`DateID`)
		);
		INSERT INTO tmp_tblUsageVendorSummary_
		SELECT
			sh.DateID,
			sh.CompanyID,
			sh.AccountID,
			sh.GatewayAccountID,
			sh.CompanyGatewayID,
			sh.Trunk,
			sh.AreaPrefix,
			sh.CountryID,
			us.TotalCharges,
			us.TotalBilledDuration,
			us.TotalDuration,
			us.NoOfCalls,
			us.NoOfFailCalls,
			a.AccountName
		FROM tblSummaryVendorHeader sh
		INNER JOIN tblUsageVendorSummary us
			ON us.SummaryVendorHeaderID = sh.SummaryVendorHeaderID 
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN wavetelwholesaleRM.tblAccount a
			ON sh.AccountID = a.AccountID
		WHERE dd.date BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.AccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR sh.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR sh.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR sh.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);
		
		INSERT INTO tmp_tblUsageVendorSummary_
		SELECT
			sh.DateID,
			sh.CompanyID,
			sh.AccountID,
			sh.GatewayAccountID,
			sh.CompanyGatewayID,
			sh.Trunk,
			sh.AreaPrefix,
			sh.CountryID,
			us.TotalCharges,
			us.TotalBilledDuration,
			us.TotalDuration,
			us.NoOfCalls,
			us.NoOfFailCalls,
			a.AccountName
		FROM tblSummaryVendorHeader sh
		INNER JOIN tblUsageVendorSummaryLive us
			ON us.SummaryVendorHeaderID = sh.SummaryVendorHeaderID 
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN wavetelwholesaleRM.tblAccount a
			ON sh.AccountID = a.AccountID
		WHERE dd.date BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.AccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR sh.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR sh.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR sh.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);
		
		
	END IF;
	
	IF p_Detail = 2 
	THEN
	
		DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageVendorSummary_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageVendorSummary_(
				`DateID` BIGINT(20) NOT NULL,
				`TimeID` INT(11) NOT NULL,
				`CompanyID` INT(11) NOT NULL,
				`AccountID` INT(11) NOT NULL,
				`GatewayAccountID` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`CompanyGatewayID` INT(11) NOT NULL,
				`Trunk` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`CountryID` INT(11) NULL DEFAULT NULL,
				`TotalCharges` DOUBLE NULL DEFAULT NULL,
				`TotalBilledDuration` INT(11) NULL DEFAULT NULL,
				`TotalDuration` INT(11) NULL DEFAULT NULL,
				`NoOfCalls` INT(11) NULL DEFAULT NULL,
				`NoOfFailCalls` INT(11) NULL DEFAULT NULL,
				`AccountName` varchar(100),
				INDEX `tblUsageSummary_dim_date` (`DateID`)
		);
		
		INSERT INTO tmp_tblUsageVendorSummary_
		SELECT
			sh.DateID,
			dt.TimeID,
			sh.CompanyID,
			sh.AccountID,
			sh.GatewayAccountID,
			sh.CompanyGatewayID,
			sh.Trunk,
			sh.AreaPrefix,
			sh.CountryID,
			usd.TotalCharges,
			usd.TotalBilledDuration,
			usd.TotalDuration,
			usd.NoOfCalls,
			usd.NoOfFailCalls,
			a.AccountName
		FROM tblSummaryVendorHeader sh
		INNER JOIN tblUsageVendorSummaryDetail usd
			ON usd.SummaryVendorHeaderID = sh.SummaryVendorHeaderID 
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN tblDimTime dt
			ON dt.TimeID = usd.TimeID
		INNER JOIN wavetelwholesaleRM.tblAccount a
			ON sh.AccountID = a.AccountID
		WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
		AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.AccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR sh.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR sh.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR sh.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);
		
		INSERT INTO tmp_tblUsageVendorSummary_
		SELECT
			sh.DateID,
			dt.TimeID,
			sh.CompanyID,
			sh.AccountID,
			sh.GatewayAccountID,
			sh.CompanyGatewayID,
			sh.Trunk,
			sh.AreaPrefix,
			sh.CountryID,
			usd.TotalCharges,
			usd.TotalBilledDuration,
			usd.TotalDuration,
			usd.NoOfCalls,
			usd.NoOfFailCalls,
			a.AccountName
		FROM tblSummaryVendorHeader sh
		INNER JOIN tblUsageVendorSummaryDetailLive usd
			ON usd.SummaryVendorHeaderID = sh.SummaryVendorHeaderID 
		INNER JOIN tblDimDate dd
			ON dd.DateID = sh.DateID
		INNER JOIN tblDimTime dt
			ON dt.TimeID = usd.TimeID
		INNER JOIN wavetelwholesaleRM.tblAccount a
			ON sh.AccountID = a.AccountID
		WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
		AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
		AND sh.CompanyID = p_CompanyID
		AND (p_AccountID = 0 OR sh.AccountID = p_AccountID)
		AND (p_CompanyGatewayID = 0 OR sh.CompanyGatewayID = p_CompanyGatewayID)
		AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
		AND (p_Trunk = '' OR sh.Trunk LIKE REPLACE(p_Trunk, '*', '%'))
		AND (p_AreaPrefix = '' OR sh.AreaPrefix LIKE REPLACE(p_AreaPrefix, '*', '%') )
		AND (p_CountryID = 0 OR sh.CountryID = p_CountryID)
		AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID);
		
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fnUsageVendorSummaryDetail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `fnUsageVendorSummaryDetail`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` TEXT,
	IN `p_AccountID` TEXT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` TEXT,
	IN `p_Trunk` TEXT,
	IN `p_CountryID` TEXT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT


)
BEGIN
	
	DECLARE i INTEGER;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageVendorSummary_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageVendorSummary_(
			`DateID` BIGINT(20) NOT NULL,
			`TimeID` INT(11) NOT NULL,
			`Time` VARCHAR(50) NOT NULL,
			`CompanyID` INT(11) NOT NULL,
			`AccountID` INT(11) NOT NULL,
			`GatewayAccountID` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
			`CompanyGatewayID` INT(11) NOT NULL,
			`Trunk` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
			`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
			`CountryID` INT(11) NULL DEFAULT NULL,
			`TotalCharges` DOUBLE NULL DEFAULT NULL,
			`TotalBilledDuration` INT(11) NULL DEFAULT NULL,
			`TotalDuration` INT(11) NULL DEFAULT NULL,
			`NoOfCalls` INT(11) NULL DEFAULT NULL,
			`NoOfFailCalls` INT(11) NULL DEFAULT NULL,
			`AccountName` varchar(100),
			INDEX `tblUsageSummary_dim_date` (`DateID`)
	);
	
	DROP TEMPORARY TABLE IF EXISTS tmp_AreaPrefix_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_AreaPrefix_ (
		`Code` Text NULL DEFAULT NULL
	);
    
	SET i = 1;
	REPEAT
		INSERT INTO tmp_AreaPrefix_ ( Code)
		SELECT wavetelwholesaleRM.FnStringSplit(p_AreaPrefix, ',', i) FROM tblDimDate WHERE wavetelwholesaleRM.FnStringSplit(p_AreaPrefix, ',', i) IS NOT NULL LIMIT 1;
		SET i = i + 1;
		UNTIL ROW_COUNT() = 0
	END REPEAT;
	
	INSERT INTO tmp_tblUsageVendorSummary_
	SELECT
		sh.DateID,
		dt.TimeID,
		CONCAT(dd.date,' ',dt.fulltime),
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		usd.TotalCharges,
		usd.TotalBilledDuration,
		usd.TotalDuration,
		usd.NoOfCalls,
		usd.NoOfFailCalls,
		a.AccountName
	FROM tblSummaryVendorHeader sh
	INNER JOIN tblUsageVendorSummaryDetail usd
		ON usd.SummaryVendorHeaderID = sh.SummaryVendorHeaderID 
	INNER JOIN tblDimDate dd
		ON dd.DateID = sh.DateID
	INNER JOIN tblDimTime dt
		ON dt.TimeID = usd.TimeID
	INNER JOIN wavetelwholesaleRM.tblAccount a
		ON sh.AccountID = a.AccountID
	LEFT JOIN wavetelwholesaleRM.tblTrunk t
		ON t.Trunk = sh.Trunk
	LEFT JOIN tmp_AreaPrefix_ ap 
		ON sh.AreaPrefix LIKE REPLACE(ap.Code, '*', '%')
	WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
	AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
	AND sh.CompanyID = p_CompanyID
	AND (p_AccountID = '' OR FIND_IN_SET(sh.AccountID,p_AccountID))
	AND (p_CompanyGatewayID = '' OR FIND_IN_SET(sh.CompanyGatewayID,p_CompanyGatewayID))
	AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
	AND (p_Trunk = '' OR FIND_IN_SET(t.TrunkID,p_Trunk))
	AND (p_CountryID = '' OR FIND_IN_SET(sh.CountryID,p_CountryID))
	AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
	AND (p_AreaPrefix ='' OR ap.Code IS NOT NULL);
	
	INSERT INTO tmp_tblUsageVendorSummary_
	SELECT
		sh.DateID,
		dt.TimeID,
		CONCAT(dd.date,' ',dt.fulltime),
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		usd.TotalCharges,
		usd.TotalBilledDuration,
		usd.TotalDuration,
		usd.NoOfCalls,
		usd.NoOfFailCalls,
		a.AccountName
	FROM tblSummaryVendorHeader sh
	INNER JOIN tblUsageVendorSummaryDetailLive usd
		ON usd.SummaryVendorHeaderID = sh.SummaryVendorHeaderID 
	INNER JOIN tblDimDate dd
		ON dd.DateID = sh.DateID
	INNER JOIN tblDimTime dt
		ON dt.TimeID = usd.TimeID
	INNER JOIN wavetelwholesaleRM.tblAccount a
		ON sh.AccountID = a.AccountID
	LEFT JOIN wavetelwholesaleRM.tblTrunk t
		ON t.Trunk = sh.Trunk
	LEFT JOIN tmp_AreaPrefix_ ap 
		ON sh.AreaPrefix LIKE REPLACE(ap.Code, '*', '%')
	WHERE dd.date BETWEEN DATE(p_StartDate) AND DATE(p_EndDate)
	AND CONCAT(dd.date,' ',dt.fulltime) BETWEEN p_StartDate AND p_EndDate
	AND sh.CompanyID = p_CompanyID
	AND (p_AccountID = '' OR FIND_IN_SET(sh.AccountID,p_AccountID))
	AND (p_CompanyGatewayID = '' OR FIND_IN_SET(sh.CompanyGatewayID,p_CompanyGatewayID))
	AND (p_isAdmin = 1 OR (p_isAdmin= 0 AND a.Owner = p_UserID))
	AND (p_Trunk = '' OR FIND_IN_SET(t.TrunkID,p_Trunk))
	AND (p_CountryID = '' OR FIND_IN_SET(sh.CountryID,p_CountryID))
	AND (p_CurrencyID = 0 OR a.CurrencyId = p_CurrencyID)
	AND (p_AreaPrefix ='' OR ap.Code IS NOT NULL);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_datedimbuild` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_datedimbuild`(IN `p_start_date` DATE, IN `p_end_date` DATE)
BEGIN
    DECLARE v_full_date DATE;

     DELETE FROM tblDimDate;

    SET v_full_date = p_start_date;
    WHILE v_full_date < p_end_date DO

        INSERT INTO tblDimDate (
            	`date`,
					`day`,
					`day_abbrev`,
					`day_of_week`,
					`day_of_month`,
					`day_of_quarter`,
					`day_of_semester`,
					`day_of_year`,
					`weekend`,
					`week_of_month`,
					`week_of_quarter`,
					`week_of_semester`,
					`week_of_year`,
					`month`,
					`month_abbrev`,
					`month_of_quarter`,
					`month_of_year`,
					`quarter_of_year`,
					`previous_day`,
					`next_day`,
					`start_week`,
					`end_week`,
					`start_month`,
					`end_month`,
					`start_quarter`,
					`end_quarter`,
					`year`,
					`week_month_name`,
					`week_quarter_name`,
					`week_year_name`,
					`month_quarter_name`,
					`month_year_name`,
					`quarter_year_name`
        ) VALUES (
        			v_full_date,
					DATE_FORMAT( v_full_date , "%W" ),
					DATE_FORMAT( v_full_date , "%a"),
					DAYOFWEEK(v_full_date),
					DAYOFMONTH(v_full_date),
					NULL,
					NULL,
					DAYOFYEAR(v_full_date),
					IF( DATE_FORMAT( v_full_date, "%W" ) IN ('Saturday','Sunday'), 'Weekend', 'Weekday'),
					WEEK(v_full_date) - WEEK(DATE_ADD(v_full_date,INTERVAL -DAY(v_full_date)+1 DAY)),
					NULL,
					NULL,
					WEEKOFYEAR(v_full_date),
					DATE_FORMAT( v_full_date , "%M"),
					DATE_FORMAT( v_full_date , "%b"),
					MOD(MONTH('2016-02-20')-1,3)+1,
					MONTH(v_full_date),
					QUARTER(v_full_date),
					DATE_ADD(v_full_date, INTERVAL -1 DAY),
					DATE_ADD(v_full_date, INTERVAL +1 DAY),
					v_full_date,
					v_full_date,
					v_full_date,
					v_full_date,
					v_full_date,
					v_full_date,
					YEAR(v_full_date),
					CONCAT(WEEK(v_full_date) - WEEK(DATE_ADD(v_full_date,INTERVAL -DAY(v_full_date)+1 DAY)),'-',DATE_FORMAT( v_full_date , "%M")),
					NULL,
					CONCAT(WEEK(date),'-',DATE_FORMAT( date , "%Y")),
					NULL,
					CONCAT(month_abbrev,'-',year),
					CONCAT(quarter_of_year,'-',year)
        );

        SET v_full_date = DATE_ADD(v_full_date, INTERVAL 1 DAY);
    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_generateSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_generateSummary`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE

)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
	
		SELECT @p2 as Message;
		ROLLBACK;
	END;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	CALL fnGetCountry();
	CALL fngetDefaultCodes(p_CompanyID); 
	CALL fnGetUsageForSummary(p_CompanyID,p_StartDate,p_EndDate);
 
 	
 	DELETE FROM tmp_UsageSummary WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_UsageSummary(DateID,TimeID,CompanyID,CompanyGatewayID,GatewayAccountID,AccountID,Trunk,AreaPrefix,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT 
		d.DateID,
		t.TimeID,
		ud.CompanyID,
		ud.CompanyGatewayID,
		ANY_VALUE(ud.GatewayAccountID),
		ud.AccountID,
		ud.trunk,
		ud.area_prefix,
		COALESCE(SUM(ud.cost),0)  AS TotalCharges ,
		COALESCE(SUM(ud.billed_duration),0) AS TotalBilledDuration ,
		COALESCE(SUM(ud.duration),0) AS TotalDuration,
		SUM(IF(ud.call_status=1,1,0)) AS  NoOfCalls,
		SUM(IF(ud.call_status=2,1,0)) AS  NoOfFailCalls
	FROM tmp_tblUsageDetailsReport ud  
	INNER JOIN tblDimTime t ON t.fulltime = connect_time
	INNER JOIN tblDimDate d ON d.date = connect_date
	GROUP BY d.DateID,t.TimeID,ud.area_prefix,ud.trunk,ud.AccountID,ud.CompanyGatewayID,ud.CompanyID;

	UPDATE tmp_UsageSummary 
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_UsageSummary.CountryID =code.CountryID
	WHERE tmp_UsageSummary.CompanyID = p_CompanyID AND code.CountryID > 0;

	UPDATE tmp_UsageSummary
	INNER JOIN (SELECT DISTINCT AreaPrefix,tblCountry.CountryID FROM tmp_UsageSummary 	INNER JOIN  temptblCountry AS tblCountry ON AreaPrefix LIKE CONCAT(Prefix , "%")) TBL
	ON tmp_UsageSummary.AreaPrefix = TBL.AreaPrefix
	SET tmp_UsageSummary.CountryID =TBL.CountryID 
	WHERE tmp_UsageSummary.CompanyID = p_CompanyID AND tmp_UsageSummary.CountryID IS NULL;
	DELETE FROM tmp_SummaryHeader WHERE CompanyID = p_CompanyID;
 	
	INSERT INTO tmp_SummaryHeader (SummaryHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_UsageSummary)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;
	
	START TRANSACTION;
	
	INSERT INTO tblSummaryHeader (DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT us.DateID,us.CompanyID,us.AccountID,ANY_VALUE(us.GatewayAccountID),us.CompanyGatewayID,us.Trunk,us.AreaPrefix,ANY_VALUE(us.CountryID),now() 
	FROM tmp_UsageSummary us
	LEFT JOIN tmp_SummaryHeader sh	 
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	WHERE sh.SummaryHeaderID IS NULL
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.Trunk,us.AreaPrefix;
	
	DELETE FROM tmp_SummaryHeader WHERE CompanyID = p_CompanyID;
 	
	INSERT INTO tmp_SummaryHeader (SummaryHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_UsageSummary)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	DELETE us FROM tblUsageSummary us 
	INNER JOIN tblSummaryHeader sh ON us.SummaryHeaderID = sh.SummaryHeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;
	
	DELETE usd FROM tblUsageSummaryDetail usd
	INNER JOIN tblSummaryHeader sh ON usd.SummaryHeaderID = sh.SummaryHeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;
	
	INSERT INTO tblUsageSummary (SummaryHeaderID,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT ANY_VALUE(sh.SummaryHeaderID),SUM(us.TotalCharges),SUM(us.TotalBilledDuration),SUM(us.TotalDuration),SUM(us.NoOfCalls),SUM(us.NoOfFailCalls)
	FROM tmp_SummaryHeader sh
	INNER JOIN tmp_UsageSummary us FORCE INDEX (Unique_key)	 
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.Trunk,us.AreaPrefix;
	
	INSERT INTO tblUsageSummaryDetail (SummaryHeaderID,TimeID,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT sh.SummaryHeaderID,TimeID,us.TotalCharges,us.TotalBilledDuration,us.TotalDuration,us.NoOfCalls,us.NoOfFailCalls
	FROM tmp_SummaryHeader sh
	INNER JOIN tmp_UsageSummary us FORCE INDEX (Unique_key)
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix;

	COMMIT;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_generateSummaryLive` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_generateSummaryLive`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE

)
BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
	
		SELECT @p2 as Message;
		ROLLBACK;
	END;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	CALL fnGetCountry();
	CALL fngetDefaultCodes(p_CompanyID); 
	CALL fnGetUsageForSummaryLive(p_CompanyID, p_StartDate, p_EndDate);
	 
 	
 	DELETE FROM tmp_UsageSummaryLive WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_UsageSummaryLive(DateID,TimeID,CompanyID,CompanyGatewayID,GatewayAccountID,AccountID,Trunk,AreaPrefix,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT 
		d.DateID,
		t.TimeID,
		ud.CompanyID,
		ud.CompanyGatewayID,
		ANY_VALUE(ud.GatewayAccountID),
		ud.AccountID,
		ud.trunk,
		ud.area_prefix,
		COALESCE(SUM(ud.cost),0)  AS TotalCharges ,
		COALESCE(SUM(ud.billed_duration),0) AS TotalBilledDuration ,
		COALESCE(SUM(ud.duration),0) AS TotalDuration,
		SUM(IF(ud.call_status=1,1,0)) AS  NoOfCalls,
		SUM(IF(ud.call_status=2,1,0)) AS  NoOfFailCalls
	FROM tmp_tblUsageDetailsReportLive ud  
	INNER JOIN tblDimTime t ON t.fulltime = connect_time
	INNER JOIN tblDimDate d ON d.date = connect_date
	GROUP BY d.DateID,t.TimeID,ud.area_prefix,ud.trunk,ud.AccountID,ud.CompanyGatewayID,ud.CompanyID;

	UPDATE tmp_UsageSummaryLive 
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_UsageSummaryLive.CountryID =code.CountryID
	WHERE tmp_UsageSummaryLive.CompanyID = p_CompanyID AND code.CountryID > 0;

	UPDATE tmp_UsageSummaryLive
	INNER JOIN (SELECT DISTINCT AreaPrefix,tblCountry.CountryID FROM tmp_UsageSummaryLive 	INNER JOIN  temptblCountry AS tblCountry ON AreaPrefix LIKE CONCAT(Prefix , "%")) TBL
	ON tmp_UsageSummaryLive.AreaPrefix = TBL.AreaPrefix
	SET tmp_UsageSummaryLive.CountryID =TBL.CountryID 
	WHERE tmp_UsageSummaryLive.CompanyID = p_CompanyID AND tmp_UsageSummaryLive.CountryID IS NULL ;

	DELETE FROM tmp_SummaryHeaderLive WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_SummaryHeaderLive (SummaryHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_UsageSummaryLive)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	START TRANSACTION;

	INSERT INTO tblSummaryHeader (DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT us.DateID,us.CompanyID,us.AccountID,ANY_VALUE(us.GatewayAccountID),us.CompanyGatewayID,us.Trunk,us.AreaPrefix,ANY_VALUE(us.CountryID),now() 
	FROM tmp_UsageSummaryLive us
	LEFT JOIN tmp_SummaryHeaderLive sh	 
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	WHERE sh.SummaryHeaderID IS NULL
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.Trunk,us.AreaPrefix;

	DELETE FROM tmp_SummaryHeaderLive WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_SummaryHeaderLive (SummaryHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_UsageSummaryLive)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	DELETE us FROM tblUsageSummaryLive us 
	INNER JOIN tblSummaryHeader sh ON us.SummaryHeaderID = sh.SummaryHeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE sh.CompanyID = p_CompanyID; 

	DELETE usd FROM tblUsageSummaryDetailLive usd
	INNER JOIN tblSummaryHeader sh ON usd.SummaryHeaderID = sh.SummaryHeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE sh.CompanyID = p_CompanyID;

	INSERT INTO tblUsageSummaryLive (SummaryHeaderID,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT ANY_VALUE(sh.SummaryHeaderID),SUM(us.TotalCharges),SUM(us.TotalBilledDuration),SUM(us.TotalDuration),SUM(us.NoOfCalls),SUM(us.NoOfFailCalls)
	FROM tmp_SummaryHeaderLive sh
	INNER JOIN tmp_UsageSummaryLive us FORCE INDEX (Unique_key)
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.Trunk,us.AreaPrefix; 
	
	INSERT INTO tblUsageSummaryDetailLive (SummaryHeaderID,TimeID,TotalCharges,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT sh.SummaryHeaderID,TimeID,us.TotalCharges,us.TotalBilledDuration,us.TotalDuration,us.NoOfCalls,us.NoOfFailCalls
	FROM tmp_SummaryHeaderLive sh
	INNER JOIN tmp_UsageSummaryLive us FORCE INDEX (Unique_key)
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix;	

	COMMIT;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_generateVendorSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_generateVendorSummary`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE

)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
	
		SELECT @p2 as Message;
		ROLLBACK;
	END;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	CALL fnGetCountry();
	CALL fngetDefaultCodes(p_CompanyID); 
	CALL fnGetVendorUsageForSummary(p_CompanyID,p_StartDate,p_EndDate);

 	
 	DELETE FROM tmp_VendorUsageSummary WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_VendorUsageSummary(DateID,TimeID,CompanyID,CompanyGatewayID,GatewayAccountID,AccountID,Trunk,AreaPrefix,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT 
		d.DateID,
		t.TimeID,
		ud.CompanyID,
		ud.CompanyGatewayID,
		ANY_VALUE(ud.GatewayAccountID),
		ud.AccountID,
		ud.trunk,
		ud.area_prefix,
		COALESCE(SUM(ud.buying_cost),0)  AS TotalCharges ,
		COALESCE(SUM(ud.selling_cost),0)  AS TotalSales ,
		COALESCE(SUM(ud.billed_duration),0) AS TotalBilledDuration ,
		COALESCE(SUM(ud.duration),0) AS TotalDuration,
		SUM(IF(ud.call_status=1,1,0)) AS  NoOfCalls,
		SUM(IF(ud.call_status=2,1,0)) AS  NoOfFailCalls
	FROM tmp_tblVendorUsageDetailsReport ud  
	INNER JOIN tblDimTime t ON t.fulltime = connect_time
	INNER JOIN tblDimDate d ON d.date = connect_date
	GROUP BY d.DateID,t.TimeID,ud.area_prefix,ud.trunk,ud.AccountID,ud.CompanyGatewayID,ud.CompanyID;

	UPDATE tmp_VendorUsageSummary 
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_VendorUsageSummary.CountryID =code.CountryID
	WHERE tmp_VendorUsageSummary.CompanyID = p_CompanyID AND code.CountryID > 0;

	UPDATE tmp_VendorUsageSummary
	INNER JOIN (SELECT DISTINCT AreaPrefix,tblCountry.CountryID FROM tmp_VendorUsageSummary 	INNER JOIN  temptblCountry AS tblCountry ON AreaPrefix LIKE CONCAT(Prefix , "%")) TBL
	ON tmp_VendorUsageSummary.AreaPrefix = TBL.AreaPrefix
	SET tmp_VendorUsageSummary.CountryID =TBL.CountryID 
	WHERE tmp_VendorUsageSummary.CompanyID = p_CompanyID AND tmp_VendorUsageSummary.CountryID IS NULL ;

	DELETE FROM tmp_SummaryVendorHeader WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_SummaryVendorHeader (SummaryVendorHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryVendorHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryVendorHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_VendorUsageSummary)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	START TRANSACTION;

	INSERT INTO tblSummaryVendorHeader (DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT us.DateID,us.CompanyID,us.AccountID,ANY_VALUE(us.GatewayAccountID),us.CompanyGatewayID,us.Trunk,us.AreaPrefix,ANY_VALUE(us.CountryID),now() 
	FROM tmp_VendorUsageSummary us
	LEFT JOIN tmp_SummaryVendorHeader sh	 
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	WHERE sh.SummaryVendorHeaderID IS NULL
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.Trunk,us.AreaPrefix;

	DELETE FROM tmp_SummaryVendorHeader WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_SummaryVendorHeader (SummaryVendorHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryVendorHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryVendorHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_VendorUsageSummary)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	DELETE us FROM tblUsageVendorSummary us 
	INNER JOIN tblSummaryVendorHeader sh ON us.SummaryVendorHeaderID = sh.SummaryVendorHeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;

	DELETE usd FROM tblUsageVendorSummaryDetail usd
	INNER JOIN tblSummaryVendorHeader sh ON usd.SummaryVendorHeaderID = sh.SummaryVendorHeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE date BETWEEN p_StartDate AND p_EndDate AND sh.CompanyID = p_CompanyID;

	INSERT INTO tblUsageVendorSummary (SummaryVendorHeaderID,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT ANY_VALUE(sh.SummaryVendorHeaderID),SUM(us.TotalCharges),SUM(us.TotalSales),SUM(us.TotalBilledDuration),SUM(us.TotalDuration),SUM(us.NoOfCalls),SUM(us.NoOfFailCalls)
	FROM tmp_SummaryVendorHeader sh
	INNER JOIN tmp_VendorUsageSummary us FORCE INDEX (Unique_key)	 
	ON 
		 sh.DateID = us.DateID
	AND sh.CompanyID = us.CompanyID
	AND sh.AccountID = us.AccountID
	AND sh.CompanyGatewayID = us.CompanyGatewayID
	AND sh.Trunk = us.Trunk
	AND sh.AreaPrefix = us.AreaPrefix
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.Trunk,us.AreaPrefix;

	INSERT INTO tblUsageVendorSummaryDetail (SummaryVendorHeaderID,TimeID,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT sh.SummaryVendorHeaderID,TimeID,us.TotalCharges,us.TotalSales,us.TotalBilledDuration,us.TotalDuration,us.NoOfCalls,us.NoOfFailCalls
	FROM tmp_SummaryVendorHeader sh
	INNER JOIN tmp_VendorUsageSummary us FORCE INDEX (Unique_key)
	ON 
		sh.DateID = us.DateID
	AND sh.CompanyID = us.CompanyID
	AND sh.AccountID = us.AccountID
	AND sh.CompanyGatewayID = us.CompanyGatewayID
	AND sh.Trunk = us.Trunk
	AND sh.AreaPrefix = us.AreaPrefix;
	
	COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_generateVendorSummaryLive` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_generateVendorSummaryLive`(
	IN `p_CompanyID` INT,
	IN `p_StartDate` DATE,
	IN `p_EndDate` DATE

)
BEGIN
	
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		
		GET DIAGNOSTICS CONDITION 1
		@p2 = MESSAGE_TEXT;
	
		SELECT @p2 as Message;
		ROLLBACK;
	END;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	CALL fnGetCountry();
	CALL fngetDefaultCodes(p_CompanyID); 
	CALL fnGetVendorUsageForSummaryLive(p_CompanyID, p_StartDate, p_EndDate);

 	
 	DELETE FROM tmp_VendorUsageSummaryLive WHERE CompanyID = p_CompanyID;
	INSERT INTO tmp_VendorUsageSummaryLive(DateID,TimeID,CompanyID,CompanyGatewayID,GatewayAccountID,AccountID,Trunk,AreaPrefix,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT 
		d.DateID,
		t.TimeID,
		ud.CompanyID,
		ud.CompanyGatewayID,
		ANY_VALUE(ud.GatewayAccountID),
		ud.AccountID,
		ud.trunk,
		ud.area_prefix,
		COALESCE(SUM(ud.buying_cost),0)  AS TotalCharges ,
		COALESCE(SUM(ud.selling_cost),0)  AS TotalSales ,
		COALESCE(SUM(ud.billed_duration),0) AS TotalBilledDuration ,
		COALESCE(SUM(ud.duration),0) AS TotalDuration,
		SUM(IF(ud.call_status=1,1,0)) AS  NoOfCalls,
		SUM(IF(ud.call_status=2,1,0)) AS  NoOfFailCalls
	FROM tmp_tblVendorUsageDetailsReportLive ud  
	INNER JOIN tblDimTime t ON t.fulltime = connect_time
	INNER JOIN tblDimDate d ON d.date = connect_date
	GROUP BY d.DateID,t.TimeID,ud.area_prefix,ud.trunk,ud.AccountID,ud.CompanyGatewayID,ud.CompanyID;

	UPDATE tmp_VendorUsageSummaryLive 
	INNER JOIN  tmp_codes_ as code ON AreaPrefix = code.code
	SET tmp_VendorUsageSummaryLive.CountryID =code.CountryID
	WHERE tmp_VendorUsageSummaryLive.CompanyID = p_CompanyID AND code.CountryID > 0;

	UPDATE tmp_VendorUsageSummaryLive
	INNER JOIN (SELECT DISTINCT AreaPrefix,tblCountry.CountryID FROM tmp_VendorUsageSummaryLive 	INNER JOIN  temptblCountry AS tblCountry ON AreaPrefix LIKE CONCAT(Prefix , "%")) TBL
	ON tmp_VendorUsageSummaryLive.AreaPrefix = TBL.AreaPrefix
	SET tmp_VendorUsageSummaryLive.CountryID =TBL.CountryID 
	WHERE tmp_VendorUsageSummaryLive.CompanyID = p_CompanyID AND tmp_VendorUsageSummaryLive.CountryID IS NULL ;

	DELETE FROM tmp_SummaryVendorHeaderLive WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_SummaryVendorHeaderLive (SummaryVendorHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryVendorHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryVendorHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_VendorUsageSummaryLive)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	START TRANSACTION;

	INSERT INTO tblSummaryVendorHeader (DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT us.DateID,us.CompanyID,us.AccountID,ANY_VALUE(us.GatewayAccountID),us.CompanyGatewayID,us.Trunk,us.AreaPrefix,ANY_VALUE(us.CountryID),now() 
	FROM tmp_VendorUsageSummaryLive us
	LEFT JOIN tmp_SummaryVendorHeaderLive sh	 
	ON 
		 us.DateID = sh.DateID
	AND us.CompanyID = sh.CompanyID
	AND us.AccountID = sh.AccountID
	AND us.CompanyGatewayID = sh.CompanyGatewayID
	AND us.Trunk = sh.Trunk
	AND us.AreaPrefix = sh.AreaPrefix
	WHERE sh.SummaryVendorHeaderID IS NULL
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.Trunk,us.AreaPrefix;

	DELETE FROM tmp_SummaryVendorHeaderLive WHERE CompanyID = p_CompanyID;

	INSERT INTO tmp_SummaryVendorHeaderLive (SummaryVendorHeaderID,DateID,CompanyID,AccountID,GatewayAccountID,CompanyGatewayID,Trunk,AreaPrefix,CountryID,created_at)
	SELECT 
		sh.SummaryVendorHeaderID,
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.GatewayAccountID,
		sh.CompanyGatewayID,
		sh.Trunk,
		sh.AreaPrefix,
		sh.CountryID,
		sh.created_at 
	FROM tblSummaryVendorHeader sh
	INNER JOIN (SELECT DISTINCT DateID,CompanyID FROM tmp_VendorUsageSummaryLive)TBL
	ON TBL.DateID = sh.DateID AND TBL.CompanyID = sh.CompanyID
	WHERE sh.CompanyID =  p_CompanyID ;

	DELETE us FROM tblUsageVendorSummaryLive us 
	INNER JOIN tblSummaryVendorHeader sh ON us.SummaryVendorHeaderID = sh.SummaryVendorHeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE sh.CompanyID = p_CompanyID;

	DELETE usd FROM tblUsageVendorSummaryDetailLive usd
	INNER JOIN tblSummaryVendorHeader sh ON usd.SummaryVendorHeaderID = sh.SummaryVendorHeaderID
	INNER JOIN tblDimDate d ON d.DateID = sh.DateID
	WHERE sh.CompanyID = p_CompanyID;

	INSERT INTO tblUsageVendorSummaryLive (SummaryVendorHeaderID,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT ANY_VALUE(sh.SummaryVendorHeaderID),SUM(us.TotalCharges),SUM(us.TotalSales),SUM(us.TotalBilledDuration),SUM(us.TotalDuration),SUM(us.NoOfCalls),SUM(us.NoOfFailCalls)
	FROM tmp_SummaryVendorHeaderLive sh
	INNER JOIN tmp_VendorUsageSummaryLive us FORCE INDEX (Unique_key)	 
	ON 
		 sh.DateID = us.DateID
	AND sh.CompanyID = us.CompanyID
	AND sh.AccountID = us.AccountID
	AND sh.CompanyGatewayID = us.CompanyGatewayID
	AND sh.Trunk = us.Trunk
	AND sh.AreaPrefix = us.AreaPrefix
	GROUP BY us.DateID,us.CompanyID,us.AccountID,us.CompanyGatewayID,us.Trunk,us.AreaPrefix;

	INSERT INTO tblUsageVendorSummaryDetailLive (SummaryVendorHeaderID,TimeID,TotalCharges,TotalSales,TotalBilledDuration,TotalDuration,NoOfCalls,NoOfFailCalls)
	SELECT sh.SummaryVendorHeaderID,TimeID,us.TotalCharges,us.TotalSales,us.TotalBilledDuration,us.TotalDuration,us.NoOfCalls,us.NoOfFailCalls
	FROM tmp_SummaryVendorHeaderLive sh
	INNER JOIN tmp_VendorUsageSummaryLive us FORCE INDEX (Unique_key)
	ON 
		 sh.DateID = us.DateID
	AND sh.CompanyID = us.CompanyID
	AND sh.AccountID = us.AccountID
	AND sh.CompanyGatewayID = us.CompanyGatewayID
	AND sh.Trunk = us.Trunk
	AND sh.AreaPrefix = us.AreaPrefix;

	COMMIT;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getAccountExpense` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getAccountExpense`(IN `p_CompanyID` INT, IN `p_AccountID` INT)
BEGIN
	DECLARE v_Round_ int;
	DECLARE v_DateID_ int;
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	SELECT MIN(DateID) INTO v_DateID_ FROM tblDimDate WHERE fnGetMonthDifference(date,NOW()) <= 12;

	DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageSummary_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageSummary_(
		`DateID` BIGINT(20) NOT NULL,
		`CompanyID` INT(11) NOT NULL,
		`AccountID` INT(11) NOT NULL,
		`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`TotalCharges` DOUBLE NULL DEFAULT NULL,
		`CustomerVendor` INT,
		INDEX `tmp_tblUsageSummary_DateID` (`DateID`)
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_tblUsageSummary2_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblUsageSummary2_(
		`DateID` BIGINT(20) NOT NULL,
		`CompanyID` INT(11) NOT NULL,
		`AccountID` INT(11) NOT NULL,
		`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`TotalCharges` DOUBLE NULL DEFAULT NULL,
		`CustomerVendor` INT,
		INDEX `tmp_tblUsageSummary_DateID` (`DateID`)
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_tblCustomerPrefix_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblCustomerPrefix_(
		`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`CustomerTotal` DOUBLE NULL DEFAULT NULL,
		`FinalTotal` DOUBLE NULL DEFAULT NULL,
		`YearMonth` VARCHAR(50) NOT NULL
	);
	DROP TEMPORARY TABLE IF EXISTS tmp_tblVendorPrefix_;
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_tblVendorPrefix_(
		`AreaPrefix` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`VendorTotal` DOUBLE NULL DEFAULT NULL,
		`FinalTotal` DOUBLE NULL DEFAULT NULL,
		`YearMonth` VARCHAR(50) NOT NULL
	);
	
	
	INSERT INTO tmp_tblUsageSummary_
	SELECT
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.AreaPrefix,
		us.TotalCharges,
		1 as Customer
	FROM tblSummaryHeader sh
	INNER JOIN tblUsageSummary us
		ON us.SummaryHeaderID = sh.SummaryHeaderID 
	WHERE  sh.CompanyID = p_CompanyID
	AND sh.AccountID = p_AccountID;
	
	INSERT INTO tmp_tblUsageSummary_
	SELECT
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.AreaPrefix,
		us.TotalCharges,
		1 as Customer
	FROM tblSummaryHeader sh
	INNER JOIN tblUsageSummaryLive us
		ON us.SummaryHeaderID = sh.SummaryHeaderID 
	WHERE  sh.CompanyID = p_CompanyID
	AND sh.AccountID = p_AccountID;
	
	
	INSERT INTO tmp_tblUsageSummary_
	SELECT
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.AreaPrefix,
		us.TotalCharges,
		2 as Vendor
	FROM tblSummaryVendorHeader sh
	INNER JOIN tblUsageVendorSummary us
		ON us.SummaryVendorHeaderID = sh.SummaryVendorHeaderID 
	WHERE  sh.CompanyID = p_CompanyID
	AND sh.AccountID = p_AccountID;
	
	INSERT INTO tmp_tblUsageSummary_
	SELECT
		sh.DateID,
		sh.CompanyID,
		sh.AccountID,
		sh.AreaPrefix,
		us.TotalCharges,
		2 as Vendor
	FROM tblSummaryVendorHeader sh
	INNER JOIN tblUsageVendorSummaryLive us
		ON us.SummaryVendorHeaderID = sh.SummaryVendorHeaderID 
	WHERE  sh.CompanyID = p_CompanyID
	AND sh.AccountID = p_AccountID;
	
	INSERT INTO tmp_tblUsageSummary2_
	SELECT * FROM tmp_tblUsageSummary_;
	
	
	SELECT 
		ROUND(SUM(IF(CustomerVendor=1,TotalCharges,0)),v_Round_) AS  CustomerTotal,
		ROUND(SUM(IF(CustomerVendor=2,TotalCharges,0)),v_Round_) AS  VendorTotal,
		dd.year as Year,
		dd.month_of_year as Month
	FROM tmp_tblUsageSummary_ us 
	INNER JOIN tblDimDate dd ON dd.DateID = us.DateID
	GROUP BY dd.year,dd.month_of_year;
	
	
	INSERT INTO tmp_tblCustomerPrefix_
	SELECT 
		us.AreaPrefix,
		ROUND(SUM(TotalCharges),2) AS  CustomerTotal,
		FinalTotal,
		CONCAT(dd.year,'-',dd.month_of_year) as YearMonth
	FROM tmp_tblUsageSummary_ us 
	INNER JOIN 
	(SELECT SUM(TotalCharges) as FinalTotal,AreaPrefix FROM tmp_tblUsageSummary2_ WHERE CustomerVendor = 1 AND AreaPrefix != 'other' AND DateID >= v_DateID_ GROUP BY AreaPrefix ORDER BY FinalTotal DESC LIMIT 5 ) tbl
	ON tbl.AreaPrefix = us.AreaPrefix
	INNER JOIN tblDimDate dd ON dd.DateID = us.DateID
	WHERE 
			 us.CustomerVendor = 1 
		AND us.AreaPrefix != 'other'
		AND dd.DateID >= v_DateID_
	GROUP BY dd.year,dd.month_of_year,us.AreaPrefix;
	
	
	
	IF (SELECT COUNT(*) FROM tmp_tblCustomerPrefix_) > 0
	THEN
		SET @sql = NULL;
		
		SELECT
			GROUP_CONCAT( DISTINCT CONCAT('MAX(IF(YearMonth = ''',YearMonth,''', CustomerTotal, 0)) AS ''',YearMonth,'''') ) INTO @sql
		FROM tmp_tblCustomerPrefix_;
	
		SET @sql = CONCAT('
							SELECT AreaPrefix , ', @sql, ' 
							FROM tmp_tblCustomerPrefix_ 
							GROUP BY AreaPrefix
							ORDER BY MAX(FinalTotal) desc, MAX(YearMonth)
						');
		
		PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	ELSE
		SELECT 0 as datacount;
	END IF;

	
	INSERT INTO tmp_tblVendorPrefix_
	SELECT 
		us.AreaPrefix,
		ROUND(SUM(TotalCharges),2) AS  VendorTotal,
		FinalTotal,
		CONCAT(dd.year,'-',dd.month_of_year) as YearMonth
	FROM tmp_tblUsageSummary_ us 
	INNER JOIN 
	(SELECT SUM(TotalCharges) as FinalTotal,AreaPrefix FROM tmp_tblUsageSummary2_ WHERE CustomerVendor = 2 AND AreaPrefix != 'other' AND DateID >= v_DateID_ GROUP BY AreaPrefix ORDER BY FinalTotal DESC LIMIT 5 ) tbl
	ON tbl.AreaPrefix = us.AreaPrefix
	INNER JOIN tblDimDate dd ON dd.DateID = us.DateID
	WHERE 
			 us.CustomerVendor = 2 
		AND us.AreaPrefix != 'other'
		AND dd.DateID >= v_DateID_
	GROUP BY dd.year,dd.month_of_year,us.AreaPrefix;

	
	
	IF (SELECT COUNT(*) FROM tmp_tblVendorPrefix_) > 0
	THEN
	
		SET @stm = NULL;
		SELECT
			GROUP_CONCAT( DISTINCT CONCAT('MAX(IF(YearMonth = ''',YearMonth,''', VendorTotal, 0)) AS ''',YearMonth,'''') ) INTO @stm
		FROM tmp_tblVendorPrefix_;

		SET @stm = CONCAT('
							SELECT AreaPrefix , ', @stm, ' 
							FROM tmp_tblVendorPrefix_ 
							GROUP BY AreaPrefix
							ORDER BY MAX(FinalTotal) desc, MAX(YearMonth)
						');
		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	ELSE
		SELECT 0 as datacount;	
	END IF;
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getAccountReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getAccountReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT AccountName ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,MAX(AccountID) as AccountID
	FROM tmp_tblUsageSummary_ us
	GROUP BY AccountName   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN AccountName
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN AccountName
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT AccountName ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT   AccountName  as Name ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT AccountName as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT AccountName as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT AccountName as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountName HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getACD_ASR_Alert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getACD_ASR_Alert`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` TEXT,
	IN `p_AccountID` TEXT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` TEXT,
	IN `p_Trunk` TEXT,
	IN `p_CountryID` TEXT
)
BEGIN
	
	DECLARE v_Round_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageSummaryDetail(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,0,1);

	IF p_AccountID = ''
	THEN
		SELECT
			IF(SUM(NoOfCalls)>0,COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls),0) as ACD , 
			ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			HOUR(ANY_VALUE(Time)) as Hour,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as Minutes,
			COALESCE(SUM(NoOfCalls),0) as Connected,
			COALESCE(SUM(NoOfCalls),0)+COALESCE(SUM(NoOfFailCalls),0) as Attempts
		FROM tmp_tblUsageSummary_ us;
		
	END IF;
	
	IF p_AccountID != ''
	THEN
		SELECT
			IF(SUM(NoOfCalls)>0,COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls),0) as ACD , 
			ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			AccountID,
			HOUR(ANY_VALUE(Time)) as Hour,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as Minutes,
			COALESCE(SUM(NoOfCalls),0) as Connected,
			COALESCE(SUM(NoOfCalls),0)+COALESCE(SUM(NoOfFailCalls),0) as Attempts
		FROM tmp_tblUsageSummary_ us
		GROUP BY AccountID;
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getDestinationReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getDestinationReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnGetCountry();
		 
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) as ASR
	FROM tmp_tblUsageSummary_ us
	LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
	WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
	GROUP BY c.Country   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryDESC') THEN Country
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryASC') THEN Country
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN IF(SUM(NoOfCalls)>0,(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN IF(SUM(NoOfCalls)>0,(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	

	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM(
		SELECT IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) as ASR
		FROM tmp_tblUsageSummary_ us
		LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY c.Country
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT SQL_CALC_FOUND_ROWS IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT Country as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT Country as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT Country as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getGatewayReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getGatewayReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT fnGetCompanyGatewayName(CompanyGatewayID) ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,CompanyGatewayID
	FROM tmp_tblUsageSummary_ us
	GROUP BY CompanyGatewayID   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GatewayDESC') THEN fnGetCompanyGatewayName(CompanyGatewayID)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GatewayASC') THEN fnGetCompanyGatewayName(CompanyGatewayID)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY CompanyGatewayID
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT   fnGetCompanyGatewayName(CompanyGatewayID)  as Name ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY CompanyGatewayID;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getHourlyReport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getHourlyReport`(
	IN `p_CompanyID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_AccountID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME
)
BEGIN
	
	DECLARE v_Round_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	CALL fnUsageSummary(p_CompanyID,0,p_AccountID,0,p_StartDate,p_EndDate,'','',0,p_UserID,p_isAdmin,2);
	
	
	SELECT ROUND(COALESCE(SUM(TotalCharges),0),v_Round_) as TotalCost FROM tmp_tblUsageSummary_;
	
	
	SELECT dt.hour as HOUR ,ROUND(COALESCE(SUM(TotalCharges),0),v_Round_) as TotalCost FROM tmp_tblUsageSummary_ us INNER JOIN tblDimTime dt on us.TimeID =  dt.TimeID GROUP BY dt.hour;
	
	
	SELECT ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes FROM tmp_tblUsageSummary_;
	
	
	SELECT dt.hour as HOUR ,ROUND(COALESCE(SUM(TotalBilledDuration),0) / 60,0) as TotalMinutes FROM tmp_tblUsageSummary_ us INNER JOIN tblDimTime dt on us.TimeID =  dt.TimeID GROUP BY dt.hour;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getPrefixReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getPrefixReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT AreaPrefix ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
	FROM tmp_tblUsageSummary_ us
	GROUP BY AreaPrefix   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AreaPrefixDESC') THEN AreaPrefix
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AreaPrefixASC') THEN AreaPrefix
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT AreaPrefix ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AreaPrefix
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT   AreaPrefix ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY AreaPrefix;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT AreaPrefix as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT AreaPrefix as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT AreaPrefix as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getReportByTime` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getReportByTime`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_ReportType` INT



)
BEGIN

	DECLARE v_Round_ INT;
	DECLARE V_Detail INT;

	SET V_Detail = 2;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,V_Detail);

	
	IF p_ReportType =1
	THEN
	
		SELECT 
			CONCAT(dt.hour,' Hour') as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tblDimTime dt on dt.TimeID = us.TimeID
		GROUP BY  us.DateID,dt.hour;

	END IF;

	
	IF p_ReportType =2
	THEN

		SELECT 
			dd.date as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  us.DateID;
	END IF;

	
	IF p_ReportType =3
	THEN

		SELECT 
			ANY_VALUE(dd.week_year_name) as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  dd.year,dd.week_of_year
		ORDER BY dd.year,dd.week_of_year;

	END IF;

	
	IF p_ReportType =4
	THEN

		SELECT 
			ANY_VALUE(dd.month_year_name) as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  dd.year,dd.month_of_year
		ORDER BY dd.year,dd.month_of_year;

	END IF;

	
	IF p_ReportType =5
	THEN

		SELECT 
			CONCAT('Q-',ANY_VALUE(dd.quarter_year_name)) as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  dd.year,dd.quarter_of_year
		ORDER BY dd.year,dd.quarter_of_year;

	END IF;

	
	IF p_ReportType =6
	THEN

		SELECT 
			dd.year as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  dd.year;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getTrunkReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getTrunkReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT Trunk ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
	FROM tmp_tblUsageSummary_ us
	GROUP BY Trunk   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TrunkDESC') THEN Trunk
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TrunkASC') THEN Trunk
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT Trunk ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY Trunk
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT   Trunk ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		GROUP BY Trunk;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT Trunk as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT Trunk as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT Trunk as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getUnbilledReport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getUnbilledReport`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_LastInvoiceDate` DATETIME,
	IN `p_Today` DATETIME,
	IN `p_Detail` INT
)
BEGIN
	
	DECLARE v_Round_ INT;
	DECLARE v_Detail_ INT;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	IF p_Detail = 3
	THEN 
		SET v_Detail_ = 1;
	ELSE 
		SET v_Detail_ = p_Detail;
	END IF;
	
	
	CALL fnUsageSummary(p_CompanyID,0,p_AccountID,0,p_LastInvoiceDate,p_Today,'','',0,0,1,v_Detail_);
	
	IF p_Detail = 1
	THEN
	
		SELECT 
			dd.date,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY us.DateID;
	
	END IF;
	
	IF p_Detail = 2
	THEN
	
		SELECT 
			dd.date,
			dt.fulltime,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		INNER JOIN tblDimTime dt on dt.TimeID = us.TimeID
		GROUP BY us.DateID,us.TimeID;
	
	END IF;
	
	IF p_Detail = 3
	THEN
	
		DROP TEMPORARY TABLE IF EXISTS tmp_FinalAmount_;
		CREATE TEMPORARY TABLE tmp_FinalAmount_  (
			FinalAmount DOUBLE
		);
		INSERT INTO tmp_FinalAmount_
		SELECT 
		ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
		FROM tmp_tblUsageSummary_ us;
	
	END IF;
 
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorAccountReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorAccountReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT AccountName ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,MAX(AccountID) as AccountID
	FROM tmp_tblUsageVendorSummary_ us
	GROUP BY AccountName   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameDESC') THEN AccountName
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AccountNameASC') THEN AccountName
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT AccountName ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountName
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT   AccountName  as Name ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountName;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT AccountName as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountName HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT AccountName as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountName HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT AccountName as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountName HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorACD_ASR_Alert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorACD_ASR_Alert`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` TEXT,
	IN `p_AccountID` TEXT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` TEXT,
	IN `p_Trunk` TEXT,
	IN `p_CountryID` TEXT
)
BEGIN
	
	DECLARE v_Round_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageVendorSummaryDetail(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,0,1);

	IF p_AccountID = ''
	THEN
		SELECT
			IF(SUM(NoOfCalls)>0,COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls),0) as ACD , 
			ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			HOUR(ANY_VALUE(Time)) as Hour,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as Minutes,
			COALESCE(SUM(NoOfCalls),0) as Connected,
			COALESCE(SUM(NoOfCalls),0)+COALESCE(SUM(NoOfFailCalls),0) as Attempts
		FROM tmp_tblUsageVendorSummary_ us;
		
	END IF;
	
	IF p_AccountID != ''
	THEN
		SELECT
			IF(SUM(NoOfCalls)>0,COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls),0) as ACD , 
			ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
			AccountID,
			HOUR(ANY_VALUE(Time)) as Hour,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as Minutes,
			COALESCE(SUM(NoOfCalls),0) as Connected,
			COALESCE(SUM(NoOfCalls),0)+COALESCE(SUM(NoOfFailCalls),0) as Attempts
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AccountID;
	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorBalanceReport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorBalanceReport`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` TEXT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME
)
BEGIN
	
	DECLARE v_Round_ INT;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageVendorSummaryDetail(p_CompanyID,'',p_AccountID,0,p_StartDate,p_EndDate,'','','',0,1);

	SELECT
		MAX(AccountName) as AccountName,
		IF(SUM(NoOfCalls)>0,COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls),0) as ACD , 
		ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
		AccountID,
		DATE(Time) as Date,
		HOUR(Time) as Hour,
		COALESCE(SUM(TotalCharges),0) as Cost,
		ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as Minutes,
		COALESCE(SUM(NoOfCalls),0) as Connected,
		COALESCE(SUM(NoOfCalls),0)+COALESCE(SUM(NoOfFailCalls),0) as Attempts
	FROM tmp_tblUsageVendorSummary_ us
	GROUP BY AccountID,DATE(Time),HOUR(Time);

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorDestinationReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorDestinationReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnGetCountry();
		 
	
	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) as ASR
	FROM tmp_tblUsageVendorSummary_ us
	LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
	WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
	GROUP BY c.Country   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryDESC') THEN Country
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CountryASC') THEN Country
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , IF(SUM(NoOfCalls)>0,ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_),0) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY c.Country
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT SQL_CALC_FOUND_ROWS IFNULL(Country,'Other') as Country ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		LEFT JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT Country as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT Country as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT Country as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN temptblCountry c ON c.CountryID = us.CountryID
		WHERE (p_CountryID = 0 OR c.CountryID = p_CountryID)
		GROUP BY Country HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorGatewayReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorGatewayReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT fnGetCompanyGatewayName(CompanyGatewayID) ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,CompanyGatewayID
	FROM tmp_tblUsageVendorSummary_ us
	GROUP BY CompanyGatewayID   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GatewayDESC') THEN fnGetCompanyGatewayName(CompanyGatewayID)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'GatewayASC') THEN fnGetCompanyGatewayName(CompanyGatewayID)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY CompanyGatewayID
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT   fnGetCompanyGatewayName(CompanyGatewayID)  as Name ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY CompanyGatewayID;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT fnGetCompanyGatewayName(CompanyGatewayID) as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.CompanyGatewayID != 'Other'
		GROUP BY CompanyGatewayID HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorPrefixReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorPrefixReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT AreaPrefix ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
	FROM tmp_tblUsageVendorSummary_ us
	GROUP BY AreaPrefix   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AreaPrefixDESC') THEN AreaPrefix
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'AreaPrefixASC') THEN AreaPrefix
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT AreaPrefix ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AreaPrefix
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT   AreaPrefix ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY AreaPrefix;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT AreaPrefix as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT AreaPrefix as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT AreaPrefix as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.AreaPrefix != 'Other'
		GROUP BY AreaPrefix HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorReportByTime` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorReportByTime`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT,
	IN `p_ReportType` INT

)
BEGIN

	DECLARE v_Round_ INT;
	DECLARE V_Detail INT;

	SET V_Detail = 2;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,V_Detail);

	
	IF p_ReportType =1
	THEN

		SELECT 
			CONCAT(dt.hour,' Hour') as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tblDimTime dt on dt.TimeID = us.TimeID
		GROUP BY  us.DateID,dt.hour;

	END IF;

	
	IF p_ReportType =2
	THEN

		SELECT 
			dd.date as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  us.DateID;

	END IF;

	
	IF p_ReportType =3
	THEN

		SELECT 
			ANY_VALUE(dd.week_year_name) as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  dd.year,dd.week_of_year
		ORDER BY dd.year,dd.week_of_year;

	END IF;

	
	IF p_ReportType =4
	THEN

		SELECT 
			ANY_VALUE(dd.month_year_name) as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  dd.year,dd.month_of_year
		ORDER BY dd.year,dd.month_of_year;

	END IF;

	
	IF p_ReportType =5
	THEN

		SELECT 
			CONCAT('Q-',ANY_VALUE(dd.quarter_year_name)) as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  dd.year,dd.quarter_of_year
		ORDER BY dd.year,dd.quarter_of_year;

	END IF;

	
	IF p_ReportType =6
	THEN

		SELECT 
			dd.year as category,
			SUM(NoOfCalls) AS CallCount,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY  dd.year;

	END IF;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorTrunkReportAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO,ALLOW_INVALID_DATES,NO_AUTO_CREATE_USER' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorTrunkReportAll`(IN `p_CompanyID` INT, IN `p_CompanyGatewayID` INT, IN `p_AccountID` INT, IN `p_CurrencyID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME, IN `p_AreaPrefix` VARCHAR(50), IN `p_Trunk` VARCHAR(50), IN `p_CountryID` INT, IN `p_UserID` INT, IN `p_isAdmin` INT, IN `p_PageNumber` INT, IN `p_RowspPage` INT, IN `p_lSortCol` VARCHAR(50), IN `p_SortOrder` VARCHAR(5), IN `p_isExport` INT)
BEGIN

	DECLARE v_Round_ int;
	DECLARE v_OffSet_ int;
		
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SET v_OffSet_ = (p_PageNumber * p_RowspPage) - p_RowspPage;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

	
	
	IF p_isExport = 0
	THEN
	
		
	SELECT Trunk ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
	FROM tmp_tblUsageVendorSummary_ us
	GROUP BY Trunk   
	ORDER BY
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountDESC') THEN SUM(NoOfCalls)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'CallCountASC') THEN SUM(NoOfCalls)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesDESC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalMinutesASC') THEN COALESCE(SUM(TotalBilledDuration),0)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TrunkDESC') THEN Trunk
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TrunkASC') THEN Trunk
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostDESC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'TotalCostASC') THEN ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDDESC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ACDASC') THEN (COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls))
	END ASC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRDESC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END DESC,
	CASE
		WHEN (CONCAT(p_lSortCol,p_SortOrder) = 'ASRASC') THEN SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100
	END ASC
	LIMIT p_RowspPage OFFSET v_OffSet_;
	
	SELECT COUNT(*) AS totalcount,SUM(CallCount) AS TotalCall,SUM(TotalSeconds) AS TotalDuration,SUM(TotalCost) AS TotalCost FROM (
		SELECT Trunk ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY Trunk
	)tbl;

	
	END IF;
	
	
	IF p_isExport = 1
	THEN
		SELECT   Trunk ,SUM(NoOfCalls) AS CallCount,COALESCE(SUM(TotalBilledDuration),0) as TotalSeconds,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		GROUP BY Trunk;
	END IF;
	
	
	
	IF p_isExport = 2
	THEN
	
			
		SELECT Trunk as ChartVal ,SUM(NoOfCalls) AS CallCount,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(NoOfCalls) > 0 ORDER BY CallCount DESC LIMIT 10;
		
			
		SELECT Trunk as ChartVal,ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(TotalCharges) > 0 ORDER BY TotalCost DESC LIMIT 10;
		
			
		SELECT Trunk as ChartVal,ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD , ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR
		FROM tmp_tblUsageVendorSummary_ us
		WHERE us.Trunk != 'Other'
		GROUP BY Trunk HAVING SUM(TotalBilledDuration) > 0  ORDER BY TotalMinutes DESC LIMIT 10;
	
	END IF;
	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorUnbilledReport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorUnbilledReport`(
	IN `p_CompanyID` INT,
	IN `p_AccountID` INT,
	IN `p_LastInvoiceDate` DATETIME,
	IN `p_Today` DATETIME,
	IN `p_Detail` INT
)
BEGIN
	
	DECLARE v_Round_ INT;
	DECLARE v_Detail_ INT;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	IF p_Detail = 3
	THEN 
		SET v_Detail_ = 1;
	ELSE 
		SET v_Detail_ = p_Detail;
	END IF;
	
	
	CALL fnUsageVendorSummary(p_CompanyID,0,p_AccountID,0,p_LastInvoiceDate,p_Today,'','',0,0,1,v_Detail_);
	
	IF p_Detail = 1
	THEN
	
		SELECT 
			dd.date,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		GROUP BY us.DateID;
	
	END IF;
	
	IF p_Detail = 2
	THEN
	
		SELECT 
			dd.date,
			dt.fulltime,
			ROUND(COALESCE(SUM(TotalBilledDuration),0)/60,0) as TotalMinutes,
			ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost
		FROM tmp_tblUsageVendorSummary_ us
		INNER JOIN tblDimDate dd on dd.DateID = us.DateID
		INNER JOIN tblDimTime dt on dt.TimeID = us.TimeID
		GROUP BY us.DateID,us.TimeID;
	
	END IF;
	
	IF p_Detail = 3
	THEN
	
		DROP TEMPORARY TABLE IF EXISTS tmp_FinalAmount_;
		CREATE TEMPORARY TABLE tmp_FinalAmount_  (
			FinalAmount DOUBLE
		);
		INSERT INTO tmp_FinalAmount_
		SELECT 
		ROUND(COALESCE(SUM(TotalCharges),0), v_Round_)
		FROM tmp_tblUsageVendorSummary_ us;
	
	END IF;
 
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getVendorWorldMap` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getVendorWorldMap`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT
)
BEGIN

	DECLARE v_Round_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	CALL fnGetCountry();

	CALL fnUsageVendorSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

		
	SELECT 
		Country,
		SUM(NoOfCalls) AS CallCount,
		ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,
		ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,
		IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD,
		ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
		MAX(ISO2) AS ISO_Code,
		tblCountry.CountryID
	FROM tmp_tblUsageVendorSummary_ AS us
	INNER JOIN temptblCountry AS tblCountry 
		ON tblCountry.CountryID = us.CountryID
	GROUP BY Country,tblCountry.CountryID 
	HAVING SUM(NoOfCalls) > 0
	ORDER BY CallCount DESC;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_getWorldMap` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_getWorldMap`(
	IN `p_CompanyID` INT,
	IN `p_CompanyGatewayID` INT,
	IN `p_AccountID` INT,
	IN `p_CurrencyID` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_AreaPrefix` VARCHAR(50),
	IN `p_Trunk` VARCHAR(50),
	IN `p_CountryID` INT,
	IN `p_UserID` INT,
	IN `p_isAdmin` INT
)
BEGIN

	DECLARE v_Round_ int;

	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;

	CALL fnGetCountry();

	CALL fnUsageSummary(p_CompanyID,p_CompanyGatewayID,p_AccountID,p_CurrencyID,p_StartDate,p_EndDate,p_AreaPrefix,p_Trunk,p_CountryID,p_UserID,p_isAdmin,2);

		
	SELECT 
		Country,
		SUM(NoOfCalls) AS CallCount,
		ROUND(COALESCE(SUM(TotalCharges),0), v_Round_) as TotalCost,
		ROUND(COALESCE(SUM(TotalBilledDuration),0)/ 60,0) as TotalMinutes,
		IF(SUM(NoOfCalls)>0,fnDurationmmss(COALESCE(SUM(TotalBilledDuration),0)/SUM(NoOfCalls)),0) as ACD,
		ROUND(SUM(NoOfCalls)/(SUM(NoOfCalls)+SUM(NoOfFailCalls))*100,v_Round_) as ASR,
		MAX(ISO2) AS ISO_Code,
		tblCountry.CountryID
	FROM tmp_tblUsageSummary_
	INNER JOIN temptblCountry AS tblCountry 
		ON tblCountry.CountryID = tmp_tblUsageSummary_.CountryID
	GROUP BY Country,tblCountry.CountryID 
	HAVING SUM(NoOfCalls) > 0
	ORDER BY CallCount DESC;

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_timedimbuild` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_timedimbuild`()
BEGIN
    DECLARE v_full_date DATETIME;

    DELETE FROM tblDimTime;

    SET v_full_date = '2009-03-01 00:00:00';
    WHILE v_full_date < '2009-03-02 00:00:00' DO

        INSERT INTO tblDimTime (
            fulltime ,
            hour ,
            minute ,
            second ,
            ampm
        ) VALUES (
            TIME(v_full_date),
            HOUR(v_full_date),
            MINUTE(v_full_date),
            SECOND(v_full_date),
            DATE_FORMAT(v_full_date,'%p')
        );

        SET v_full_date = DATE_ADD(v_full_date, INTERVAL 1 SECOND);
    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_updateUnbilledAmount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_updateUnbilledAmount`(
	IN `p_CompanyID` INT,
	IN `p_Today` DATETIME

)
BEGIN
	
	DECLARE v_Round_ INT;
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_LastInvoiceDate_ DATE;
	DECLARE v_FinalAmount_ DOUBLE;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_Account_;
	CREATE TEMPORARY TABLE tmp_Account_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		LastInvoiceDate DATE
	);
	
	INSERT INTO tmp_Account_ (AccountID)
	SELECT DISTINCT tblSummaryHeader.AccountID  FROM tblSummaryHeader INNER JOIN wavetelwholesaleRM.tblAccount ON tblAccount.AccountID = tblSummaryHeader.AccountID WHERE tblSummaryHeader.CompanyID = p_CompanyID;
	
	UPDATE tmp_Account_ SET LastInvoiceDate = fngetLastInvoiceDate(AccountID);
	
	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*) FROM tmp_Account_);

	WHILE v_pointer_ <= v_rowCount_
	DO
		SET v_AccountID_ = (SELECT AccountID FROM tmp_Account_ t WHERE t.RowID = v_pointer_);
		SET v_LastInvoiceDate_ = (SELECT LastInvoiceDate FROM tmp_Account_ t WHERE t.RowID = v_pointer_);
		
		CALL prc_getUnbilledReport(p_CompanyID,v_AccountID_,v_LastInvoiceDate_,p_Today,3);
		
		SELECT FinalAmount INTO v_FinalAmount_ FROM tmp_FinalAmount_;
		
		IF (SELECT COUNT(*) FROM wavetelwholesaleRM.tblAccountBalance WHERE AccountID = v_AccountID_) > 0
		THEN
			UPDATE wavetelwholesaleRM.tblAccountBalance SET UnbilledAmount = v_FinalAmount_ WHERE AccountID = v_AccountID_;
		ELSE
			INSERT INTO wavetelwholesaleRM.tblAccountBalance (AccountID,UnbilledAmount,BalanceAmount)
			SELECT v_AccountID_,v_FinalAmount_,v_FinalAmount_;
		END IF;
		
		SET v_pointer_ = v_pointer_ + 1;
	
	END WHILE;
	
	UPDATE 
		wavetelwholesaleRM.tblAccountBalance 
	INNER JOIN
		(
			SELECT 
				DISTINCT tblAccount.AccountID 
			FROM wavetelwholesaleRM.tblAccount  
			LEFT JOIN tmp_Account_ 
				ON tblAccount.AccountID = tmp_Account_.AccountID
			WHERE tmp_Account_.AccountID IS NULL AND tblAccount.CompanyID = p_CompanyID
		) TBL
	ON TBL.AccountID = tblAccountBalance.AccountID
	SET UnbilledAmount = 0;
	
	CALL prc_updateVendorUnbilledAmount(p_CompanyID,p_Today);
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_updateVendorUnbilledAmount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_updateVendorUnbilledAmount`(
	IN `p_CompanyID` INT,
	IN `p_Today` DATETIME

)
BEGIN
	
	DECLARE v_Round_ INT;
	DECLARE v_rowCount_ INT;
	DECLARE v_pointer_ INT;
	DECLARE v_AccountID_ INT;
	DECLARE v_LastInvoiceDate_ DATETIME;
	DECLARE v_FinalAmount_ DOUBLE;
	
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT fnGetRoundingPoint(p_CompanyID) INTO v_Round_;
	
	DROP TEMPORARY TABLE IF EXISTS tmp_Account_;
	CREATE TEMPORARY TABLE tmp_Account_  (
		RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		AccountID INT,
		LastInvoiceDate DATETIME
	);
	
	INSERT INTO tmp_Account_ (AccountID)
	SELECT DISTINCT tblSummaryVendorHeader.AccountID  FROM tblSummaryVendorHeader INNER JOIN wavetelwholesaleRM.tblAccount ON tblAccount.AccountID = tblSummaryVendorHeader.AccountID WHERE tblSummaryVendorHeader.CompanyID = p_CompanyID;
	
	UPDATE tmp_Account_ SET LastInvoiceDate = fngetLastVendorInvoiceDate(AccountID);
	
	SET v_pointer_ = 1;
	SET v_rowCount_ = (SELECT COUNT(*) FROM tmp_Account_);

	WHILE v_pointer_ <= v_rowCount_
	DO
		SET v_AccountID_ = (SELECT AccountID FROM tmp_Account_ t WHERE t.RowID = v_pointer_);
		SET v_LastInvoiceDate_ = (SELECT LastInvoiceDate FROM tmp_Account_ t WHERE t.RowID = v_pointer_);
		
		IF v_LastInvoiceDate_ IS NOT NULL
		THEN
		
			CALL prc_getVendorUnbilledReport(p_CompanyID,v_AccountID_,v_LastInvoiceDate_,p_Today,3);
			
			SELECT FinalAmount INTO v_FinalAmount_ FROM tmp_FinalAmount_;
			
			IF (SELECT COUNT(*) FROM wavetelwholesaleRM.tblAccountBalance WHERE AccountID = v_AccountID_) > 0
			THEN
				UPDATE wavetelwholesaleRM.tblAccountBalance SET VendorUnbilledAmount = v_FinalAmount_ WHERE AccountID = v_AccountID_;
			ELSE
				INSERT INTO wavetelwholesaleRM.tblAccountBalance (AccountID,VendorUnbilledAmount,BalanceAmount)
				SELECT v_AccountID_,v_FinalAmount_,v_FinalAmount_;
			END IF;
			
		END IF;
		
		SET v_pointer_ = v_pointer_ + 1;
	
	END WHILE;	
	
	UPDATE 
		wavetelwholesaleRM.tblAccountBalance 
	INNER JOIN
		(
			SELECT 
				DISTINCT tblAccount.AccountID 
			FROM wavetelwholesaleRM.tblAccount  
			LEFT JOIN tmp_Account_ 
				ON tblAccount.AccountID = tmp_Account_.AccountID
			WHERE tmp_Account_.AccountID IS NULL AND tblAccount.CompanyID = p_CompanyID
		) TBL
	ON TBL.AccountID = tblAccountBalance.AccountID
	SET VendorUnbilledAmount = 0;	

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prc_verifySummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`neon-user-dev`@`localhost` PROCEDURE `prc_verifySummary`(IN `p_CompanyID` INT, IN `p_AccountID` INT, IN `p_StartDate` DATETIME, IN `p_EndDate` DATETIME)
BEGIN

	DROP TEMPORARY TABLE IF EXISTS tmp_verify_;
   CREATE TEMPORARY TABLE IF NOT EXISTS tmp_verify_(
	   AccountID INT,
	   TotalCall INT,
	   TotalCharges decimal(18,6),
	   TotalSecond BIGINT,
	   Summary INT,
	   CDR INT
   );
	SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	CALL wavetelwholesaleBilling.fnUsageDetail(p_CompanyID,p_AccountID,0,p_StartDate,p_EndDate,0,1,1,'','','',0);
	
	INSERT INTO tmp_verify_ (AccountID,TotalCall,TotalCharges,TotalSecond,Summary,CDR)
	SELECT p_AccountID,COUNT(*) as TotalCall,SUM(cost) as TotalCost,SUM(billed_duration) as TotalSecond,0,1 FROM wavetelwholesaleBilling.tmp_tblUsageDetails_;
	
	CALL fnUsageSummary(p_CompanyID,0,p_AccountID,0,p_StartDate,p_EndDate,'','',0,0,1,1);
	
	INSERT INTO tmp_verify_ (AccountID,TotalCall,TotalCharges,TotalSecond,Summary,CDR)
	SELECT p_AccountID,SUM(NoOfCalls) as TotalCall,SUM(TotalCharges) as TotalCost,SUM(TotalBilledDuration) as TotalSecond,1,0 FROM tmp_tblUsageSummary_;
	
	SELECT * FROM tmp_verify_;

	


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-04-03 11:36:13
